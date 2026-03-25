use bicicleta

DECLARE @NewClientID INT;

-- spClienti_Create returnează un result set cu ClientID (SCOPE_IDENTITY)
-- Îl capturăm într-un tabel temporar pentru a-l folosi mai departe:
DECLARE @T TABLE (ClientID INT);

INSERT INTO @T
EXEC dbo.spClienti_Create
    @Nume = N'Demo Client6',
    @Email = N'demo.client6@email.com',
    @Telefon = N'0799999999';

SELECT @NewClientID = ClientID FROM @T;

SELECT @NewClientID AS NewClientID;

EXEC dbo.spClienti_ReadById @ClientID = @NewClientID;

select * from Clienti


EXEC dbo.spClienti_Update
    @ClientID = @NewClientID,
    @Nume = N'Demo Client6 Modificat',
    @Email = N'demo.client6@email.com',
    @Telefon = N'0700000000';

EXEC dbo.spClienti_ReadById @ClientID = @NewClientID;

select * from Clienti


DECLARE @NewBikeID INT;
DECLARE @TB TABLE (BicicletaID INT);

INSERT INTO @TB
EXEC dbo.spBiciclete_Create
    @TipID = 1,
    @StatieID = 1,
    @Status = N'disponibila';

SELECT @NewBikeID = BicicletaID FROM @TB;
SELECT @NewBikeID AS NewBikeID;

-- schimbă status (Update)
EXEC dbo.spBiciclete_UpdateStatus
    @BicicletaID = @NewBikeID,
    @Status = N'mentenanta';

SELECT * FROM dbo.Biciclete WHERE BicicletaID = @NewBikeID;

-- mută bicicleta în altă stație
EXEC dbo.spBiciclete_MoveToStatie
    @BicicletaID = @NewBikeID,
    @StatieID = 2;

SELECT * FROM dbo.Biciclete WHERE BicicletaID = @NewBikeID;



DECLARE @NewImprumutID INT;
DECLARE @TI TABLE (ImprumutID INT);

-- Pune bicicleta pe "disponibila" ca să poți începe împrumutul
EXEC dbo.spBiciclete_UpdateStatus
    @BicicletaID = @NewBikeID,
    @Status = N'disponibila';

-- Start împrumut
INSERT INTO @TI
EXEC dbo.spImprumut_Start
    @ClientID = @NewClientID,
    @BicicletaID = @NewBikeID;

SELECT @NewImprumutID = ImprumutID FROM @TI;
SELECT @NewImprumutID AS NewImprumutID;


EXEC dbo.spImprumut_End
    @ImprumutID = @NewImprumutID,
    @StatieReturnareID = 3;

SELECT * FROM dbo.Imprumuturi WHERE ImprumutID = @NewImprumutID;
SELECT * FROM dbo.Biciclete WHERE BicicletaID = @NewBikeID;

DECLARE @NewPlataID INT;
DECLARE @TP TABLE (PlataID INT);

INSERT INTO @TP
EXEC dbo.spPlati_Create
    @ImprumutID = @NewImprumutID,
    @Suma = 18.50;

SELECT @NewPlataID = PlataID FROM @TP;
SELECT @NewPlataID AS NewPlataID;

SELECT * FROM dbo.Plati WHERE PlataID = @NewPlataID;


-- Pornește iar un împrumut pe bicicleta @NewBikeID
DECLARE @T1 TABLE (ImprumutID INT);
INSERT INTO @T1 EXEC dbo.spImprumut_Start @ClientID=@NewClientID, @BicicletaID=@NewBikeID;

-- Încerci încă unul imediat (ar trebui să dea eroare / să fie blocat)
DECLARE @T2 TABLE (ImprumutID INT);
INSERT INTO @T2 EXEC dbo.spImprumut_Start @ClientID=2, @BicicletaID=@NewBikeID;
