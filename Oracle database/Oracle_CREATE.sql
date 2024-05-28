-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-01-19 01:38:07.5

-- tables
-- Table: Kategoria
CREATE TABLE Kategoria (
    ID integer  NOT NULL,
    nazwa varchar2(255)  NOT NULL,
    CONSTRAINT Kategoria_pk PRIMARY KEY (ID)
) ;

-- Table: Klient
CREATE TABLE Klient (
    Osoba_login varchar2(50)  NOT NULL,
    punkty_lojalnosciowe integer  NULL,
    ulica varchar2(255)  NULL,
    nr_domu varchar2(20)  NULL,
    nr_lokalu varchar2(20)  NULL,
    kod_pocztowy varchar2(6)  NULL,
    miasto varchar2(255)  NULL,
    CONSTRAINT Klient_pk PRIMARY KEY (Osoba_login)
) ;

-- Table: Osoba
CREATE TABLE Osoba (
    login varchar2(50)  NOT NULL,
    haslo varchar2(255)  NOT NULL,
    imie varchar2(255)  NULL,
    nazwisko varchar2(255)  NULL,
    nr_telefonu number(9,0)  NULL,
    email varchar2(255)  NULL,
    CONSTRAINT Osoba_pk PRIMARY KEY (login)
) ;

-- Table: Pracownik
CREATE TABLE Pracownik (
    Osoba_login varchar2(50)  NOT NULL,
    Sklep_ID integer  NULL,
    szef_login varchar2(50)  NULL,
    pensja number(12,2)  NULL,
    numer_konta number(26,0)  NULL,
    dostepnosc varchar2(50)  NULL,
    CONSTRAINT Pracownik_pk PRIMARY KEY (Osoba_login)
) ;

-- Table: Produkt
CREATE TABLE Produkt (
    ID integer  NOT NULL,
    nazwa varchar2(255)  NOT NULL,
    opis varchar2(1000)  NULL,
    cena number(12,2)  NOT NULL,
    image blob  NULL,
    kategoria integer  NULL,
    CONSTRAINT Produkt_pk PRIMARY KEY (ID)
) ;

-- Table: Produkty_w_zamowieniu
CREATE TABLE Produkty_w_zamowieniu (
    ID integer  NOT NULL,
    zamowienie_ID integer  NOT NULL,
    produkt_ID integer  NOT NULL,
    Ilosc integer  NOT NULL,
    CONSTRAINT Produkty_w_zamowieniu_pk PRIMARY KEY (ID)
) ;

-- Table: Promocja
CREATE TABLE Promocja (
    Produkt_ID integer  NOT NULL,
    Data_rozpoczecia date  NOT NULL,
    Data_zakonczenia date  NULL,
    obnizka_ceny_procentowa integer  NOT NULL,
    CONSTRAINT Promocja_pk PRIMARY KEY (Produkt_ID)
) ;

-- Table: Sklep
CREATE TABLE Sklep (
    ID integer  NOT NULL,
    miasto varchar2(50)  NOT NULL,
    CONSTRAINT Sklep_pk PRIMARY KEY (ID)
) ;

-- Table: Stan_magazynowy
CREATE TABLE Stan_magazynowy (
    ID integer  NOT NULL,
    data date  NOT NULL,
    Sklep_ID integer  NOT NULL,
    CONSTRAINT Stan_magazynowy_pk PRIMARY KEY (ID)
) ;

-- Table: Stan_magazynowy_produkt
CREATE TABLE Stan_magazynowy_produkt (
    Stan_magazynowy_ID integer  NOT NULL,
    Produkt_ID integer  NOT NULL,
    ilosc integer  NOT NULL,
    CONSTRAINT Stan_magazynowy_produkt_pk PRIMARY KEY (Stan_magazynowy_ID,Produkt_ID)
) ;

-- Table: Stanowisko
CREATE TABLE Stanowisko (
    ID integer  NOT NULL,
    nazwa varchar2(50)  NOT NULL,
    CONSTRAINT Stanowisko_pk PRIMARY KEY (ID)
) ;

-- Table: Wiadomosci
CREATE TABLE Wiadomosci (
    nadawca_login varchar2(50)  NOT NULL,
    odbiorca_login varchar2(50)  NOT NULL,
    data date  NOT NULL,
    tresc varchar2(1000)  NOT NULL,
    CONSTRAINT Wiadomosci_pk PRIMARY KEY (nadawca_login,odbiorca_login)
) ;

-- Table: Zamowienie
CREATE TABLE Zamowienie (
    ID integer  NOT NULL,
    Klient_login varchar2(50)  NOT NULL,
    sklep_ID integer  NOT NULL,
    data date  NOT NULL,
    suma number(12,2)  NOT NULL,
    sposob_dostawy varchar2(255)  NOT NULL,
    sposob_platnosci varchar2(255)  NOT NULL,
    status varchar2(255)  NULL,
    realizator_login varchar2(50)  NULL,
    CONSTRAINT Zamowienie_pk PRIMARY KEY (ID)
) ;

-- Table: Zatrudnienie
CREATE TABLE Zatrudnienie (
    Pracownik_login varchar2(50)  NOT NULL,
    Stanowisko_ID integer  NOT NULL,
    od date  NOT NULL,
    do date  NULL,
    CONSTRAINT Zatrudnienie_pk PRIMARY KEY (Stanowisko_ID,od,Pracownik_login)
) ;

-- foreign keys
-- Reference: Klient_Osoba (table: Klient)
ALTER TABLE Klient ADD CONSTRAINT Klient_Osoba
    FOREIGN KEY (Osoba_login)
    REFERENCES Osoba (login);

-- Reference: Pracownik_Osoba (table: Pracownik)
ALTER TABLE Pracownik ADD CONSTRAINT Pracownik_Osoba
    FOREIGN KEY (Osoba_login)
    REFERENCES Osoba (login);

-- Reference: Pracownik_Pracownik (table: Pracownik)
ALTER TABLE Pracownik ADD CONSTRAINT Pracownik_Pracownik
    FOREIGN KEY (szef_login)
    REFERENCES Pracownik (Osoba_login);

-- Reference: Produkt_kategoria (table: Produkt)
ALTER TABLE Produkt ADD CONSTRAINT Produkt_kategoria
    FOREIGN KEY (kategoria)
    REFERENCES Kategoria (ID);

-- Reference: Produkty_zamowienia_Produkt (table: Produkty_w_zamowieniu)
ALTER TABLE Produkty_w_zamowieniu ADD CONSTRAINT Produkty_zamowienia_Produkt
    FOREIGN KEY (produkt_ID)
    REFERENCES Produkt (ID);

-- Reference: Produkty_zamowienia_Zamowienie (table: Produkty_w_zamowieniu)
ALTER TABLE Produkty_w_zamowieniu ADD CONSTRAINT Produkty_zamowienia_Zamowienie
    FOREIGN KEY (zamowienie_ID)
    REFERENCES Zamowienie (ID);

-- Reference: Stan_Produkty (table: Stan_magazynowy_produkt)
ALTER TABLE Stan_magazynowy_produkt ADD CONSTRAINT Stan_Produkty
    FOREIGN KEY (Stan_magazynowy_ID)
    REFERENCES Stan_magazynowy (ID);

-- Reference: Stan_magazynowy_Produkt (table: Stan_magazynowy_produkt)
ALTER TABLE Stan_magazynowy_produkt ADD CONSTRAINT Stan_magazynowy_Produkt
    FOREIGN KEY (Produkt_ID)
    REFERENCES Produkt (ID);

-- Reference: Stan_magazynowy_Sklep (table: Stan_magazynowy)
ALTER TABLE Stan_magazynowy ADD CONSTRAINT Stan_magazynowy_Sklep
    FOREIGN KEY (Sklep_ID)
    REFERENCES Sklep (ID);

-- Reference: Wiadomosci_nadawca (table: Wiadomosci)
ALTER TABLE Wiadomosci ADD CONSTRAINT Wiadomosci_nadawca
    FOREIGN KEY (nadawca_login)
    REFERENCES Osoba (login);

-- Reference: Wiadomosci_odbiorca (table: Wiadomosci)
ALTER TABLE Wiadomosci ADD CONSTRAINT Wiadomosci_odbiorca
    FOREIGN KEY (odbiorca_login)
    REFERENCES Osoba (login);

-- Reference: Zamowienie_Klient (table: Zamowienie)
ALTER TABLE Zamowienie ADD CONSTRAINT Zamowienie_Klient
    FOREIGN KEY (Klient_login)
    REFERENCES Klient (Osoba_login);

-- Reference: Zamowienie_Pracownik (table: Zamowienie)
ALTER TABLE Zamowienie ADD CONSTRAINT Zamowienie_Pracownik
    FOREIGN KEY (realizator_login)
    REFERENCES Pracownik (Osoba_login);

-- Reference: Zamowienie_Sklep (table: Zamowienie)
ALTER TABLE Zamowienie ADD CONSTRAINT Zamowienie_Sklep
    FOREIGN KEY (sklep_ID)
    REFERENCES Sklep (ID);

-- Reference: Zatrudnienie_Pracownik (table: Zatrudnienie)
ALTER TABLE Zatrudnienie ADD CONSTRAINT Zatrudnienie_Pracownik
    FOREIGN KEY (Pracownik_login)
    REFERENCES Pracownik (Osoba_login);

-- Reference: Zatrudnienie_Stanowisko (table: Zatrudnienie)
ALTER TABLE Zatrudnienie ADD CONSTRAINT Zatrudnienie_Stanowisko
    FOREIGN KEY (Stanowisko_ID)
    REFERENCES Stanowisko (ID);

-- Reference: pracownik_Sklep (table: Pracownik)
ALTER TABLE Pracownik ADD CONSTRAINT pracownik_Sklep
    FOREIGN KEY (Sklep_ID)
    REFERENCES Sklep (ID);

-- Reference: promocja_Produkt (table: Promocja)
ALTER TABLE Promocja ADD CONSTRAINT promocja_Produkt
    FOREIGN KEY (Produkt_ID)
    REFERENCES Produkt (ID);

-- End of file.

