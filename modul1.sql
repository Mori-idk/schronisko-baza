create database modulo1;
use modulo1;



CREATE TABLE Gatunek (
    ID_Gatunku INT IDENTITY(1,1) PRIMARY KEY,
    Nazwa NVARCHAR(50) NOT NULL UNIQUE
);



CREATE TABLE Rasa (
    ID_Rasy INT IDENTITY(1,1) PRIMARY KEY,
    ID_Gatunku INT NOT NULL,
    Nazwa NVARCHAR(100) NOT NULL,
    FOREIGN KEY (ID_Gatunku) REFERENCES Gatunek(ID_Gatunku)
);

CREATE TABLE StatusZdrowotny (
    ID_Statusu INT IDENTITY(1,1) PRIMARY KEY,
    Nazwa NVARCHAR(50) NOT NULL UNIQUE,
    Opis NVARCHAR(255)
);

CREATE TABLE Lek (
    ID_Leku INT IDENTITY(1,1) PRIMARY KEY,
    Nazwa NVARCHAR(100) NOT NULL,
    SubstancjaCzynna NVARCHAR(100),
    JednostkaMiary NVARCHAR(20)
);

CREATE TABLE Choroba (
    ID_Choroby INT IDENTITY(1,1) PRIMARY KEY,
    Nazwa NVARCHAR(100) NOT NULL UNIQUE,
    CzyZakazna BIT NOT NULL DEFAULT 0,
    OpisSymptomow NVARCHAR(MAX)
);


CREATE TABLE Zwierze (
    ID_Zwierzecia INT IDENTITY(1,1) PRIMARY KEY,
    Imie NVARCHAR(50) NOT NULL,
    ID_Gatunku INT NOT NULL,
    ID_Rasy INT, 
    DataUrodzenia_Szacunkowa DATE,
    Plec CHAR(1) CHECK (Plec IN ('M', 'S', 'N')),
    ID_StatusuZdrowotnego INT NOT NULL,
    UwagiOgolne NVARCHAR(MAX),
    FOREIGN KEY (ID_Gatunku) REFERENCES Gatunek(ID_Gatunku),
    FOREIGN KEY (ID_Rasy) REFERENCES Rasa(ID_Rasy),
    FOREIGN KEY (ID_StatusuZdrowotnego) REFERENCES StatusZdrowotny(ID_Statusu)
);



CREATE TABLE OsobaPrzekazujaca (
    ID_Osoby INT IDENTITY(1,1) PRIMARY KEY,
    Imie NVARCHAR(50) NOT NULL,
    Nazwisko NVARCHAR(50),
    TypOsoby NVARCHAR(50) NOT NULL,
    NrTelefonu VARCHAR(20),
    NrDokumentu NVARCHAR(50),
    Adres NVARCHAR(255),
    Notatki NVARCHAR(MAX)
);

CREATE TABLE KartaPrzyjecia (
    ID_Karty INT IDENTITY(1,1) PRIMARY KEY,
    ID_Zwierzecia INT NOT NULL UNIQUE,
    DataPrzyjecia DATETIME NOT NULL DEFAULT GETDATE(),
    SkadOdebrane NVARCHAR(255),
    OsobaPrzekazujaca NVARCHAR(150),
    PowodPrzyjecia NVARCHAR(MAX),
    ID_OsobyPrzekazujacej INT,
    FOREIGN KEY (ID_OsobyPrzekazujacej) REFERENCES OsobaPrzekazujaca(ID_Osoby),
    FOREIGN KEY (ID_Zwierzecia) REFERENCES Zwierze(ID_Zwierzecia)
);

CREATE TABLE Kwarantanna (
    ID_Kwarantanny INT IDENTITY(1,1) PRIMARY KEY,
    ID_Zwierzecia INT NOT NULL,
    DataRozpoczecia DATETIME NOT NULL,
    DataZakonczenia DATETIME,
    Powod NVARCHAR(255),
    OpiekunNadzorujacy NVARCHAR(100), 
    FOREIGN KEY (ID_Zwierzecia) REFERENCES Zwierze(ID_Zwierzecia)
);

CREATE TABLE Szczepienie (
    ID_Szczepienia INT IDENTITY(1,1) PRIMARY KEY,
    ID_Zwierzecia INT NOT NULL,
    NazwaSzczepionki NVARCHAR(100) NOT NULL,
    ChorobaDocelowa NVARCHAR(100),
    DataSzczepienia DATE NOT NULL,
    WazneDo DATE,
    Weterynarz NVARCHAR(100),
    FOREIGN KEY (ID_Zwierzecia) REFERENCES Zwierze(ID_Zwierzecia)
);

CREATE TABLE ZabiegWeterynaryjny (
    ID_Zabiegu INT IDENTITY(1,1) PRIMARY KEY,
    ID_Zwierzecia INT NOT NULL,
    NazwaZabiegu NVARCHAR(150) NOT NULL,
    DataZabiegu DATETIME NOT NULL,
    Wynik_Zalecenia NVARCHAR(MAX),
    Koszt DECIMAL(10, 2),
    FOREIGN KEY (ID_Zwierzecia) REFERENCES Zwierze(ID_Zwierzecia)
);

CREATE TABLE Dawkowanie (
    ID_Dawkowania INT IDENTITY(1,1) PRIMARY KEY,
    ID_Zwierzecia INT NOT NULL,
    ID_Leku INT NOT NULL,
    Dawka NVARCHAR(50) NOT NULL,
    Czestotliwosc NVARCHAR(100) NOT NULL,
    DataRozpoczecia DATE NOT NULL,
    DataZakonczenia DATE,
    FOREIGN KEY (ID_Zwierzecia) REFERENCES Zwierze(ID_Zwierzecia),
    FOREIGN KEY (ID_Leku) REFERENCES Lek(ID_Leku)
);

CREATE TABLE Diagnoza (
    ID_Diagnozy INT IDENTITY(1,1) PRIMARY KEY,
    ID_Zwierzecia INT NOT NULL,
    ID_Choroby INT NOT NULL,
    DataPostawienia DATE NOT NULL,
    OpisDodatkowy NVARCHAR(MAX),
    StatusDiagnozy NVARCHAR(50) DEFAULT 'Aktywna', 
    FOREIGN KEY (ID_Zwierzecia) REFERENCES Zwierze(ID_Zwierzecia),
    FOREIGN KEY (ID_Choroby) REFERENCES Choroba(ID_Choroby)
);

CREATE TABLE Mikrochip (
    ID_Mikrochipa INT IDENTITY(1,1) PRIMARY KEY,
    ID_Zwierzecia INT NOT NULL UNIQUE, 
    NumerChipa NVARCHAR(50) NOT NULL UNIQUE,
    DataWszczepienia DATE,
    LokalizacjaWszczepu NVARCHAR(100), 
    FOREIGN KEY (ID_Zwierzecia) REFERENCES Zwierze(ID_Zwierzecia)
);

CREATE TABLE ProfilBehawioralny (
    ID_Profilu INT IDENTITY(1,1) PRIMARY KEY,
    ID_Zwierzecia INT NOT NULL,
    DataOceny DATE NOT NULL,
    PoziomAgresji INT CHECK (PoziomAgresji BETWEEN 1 AND 5),
    PoziomLeku INT CHECK (PoziomLeku BETWEEN 1 AND 5),
    StosunekDoInnychZwierzat NVARCHAR(MAX),
    NotatkiBehawiorysty NVARCHAR(MAX),
    FOREIGN KEY (ID_Zwierzecia) REFERENCES Zwierze(ID_Zwierzecia)
);

CREATE TABLE DokumentacjaMedyczna (
    ID_Dokumentu INT IDENTITY(1,1) PRIMARY KEY,
    ID_Zwierzecia INT NOT NULL,
    TypDokumentu NVARCHAR(50) NOT NULL, 
    SciezkaDoPliku NVARCHAR(255) NOT NULL, 
    DataDodania DATETIME DEFAULT GETDATE(),
    Opis NVARCHAR(255),
    FOREIGN KEY (ID_Zwierzecia) REFERENCES Zwierze(ID_Zwierzecia)
);

CREATE TABLE HistoriaZmianStatusu (
    ID_Zmiany INT IDENTITY(1,1) PRIMARY KEY,
    ID_Zwierzecia INT NOT NULL,
    ID_StaregoStatusu INT, 
    ID_NowegoStatusu INT NOT NULL,
    DataZmiany DATETIME NOT NULL DEFAULT GETDATE(),
    UzytkownikZmieniajacy NVARCHAR(100), 
    PowodZmiany NVARCHAR(255),
    FOREIGN KEY (ID_Zwierzecia) REFERENCES Zwierze(ID_Zwierzecia),
    FOREIGN KEY (ID_StaregoStatusu) REFERENCES StatusZdrowotny(ID_Statusu),
    FOREIGN KEY (ID_NowegoStatusu) REFERENCES StatusZdrowotny(ID_Statusu)
);


