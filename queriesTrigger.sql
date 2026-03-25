-- presupunem ca bicicleta 1 este disponibila
EXEC dbo.spImprumut_Start
    @ClientID = 1,
    @BicicletaID = 3;


EXEC dbo.spImprumut_Start
    @ClientID = 2,
    @BicicletaID = 3;


SELECT TOP 1 ImprumutID
FROM Imprumuturi
WHERE DataSfarsit IS NULL;


INSERT INTO Plati (ImprumutID, Suma)
VALUES (3, 20.00);
