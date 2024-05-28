
-- procedura, która tworzy promocję na wszystkie produkty (rekord w tabeli PROMOCJA), które sprzedały się w mniejszej niż podana ilość w argumencie, 
-- przez ostatnie 30 dni i od oraz obniża cenę produktu o podany procent w argumencie (CENA w tabeli PRODUKT)

CREATE PROCEDURE PromocjaNaDeadstock
    @sprzedanoMniejNiz INT,
    @procentPromocji INT,
    @czasTrwaniaPromocjiDni INT
AS
BEGIN
    DECLARE @produktId INT, @cena money, @sprzedanaIlosc INT, @nowaCena money;

    DECLARE looper CURSOR FOR
        SELECT PRODUKT.ID, CENA AS Cena, SUM(ILOSC) AS SumaIlosci
		FROM PRODUKT
		JOIN PRODUKTY_W_ZAMOWIENIU ON PRODUKT.ID = PRODUKTY_W_ZAMOWIENIU.PRODUKT_ID
		JOIN ZAMOWIENIE ON ZAMOWIENIE.ID = PRODUKTY_W_ZAMOWIENIU.ZAMOWIENIE_ID
		WHERE ZAMOWIENIE.DATA > DATEADD(DAY, -30, GETDATE())
		GROUP BY PRODUKT.ID, cena;

    OPEN looper;

    FETCH NEXT FROM looper INTO @produktId, @cena, @sprzedanaIlosc;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @sprzedanaIlosc < @sprzedanoMniejNiz
        BEGIN
            INSERT INTO PROMOCJA (PRODUKT_ID, DATA_ROZPOCZECIA, DATA_ZAKONCZENIA, OBNIZKA_CENY_PROCENTOWA)
            VALUES (@produktId, GETDATE(), DATEADD(DAY, @czasTrwaniaPromocjiDni, GETDATE()), @procentPromocji);

            SET @nowaCena = @cena - (@cena * @procentPromocji / 100);

			UPDATE PRODUKT SET CENA = @nowaCena WHERE ID = @produktId;

            PRINT 'Promocja na produkt o ID: ' + CAST(@produktId AS NVARCHAR(10)) + ' który sprzedał się w ilości: ' + CAST(@sprzedanaIlosc AS NVARCHAR(10)) +
                  ' w ostatnich 30 dniach, obniżka ceny z: ' + CAST(@cena AS NVARCHAR(10)) + ' na ' + CAST(@nowaCena AS NVARCHAR(10));
        END;

        FETCH NEXT FROM looper INTO @produktId, @cena, @sprzedanaIlosc;
    END;

    CLOSE looper;
    DEALLOCATE looper;
END;

drop procedure PromocjaNaDeadstock

-- przykład użycia
EXEC PromocjaNaDeadstock @sprzedanoMniejNiz = 10, @procentPromocji = 10, @czasTrwaniaPromocjiDni = 30;

select * from Promocja
delete from Promocja


-- =====================================================================================================================

-- procedura która generuje ranking pracowników którzy zrealizowali najwięcej zamówień (ostatnie 30 dni) i na tej podstawie przyznaje podwyżkę (wartosc podana w argumencie) 
-- najlepszym pracownikomm, jeśli dwóch lub więcej pracowników ma tyle samo zrealizowanych zamówień, to podwyżka jest przyznawana wszystkim

-- Tworzenie widoku
CREATE VIEW RankingPracownikow AS
SELECT 
    zam.REALIZATOR_LOGIN AS pracownikLogin, 
    COUNT(*) AS liczbaZrealizowanychZamowien
FROM 
    PRODUKTY_W_ZAMOWIENIU prod
JOIN 
    ZAMOWIENIE zam ON zam.ID = prod.ZAMOWIENIE_ID
WHERE 
    zam.DATA > DATEADD(day, -30, GETDATE()) AND zam.STATUS = 'zrealizowane'
GROUP BY 
    zam.REALIZATOR_LOGIN;

	--------------------------------------------------
-- Procedura przyznawania podwyżki
CREATE PROCEDURE Podwyzka
    @podwyzka INT
AS
BEGIN
    DECLARE @najwiecejZrealizowanychZamowien INT;
    DECLARE @pracownikLogin NVARCHAR(50);

    -- Znajdź pracownika z największą liczbą zrealizowanych zamówień
    SELECT TOP 1 @pracownikLogin = pracownikLogin, @najwiecejZrealizowanychZamowien = liczbaZrealizowanychZamowien
    FROM RankingPracownikow
    ORDER BY liczbaZrealizowanychZamowien DESC;

    -- Przyznawanie podwyżki pracownikowi z najlepszym wynikiem
    UPDATE PRACOWNIK
    SET PENSJA = PENSJA + @podwyzka
    WHERE OSOBA_LOGIN = @pracownikLogin;

    -- Wyświetlanie informacji na konsoli
    PRINT 'Podwyzka dla pracownika ' + @pracownikLogin + ' o: ' + CAST(@podwyzka AS VARCHAR(10)) + ' za zrealizowanie: ' + CAST(@najwiecejZrealizowanychZamowien AS VARCHAR(10)) + ' zamowien w ostatnich 30 dniach';
END;


drop procedure Podwyzka;

-- Przykład użycia
EXEC Podwyzka 1000;

-- =====================================================================================================================

-- trigger, który przyznaje punkty lojalnościowe, gdy klient złoży zamówienie (10 punktów za każde wydane 1 zł)

CREATE TRIGGER PunktyLojalnosciowe
ON ZAMOWIENIE
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @klientLogin NVARCHAR(50);
    DECLARE @wartoscZamowienia MONEY;

    SELECT @klientLogin = i.Klient_login, @wartoscZamowienia = i.SUMA
    FROM inserted i;

    UPDATE KLIENT
    SET PUNKTY_LOJALNOSCIOWE = PUNKTY_LOJALNOSCIOWE + (@wartoscZamowienia * 10)
    WHERE Osoba_login = @klientLogin;

    PRINT 'Przyznano ' + CAST(@wartoscZamowienia * 10 AS NVARCHAR(50)) + ' punktów lojalnościowych dla klienta: ' + @klientLogin;
END;

-- przykład użycia
DECLARE @newId INT;
SELECT @newId = ISNULL(MAX(ID), 0) + 1 FROM ZAMOWIENIE;

INSERT INTO ZAMOWIENIE (ID, KLIENT_LOGIN, SKLEP_ID, DATA, SUMA, SPOSOB_DOSTAWY, SPOSOB_PLATNOSCI, STATUS, REALIZATOR_LOGIN)
VALUES (@newId, 'klient1', 1, GETDATE(), 100, 'kurier', 'karta', NULL, NULL);

select * from Klient where Osoba_login = 'klient1';

-- =====================================================================================================================

-- trigger który po utworzeniu nowego zamówienia:
-- 1. nadaje mu status "złożone"
-- 2. automatycznie przypisuje pracnwnika z danego sklepu do zamówienia (jeśli jakiś pracownik ma status dostępny) oraz zmienia status tego pracownika na "zajety"
-- 3. jeśli nie ma dostępnego pracownika, to zamówienie dostaje status "oczekujace" (bez przypisanego pracownika)
-- 4. po przypisaniu pracownika zmienia status na "przypisane"

-- mozliwe statusy zamowienia: null, zlozone, oczekujace, przypisane, w trakcie realizacji, zrealizowane

CREATE TRIGGER NoweZamowienie
ON ZAMOWIENIE
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @dostepniPracownicyCount INT;
    DECLARE @dostepnyPracownikLogin NVARCHAR(50);
    DECLARE @insertedId INT;
	DECLARE @insertedSklepId INT;

    -- Update only the inserted rows
    SELECT TOP 1 @insertedId = ID FROM INSERTED;
	SELECT TOP 1 @insertedSklepId = SKLEP_ID FROM INSERTED;

    UPDATE ZAMOWIENIE SET STATUS = 'zlozone' WHERE ID = @insertedId;

    PRINT 'Utworzono zamowienie o id: ' + CAST(@insertedId AS NVARCHAR(50)) + ' o statusie: zlozone';

    -- dostepni pracownicy w sklepie
    SELECT @dostepniPracownicyCount = COUNT(*) FROM PRACOWNIK WHERE DOSTEPNOSC = 'dostepny' AND Sklep_ID = @insertedSklepId;

    PRINT 'Dostepnych pracownikow w sklepie o id ' + CAST(@insertedSklepId AS NVARCHAR(50)) + ': ' + CAST(@dostepniPracownicyCount AS NVARCHAR(10));

    IF @dostepniPracownicyCount > 0
    BEGIN
        SELECT TOP 1 @dostepnyPracownikLogin = OSOBA_LOGIN FROM PRACOWNIK WHERE DOSTEPNOSC = 'dostepny' AND Sklep_ID = @insertedSklepId;

        UPDATE PRACOWNIK SET DOSTEPNOSC = 'zajety' WHERE OSOBA_LOGIN = @dostepnyPracownikLogin;

        UPDATE ZAMOWIENIE SET REALIZATOR_LOGIN = @dostepnyPracownikLogin, STATUS = 'przypisane' WHERE ZAMOWIENIE.ID = @insertedId;

        PRINT 'Do zamowienia przypisano pracownika: ' + @dostepnyPracownikLogin;
    END
    ELSE
    BEGIN
        -- jesli nie ma dostepnych pracownikow
        UPDATE ZAMOWIENIE SET STATUS = 'oczekujace' WHERE ZAMOWIENIE.ID = @insertedId;

        PRINT 'Brak dostepnych pracownikow, zamowienie o id: ' + CAST(@insertedId AS NVARCHAR(50)) + ' oczekuje na przypisanie pracownika';
    END
END;




-- przykład użycia
DECLARE @newId INT;
SELECT @newId = ISNULL(MAX(ID), 0) + 1 FROM ZAMOWIENIE;

INSERT INTO ZAMOWIENIE (ID, KLIENT_LOGIN, SKLEP_ID, DATA, SUMA, SPOSOB_DOSTAWY, SPOSOB_PLATNOSCI, STATUS, REALIZATOR_LOGIN)
VALUES (@newId, 'klient2', 1, GETDATE(), 100, 'kurier', 'karta', NULL, NULL);

SELECT * FROM ZAMOWIENIE WHERE ID = @newId;

-- =====================================================================================================================

-- trigger, który automatycznie przypisuje pracownikowi nowe zamowienie, kiedy on zmieni swój status na "dostępny" oraz istnieje zamówienie o statusie "oczekujące"

CREATE TRIGGER AutoPrzypisanieZamowienia
ON PRACOWNIK
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @oczekujaceZamowienieId INT;
    DECLARE @oczekujaceZamowieniaCount INT;

    DECLARE @insertedLogin NVARCHAR(50);
    DECLARE @insertedSklepId INT;
    DECLARE @insertedDostepnosc NVARCHAR(50);

    SELECT @oczekujaceZamowieniaCount = COUNT(*) FROM ZAMOWIENIE WHERE STATUS = 'oczekujace' AND SKLEP_ID = (SELECT SKLEP_ID FROM INSERTED);

    SELECT TOP 1 @insertedLogin = Osoba_login FROM INSERTED;
	SELECT TOP 1 @insertedSklepId = SKLEP_ID FROM INSERTED;
    SELECT TOP 1 @insertedDostepnosc = DOSTEPNOSC FROM INSERTED;

    PRINT 'Oczekujacych zamowien w sklepie o id ' + CAST(@insertedSklepId AS NVARCHAR(50)) + ': ' + CAST(@oczekujaceZamowieniaCount AS NVARCHAR(50));

    IF @insertedDostepnosc = 'dostepny' AND @oczekujaceZamowieniaCount > 0
    BEGIN
        -- weź jedno oczekujące zamówienie ze sklepu pracownika
        SELECT TOP 1 @oczekujaceZamowienieId = ID
        FROM ZAMOWIENIE
        WHERE STATUS = 'oczekujace' AND SKLEP_ID = @insertedSklepId ;

        -- przypisz je do pracownika
        UPDATE ZAMOWIENIE
        SET REALIZATOR_LOGIN = @insertedLogin, STATUS = 'przypisane'
        WHERE ID = @oczekujaceZamowienieId;

        UPDATE PRACOWNIK
        SET DOSTEPNOSC = 'zajety'
        WHERE OSOBA_LOGIN = @insertedLogin;

        PRINT 'Automatycznie przypisano zamowienie o id: ' + CAST(@oczekujaceZamowienieId AS NVARCHAR(50)) +
              ' do pracownika: ' + @insertedLogin;
    END
END;

drop trigger AutoPrzypisanieZamowienia;

-- przykład użycia
DECLARE @newId INT;
SELECT @newId = ISNULL(MAX(ID) + 1, 1) FROM ZAMOWIENIE;

INSERT INTO ZAMOWIENIE (ID, KLIENT_LOGIN, SKLEP_ID, DATA, SUMA, SPOSOB_DOSTAWY, SPOSOB_PLATNOSCI, STATUS, REALIZATOR_LOGIN)
VALUES (@newId, 'klient2', 1, GETDATE(), 100, 'kurier', 'karta', 'oczekujace', NULL);

SELECT ID, STATUS, REALIZATOR_LOGIN FROM ZAMOWIENIE WHERE STATUS = 'oczekujace' AND SKLEP_ID = 1;

SELECT OSOBA_LOGIN, DOSTEPNOSC FROM PRACOWNIK WHERE DOSTEPNOSC = 'zajety' AND SKLEP_ID = 1;

UPDATE PRACOWNIK SET DOSTEPNOSC = 'dostepny' WHERE OSOBA_LOGIN = 'pedalujacy_piotr';


-- =====================================================================================================================

select * from kategoria
select * from klient
select * from osoba
select * from pracownik
select * from produkt
select * from produkty_w_zamowieniu
select * from promocja
select * from sklep
select * from stan_magazynowy
select * from stan_magazynowy_produkt
select * from stanowisko
select * from wiadomosci
select * from zamowienie
select * from zatrudnienie

