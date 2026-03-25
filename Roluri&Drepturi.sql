USE bicicleta;
GO

-- Roluri de DB
CREATE ROLE db_admin_app;
CREATE ROLE db_operator;
CREATE ROLE db_cashier;
CREATE ROLE db_readonly;
GO

-- Permisiuni pe obiecte (exemplu rezonabil)
-- Admin aplicație: full pe schema dbo
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO db_admin_app;
GRANT EXECUTE ON SCHEMA::dbo TO db_admin_app;

-- Operator: gestionează biciclete + stații + împrumuturi
GRANT SELECT, INSERT, UPDATE ON dbo.Biciclete TO db_operator;
GRANT SELECT, INSERT, UPDATE ON dbo.Statii TO db_operator;
GRANT SELECT, INSERT, UPDATE ON dbo.Imprumuturi TO db_operator;
GRANT EXECUTE ON dbo.spImprumut_Start TO db_operator;
GRANT EXECUTE ON dbo.spImprumut_End   TO db_operator;

-- Casier: plăți + rapoarte
GRANT SELECT ON dbo.Plati TO db_cashier;
GRANT INSERT ON dbo.Plati TO db_cashier;
GRANT EXECUTE ON dbo.spPlati_Create TO db_cashier;
GRANT SELECT ON dbo.vVenituriLunare TO db_cashier;

-- Read-only: doar citire views/tabele
GRANT SELECT ON SCHEMA::dbo TO db_readonly;
GO

-- Exemple de utilizatori (logins + users).
-- Dacă nu ai drepturi de CREATE LOGIN, fă doar CREATE USER pentru logins existente.
CREATE LOGIN login_admin_app WITH PASSWORD = 'P@rola_Str0ng!123';
CREATE LOGIN login_operator  WITH PASSWORD = 'P@rola_Str0ng!123';
CREATE LOGIN login_cashier   WITH PASSWORD = 'P@rola_Str0ng!123';
CREATE LOGIN login_readonly  WITH PASSWORD = 'P@rola_Str0ng!123';
GO

CREATE USER user_admin_app FOR LOGIN login_admin_app;
CREATE USER user_operator  FOR LOGIN login_operator;
CREATE USER user_cashier   FOR LOGIN login_cashier;
CREATE USER user_readonly  FOR LOGIN login_readonly;
GO

EXEC sp_addrolemember 'db_admin_app', 'user_admin_app';
EXEC sp_addrolemember 'db_operator',  'user_operator';
EXEC sp_addrolemember 'db_cashier',   'user_cashier';
EXEC sp_addrolemember 'db_readonly',  'user_readonly';
GO
