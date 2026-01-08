USE HUMAN_BOT;
GO

/* FACTORIES */
INSERT INTO FACTORIES (name, city)
SELECT 'Usine Paris', 'Paris'
WHERE NOT EXISTS (SELECT 1 FROM FACTORIES WHERE name = 'Usine Paris');

INSERT INTO FACTORIES (name, city)
SELECT 'Usine Caracas', 'Caracas'
WHERE NOT EXISTS (SELECT 1 FROM FACTORIES WHERE name = 'Usine Caracas');

INSERT INTO FACTORIES (name, city)
SELECT 'Usine Beijing', 'Beijing'
WHERE NOT EXISTS (SELECT 1 FROM FACTORIES WHERE name = 'Usine Beijing');
GO

/* ROBOT MODELS */
INSERT INTO ROBOT_MODELS (model_name)
SELECT v.model_name
FROM (VALUES
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
) v(model_name)
WHERE NOT EXISTS (
    SELECT 1 FROM ROBOT_MODELS rm WHERE rm.model_name = v.model_name
);
GO

/* SUPPLIERS */
INSERT INTO SUPPLIERS (supplier_name)
SELECT v.supplier_name
FROM (VALUES
 ('CyberParts'),
 ('MechaSupply'),
 ('RoboCore')
) v(supplier_name)
WHERE NOT EXISTS (
    SELECT 1 FROM SUPPLIERS s WHERE s.supplier_name = v.supplier_name
);
GO

/* SPARE PARTS */
INSERT INTO SPARE_PARTS (part_name)
SELECT v.part_name
FROM (VALUES
 ('Head'),
 ('Arm'),
 ('Leg'),
 ('CPU'),
 ('Sensor')
) v(part_name)
WHERE NOT EXISTS (
    SELECT 1 FROM SPARE_PARTS p WHERE p.part_name = v.part_name
);
GO

/* SUPPLIER PARTS (quantités élevées pour BEST_SUPPLIERS) */
INSERT INTO SUPPLIER_PARTS (supplier_id, part_id, quantity_supplied)
SELECT s.supplier_id, p.part_id, 600
FROM SUPPLIERS s
CROSS JOIN SPARE_PARTS p
WHERE s.supplier_name = 'CyberParts';

INSERT INTO SUPPLIER_PARTS (supplier_id, part_id, quantity_supplied)
SELECT s.supplier_id, p.part_id, 500
FROM SUPPLIERS s
CROSS JOIN SPARE_PARTS p
WHERE s.supplier_name = 'MechaSupply';
GO

/* PRODUCTION (DATASET EXCEL) */

/* -------- 01/01/2020 -------- */
INSERT INTO PRODUCTION (factory_id, model_id, production_date, quantity)
SELECT f.factory_id, m.model_id, '2020-01-01', v.quantity
FROM (VALUES
 ('Vital Strider','Usine Paris',29),
 ('Master Sentinel','Usine Paris',14),
 ('Vanguard Stalker','Usine Paris',3),
 ('Grim Angel','Usine Paris',34),
 ('Amplified Master','Usine Paris',41),
 ('Phoenix','Usine Caracas',8),
 ('Freedom','Usine Caracas',25),
 ('Coyote','Usine Caracas',0),
 ('Vulture','Usine Beijing',13),
 ('Infinity','Usine Caracas',9)
) v(model_name, factory_name, quantity)
JOIN ROBOT_MODELS m ON m.model_name = v.model_name
JOIN FACTORIES f ON f.name = v.factory_name;

/* -------- 01/02/2020 -------- */
INSERT INTO PRODUCTION (factory_id, model_id, production_date, quantity)
SELECT f.factory_id, m.model_id, '2020-02-01', v.quantity
FROM (VALUES
 ('Vital Strider','Usine Paris',2),
 ('Master Sentinel','Usine Paris',13),
 ('Vanguard Stalker','Usine Paris',32),
 ('Grim Angel','Usine Paris',25),
 ('Amplified Master','Usine Paris',6),
 ('Phoenix','Usine Caracas',34),
 ('Freedom','Usine Caracas',21),
 ('Coyote','Usine Caracas',20),
 ('Vulture','Usine Beijing',38),
 ('Infinity','Usine Caracas',41)
) v(model_name, factory_name, quantity)
JOIN ROBOT_MODELS m ON m.model_name = v.model_name
JOIN FACTORIES f ON f.name = v.factory_name;

/* -------- 01/03/2020 -------- */
INSERT INTO PRODUCTION (factory_id, model_id, production_date, quantity)
SELECT f.factory_id, m.model_id, '2020-03-01', v.quantity
FROM (VALUES
 ('Vital Strider','Usine Paris',1),
 ('Master Sentinel','Usine Paris',22),
 ('Vanguard Stalker','Usine Paris',31),
 ('Grim Angel','Usine Paris',15),
 ('Amplified Master','Usine Paris',28),
 ('Phoenix','Usine Caracas',4),
 ('Freedom','Usine Caracas',39),
 ('Coyote','Usine Caracas',22),
 ('Vulture','Usine Beijing',39),
 ('Infinity','Usine Caracas',3)
) v(model_name, factory_name, quantity)
JOIN ROBOT_MODELS m ON m.model_name = v.model_name
JOIN FACTORIES f ON f.name = v.factory_name;

/* -------- 01/04/2020 -------- */
INSERT INTO PRODUCTION (factory_id, model_id, production_date, quantity)
SELECT f.factory_id, m.model_id, '2020-04-01', v.quantity
FROM (VALUES
 ('Vital Strider','Usine Paris',31),
 ('Master Sentinel','Usine Paris',26),
 ('Vanguard Stalker','Usine Paris',26),
 ('Grim Angel','Usine Paris',38),
 ('Amplified Master','Usine Paris',17),
 ('Phoenix','Usine Caracas',33),
 ('Freedom','Usine Caracas',18),
 ('Coyote','Usine Caracas',14),
 ('Vulture','Usine Beijing',24),
 ('Infinity','Usine Caracas',19)
) v(model_name, factory_name, quantity)
JOIN ROBOT_MODELS m ON m.model_name = v.model_name
JOIN FACTORIES f ON f.name = v.factory_name;
GO
