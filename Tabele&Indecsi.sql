use bicicleta;

CREATE TABLE TipuriBiciclete (
    TipID INT IDENTITY(1,1) PRIMARY KEY,
    NumeTip NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Statii (
    StatieID INT IDENTITY(1,1) PRIMARY KEY,
    NumeStatie NVARCHAR(100) NOT NULL,
    Adresa NVARCHAR(200) NOT NULL
);

CREATE TABLE Biciclete (
    BicicletaID INT IDENTITY(1,1) PRIMARY KEY,
    TipID INT NOT NULL,
    StatieID INT NOT NULL,
    Status NVARCHAR(20) NOT NULL 
        CHECK (Status IN ('disponibila', 'inchiriata', 'mentenanta')),

    FOREIGN KEY (TipID) REFERENCES TipuriBiciclete(TipID),
    FOREIGN KEY (StatieID) REFERENCES Statii(StatieID)
);


CREATE TABLE Clienti (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    Nume NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Telefon NVARCHAR(15)
);


CREATE TABLE Imprumuturi (
    ImprumutID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    BicicletaID INT NOT NULL,
    DataInceput DATETIME NOT NULL,
    DataSfarsit DATETIME NULL,

    FOREIGN KEY (ClientID) REFERENCES Clienti(ClientID),
    FOREIGN KEY (BicicletaID) REFERENCES Biciclete(BicicletaID),

    -- CHECK constraint corect (la nivel de tabel)
    CONSTRAINT CK_Imprumuturi_Data CHECK (DataSfarsit IS NULL OR DataSfarsit >= DataInceput)
);



CREATE TABLE Plati (
    PlataID INT IDENTITY(1,1) PRIMARY KEY,
    ImprumutID INT NOT NULL,
    Suma DECIMAL(10,2) NOT NULL CHECK (Suma > 0),
    DataPlata DATETIME NOT NULL DEFAULT(GETDATE()),

    FOREIGN KEY (ImprumutID) REFERENCES Imprumuturi(ImprumutID)
);


CREATE TABLE Roluri (
    RolID INT IDENTITY(1,1) PRIMARY KEY,
    NumeRol NVARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE Utilizatori (
    UtilizatorID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    ParolaHash NVARCHAR(256) NOT NULL,
    RolID INT NOT NULL,

    FOREIGN KEY (RolID) REFERENCES Roluri(RolID)
);


CREATE TABLE ClientiStatiiFavorite (
    ClientID INT NOT NULL,
    StatieID INT NOT NULL,

    PRIMARY KEY (ClientID, StatieID),

    FOREIGN KEY (ClientID) REFERENCES Clienti(ClientID),
    FOREIGN KEY (StatieID) REFERENCES Statii(StatieID)
);

-- Cautare biciclete dupa statie
CREATE NONCLUSTERED INDEX IX_Biciclete_StatieID
ON Biciclete(StatieID);

-- Cautare biciclete dupa status
CREATE NONCLUSTERED INDEX IX_Biciclete_Status
ON Biciclete(Status);

-- Cautare împrumuturi pentru un client
CREATE NONCLUSTERED INDEX IX_Imprumuturi_ClientID
ON Imprumuturi(ClientID);

-- Cautare plati pentru un împrumut
CREATE NONCLUSTERED INDEX IX_Plati_ImprumutID
ON Plati(ImprumutID);
