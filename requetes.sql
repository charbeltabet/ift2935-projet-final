-- Nombre d'entités adoptées par nombre d'utilisateurs, trié par ordre décroissant
SELECT
    ME.type AS TypeEntite,
    ME.name AS NomEntite,
    COUNT(A.user_id) AS NombreAdoptants
FROM
    MOBILE_ENTITY AS ME
    LEFT JOIN ADOPTIONS AS A ON ME.id = A.mobile_entity_id
GROUP BY
    ME.type, ME.name
ORDER BY
    NombreAdoptants DESC;

-- Liste des utilisateurs et le nombre d'entités qu'ils ont adoptées, triée par nombre d'adoptions
SELECT
    U.full_name AS NomUtilisateur,
    COUNT(A.mobile_entity_id) AS NombreEntitesAdoptees
FROM
    USERS AS U
    LEFT JOIN ADOPTIONS AS A ON U.id = A.user_id
GROUP BY
    U.full_name
ORDER BY
    NombreEntitesAdoptees DESC;

-- Détails des entités mobiles qui n'ont pas été adoptées
SELECT
    ME.type AS TypeEntite,
    ME.name AS NomEntite
FROM
    MOBILE_ENTITY AS ME
    LEFT JOIN ADOPTIONS AS A ON ME.id = A.mobile_entity_id
WHERE
    A.mobile_entity_id IS NULL;

-- Afficher toutes les positions enregistrées pour une entité spécifique
-- 'Bruce' est le nom de l'entité désirée
SELECT
    L.*
FROM
    LOGS AS L
    JOIN MOBILE_ENTITY AS ME ON L.mobile_entity_id = ME.id
WHERE
    ME.name = 'Bruce'
ORDER BY
    L.recorded_at DESC;

-- Afficher le dernier emplacement enregistré pour chaque entité mobile
SELECT
    ME.name AS NomEntite,
    L.*
FROM
    MOBILE_ENTITY AS ME
    JOIN LOGS AS L ON ME.id = L.mobile_entity_id
    INNER JOIN (
        SELECT
            mobile_entity_id,
            MAX(recorded_at) as LastRecorded
        FROM
            LOGS
        GROUP BY
            mobile_entity_id
    ) AS LastLogs ON L.mobile_entity_id = LastLogs.mobile_entity_id AND L.recorded_at = LastLogs.LastRecorded;

-- Afficher les utilisateurs qui ont adopté plus d'une entité
SELECT
    U.full_name AS NomUtilisateur,
    COUNT(A.mobile_entity_id) AS NombreEntitesAdoptees
FROM
    USERS AS U
    JOIN ADOPTIONS AS A ON U.id = A.user_id
GROUP BY
    U.full_name
HAVING
    COUNT(A.mobile_entity_id) > 1;

-- Afficher les entités mobiles par type avec le nombre d'adoptions
SELECT
    ME.type AS TypeEntite,
    COUNT(A.mobile_entity_id) AS NombreAdoptions
FROM
    MOBILE_ENTITY AS ME
    LEFT JOIN ADOPTIONS AS A ON ME.id = A.mobile_entity_id
GROUP BY
    ME.type;

-- Afficher les adoptions récentes avec les informations de l'utilisateur et de l'entité mobile
SELECT
    U.full_name AS NomUtilisateur,
    ME.name AS NomEntite,
    A.created_at AS DateAdoption
FROM
    ADOPTIONS AS A
    JOIN USERS AS U ON A.user_id = U.id
    JOIN MOBILE_ENTITY AS ME ON A.mobile_entity_id = ME.id
ORDER BY
    A.created_at DESC

-- Afficher la moyenne des températures enregistrées pour chaque type d'entité mobile
SELECT
    ME.type AS TypeEntite,
    AVG(L.temperature) AS TemperatureMoyenne
FROM
    LOGS AS L
    JOIN MOBILE_ENTITY AS ME ON L.mobile_entity_id = ME.id
GROUP BY
    ME.type;

-- Afficher les utilisateurs et leurs entités adoptées
SELECT
    U.full_name AS NomUtilisateur,
    ME.name AS NomEntite
FROM
    ADOPTIONS AS A
    JOIN USERS AS U ON A.user_id = U.id
    JOIN MOBILE_ENTITY AS ME ON A.mobile_entity_id = ME.id
ORDER BY
    U.full_name, ME.name;
