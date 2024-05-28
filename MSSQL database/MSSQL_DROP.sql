-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-01-19 01:40:52.04

-- foreign keys
ALTER TABLE Klient DROP CONSTRAINT Klient_Osoba;

ALTER TABLE Pracownik DROP CONSTRAINT Pracownik_Osoba;

ALTER TABLE Pracownik DROP CONSTRAINT Pracownik_Pracownik;

ALTER TABLE Produkt DROP CONSTRAINT Produkt_kategoria;

ALTER TABLE Produkty_w_zamowieniu DROP CONSTRAINT Produkty_zamowienia_Produkt;

ALTER TABLE Produkty_w_zamowieniu DROP CONSTRAINT Produkty_zamowienia_Zamowienie;

ALTER TABLE Stan_magazynowy_produkt DROP CONSTRAINT Stan_Produkty;

ALTER TABLE Stan_magazynowy_produkt DROP CONSTRAINT Stan_magazynowy_Produkt;

ALTER TABLE Stan_magazynowy DROP CONSTRAINT Stan_magazynowy_Sklep;

ALTER TABLE Wiadomosci DROP CONSTRAINT Wiadomosci_nadawca;

ALTER TABLE Wiadomosci DROP CONSTRAINT Wiadomosci_odbiorca;

ALTER TABLE Zamowienie DROP CONSTRAINT Zamowienie_Klient;

ALTER TABLE Zamowienie DROP CONSTRAINT Zamowienie_Pracownik;

ALTER TABLE Zamowienie DROP CONSTRAINT Zamowienie_Sklep;

ALTER TABLE Zatrudnienie DROP CONSTRAINT Zatrudnienie_Pracownik;

ALTER TABLE Zatrudnienie DROP CONSTRAINT Zatrudnienie_Stanowisko;

ALTER TABLE Pracownik DROP CONSTRAINT pracownik_Sklep;

ALTER TABLE Promocja DROP CONSTRAINT promocja_Produkt;

-- tables
DROP TABLE Kategoria;

DROP TABLE Klient;

DROP TABLE Osoba;

DROP TABLE Pracownik;

DROP TABLE Produkt;

DROP TABLE Produkty_w_zamowieniu;

DROP TABLE Promocja;

DROP TABLE Sklep;

DROP TABLE Stan_magazynowy;

DROP TABLE Stan_magazynowy_produkt;

DROP TABLE Stanowisko;

DROP TABLE Wiadomosci;

DROP TABLE Zamowienie;

DROP TABLE Zatrudnienie;

-- End of file.

