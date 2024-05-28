# Baza danych sklepu rowerowego
Może być używana do przechowywania i zarządzania różnymi informacjami związanymi z funkcjonowaniem internetowego sklepu rowerowego.

Dzięki relacjom między tabelami i kluczom obcym, baza danych pozwala na skomplikowane zapytania, automatyzację przypisywania zamówień, raporty i analizy, co ułatwia zarządzanie sklepem rowerowym, monitorowanie stanu magazynowego, śledzenie zamówień klientów oraz zarządzanie personelem. System ten może być zintegrowany z aplikacją internetową sklepu, umożliwiając obsługę zamówień online, zarządzanie stanem magazynowym i śledzenie promocji.

Główne zastowania Tabel:
- Zarządzanie Produktami - informacje o produktach dostępnych w sklepie
- Zamówienia i Klienci - przechowuje dane o klientach, takie jak punkty lojalnościowe, adres dostawy, itp. oraz informacje o złożonych zamówieniach
- Promocje - pozwala na definiowanie promocji dla konkretnych produktów, określając datę rozpoczęcia, datę zakończenia i procentową obniżkę ceny
- Magazyn i Stan Magazynowy - przechowuje informacje o stanie magazynowym w poszczególnych sklepach, pozwala na śledzenie ilości konkretnych produktów w danym stanie magazynowym.
- Pracownicy i Zatrudnienie -  informacje o pracownikach, ich pensji, dostępności oraz umożliwia śledzenie historii zatrudnienia pracowników na różnych stanowiskach.
- Wiadomości - przechowuje informacje o wiadomościach między użytkownikami systemu, takie jak nadawca, odbiorca, data i treść wiadomości.
- Sklepy - przechowuje dane o sklepach, takie jak identyfikator, miasto, co umożliwia zarządzanie wieloma lokalizacjami sklepów.

# Wymagania:
Projekt musi zawierać: 
1. Opis wymagań 

2. Diagram związków encji zgodny z opisem 

3. Skrypty poleceń DDL wygenerowane z diagramów związków encji (ORACLE i MS SQL Server) 

4. Skrypty poleceń DML wprowadzających przykładowe dane do bazy (ORACLE i MS SQL Server) 

5. Minimum dwie procedury w każdym ze środowisk (ORACLE i MS SQL Server) 

6. Minimum dwa wyzwalacze w każdym ze środowisk, z czego jeden z wyzwalaczy PL/SQL ma być FOR EACH ROW. (ORACLE i MS SQL Server) 

7. Należy użyć kursora - w T-SQL może to być w wyzwalaczu lub procedurze, w PL/SQL w procedurze. 

8. Operacje DML demonstrujące działanie procedur i wyzwalaczy (najlepiej wraz z komentarzami)
