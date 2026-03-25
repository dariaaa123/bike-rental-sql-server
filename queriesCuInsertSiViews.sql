use bicicleta

INSERT INTO TipuriBiciclete (NumeTip) VALUES
('oras'),
('mountain'),
('electrica'),
('copii');


INSERT INTO Statii (NumeStatie, Adresa) VALUES
('Statie Centru', 'Str. Independentei nr. 1'),
('Statie Gara', 'Bulevardul Garii nr. 10'),
('Statie Parc', 'Aleea Parcului nr. 5'),
('Statie Universitate', 'Str. Universitatii nr. 12');


INSERT INTO Clienti (Nume, Email, Telefon) VALUES
('Popescu Andrei', 'andrei.popescu@email.com', '0711111111'),
('Ionescu Maria', 'maria.ionescu@email.com', '0722222222'),
('Georgescu Mihai', 'mihai.georgescu@email.com', '0733333333'),
('Dumitrescu Ana', 'ana.dumitrescu@email.com', '0744444444');

INSERT INTO Roluri (NumeRol) VALUES
('admin'),
('operator'),
('casier'),
('client');


INSERT INTO Utilizatori (Username, ParolaHash, RolID) VALUES
('admin1', 'HASH_ADMIN', 1),
('operator1', 'HASH_OPERATOR', 2),
('casier1', 'HASH_CASIER', 3);


INSERT INTO Biciclete (TipID, StatieID, Status) VALUES
(1, 1, 'disponibila'),
(1, 1, 'disponibila'),
(2, 2, 'disponibila'),
(2, 3, 'mentenanta'),
(3, 1, 'disponibila'),
(3, 4, 'disponibila'),
(4, 3, 'disponibila');

INSERT INTO ClientiStatiiFavorite (ClientID, StatieID) VALUES
(1, 1),
(1, 3),
(2, 2),
(3, 1),
(3, 4);


INSERT INTO Imprumuturi (ClientID, BicicletaID, DataInceput, DataSfarsit) VALUES
(1, 1, '2025-01-10 10:00', '2025-01-10 12:00'),
(2, 3, '2025-01-11 09:30', '2025-01-11 10:30'),
(3, 5, '2025-01-12 14:00', NULL);


INSERT INTO Plati (ImprumutID, Suma, DataPlata) VALUES
(1, 15.00, '2025-01-10 12:05'),
(2, 12.50, '2025-01-11 10:35');

select * from dbo.vBicicleteDisponibilePeStatie
select * from dbo.vImprumuturiActive
select * from dbo.vTopClienti
select * from dbo.vVenituriLunare
