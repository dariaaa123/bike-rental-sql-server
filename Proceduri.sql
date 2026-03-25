USE bicicleta;
GO

CREATE OR ALTER PROCEDURE dbo.spClienti_Create
    @Nume NVARCHAR(100),
    @Email NVARCHAR(100),
    @Telefon NVARCHAR(15) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Clienti (Nume, Email, Telefon)
    VALUES (@Nume, @Email, @Telefon);

    SELECT SCOPE_IDENTITY() AS ClientID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.spClienti_ReadById
    @ClientID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * FROM dbo.Clienti WHERE ClientID = @ClientID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.spClienti_Update
    @ClientID INT,
    @Nume NVARCHAR(100),
    @Email NVARCHAR(100),
    @Telefon NVARCHAR(15) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Clienti
    SET Nume = @Nume, Email = @Email, Telefon = @Telefon
    WHERE ClientID = @ClientID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.spClienti_Delete
    @ClientID INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.Clienti WHERE ClientID = @ClientID;
END;
GO




CREATE OR ALTER PROCEDURE dbo.spBiciclete_Create
    @TipID INT,
    @StatieID INT,
    @Status NVARCHAR(20) = 'disponibila'
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Biciclete (TipID, StatieID, Status)
    VALUES (@TipID, @StatieID, @Status);

    SELECT SCOPE_IDENTITY() AS BicicletaID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.spBiciclete_UpdateStatus
    @BicicletaID INT,
    @Status NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Biciclete
    SET Status = @Status
    WHERE BicicletaID = @BicicletaID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.spBiciclete_MoveToStatie
    @BicicletaID INT,
    @StatieID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Biciclete
    SET StatieID = @StatieID
    WHERE BicicletaID = @BicicletaID;
END;
GO


CREATE OR ALTER PROCEDURE dbo.spImprumut_Start
    @ClientID INT,
    @BicicletaID INT,
    @DataInceput DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @DataInceput IS NULL SET @DataInceput = GETDATE();

    BEGIN TRAN;

    -- blochează bicicleta în timpul verificării
    DECLARE @Status NVARCHAR(20);
    SELECT @Status = Status
    FROM dbo.Biciclete WITH (UPDLOCK, HOLDLOCK)
    WHERE BicicletaID = @BicicletaID;

    IF @Status IS NULL
    BEGIN
        ROLLBACK;
        RAISERROR('Bicicleta nu exista.', 16, 1);
        RETURN;
    END

    IF @Status <> 'disponibila'
    BEGIN
        ROLLBACK;
        RAISERROR('Bicicleta nu este disponibila.', 16, 1);
        RETURN;
    END

    INSERT INTO dbo.Imprumuturi (ClientID, BicicletaID, DataInceput, DataSfarsit)
    VALUES (@ClientID, @BicicletaID, @DataInceput, NULL);

    -- Status bicicleta -> inchiriata
    UPDATE dbo.Biciclete
    SET Status = 'inchiriata'
    WHERE BicicletaID = @BicicletaID;

    COMMIT;

    SELECT SCOPE_IDENTITY() AS ImprumutID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.spImprumut_End
    @ImprumutID INT,
    @DataSfarsit DATETIME = NULL,
    @StatieReturnareID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @DataSfarsit IS NULL SET @DataSfarsit = GETDATE();

    DECLARE @BicicletaID INT;

    BEGIN TRAN;

    SELECT @BicicletaID = BicicletaID
    FROM dbo.Imprumuturi WITH (UPDLOCK, HOLDLOCK)
    WHERE ImprumutID = @ImprumutID;

    IF @BicicletaID IS NULL
    BEGIN
        ROLLBACK;
        RAISERROR('Imprumutul nu exista.', 16, 1);
        RETURN;
    END

    -- închide împrumutul doar dacă e activ
    UPDATE dbo.Imprumuturi
    SET DataSfarsit = @DataSfarsit
    WHERE ImprumutID = @ImprumutID
      AND DataSfarsit IS NULL;

    IF @@ROWCOUNT = 0
    BEGIN
        ROLLBACK;
        RAISERROR('Imprumutul este deja inchis.', 16, 1);
        RETURN;
    END

    -- bicicleta -> disponibila + opțional schimbare stație
    UPDATE dbo.Biciclete
    SET Status = 'disponibila',
        StatieID = COALESCE(@StatieReturnareID, StatieID)
    WHERE BicicletaID = @BicicletaID;

    COMMIT;
END;
GO



CREATE OR ALTER PROCEDURE dbo.spPlati_Create
    @ImprumutID INT,
    @Suma DECIMAL(10,2),
    @DataPlata DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @DataPlata IS NULL SET @DataPlata = GETDATE();

    INSERT INTO dbo.Plati (ImprumutID, Suma, DataPlata)
    VALUES (@ImprumutID, @Suma, @DataPlata);

    SELECT SCOPE_IDENTITY() AS PlataID;
END;
GO
