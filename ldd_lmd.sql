IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ADOPTIONS]') AND type in (N'U'))
    DROP TABLE ADOPTIONS;

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOGS]') AND type in (N'U'))
    DROP TABLE LOGS;

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MOBILE_ENTITY]') AND type in (N'U'))
    DROP TABLE MOBILE_ENTITY;

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USERS]') AND type in (N'U'))
    DROP TABLE USERS;

CREATE TABLE USERS (
    id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
);

CREATE TABLE MOBILE_ENTITY (
    id INT IDENTITY(1,1) PRIMARY KEY,
    type NVARCHAR(255) NOT NULL,
    name NVARCHAR(255) NOT NULL,
    label NVARCHAR(255),
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
);

CREATE TABLE LOGS (
    id INT IDENTITY(1,1) PRIMARY KEY,
    mobile_entity_id INT,
    recorded_at DATETIME NOT NULL,
    lng FLOAT NOT NULL,
    lat FLOAT NOT NULL,
    temperature FLOAT,
    wind_speed FLOAT,
    solar_intensity FLOAT,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    FOREIGN KEY (mobile_entity_id) REFERENCES MOBILE_ENTITY(id)
);

CREATE TABLE ADOPTIONS (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    mobile_entity_id INT,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES USERS(id),
    FOREIGN KEY (mobile_entity_id) REFERENCES MOBILE_ENTITY(id)
);

INSERT INTO MOBILE_ENTITY (type, name, label, created_at, updated_at) VALUES
('requin', 'Bruce', 'Great White Shark', GETDATE(), GETDATE()),
('ours', 'Baloo', 'Brown Bear', GETDATE(), GETDATE()),
('iceberg', 'Ice King', 'Arctic Iceberg', GETDATE(), GETDATE()),
('baleine', 'Willy', 'Blue Whale', GETDATE(), GETDATE()),
('oiseau', 'Zazu', 'African Eagle', GETDATE(), GETDATE()),
('requin', 'Shadow', 'Hammerhead Shark', GETDATE(), GETDATE()),
('ours', 'Grizzly', 'Grizzly Bear', GETDATE(), GETDATE()),
('iceberg', 'Frost', 'Antarctic Iceberg', GETDATE(), GETDATE()),
('baleine', 'Echo', 'Humpback Whale', GETDATE(), GETDATE()),
('oiseau', 'Hawkeye', 'Peregrine Falcon', GETDATE(), GETDATE()),
('requin', 'Lenny', 'Leopard Shark', GETDATE(), GETDATE()),
('ours', 'Yogi', 'American Black Bear', GETDATE(), GETDATE()),
('iceberg', 'Glacier', 'Greenland Iceberg', GETDATE(), GETDATE()),
('baleine', 'Orca', 'Killer Whale', GETDATE(), GETDATE()),
('oiseau', 'Skyler', 'Harpy Eagle', GETDATE(), GETDATE()),
('requin', 'Goblin', 'Goblin Shark', GETDATE(), GETDATE()),
('ours', 'Paddington', 'Andean Bear', GETDATE(), GETDATE()),
('iceberg', 'Summit', 'Patagonian Ice Field', GETDATE(), GETDATE()),
('baleine', 'Narwhal', 'Narwhal', GETDATE(), GETDATE()),
('oiseau', 'Phoenix', 'Flamingo', GETDATE(), GETDATE()),
('requin', 'Finn', 'Bull Shark', GETDATE(), GETDATE()),
('ours', 'Koda', 'Kodiak Bear', GETDATE(), GETDATE()),
('iceberg', 'Berg', 'Ross Ice Shelf', GETDATE(), GETDATE()),
('baleine', 'Misty', 'Minke Whale', GETDATE(), GETDATE()),
('oiseau', 'Blu', 'Macaw', GETDATE(), GETDATE()),
('requin', 'Razor', 'Thresher Shark', GETDATE(), GETDATE()),
('ours', 'Bjorn', 'Polar Bear', GETDATE(), GETDATE()),
('iceberg', 'Avalanche', 'Svalbard Iceberg', GETDATE(), GETDATE()),
('baleine', 'Dory', 'Beluga Whale', GETDATE(), GETDATE()),
('oiseau', 'Gale', 'Albatross', GETDATE(), GETDATE()),
('requin', 'Spike', 'Saw Shark', GETDATE(), GETDATE()),
('ours', 'Teddy', 'Sun Bear', GETDATE(), GETDATE()),
('iceberg', 'Crystal', 'East Antarctica Iceberg', GETDATE(), GETDATE()),
('baleine', 'Ahab', 'Sperm Whale', GETDATE(), GETDATE()),
('oiseau', 'Robin', 'Robin', GETDATE(), GETDATE()),
('requin', 'Casper', 'Whale Shark', GETDATE(), GETDATE()),
('ours', 'Po', 'Giant Panda', GETDATE(), GETDATE()),
('iceberg', 'Titan', 'Weddell Sea Iceberg', GETDATE(), GETDATE()),
('baleine', 'Flipper', 'Dolphin', GETDATE(), GETDATE()),
('oiseau', 'Kiwi', 'Kiwi Bird', GETDATE(), GETDATE()),
('requin', 'Jet', 'Blacktip Shark', GETDATE(), GETDATE()),
('ours', 'Honey', 'Honey Bear', GETDATE(), GETDATE()),
('iceberg', 'Noble', 'Northwest Greenland Iceberg', GETDATE(), GETDATE()),
('baleine', 'Giant', 'Gray Whale', GETDATE(), GETDATE()),
('oiseau', 'Hoot', 'Snowy Owl', GETDATE(), GETDATE()),
('requin', 'Blitz', 'Blue Shark', GETDATE(), GETDATE()),
('ours', 'Cub', 'Cub Bear', GETDATE(), GETDATE()),
('iceberg', 'King', 'King George Island Ice', GETDATE(), GETDATE()),
('baleine', 'Voyager', 'Pilot Whale', GETDATE(), GETDATE()),
('oiseau', 'Falcon', 'Falcon', GETDATE(), GETDATE());

INSERT INTO LOGS (mobile_entity_id, recorded_at, lng, lat, temperature, wind_speed, solar_intensity, created_at, updated_at) VALUES
(1, GETDATE(), -20.917574, 55.292118, 25.5, 15.2, 1000, GETDATE(), GETDATE()),
(1, DATEADD(DAY, -1, GETDATE()), -21.117574, 55.492118, 26.0, 15.0, 950, GETDATE(), GETDATE()),
(1, DATEADD(DAY, -2, GETDATE()), -20.827574, 55.382118, 24.8, 14.5, 970, GETDATE(), GETDATE()),
(1, DATEADD(DAY, -3, GETDATE()), -20.737574, 55.472118, 23.2, 16.8, 1100, GETDATE(), GETDATE()),
(1, DATEADD(DAY, -4, GETDATE()), -20.647574, 55.562118, 22.0, 17.2, 1050, GETDATE(), GETDATE());

INSERT INTO LOGS (mobile_entity_id, recorded_at, lng, lat, temperature, wind_speed, solar_intensity, created_at, updated_at) VALUES
(2, GETDATE(), -20.917574, 55.292118, 25.5, 15.2, 1000, GETDATE(), GETDATE()),
(2, DATEADD(DAY, -1, GETDATE()), -21.217574, 55.592118, 26.5, 14.8, 980, GETDATE(), GETDATE()),
(2, DATEADD(DAY, -2, GETDATE()), -20.917574, 55.392118, 24.2, 16.0, 1020, GETDATE(), GETDATE()),
(2, DATEADD(DAY, -3, GETDATE()), -20.617574, 55.492118, 23.8, 17.5, 1050, GETDATE(), GETDATE()),
(2, DATEADD(DAY, -4, GETDATE()), -20.817574, 55.282118, 22.6, 15.6, 990, GETDATE(), GETDATE()),
(2, DATEADD(DAY, -5, GETDATE()), -20.917584, 55.292128, 26.1, 14.7, 950, GETDATE(), GETDATE()),
(2, DATEADD(DAY, -6, GETDATE()), -21.017574, 55.392138, 25.8, 16.2, 965, GETDATE(), GETDATE()),
(2, DATEADD(DAY, -7, GETDATE()), -20.817564, 55.492148, 24.9, 15.4, 980, GETDATE(), GETDATE()),
(2, DATEADD(DAY, -8, GETDATE()), -20.717554, 55.292158, 24.0, 17.0, 995, GETDATE(), GETDATE()),
(2, DATEADD(DAY, -9, GETDATE()), -20.917544, 55.492168, 23.5, 15.8, 1010, GETDATE(), GETDATE()),
(2, DATEADD(DAY, -10, GETDATE()), -21.117534, 55.292178, 23.0, 16.6, 1025, GETDATE(), GETDATE()),
(2, DATEADD(DAY, -11, GETDATE()), -20.817524, 55.492188, 22.5, 14.9, 1040, GETDATE(), GETDATE()),
(2, DATEADD(DAY, -12, GETDATE()), -20.717514, 55.292198, 26.3, 15.1, 1055, GETDATE(), GETDATE()),
(2, DATEADD(DAY, -13, GETDATE()), -20.917504, 55.492208, 25.7, 16.3, 1070, GETDATE(), GETDATE()),
(2, DATEADD(DAY, -14, GETDATE()), -21.017494, 55.292218, 25.2, 15.5, 1085, GETDATE(), GETDATE());

INSERT INTO LOGS (mobile_entity_id, recorded_at, lng, lat, temperature, wind_speed, solar_intensity, created_at, updated_at) VALUES
(3, GETDATE(), -20.917574, 55.292118, 25.5, 15.2, 1000, GETDATE(), GETDATE()),
(3, DATEADD(DAY, -1, GETDATE()), -21.217574, 55.592118, 26.5, 14.8, 980, GETDATE(), GETDATE()),
(3, DATEADD(DAY, -2, GETDATE()), -20.917574, 55.392118, 24.2, 16.0, 1020, GETDATE(), GETDATE()),
(3, DATEADD(DAY, -3, GETDATE()), -20.617574, 55.492118, 23.8, 17.5, 1050, GETDATE(), GETDATE()),
(3, DATEADD(DAY, -4, GETDATE()), -20.817574, 55.282118, 22.6, 15.6, 990, GETDATE(), GETDATE()),
(3, DATEADD(DAY, -5, GETDATE()), -20.917584, 55.292128, 26.1, 14.7, 950, GETDATE(), GETDATE()),
(3, DATEADD(DAY, -11, GETDATE()), -20.817524, 55.492188, 22.5, 14.9, 1040, GETDATE(), GETDATE()),
(3, DATEADD(DAY, -12, GETDATE()), -20.717514, 55.292198, 26.3, 15.1, 1055, GETDATE(), GETDATE()),
(3, DATEADD(DAY, -13, GETDATE()), -20.917504, 55.492208, 25.7, 16.3, 1070, GETDATE(), GETDATE()),
(3, DATEADD(DAY, -14, GETDATE()), -21.017494, 55.292218, 25.2, 15.5, 1085, GETDATE(), GETDATE());

INSERT INTO LOGS (mobile_entity_id, recorded_at, lng, lat, temperature, wind_speed, solar_intensity, created_at, updated_at) VALUES
(4, GETDATE(), -20.917574, 55.292118, 25.5, 15.2, 1000, GETDATE(), GETDATE()),
(4, DATEADD(DAY, -1, GETDATE()), -21.217574, 55.592118, 26.5, 14.8, 980, GETDATE(), GETDATE()),
(4, DATEADD(DAY, -2, GETDATE()), -20.917574, 55.392118, 24.2, 16.0, 1020, GETDATE(), GETDATE()),
(4, DATEADD(DAY, -3, GETDATE()), -20.617574, 55.492118, 23.8, 17.5, 1050, GETDATE(), GETDATE()),
(4, DATEADD(DAY, -4, GETDATE()), -20.817574, 55.282118, 22.6, 15.6, 990, GETDATE(), GETDATE()),
(4, DATEADD(DAY, -5, GETDATE()), -20.917584, 55.292128, 26.1, 14.7, 950, GETDATE(), GETDATE()),
(4, DATEADD(DAY, -6, GETDATE()), -21.017574, 55.392138, 25.8, 16.2, 965, GETDATE(), GETDATE()),
(4, DATEADD(DAY, -7, GETDATE()), -20.817564, 55.492148, 24.9, 15.4, 980, GETDATE(), GETDATE()),
(4, DATEADD(DAY, -8, GETDATE()), -20.717554, 55.292158, 24.0, 17.0, 995, GETDATE(), GETDATE()),
(4, DATEADD(DAY, -9, GETDATE()), -20.917544, 55.492168, 23.5, 15.8, 1010, GETDATE(), GETDATE()),
(4, DATEADD(DAY, -10, GETDATE()), -21.117534, 55.292178, 23.0, 16.6, 1025, GETDATE(), GETDATE()),
(4, DATEADD(DAY, -11, GETDATE()), -20.817524, 55.492188, 22.5, 14.9, 1040, GETDATE(), GETDATE()),
(4, DATEADD(DAY, -12, GETDATE()), -20.717514, 55.292198, 26.3, 15.1, 1055, GETDATE(), GETDATE()),
(4, DATEADD(DAY, -13, GETDATE()), -20.917504, 55.492208, 25.7, 16.3, 1070, GETDATE(), GETDATE()),
(4, DATEADD(DAY, -14, GETDATE()), -21.017494, 55.292218, 25.2, 15.5, 1085, GETDATE(), GETDATE());

INSERT INTO LOGS (mobile_entity_id, recorded_at, lng, lat, temperature, wind_speed, solar_intensity, created_at, updated_at) VALUES
(5, GETDATE(), -20.917574, 55.292118, 25.5, 15.2, 1000, GETDATE(), GETDATE()),
(5, DATEADD(DAY, -1, GETDATE()), -21.217574, 55.592118, 26.5, 14.8, 980, GETDATE(), GETDATE()),
(5, DATEADD(DAY, -2, GETDATE()), -20.917574, 55.392118, 24.2, 16.0, 1020, GETDATE(), GETDATE()),
(5, DATEADD(DAY, -3, GETDATE()), -20.617574, 55.492118, 23.8, 17.5, 1050, GETDATE(), GETDATE()),
(5, DATEADD(DAY, -4, GETDATE()), -20.817574, 55.282118, 22.6, 15.6, 990, GETDATE(), GETDATE()),
(5, DATEADD(DAY, -5, GETDATE()), -20.917584, 55.292128, 26.1, 14.7, 950, GETDATE(), GETDATE()),
(5, DATEADD(DAY, -6, GETDATE()), -21.017574, 55.392138, 25.8, 16.2, 965, GETDATE(), GETDATE()),
(5, DATEADD(DAY, -7, GETDATE()), -20.817564, 55.492148, 24.9, 15.4, 980, GETDATE(), GETDATE()),
(5, DATEADD(DAY, -8, GETDATE()), -20.717554, 55.292158, 24.0, 17.0, 995, GETDATE(), GETDATE()),
(5, DATEADD(DAY, -9, GETDATE()), -20.917544, 55.492168, 23.5, 15.8, 1010, GETDATE(), GETDATE()),
(5, DATEADD(DAY, -10, GETDATE()), -21.117534, 55.292178, 23.0, 16.6, 1025, GETDATE(), GETDATE()),
(5, DATEADD(DAY, -11, GETDATE()), -20.817524, 55.492188, 22.5, 14.9, 1040, GETDATE(), GETDATE()),
(5, DATEADD(DAY, -12, GETDATE()), -20.717514, 55.292198, 26.3, 15.1, 1055, GETDATE(), GETDATE()),
(5, DATEADD(DAY, -13, GETDATE()), -20.917504, 55.492208, 25.7, 16.3, 1070, GETDATE(), GETDATE()),
(5, DATEADD(DAY, -14, GETDATE()), -21.017494, 55.292218, 25.2, 15.5, 1085, GETDATE(), GETDATE());

INSERT INTO USERS (full_name, created_at, updated_at) VALUES
('John Doe', GETDATE(), GETDATE()),
('Jane Smith', GETDATE(), GETDATE()),
('Ecole Internationale', GETDATE(), GETDATE()),
('Laboratoire de Biologie Marine', GETDATE(), GETDATE()),
('Organisme de Conservation', GETDATE(), GETDATE());

INSERT INTO ADOPTIONS (user_id, mobile_entity_id, created_at, updated_at) VALUES
(1, 1, GETDATE(), GETDATE()),
(2, 2, GETDATE(), GETDATE()),
(3, 3, GETDATE(), GETDATE()),
(4, 4, GETDATE(), GETDATE()),
(5, 5, GETDATE(), GETDATE()),
(1, 6, GETDATE(), GETDATE()),
(1, 7, GETDATE(), GETDATE()),
(1, 8, GETDATE(), GETDATE()),
(1, 9, GETDATE(), GETDATE()),
(1, 10, GETDATE(), GETDATE()),
(2, 11, GETDATE(), GETDATE()),
(2, 12, GETDATE(), GETDATE()),
(2, 13, GETDATE(), GETDATE()),
(2, 14, GETDATE(), GETDATE()),
(3, 15, GETDATE(), GETDATE()),
(3, 16, GETDATE(), GETDATE()),
(3, 17, GETDATE(), GETDATE()),
(4, 18, GETDATE(), GETDATE()),
(4, 19, GETDATE(), GETDATE()),
(5, 20, GETDATE(), GETDATE()),
(5, 21, GETDATE(), GETDATE()),
(5, 22, GETDATE(), GETDATE()),
(5, 23, GETDATE(), GETDATE()),
(5, 24, GETDATE(), GETDATE()),
(5, 25, GETDATE(), GETDATE()),
(1, 26, GETDATE(), GETDATE()),
(2, 27, GETDATE(), GETDATE()),
(3, 28, GETDATE(), GETDATE()),
(4, 29, GETDATE(), GETDATE()),
(5, 30, GETDATE(), GETDATE()),
(1, 31, GETDATE(), GETDATE()),
(2, 32, GETDATE(), GETDATE()),
(3, 33, GETDATE(), GETDATE()),
(4, 34, GETDATE(), GETDATE()),
(5, 35, GETDATE(), GETDATE()),
(1, 36, GETDATE(), GETDATE()),
(2, 37, GETDATE(), GETDATE()),
(3, 38, GETDATE(), GETDATE()),
(4, 39, GETDATE(), GETDATE()),
(5, 40, GETDATE(), GETDATE()),
(1, 41, GETDATE(), GETDATE()),
(1, 42, GETDATE(), GETDATE()),
(2, 43, GETDATE(), GETDATE()),
(3, 44, GETDATE(), GETDATE()),
(4, 45, GETDATE(), GETDATE()),
(4, 46, GETDATE(), GETDATE()),
(5, 47, GETDATE(), GETDATE()),
(5, 48, GETDATE(), GETDATE()),
(3, 49, GETDATE(), GETDATE()),
(2, 50, GETDATE(), GETDATE());
