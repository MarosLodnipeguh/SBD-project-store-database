-- procedura, która tworzy promocję na wszystkie produkty (rekord w tabeli PROMOCJA), które sprzedały się w mniejszej niż podana ilość w argumencie, 
-- przez ostatnie 30 dni i od oraz obniża cenę produktu o podany procent w argumencie (CENA w tabeli PRODUKT)

create view SprzedaneProdukty30dni (produktId, cena, sprzedanaIlosc) --data
as
select PRODUKT.ID, cena, sum(produktyZamowienie.ILOSC) from PRODUKT
join PRODUKTY_W_ZAMOWIENIU produktyZamowienie on PRODUKT.ID = produktyZamowienie.PRODUKT_ID
join ZAMOWIENIE zamowienie on zamowienie.ID = produktyZamowienie.ZAMOWIENIE_ID
--where zamowienie.DATA > add_months(sysdate, -1);
where zamowienie.DATA > sysdate - 30
GROUP BY PRODUKT.ID, cena;

drop view SprzedaneProdukty30dni;


create procedure PromocjaNaDeadstock
    (sprzedanoMniejNiz int, procentPromocji int, czasTrawniaPromocjiDni int)
is
cursor looper is
    select * from SprzedaneProdukty30dni;

    produkt SprzedaneProdukty30dni%rowtype;
    nowaCena PRODUKT.CENA%type;
begin
    open looper;
    loop
        fetch looper into produkt;
        exit when looper%NotFound;

        if produkt.sprzedanaIlosc < sprzedanoMniejNiz then

            insert into PROMOCJA (PRODUKT_ID, DATA_ROZPOCZECIA, DATA_ZAKONCZENIA, OBNIZKA_CENY_PROCENTOWA) values (produkt.produktId, sysdate, sysdate + czasTrawniaPromocjiDni, procentPromocji);

            nowaCena := produkt.cena - produkt.cena*procentPromocji/100;
            update produkt set CENA = nowaCena where produkt.ID = produkt.produktId;

            dbms_output.put_line('Promocja na produkt o id: ' || produkt.produktId || ' który sprzedał się w ilości: ' || produkt.sprzedanaIlosc || ' w ostatnich 30 dniach, ' || ' obniżka ceny z: ' || produkt.cena || ' na ' || nowaCena);

        end if;
    end loop;
    close looper;
end;


select * from SprzedaneProdukty30dni;

-- przykład użycia
call PromocjaNaDeadstock(10, 10, 30);

select * from PRODUKT;
select * from PROMOCJA;

-- =====================================================================================================================

-- procedura która generuje ranking pracowników którzy zrealizowali najwięcej zamówień (ostatnie 30 dni) i na tej podstawie przyznaje podwyżkę (wartosc podana w argumencie) 
-- najlepszym pracownikomm, jeśli dwóch lub więcej pracowników ma tyle samo zrealizowanych zamówień, to podwyżka jest przyznawana wszystkim

create view RankingPracownikow (pracownikLogin, liczbaZrealizowanychZamowien) --sumaZrealizowanychProduktow
as
select zamowienie.REALIZATOR_LOGIN, count(*) from PRODUKTY_W_ZAMOWIENIU --sum(ILOSC)
join ZAMOWIENIE zamowienie on zamowienie.ID = PRODUKTY_W_ZAMOWIENIU.ZAMOWIENIE_ID
where zamowienie.DATA > sysdate - 30 and zamowienie.STATUS = 'zrealizowane'
group by REALIZATOR_LOGIN;

select * from RankingPracownikow;
drop view RankingPracownikow;

create or replace procedure Podwyzka (podwyzka PRACOWNIK.PENSJA%type) is
    najwiecejZrealizowanychZamowien int;
begin
    for p in (select pracownikLogin, liczbaZrealizowanychZamowien from RankingPracownikow) loop

        select max(liczbaZrealizowanychZamowien) into najwiecejZrealizowanychZamowien from RankingPracownikow;

        -- daj podwyzke wszystkim pracownikom z najlepszym wynikiem
        if p.liczbaZrealizowanychZamowien = najwiecejZrealizowanychZamowien then
            update PRACOWNIK set PENSJA = PENSJA + podwyzka where OSOBA_LOGIN = p.pracownikLogin;
            dbms_output.put_line('Podwyzka dla pracownika: ' || p.pracownikLogin || ' o: ' || podwyzka || ' zł' || ' za zrealizowanie: ' || p.liczbaZrealizowanychZamowien || ' zamówień w ostatnich 30 dniach');
        end if;

    end loop;
end;

-- przykład użycia
call Podwyzka(1000);


-- =====================================================================================================================
-- trigger, który przyznaje punkty lojalnościowe, gdy klient złoży zamówienie (10 punktów za każde wydane 1 zł)

create or replace trigger PunktyLojalnosciowe
    after insert on ZAMOWIENIE
    for each row
declare
    klientLogin KLIENT.OSOBA_LOGIN%type;
    wartoscZamowienia ZAMOWIENIE.SUMA%type;
begin
    select KLIENT_LOGIN, SUMA into klientLogin, wartoscZamowienia from :new;
    update KLIENT set PUNKTY_LOJALNOSCIOWE = PUNKTY_LOJALNOSCIOWE + (wartoscZamowienia*10) where KLIENT_LOGIN = klientLogin;
    dbms_output.put_line('Przyznano ' || wartoscZamowienia*10 || ' punktów lojalnościowych dla klienta: ' || klientLogin);
end;

-- przykład użycia
declare
    newId ZAMOWIENIE.ID%type;
    begin
    select max(ID)+1 into newId from ZAMOWIENIE;
    Insert into ZAMOWIENIE (ID, KLIENT_LOGIN, SKLEP_ID, DATA, SUMA, SPOSOB_DOSTAWY, SPOSOB_PLATNOSCI, STATUS, REALIZATOR_LOGIN)
    values (newId, 'klient1', 1, to_date(current_date,'DD-MM-RRRR'), 100, 'kurier', 'karta', null, null);
end;

select * from Klient where Osoba_login = 'klient1';

-- =====================================================================================================================
-- trigger który po utworzeniu nowego zamówienia:
-- 1. nadaje mu status "złożone"
-- 2. automatycznie przypisuje pracnwnika z danego sklepu do zamówienia (jeśli jakiś pracownik ma status dostępny) oraz zmienia status tego pracownika na "zajety"
-- 3. jeśli nie ma dostępnego pracownika, to zamówienie dostaje status "oczekujace" (bez przypisanego pracownika)
-- 4. po przypisaniu pracownika zmienia status na "przypisane"

-- mozliwe statusy zamowienia: null, zlozone, oczekujace, przypisane, w trakcie realizacji, zrealizowane

create or replace trigger NoweZamowienie
    before insert on ZAMOWIENIE
    for each row
declare
    dostepniPraciwnicyCount int;
    dostepnyPracownikLogin PRACOWNIK.OSOBA_LOGIN%type;
begin
    :NEW.STATUS := 'zlozone';
    dbms_output.put_line('Utworzono zamowienie o id: ' || :NEW.ID || ' o statusie: ' || :NEW.STATUS);

    select count(*) into dostepniPraciwnicyCount from PRACOWNIK where DOSTEPNOSC = 'dostepny' and Sklep_ID = :NEW.SKLEP_ID;
    DBMS_OUTPUT.PUT_LINE('Dostepnych pracownikow w sklepie o id ' || :NEW.SKLEP_ID || ': ' || dostepniPraciwnicyCount);

    if dostepniPraciwnicyCount > 0 then
        select OSOBA_LOGIN into dostepnyPracownikLogin from PRACOWNIK where DOSTEPNOSC = 'dostepny' and rownum = 1;
        update PRACOWNIK set DOSTEPNOSC = 'zajety' where OSOBA_LOGIN = dostepnyPracownikLogin;
        :NEW.REALIZATOR_LOGIN := dostepnyPracownikLogin;
        :NEW.STATUS := 'przypisane';
        dbms_output.put_line('Do zamowienia przypisano pracownika: ' || dostepnyPracownikLogin);
    else
        :NEW.STATUS := 'oczekujace';
        dbms_output.put_line('Brak dostepnych pracownikow, zamowienie o id: ' || :NEW.ID || ' oczekuje na przypisanie pracownika');
    end if;

end;

drop trigger NoweZamowienie;

-- przykład użycia
declare
    newId ZAMOWIENIE.ID%type;
    begin
    select max(ID)+1 into newId from ZAMOWIENIE;
    Insert into ZAMOWIENIE
        (ID, KLIENT_LOGIN, SKLEP_ID, DATA, SUMA, SPOSOB_DOSTAWY, SPOSOB_PLATNOSCI, STATUS, REALIZATOR_LOGIN)
    values (newId, 'klient2', 1, to_date(current_date,'DD-MM-RRRR'), 100, 'kurier', 'karta', null, null);
end;


-- =====================================================================================================================

-- trigger, który automatycznie przypisuje pracownikowi nowe zamowienie, kiedy on zmieni swój status na "dostępny" oraz istnieje zamówienie o statusie "oczekujące"
create or replace trigger AutoPrzypisanieZamowienia
    before update on PRACOWNIK
--     after update on PRACOWNIK
    for each row
declare
    oczekujaceZamowienieId int;
    oczekujaceZamowieniaCount int;
begin
    select count(*) into oczekujaceZamowieniaCount from ZAMOWIENIE where STATUS = 'oczekujace' and SKLEP_ID = :NEW.SKLEP_ID;
    dbms_output.put_line('Oczekujacych zamowien w sklepie o id ' || :NEW.SKLEP_ID || ': ' || oczekujaceZamowieniaCount);

    if :NEW.DOSTEPNOSC = 'dostepny' and oczekujaceZamowieniaCount > 0 then

        -- weź jedno oczekujące zamówienie ze sklepu pracownika
        select ID into oczekujaceZamowienieId from ZAMOWIENIE where STATUS = 'oczekujace' and SKLEP_ID = :NEW.SKLEP_ID and rownum = 1;
        -- przypisz je do pracownika
        update ZAMOWIENIE set REALIZATOR_LOGIN = :NEW.OSOBA_LOGIN, STATUS = 'przypisane' where ID = oczekujaceZamowienieId;
        :NEW.DOSTEPNOSC := 'zajety';
        dbms_output.put_line('Automatycznie przypisano zamowienie o id: ' || oczekujaceZamowienieId || ' do pracownika: ' || :NEW.OSOBA_LOGIN);

    end if;

end;

drop trigger AutoPrzypisanieZamowienia;

-- przykład użycia
drop trigger NoweZamowienie;

declare
    newId ZAMOWIENIE.ID%type;
    begin
    select max(ID)+1 into newId from ZAMOWIENIE;
    Insert into ZAMOWIENIE
        (ID, KLIENT_LOGIN, SKLEP_ID, DATA, SUMA, SPOSOB_DOSTAWY, SPOSOB_PLATNOSCI, STATUS, REALIZATOR_LOGIN)
    values (newId, 'klient2', 1, to_date(current_date,'DD-MM-RRRR'), 100, 'kurier', 'karta', 'oczekujace', null);
end;

select ID, STATUS, REALIZATOR_LOGIN from ZAMOWIENIE where STATUS = 'oczekujace' and SKLEP_ID = 1;

select OSOBA_LOGIN, DOSTEPNOSC from PRACOWNIK where DOSTEPNOSC = 'zajety' and SKLEP_ID = 1;

update PRACOWNIK set DOSTEPNOSC = 'dostepny' where OSOBA_LOGIN = 'pedalujacy_piotr';





-- =====================================================================================================================
-- SCRAPPED

-- -- trigger, który po zmianie statusu zamówienia na "zrealizowane", automatycznie zmienia status pracownika realizującego to zamówienie na "dostępny"
-- create or replace trigger ZamknijZamowienie
--     after update on ZAMOWIENIE
--     for each row
-- begin
--     if :NEW.STATUS = 'zrealizowane' and :OLD.STATUS = 'w trakcie realizacji' then
--         update PRACOWNIK set DOSTEPNOSC = 'dostepny' where OSOBA_LOGIN = :OLD.REALIZATOR_LOGIN;
--         dbms_output.put_line('Zamowienie o id: ' || :NEW.ID || ' zostalo zrealizowane, pracownik: ' || :OLD.REALIZATOR_LOGIN || ' jest dostepny');
--     end if;
-- end;
--
-- drop trigger ZamknijZamowienie;
--
-- -- przykład użycia
-- declare
--     newId ZAMOWIENIE.ID%type;
--     begin
--     select max(ID)+1 into newId from ZAMOWIENIE;
--     Insert into ZAMOWIENIE
--         (ID, KLIENT_LOGIN, SKLEP_ID, DATA, SUMA, SPOSOB_DOSTAWY, SPOSOB_PLATNOSCI, STATUS, REALIZATOR_LOGIN)
--     values (newId, 'klient2', 1, to_date(current_date,'DD-MM-RRRR'), 100, 'kurier', 'karta', null, null);
--
--     update ZAMOWIENIE set STATUS = 'w trakcie realizacji' where ID = newId;
--
--     update ZAMOWIENIE set STATUS = 'zrealizowane' where ID = newId;
-- end;