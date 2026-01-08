USE HUMAN_BOT;
GO

/* FACTORIES - Données réelles */
IF NOT EXISTS (SELECT 1 FROM FACTORIES WHERE name = 'Usine Paris')
    INSERT INTO FACTORIES (name, city) VALUES ('Usine Paris', 'Paris');

IF NOT EXISTS (SELECT 1 FROM FACTORIES WHERE name = 'Usine Caracas')
    INSERT INTO FACTORIES (name, city) VALUES ('Usine Caracas', 'Caracas');

IF NOT EXISTS (SELECT 1 FROM FACTORIES WHERE name = 'Usine Beijing')
    INSERT INTO FACTORIES (name, city) VALUES ('Usine Beijing', 'Beijing');
GO

/* ROBOT MODELS - Données réelles */
INSERT INTO ROBOT_MODELS (model_name) 
SELECT model_name FROM (VALUES
    ('Vital Strider'),
    ('Master Sentinel'),
    ('Vanguard Stalker'),
    ('Grim Angel'),
    ('Amplified Master'),
    ('Phoenix'),
    ('Freedom'),
    ('Coyote'),
    ('Vulture'),
    ('Infinity')
) AS models(model_name)
WHERE NOT EXISTS (SELECT 1 FROM ROBOT_MODELS WHERE model_name = models.model_name);
GO

/* SUPPLIERS - Données réelles */
INSERT INTO SUPPLIERS (supplier_name)
SELECT supplier_name FROM (VALUES
    ('Optimux'),
    ('Boston Mimics'),
    ('VCTech Robotics')
) AS suppliers(supplier_name)
WHERE NOT EXISTS (SELECT 1 FROM SUPPLIERS WHERE supplier_name = suppliers.supplier_name);
GO

/* SPARE PARTS - Données réelles */
INSERT INTO SPARE_PARTS (part_name)
SELECT part_name FROM (VALUES
    ('bras droit'),
    ('bras gauche'),
    ('jambe droit'),
    ('jambe gauche'),
    ('tete'),
    ('buste'),
    ('jetpack')
) AS parts(part_name)
WHERE NOT EXISTS (SELECT 1 FROM SPARE_PARTS WHERE part_name = parts.part_name);
GO

/* ROBOT_PARTS_COMPOSITION - Version SIMPLIFIÉE */
-- Vider la table d'abord
DELETE FROM ROBOT_PARTS_COMPOSITION;

-- Remplir avec les données de base
DECLARE @model_id INT, @part_id INT, @supplier_id INT;

-- Pour chaque modèle de robot, assigner les 7 pièces avec leurs fournisseurs
DECLARE model_cursor CURSOR FOR
SELECT model_id, model_name FROM ROBOT_MODELS;

DECLARE @model_name VARCHAR(50);

OPEN model_cursor;
FETCH NEXT FROM model_cursor INTO @model_id, @model_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Assigner les pièces selon le modèle
    -- Tous les modèles ont les mêmes 7 pièces, mais avec des fournisseurs différents
    
    -- bras droit
    SELECT @part_id = part_id FROM SPARE_PARTS WHERE part_name = 'bras droit';
    SELECT @supplier_id = supplier_id FROM SUPPLIERS 
    WHERE supplier_name = CASE @model_name
        WHEN 'Vital Strider' THEN 'Optimux'
        WHEN 'Master Sentinel' THEN 'Boston Mimics'
        WHEN 'Vanguard Stalker' THEN 'VCTech Robotics'
        WHEN 'Grim Angel' THEN 'Optimux'
        WHEN 'Amplified Master' THEN 'Boston Mimics'
        WHEN 'Phoenix' THEN 'VCTech Robotics'
        WHEN 'Freedom' THEN 'Optimux'
        WHEN 'Coyote' THEN 'Boston Mimics'
        WHEN 'Vulture' THEN 'VCTech Robotics'
        WHEN 'Infinity' THEN 'Optimux'
        ELSE 'Optimux'
    END;
    INSERT INTO ROBOT_PARTS_COMPOSITION (model_id, part_id, supplier_id) 
    VALUES (@model_id, @part_id, @supplier_id);
    
    -- bras gauche
    SELECT @part_id = part_id FROM SPARE_PARTS WHERE part_name = 'bras gauche';
    SELECT @supplier_id = supplier_id FROM SUPPLIERS 
    WHERE supplier_name = CASE @model_name
        WHEN 'Vital Strider' THEN 'Boston Mimics'
        WHEN 'Master Sentinel' THEN 'VCTech Robotics'
        WHEN 'Vanguard Stalker' THEN 'Optimux'
        WHEN 'Grim Angel' THEN 'Boston Mimics'
        WHEN 'Amplified Master' THEN 'VCTech Robotics'
        WHEN 'Phoenix' THEN 'Optimux'
        WHEN 'Freedom' THEN 'Boston Mimics'
        WHEN 'Coyote' THEN 'VCTech Robotics'
        WHEN 'Vulture' THEN 'Optimux'
        WHEN 'Infinity' THEN 'Boston Mimics'
        ELSE 'Boston Mimics'
    END;
    INSERT INTO ROBOT_PARTS_COMPOSITION (model_id, part_id, supplier_id) 
    VALUES (@model_id, @part_id, @supplier_id);
    
    -- jambe droit
    SELECT @part_id = part_id FROM SPARE_PARTS WHERE part_name = 'jambe droit';
    SELECT @supplier_id = supplier_id FROM SUPPLIERS 
    WHERE supplier_name = CASE @model_name
        WHEN 'Vital Strider' THEN 'VCTech Robotics'
        WHEN 'Master Sentinel' THEN 'Optimux'
        WHEN 'Vanguard Stalker' THEN 'Boston Mimics'
        WHEN 'Grim Angel' THEN 'VCTech Robotics'
        WHEN 'Amplified Master' THEN 'Optimux'
        WHEN 'Phoenix' THEN 'Boston Mimics'
        WHEN 'Freedom' THEN 'VCTech Robotics'
        WHEN 'Coyote' THEN 'Optimux'
        WHEN 'Vulture' THEN 'Boston Mimics'
        WHEN 'Infinity' THEN 'VCTech Robotics'
        ELSE 'VCTech Robotics'
    END;
    INSERT INTO ROBOT_PARTS_COMPOSITION (model_id, part_id, supplier_id) 
    VALUES (@model_id, @part_id, @supplier_id);
    
    -- jambe gauche
    SELECT @part_id = part_id FROM SPARE_PARTS WHERE part_name = 'jambe gauche';
    SELECT @supplier_id = supplier_id FROM SUPPLIERS 
    WHERE supplier_name = CASE @model_name
        WHEN 'Vital Strider' THEN 'Optimux'
        WHEN 'Master Sentinel' THEN 'Boston Mimics'
        WHEN 'Vanguard Stalker' THEN 'VCTech Robotics'
        WHEN 'Grim Angel' THEN 'Optimux'
        WHEN 'Amplified Master' THEN 'Boston Mimics'
        WHEN 'Phoenix' THEN 'VCTech Robotics'
        WHEN 'Freedom' THEN 'Optimux'
        WHEN 'Coyote' THEN 'Boston Mimics'
        WHEN 'Vulture' THEN 'VCTech Robotics'
        WHEN 'Infinity' THEN 'Optimux'
        ELSE 'Optimux'
    END;
    INSERT INTO ROBOT_PARTS_COMPOSITION (model_id, part_id, supplier_id) 
    VALUES (@model_id, @part_id, @supplier_id);
    
    -- tete
    SELECT @part_id = part_id FROM SPARE_PARTS WHERE part_name = 'tete';
    SELECT @supplier_id = supplier_id FROM SUPPLIERS 
    WHERE supplier_name = CASE @model_name
        WHEN 'Vital Strider' THEN 'Boston Mimics'
        WHEN 'Master Sentinel' THEN 'VCTech Robotics'
        WHEN 'Vanguard Stalker' THEN 'Optimux'
        WHEN 'Grim Angel' THEN 'Boston Mimics'
        WHEN 'Amplified Master' THEN 'VCTech Robotics'
        WHEN 'Phoenix' THEN 'Optimux'
        WHEN 'Freedom' THEN 'Boston Mimics'
        WHEN 'Coyote' THEN 'VCTech Robotics'
        WHEN 'Vulture' THEN 'Optimux'
        WHEN 'Infinity' THEN 'Boston Mimics'
        ELSE 'Boston Mimics'
    END;
    INSERT INTO ROBOT_PARTS_COMPOSITION (model_id, part_id, supplier_id) 
    VALUES (@model_id, @part_id, @supplier_id);
    
    -- buste
    SELECT @part_id = part_id FROM SPARE_PARTS WHERE part_name = 'buste';
    SELECT @supplier_id = supplier_id FROM SUPPLIERS 
    WHERE supplier_name = CASE @model_name
        WHEN 'Vital Strider' THEN 'VCTech Robotics'
        WHEN 'Master Sentinel' THEN 'Optimux'
        WHEN 'Vanguard Stalker' THEN 'Boston Mimics'
        WHEN 'Grim Angel' THEN 'VCTech Robotics'
        WHEN 'Amplified Master' THEN 'Optimux'
        WHEN 'Phoenix' THEN 'Boston Mimics'
        WHEN 'Freedom' THEN 'VCTech Robotics'
        WHEN 'Coyote' THEN 'Optimux'
        WHEN 'Vulture' THEN 'Boston Mimics'
        WHEN 'Infinity' THEN 'VCTech Robotics'
        ELSE 'VCTech Robotics'
    END;
    INSERT INTO ROBOT_PARTS_COMPOSITION (model_id, part_id, supplier_id) 
    VALUES (@model_id, @part_id, @supplier_id);
    
    -- jetpack
    SELECT @part_id = part_id FROM SPARE_PARTS WHERE part_name = 'jetpack';
    SELECT @supplier_id = supplier_id FROM SUPPLIERS 
    WHERE supplier_name = CASE @model_name
        WHEN 'Vital Strider' THEN 'Optimux'
        WHEN 'Master Sentinel' THEN 'Boston Mimics'
        WHEN 'Vanguard Stalker' THEN 'VCTech Robotics'
        WHEN 'Grim Angel' THEN 'Optimux'
        WHEN 'Amplified Master' THEN 'Boston Mimics'
        WHEN 'Phoenix' THEN 'VCTech Robotics'
        WHEN 'Freedom' THEN 'Optimux'
        WHEN 'Coyote' THEN 'Boston Mimics'
        WHEN 'Vulture' THEN 'VCTech Robotics'
        WHEN 'Infinity' THEN 'Optimux'
        ELSE 'Optimux'
    END;
    INSERT INTO ROBOT_PARTS_COMPOSITION (model_id, part_id, supplier_id) 
    VALUES (@model_id, @part_id, @supplier_id);
    
    FETCH NEXT FROM model_cursor INTO @model_id, @model_name;
END;

CLOSE model_cursor;
DEALLOCATE model_cursor;
GO

/* SUPPLIER_DELIVERIES - Données pour BEST_SUPPLIERS */
-- Optimux livre 1500 pièces
INSERT INTO SUPPLIER_DELIVERIES (supplier_id, part_id, factory_id, delivery_date, quantity)
SELECT 
    s.supplier_id,
    sp.part_id,
    f.factory_id,
    '2024-01-15',
    300
FROM SUPPLIERS s
CROSS JOIN SPARE_PARTS sp
CROSS JOIN FACTORIES f
WHERE s.supplier_name = 'Optimux'
AND f.name = 'Usine Paris'
AND NOT EXISTS (
    SELECT 1 FROM SUPPLIER_DELIVERIES sd 
    WHERE sd.supplier_id = s.supplier_id 
    AND sd.part_id = sp.part_id 
    AND sd.factory_id = f.factory_id
    AND sd.delivery_date = '2024-01-15'
);

-- Boston Mimics livre 800 pièces
INSERT INTO SUPPLIER_DELIVERIES (supplier_id, part_id, factory_id, delivery_date, quantity)
SELECT 
    s.supplier_id,
    sp.part_id,
    f.factory_id,
    '2024-01-15',
    200
FROM SUPPLIERS s
CROSS JOIN SPARE_PARTS sp
CROSS JOIN FACTORIES f
WHERE s.supplier_name = 'Boston Mimics'
AND f.name = 'Usine Paris'
AND NOT EXISTS (
    SELECT 1 FROM SUPPLIER_DELIVERIES sd 
    WHERE sd.supplier_id = s.supplier_id 
    AND sd.part_id = sp.part_id 
    AND sd.factory_id = f.factory_id
    AND sd.delivery_date = '2024-01-15'
);
GO

/* PRODUCTION - Données réelles du dataset */
-- Vider la table d'abord
DELETE FROM PRODUCTION;

-- Insertion directe et simple des données
INSERT INTO PRODUCTION (factory_id, model_id, production_date, quantity)
SELECT f.factory_id, rm.model_id, '2020-01-01', 29
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Vital Strider'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-01-01', 14
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Master Sentinel'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-01-01', 3
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Vanguard Stalker'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-01-01', 34
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Grim Angel'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-01-01', 41
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Amplified Master'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-01-01', 8
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Phoenix'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-01-01', 25
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Freedom'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-01-01', 0
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Coyote'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-01-01', 13
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Beijing' AND rm.model_name = 'Vulture'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-01-01', 9
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Infinity';
GO

-- 2020-02-01
INSERT INTO PRODUCTION (factory_id, model_id, production_date, quantity)
SELECT f.factory_id, rm.model_id, '2020-02-01', 2
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Vital Strider'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-02-01', 13
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Master Sentinel'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-02-01', 32
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Vanguard Stalker'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-02-01', 25
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Grim Angel'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-02-01', 6
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Amplified Master'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-02-01', 34
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Phoenix'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-02-01', 21
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Freedom'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-02-01', 20
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Coyote'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-02-01', 38
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Beijing' AND rm.model_name = 'Vulture'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-02-01', 41
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Infinity';
GO

-- 2020-03-01
INSERT INTO PRODUCTION (factory_id, model_id, production_date, quantity)
SELECT f.factory_id, rm.model_id, '2020-03-01', 1
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Vital Strider'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-03-01', 22
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Master Sentinel'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-03-01', 31
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Vanguard Stalker'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-03-01', 15
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Grim Angel'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-03-01', 28
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Amplified Master'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-03-01', 4
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Phoenix'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-03-01', 39
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Freedom'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-03-01', 22
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Coyote'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-03-01', 39
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Beijing' AND rm.model_name = 'Vulture'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-03-01', 3
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Infinity';
GO

-- 2020-04-01
INSERT INTO PRODUCTION (factory_id, model_id, production_date, quantity)
SELECT f.factory_id, rm.model_id, '2020-04-01', 31
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Vital Strider'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-04-01', 26
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Master Sentinel'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-04-01', 26
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Vanguard Stalker'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-04-01', 38
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Grim Angel'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-04-01', 17
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Paris' AND rm.model_name = 'Amplified Master'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-04-01', 33
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Phoenix'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-04-01', 18
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Freedom'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-04-01', 14
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Coyote'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-04-01', 24
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Beijing' AND rm.model_name = 'Vulture'
UNION ALL
SELECT f.factory_id, rm.model_id, '2020-04-01', 19
FROM FACTORIES f, ROBOT_MODELS rm
WHERE f.name = 'Usine Caracas' AND rm.model_name = 'Infinity';
GO

/* WORKERS - Données réelles du dataset intervenants */
INSERT INTO WORKERS (lastname, firstname, age)
SELECT lastname, firstname, age FROM (VALUES
    ('Hurst', 'Alan', 61),
    ('Kelly', 'Floyd', 73),
    ('Woodard', 'Roger', 34),
    ('Mullins', 'Leon', 34),
    ('Howe', 'Kim', 20),
    ('Hicks', 'Brad', 21),
    ('Owens', 'Jonathon', 67),
    ('Strong', 'Eddie', 34),
    ('Gamble', 'Alec', 54),
    ('Harrington', 'Wesley', 17),
    ('Guy', 'Marcia', 53),
    ('McLeod', 'Theresa', 68),
    ('Livingston', 'Janice', 51),
    ('Lancaster', 'Mallory', 71),
    ('McCormick', 'Bridget', 29),
    ('Burch', 'Rebekah', 41),
    ('Holland', 'Autumn', 42),
    ('Case', 'Claire', 65),
    ('Waller', 'Billie', 60),
    ('Brock', 'Constance', 31)
) AS workers_data(lastname, firstname, age)
WHERE NOT EXISTS (
    SELECT 1 FROM WORKERS w 
    WHERE w.lastname = workers_data.lastname 
    AND w.firstname = workers_data.firstname
);
GO

/* CONTRACTS - Données réelles */
-- Insertion simplifiée des contrats
INSERT INTO CONTRACTS (worker_id, factory_id, start_date, end_date)
SELECT 
    w.worker_id,
    f.factory_id,
    '2024-01-01' AS start_date,
    NULL AS end_date  -- Tous les contrats sont actifs pour la vue ALL_WORKERS
FROM WORKERS w
CROSS JOIN FACTORIES f
WHERE f.name IN ('Usine Paris', 'Usine Caracas')
AND NOT EXISTS (
    SELECT 1 FROM CONTRACTS c 
    WHERE c.worker_id = w.worker_id 
    AND c.factory_id = f.factory_id
);
GO

PRINT '=== DONNÉES INSÉRÉES AVEC SUCCÈS ===';
PRINT 'Factories: 3 usines';
PRINT 'Robot Models: 10 modèles';
PRINT 'Suppliers: 3 fournisseurs';
PRINT 'Spare Parts: 7 types de pièces';
PRINT 'Robot Parts Composition: 10 modèles x 7 pièces = 70 relations';
PRINT 'Production: 40 enregistrements (10 robots x 4 mois)';
PRINT 'Workers: 20 travailleurs';
PRINT 'Contracts: Contrats actifs pour toutes les usines';
GO