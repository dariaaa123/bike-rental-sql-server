USE bicicleta;
GO

CREATE OR ALTER PROCEDURE dbo.spRaport_DisponibilitatePeStatii_Cursor
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StatieID INT, @NumeStatie NVARCHAR(100), @NrDisponibile INT;

    DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
        SELECT StatieID, NumeStatie
        FROM dbo.Statii
        ORDER BY NumeStatie;

    OPEN cur;

    FETCH NEXT FROM cur INTO @StatieID, @NumeStatie;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @NrDisponibile = COUNT(*)
        FROM dbo.Biciclete
        WHERE StatieID = @StatieID AND Status = 'disponibila';

        PRINT CONCAT('Statie: ', @NumeStatie, ' (ID=', @StatieID, ') -> Disponibile: ', @NrDisponibile);

        FETCH NEXT FROM cur INTO @StatieID, @NumeStatie;
    END

    CLOSE cur;
    DEALLOCATE cur;
END;
GO
