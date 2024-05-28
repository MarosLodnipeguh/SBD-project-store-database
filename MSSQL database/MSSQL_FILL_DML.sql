-- Insert data into Kategoria
INSERT INTO Kategoria (ID, nazwa) VALUES (1, 'Rowery górskie');
INSERT INTO Kategoria (ID, nazwa) VALUES (2, 'Rowery szosowe');
INSERT INTO Kategoria (ID, nazwa) VALUES (3, 'Akcesoria rowerowe');
INSERT INTO Kategoria (ID, nazwa) VALUES (4, 'Kaski i ochraniacze');
INSERT INTO Kategoria (ID, nazwa) VALUES (5, 'Odzież rowerowa');

-- Insert data into Osoba
INSERT INTO Osoba (login, haslo, imie, nazwisko, nr_telefonu, email) VALUES ('ADMIN', 'adminpass', 'Admin', 'User', NULL, 'admin.user@example.com');
INSERT INTO Osoba (login, haslo, imie, nazwisko, nr_telefonu, email) VALUES ('roweroman', 'password123', 'John', 'Doe', 123456789, 'john.doe@example.com');
INSERT INTO Osoba (login, haslo, imie, nazwisko, nr_telefonu, email) VALUES ('skok_na_rower', 'qwerty456', 'Jane', 'Smith', 987654321, 'jane.smith@example.com');
INSERT INTO Osoba (login, haslo, imie, nazwisko, nr_telefonu, email) VALUES ('pedalujacy_piotr', 'alicepass123', 'Alice', 'Wonder', 555666777, 'alice.wonder@example.com');
INSERT INTO Osoba (login, haslo, imie, nazwisko, nr_telefonu, email) VALUES ('szybkiRowerowiec', 'bobpass456', 'Bob', 'Jones', 777888999, 'bob.jones@example.com');
INSERT INTO Osoba (login, haslo, imie, nazwisko, nr_telefonu, email) VALUES ('kraksa_mistrz', 'emilypass789', 'Emily', 'Smith', 333444555, 'emily.smith@example.com');
INSERT INTO Osoba (login, haslo, imie, nazwisko, nr_telefonu, email) VALUES ('wielbladNaRowerze', 'davidpass987', 'David', 'Brown', 111222333, 'david.brown@example.com');
INSERT INTO Osoba (login, haslo, imie, nazwisko, nr_telefonu, email) VALUES ('szosaMistrz', 'lisapass654', 'Lisa', 'Davis', 999888777, 'lisa.davis@example.com');
INSERT INTO Osoba (login, haslo, imie, nazwisko, nr_telefonu, email) VALUES ('klient1', 'lisa_pass123', 'Lisa', 'Davis', 555111222, 'lisa.davis@example.com');
INSERT INTO Osoba (login, haslo, imie, nazwisko, nr_telefonu, email) VALUES ('klient2', 'john_pass456', 'John', 'Smith', 666222333, 'john.smith@example.com');
INSERT INTO Osoba (login, haslo, imie, nazwisko, nr_telefonu, email) VALUES ('klient3', 'emily_pass789', 'Emily', 'Johnson', 777333444, 'emily.johnson@example.com');
INSERT INTO Osoba (login, haslo, imie, nazwisko, nr_telefonu, email) VALUES ('klient4', 'david_pass987', 'David', 'Brown', 888444555, 'david.brown@example.com');
INSERT INTO Osoba (login, haslo, imie, nazwisko, nr_telefonu, email) VALUES ('klient5', 'lisa_pass654', 'Marta', 'Nowak', 999555666, 'marta.nowak@example.com');





-- Insert data into Klient
INSERT INTO Klient (Osoba_login, punkty_lojalnosciowe, ulica, nr_domu, nr_lokalu, kod_pocztowy, miasto) VALUES ('klient1', 50, 'Main Street', '123', 'A', '12-345', 'Warszawa');
INSERT INTO Klient (Osoba_login, punkty_lojalnosciowe, ulica, nr_domu, nr_lokalu, kod_pocztowy, miasto) VALUES ('klient2', 30, 'Second Street', '456', 'B', '67-890', 'Warszawa');
INSERT INTO Klient (Osoba_login, punkty_lojalnosciowe, ulica, nr_domu, nr_lokalu, kod_pocztowy, miasto) VALUES ('klient3', 20, 'Oak Street', '789', NULL, '45-678', 'Warszawa');
INSERT INTO Klient (Osoba_login, punkty_lojalnosciowe, ulica, nr_domu, nr_lokalu, kod_pocztowy, miasto) VALUES ('klient4', 15, 'Maple Avenue', '123', 'C', '90-123', 'Warszawa');
INSERT INTO Klient (Osoba_login, punkty_lojalnosciowe, ulica, nr_domu, nr_lokalu, kod_pocztowy, miasto) VALUES ('klient5', 10, 'Pine Street', '456', NULL, '34-567', 'Warszawa');


-- Insert data into Sklep
INSERT INTO Sklep (ID, miasto) VALUES (1, 'Warszawa');
INSERT INTO Sklep (ID, miasto) VALUES (2, 'Kraków');
INSERT INTO Sklep (ID, miasto) VALUES (3, 'Gdańsk');
INSERT INTO Sklep (ID, miasto) VALUES (4, 'Wrocław');
INSERT INTO Sklep (ID, miasto) VALUES (5, 'Poznań');

-- Insert data into Pracownik
INSERT INTO Pracownik (Osoba_login, Sklep_ID, szef_login, pensja, numer_konta, dostepnosc) VALUES ('roweroman', 1, NULL, 4000.00, 9876543210987654, 'zajety');
INSERT INTO Pracownik (Osoba_login, Sklep_ID, szef_login, pensja, numer_konta, dostepnosc) VALUES ('pedalujacy_piotr', 1, 'roweroman', 4500.00, 5555444433332222, 'dostepny');
INSERT INTO Pracownik (Osoba_login, Sklep_ID, szef_login, pensja, numer_konta, dostepnosc) VALUES ('szybkiRowerowiec', 2, 'roweroman', 4000.00, 1234123412341234, 'zajety');
INSERT INTO Pracownik (Osoba_login, Sklep_ID, szef_login, pensja, numer_konta, dostepnosc) VALUES ('kraksa_mistrz', 1, 'szybkiRowerowiec', 3500.00, 9876987698769876, 'zajety');
INSERT INTO Pracownik (Osoba_login, Sklep_ID, szef_login, pensja, numer_konta, dostepnosc) VALUES ('wielbladNaRowerze', 2, 'roweroman', 3000.00, 1111222233334444, 'zajety');
INSERT INTO Pracownik (Osoba_login, Sklep_ID, szef_login, pensja, numer_konta, dostepnosc) VALUES ('szosaMistrz', 1, 'szybkiRowerowiec', 4200.00, 9999555577778888, 'zajety');
INSERT INTO Pracownik (Osoba_login, Sklep_ID, szef_login, pensja, numer_konta, dostepnosc) VALUES ('skok_na_rower', 1, 'roweroman', 4200.00, 9999555577778888, 'zajety');

-- Insert data into Stanowisko
INSERT INTO Stanowisko (ID, nazwa) VALUES (1, 'CEO');
INSERT INTO Stanowisko (ID, nazwa) VALUES (2, 'Manager');
INSERT INTO Stanowisko (ID, nazwa) VALUES (3, 'Magazynier');
INSERT INTO Stanowisko (ID, nazwa) VALUES (4, 'Sprzedawca');
INSERT INTO Stanowisko (ID, nazwa) VALUES (5, 'Serwisant');

-- Insert data into Zatrudnienie
INSERT INTO Zatrudnienie (Pracownik_login, Stanowisko_ID, od, do) VALUES ('roweroman', 1, '01-19-2024', NULL);

INSERT INTO Zatrudnienie (Pracownik_login, Stanowisko_ID, od, do) VALUES ('pedalujacy_piotr', 4, '01-19-2024', '01-19-2024');
INSERT INTO Zatrudnienie (Pracownik_login, Stanowisko_ID, od, do) VALUES ('pedalujacy_piotr', 2, '01-19-2024', NULL);

INSERT INTO Zatrudnienie (Pracownik_login, Stanowisko_ID, od, do) VALUES ('szybkiRowerowiec', 5, '01-19-2024', '01-19-2024');
INSERT INTO Zatrudnienie (Pracownik_login, Stanowisko_ID, od, do) VALUES ('szybkiRowerowiec', 2, '01-19-2024', NULL);

INSERT INTO Zatrudnienie (Pracownik_login, Stanowisko_ID, od, do) VALUES ('kraksa_mistrz', 3, '01-19-2024', NULL);
INSERT INTO Zatrudnienie (Pracownik_login, Stanowisko_ID, od, do) VALUES ('wielbladNaRowerze', 4, '01-19-2024', NULL);
INSERT INTO Zatrudnienie (Pracownik_login, Stanowisko_ID, od, do) VALUES ('szosaMistrz', 5, '01-19-2024', NULL);

INSERT INTO Zatrudnienie (Pracownik_login, Stanowisko_ID, od, do) VALUES ('skok_na_rower', 5, '01-19-2024', '01-19-2024');





-- Insert data into Produkt
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (1, 'Rower górski X1', 'Najnowszy model roweru górskiego', 1500.00, 1);
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (2, 'Rower szosowy S2', 'Idealny rower dla miłośników jazdy szosowej', 2000.00, 2);
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (3, 'Kask ochronny ABC', 'Lekki i wygodny kask ochronny', 50.00, 4);
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (4, 'Koło rowerowe MTB', 'Solidne i wytrzymałe koło do roweru górskiego', 100.00, 3);
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (5, 'Kurtka rowerowa XYZ', 'Wodoodporna kurtka rowerowa', 120.00, 5);
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (6, 'Rowerek biegowy ABC', 'Idealny dla najmłodszych rowerzystów', 120.00, 1);
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (7, 'Opona rowerowa XYZ', 'Wytrzymała opona do jazdy po różnych nawierzchniach', 40.00, 3);
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (8, 'Kosz na bidon Sporty', 'Praktyczny i lekki kosz na bidon do roweru', 15.00, 3);
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (9, 'Kask dla dzieci KiddySafe', 'Bezpieczny kask ochronny dla najmłodszych rowerzystów', 35.00, 4);
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (10, 'Rękawiczki rowerowe ComfortFit', 'Wygodne rękawiczki z żelowym wypełnieniem', 25.00, 5);
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (11, 'Rower elektryczny PowerRide', 'Innowacyjny rower z napędem elektrycznym', 3000.00, 1);
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (12, 'Łańcuch rowerowy HighEnd', 'Trwały i lekki łańcuch do roweru', 50.00, 3);
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (13, 'Siodło ComfortRide', 'Ergonomiczne siodło dla wygodnej jazdy', 45.00, 3);
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (14, 'Lampa przednia LED SuperBright', 'Potężna lampa do oświetlania drogi', 30.00, 3);
INSERT INTO Produkt (ID, nazwa, opis, cena, kategoria) VALUES (15, 'Bagażnik rowerowy QuickMount', 'Uniwersalny bagażnik do przewożenia rzeczy', 55.00, 3);


-- Insert data into Zamowienie
INSERT INTO Zamowienie (ID, Klient_login, sklep_ID, data, suma, sposob_dostawy, sposob_platnosci, status, realizator_login) VALUES (1, 'klient1', 1, '01-19-2024', 3000.00, 'Kurier', 'Karta kredytowa', 'zrealizowane', 'kraksa_mistrz');
INSERT INTO Zamowienie (ID, Klient_login, sklep_ID, data, suma, sposob_dostawy, sposob_platnosci, status, realizator_login) VALUES (2, 'klient2', 2, '01-19-2024', 200.00, 'Odbiór osobisty', 'Gotówka', 'w trakcie realizacji', 'szosaMistrz');
INSERT INTO Zamowienie (ID, Klient_login, sklep_ID, data, suma, sposob_dostawy, sposob_platnosci, status, realizator_login) VALUES (3, 'klient5', 1, '01-19-2024', 150.00, 'Paczkomat', 'Przelew', 'zrealizowane', 'szosaMistrz');
INSERT INTO Zamowienie (ID, Klient_login, sklep_ID, data, suma, sposob_dostawy, sposob_platnosci, status, realizator_login) VALUES (4, 'klient3', 1, '01-19-2024', 100.00, 'Kurier', 'Karta kredytowa', 'w trakcie realizacji', 'wielbladNaRowerze');
INSERT INTO Zamowienie (ID, Klient_login, sklep_ID, data, suma, sposob_dostawy, sposob_platnosci, status, realizator_login) VALUES (5, 'klient4', 2, '01-19-2024', 200.00, 'Odbiór osobisty', 'Gotówka', 'zrealizowane', 'kraksa_mistrz');
INSERT INTO Zamowienie (ID, Klient_login, sklep_ID, data, suma, sposob_dostawy, sposob_platnosci, status, realizator_login) VALUES (6, 'klient1', 1, '01-19-2024', 150.00, 'Paczkomat', 'Przelew', 'zrealizowane', 'wielbladNaRowerze');
INSERT INTO Zamowienie (ID, Klient_login, sklep_ID, data, suma, sposob_dostawy, sposob_platnosci, status, realizator_login) VALUES (7, 'klient2', 2, '01-19-2024', 100.00, 'Kurier', 'Karta kredytowa', 'w trakcie realizacji', 'kraksa_mistrz');
INSERT INTO Zamowienie (ID, Klient_login, sklep_ID, data, suma, sposob_dostawy, sposob_platnosci, status, realizator_login) VALUES (8, 'klient5', 1, '01-19-2024', 200.00, 'Odbiór osobisty', 'Gotówka', 'zrealizowane', 'wielbladNaRowerze');


-- Insert data into Produkty_w_zamowieniu
INSERT INTO Produkty_w_zamowieniu (ID, zamowienie_ID, produkt_ID, ilosc) VALUES (1, 1, 1, 2);
INSERT INTO Produkty_w_zamowieniu (ID, zamowienie_ID, produkt_ID, ilosc) VALUES (2, 1, 3, 1);
INSERT INTO Produkty_w_zamowieniu (ID, zamowienie_ID, produkt_ID, ilosc) VALUES (3, 2, 2, 1);
INSERT INTO Produkty_w_zamowieniu (ID, zamowienie_ID, produkt_ID, ilosc) VALUES (4, 2, 3, 1);
INSERT INTO Produkty_w_zamowieniu (ID, zamowienie_ID, produkt_ID, ilosc) VALUES (5, 3, 1, 3);
INSERT INTO Produkty_w_zamowieniu (ID, zamowienie_ID, produkt_ID, ilosc) VALUES (6, 3, 3, 2);
INSERT INTO Produkty_w_zamowieniu (ID, zamowienie_ID, produkt_ID, ilosc) VALUES (7, 4, 5, 2);
INSERT INTO Produkty_w_zamowieniu (ID, zamowienie_ID, produkt_ID, ilosc) VALUES (8, 5, 4, 1);
INSERT INTO Produkty_w_zamowieniu (ID, zamowienie_ID, produkt_ID, ilosc) VALUES (9, 6, 5, 1);
INSERT INTO Produkty_w_zamowieniu (ID, zamowienie_ID, produkt_ID, ilosc) VALUES (10, 6, 4, 1);
INSERT INTO Produkty_w_zamowieniu (ID, zamowienie_ID, produkt_ID, ilosc) VALUES (11, 7, 5, 1);
INSERT INTO Produkty_w_zamowieniu (ID, zamowienie_ID, produkt_ID, ilosc) VALUES (12, 8, 1, 1);



-- Insert data into Promocja
-- INSERT INTO Promocja (Produkt_ID, Data_rozpoczecia, Data_zakonczenia, obnizka_ceny_procentowa) VALUES (1, '01-19-2024', '02-19-2024', 10);
-- INSERT INTO Promocja (Produkt_ID, Data_rozpoczecia, Data_zakonczenia, obnizka_ceny_procentowa) VALUES (3, '01-19-2024', '02-19-2024', 15);



-- Insert data into Stan_magazynowy
INSERT INTO Stan_magazynowy (ID, data, Sklep_ID) VALUES (1, '01-19-2024', 1);
INSERT INTO Stan_magazynowy (ID, data, Sklep_ID) VALUES (2, '01-19-2024', 2);

-- Insert data into Stan_magazynowy_produkt
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (1, 1, 10);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (1, 3, 5);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (2, 2, 8);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (2, 4, 15);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (1, 2, 5);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (1, 5, 12);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (2, 1, 8);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (2, 3, 3);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (2, 15, 10);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (2, 14, 6);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (1, 6, 20);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (1, 9, 30);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (2, 13, 12);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (2, 11, 5);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (2, 12, 18);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (2, 10, 8);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (1, 13, 25);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (2, 9, 15);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (1, 10, 10);
INSERT INTO Stan_magazynowy_produkt (Stan_magazynowy_ID, Produkt_ID, ilosc) VALUES (2, 8, 20);


-- Insert data into Wiadomosci
INSERT INTO Wiadomosci (nadawca_login, odbiorca_login, data, tresc) VALUES ('roweroman', 'skok_na_rower', '01-19-2024', 'Cześć! Chciałem się dowiedzieć, czy interesuje Cię nasza nowa oferta rowerów górskich.');
INSERT INTO Wiadomosci (nadawca_login, odbiorca_login, data, tresc) VALUES ('ADMIN', 'roweroman', '01-19-2024', 'Witaj! Dziękujemy za Twoje zaangażowanie w pracę.');

