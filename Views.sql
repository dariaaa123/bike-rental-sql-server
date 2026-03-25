USE bicicleta;
GO

-- Biciclete disponibile pe stație + tip
CREATE OR ALTER VIEW dbo.vBicicleteDisponibilePeStatie
AS
SELECT
    s.StatieID,
    s.NumeStatie,
    t.TipID,
    t.NumeTip,
    COUNT(*) AS NrDisponibile
FROM dbo.Biciclete b
JOIN dbo.Statii s ON s.StatieID = b.StatieID
JOIN dbo.TipuriBiciclete t ON t.TipID = b.TipID
WHERE b.Status = 'disponibila'
GROUP BY s.StatieID, s.NumeStatie, t.TipID, t.NumeTip;
GO

-- Împrumuturi active (neînchise)
CREATE OR ALTER VIEW dbo.vImprumuturiActive
AS
SELECT
    i.ImprumutID,
    i.ClientID,
    c.Nume AS NumeClient,
    i.BicicletaID,
    i.DataInceput,
    i.DataSfarsit
FROM dbo.Imprumuturi i
JOIN dbo.Clienti c ON c.ClientID = i.ClientID
WHERE i.DataSfarsit IS NULL;
GO

-- Venituri pe lună (din plăți)
CREATE OR ALTER VIEW dbo.vVenituriLunare
AS
SELECT
    YEAR(p.DataPlata) AS An,
    MONTH(p.DataPlata) AS Luna,
    SUM(p.Suma) AS TotalVenit
FROM dbo.Plati p
GROUP BY YEAR(p.DataPlata), MONTH(p.DataPlata);
GO

-- Top clienți după număr împrumuturi
CREATE OR ALTER VIEW dbo.vTopClienti
AS
SELECT TOP (10)
    c.ClientID,
    c.Nume,
    c.Email,
    COUNT(*) AS NrImprumuturi
FROM dbo.Clienti c
JOIN dbo.Imprumuturi i ON i.ClientID = c.ClientID
GROUP BY c.ClientID, c.Nume, c.Email
ORDER BY NrImprumuturi DESC;
GO
