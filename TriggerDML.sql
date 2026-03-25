USE bicicleta;
GO

CREATE OR ALTER TRIGGER dbo.tr_Imprumuturi_PreventDoubleActive
ON dbo.Imprumuturi
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM dbo.Imprumuturi i
        JOIN inserted ins ON ins.BicicletaID = i.BicicletaID
        WHERE i.DataSfarsit IS NULL
        GROUP BY i.BicicletaID
        HAVING COUNT(*) > 1
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Nu poti avea mai mult de un imprumut activ pentru aceeasi bicicleta.', 16, 1);
        RETURN;
    END
END;
GO


CREATE OR ALTER TRIGGER dbo.tr_Imprumuturi_CloseSetsBikeAvailable
ON dbo.Imprumuturi
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- doar rândurile care au trecut de la NULL -> non-NULL
    UPDATE b
    SET b.Status = 'disponibila'
    FROM dbo.Biciclete b
    JOIN inserted i ON i.BicicletaID = b.BicicletaID
    JOIN deleted d  ON d.ImprumutID = i.ImprumutID
    WHERE d.DataSfarsit IS NULL
      AND i.DataSfarsit IS NOT NULL;
END;
GO



use bicicleta;

CREATE OR ALTER TRIGGER dbo.tr_Plati_DoarPentruImprumutInchis
ON dbo.Plati
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.Imprumuturi im ON im.ImprumutID = i.ImprumutID
        WHERE im.DataSfarsit IS NULL
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR(
            'Nu se poate inregistra plata pentru un imprumut care nu este inchis.',
            16, 1
        );
        RETURN;
    END
END;
GO

