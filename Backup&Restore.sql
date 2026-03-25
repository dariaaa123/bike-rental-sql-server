-- FULL BACKUP
BACKUP DATABASE bicicleta
TO DISK = 'C:\Backup\bicicleta_full.bak'
WITH INIT, COMPRESSION, STATS = 10;
GO

-- (opțional) DIFFERENTIAL
BACKUP DATABASE bicicleta
TO DISK = 'C:\Backup\bicicleta_diff.bak'
WITH DIFFERENTIAL, INIT, COMPRESSION, STATS = 10;
GO

-- RESTORE (exemplu simplu)
-- Atenție: în practică trebuie exclusivitate pe DB.
-- RESTORE DATABASE bicicleta
-- FROM DISK = 'C:\Backup\bicicleta_full.bak'
-- WITH REPLACE, RECOVERY, STATS = 10;
GO
