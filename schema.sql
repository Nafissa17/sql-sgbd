/* -------------DATABASE----------------- */
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'HUMAN_BOT')
    DROP DATABASE HUMAN_BOT;
GO

CREATE DATABASE HUMAN_BOT;
GO

USE HUMAN_BOT;
GO

/* -------------FACTORIES----------------- */
IF OBJECT_ID('FACTORIES', 'U') IS NOT NULL
    DROP TABLE FACTORIES;
GO

CREATE TABLE FACTORIES (
    factory_id INT IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(50) NOT NULL
);
GO

/* -------------WORKERS----------------- */
IF OBJECT_ID('WORKERS', 'U') IS NOT NULL
    DROP TABLE WORKERS;
GO

CREATE TABLE WORKERS (
    worker_id INT IDENTITY PRIMARY KEY,
    lastname VARCHAR(100) NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    age INT NULL,
    CONSTRAINT chk_worker_age_positive CHECK (age IS NULL OR age > 0)
);
GO

/* -------------CONTRACTS----------------- */
IF OBJECT_ID('CONTRACTS', 'U') IS NOT NULL
    DROP TABLE CONTRACTS;
GO

CREATE TABLE CONTRACTS (
    contract_id INT IDENTITY PRIMARY KEY,
    worker_id INT NOT NULL,
    factory_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    duration_days AS DATEDIFF(DAY, start_date, ISNULL(end_date, GETDATE())),
    CONSTRAINT fk_contract_worker
        FOREIGN KEY (worker_id) REFERENCES WORKERS(worker_id),
    CONSTRAINT fk_contract_factory
        FOREIGN KEY (factory_id) REFERENCES FACTORIES(factory_id),
    CONSTRAINT chk_contract_dates
        CHECK (end_date IS NULL OR end_date >= start_date)
);
GO

/* -------------ROBOT MODELS----------------- */
IF OBJECT_ID('ROBOT_MODELS', 'U') IS NOT NULL
    DROP TABLE ROBOT_MODELS;
GO

CREATE TABLE ROBOT_MODELS (
    model_id INT IDENTITY PRIMARY KEY,
    model_name VARCHAR(50) NOT NULL UNIQUE
);
GO

/* -------------ROBOTS----------------- */
IF OBJECT_ID('ROBOTS', 'U') IS NOT NULL
    DROP TABLE ROBOTS;
GO

CREATE TABLE ROBOTS (
    robot_id INT IDENTITY PRIMARY KEY,
    model_id INT NOT NULL,
    factory_id INT NOT NULL,
    assembly_date DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_robot_model
        FOREIGN KEY (model_id) REFERENCES ROBOT_MODELS(model_id),
    CONSTRAINT fk_robot_factory
        FOREIGN KEY (factory_id) REFERENCES FACTORIES(factory_id)
);
GO

/* -------------SPARE PARTS----------------- */
IF OBJECT_ID('SPARE_PARTS', 'U') IS NOT NULL
    DROP TABLE SPARE_PARTS;
GO

CREATE TABLE SPARE_PARTS (
    part_id INT IDENTITY PRIMARY KEY,
    part_name VARCHAR(100) NOT NULL UNIQUE
);
GO

/* -------------SUPPLIERS----------------- */
IF OBJECT_ID('SUPPLIERS', 'U') IS NOT NULL
    DROP TABLE SUPPLIERS;
GO

CREATE TABLE SUPPLIERS (
    supplier_id INT IDENTITY PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL UNIQUE
);
GO

/* -------------SUPPLIER PARTS----------------- */
IF OBJECT_ID('SUPPLIER_PARTS', 'U') IS NOT NULL
    DROP TABLE SUPPLIER_PARTS;
GO

CREATE TABLE SUPPLIER_PARTS (
    supplier_id INT NOT NULL,
    part_id INT NOT NULL,
    quantity_supplied INT NOT NULL,
    CONSTRAINT pk_supplier_parts PRIMARY KEY (supplier_id, part_id),
    CONSTRAINT fk_sp_supplier
        FOREIGN KEY (supplier_id) REFERENCES SUPPLIERS(supplier_id),
    CONSTRAINT fk_sp_part
        FOREIGN KEY (part_id) REFERENCES SPARE_PARTS(part_id),
    CONSTRAINT chk_quantity_supplied CHECK (quantity_supplied > 0)
);
GO

/* -------------ROBOT PARTS----------------- */
IF OBJECT_ID('ROBOT_PARTS', 'U') IS NOT NULL
    DROP TABLE ROBOT_PARTS;
GO

CREATE TABLE ROBOT_PARTS (
    robot_id INT NOT NULL,
    part_id INT NOT NULL,
    quantity_needed INT NOT NULL,
    CONSTRAINT pk_robot_parts PRIMARY KEY (robot_id, part_id),
    CONSTRAINT fk_rp_robot
        FOREIGN KEY (robot_id) REFERENCES ROBOTS(robot_id),
    CONSTRAINT fk_rp_part
        FOREIGN KEY (part_id) REFERENCES SPARE_PARTS(part_id),
    CONSTRAINT chk_quantity_needed CHECK (quantity_needed > 0)
);
GO

/* -------------PRODUCTION----------------- */
IF OBJECT_ID('PRODUCTION', 'U') IS NOT NULL
    DROP TABLE PRODUCTION;
GO

CREATE TABLE PRODUCTION (
    production_id INT IDENTITY PRIMARY KEY,
    factory_id INT NOT NULL,
    model_id INT NOT NULL,
    production_date DATE NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    CONSTRAINT fk_prod_factory
        FOREIGN KEY (factory_id) REFERENCES FACTORIES(factory_id),
    CONSTRAINT fk_prod_model
        FOREIGN KEY (model_id) REFERENCES ROBOT_MODELS(model_id)
);
GO

/* -------------AUDIT ROBOT----------------- */
IF OBJECT_ID('AUDIT_ROBOT', 'U') IS NOT NULL
    DROP TABLE AUDIT_ROBOT;
GO

CREATE TABLE AUDIT_ROBOT (
    audit_id INT IDENTITY PRIMARY KEY,
    robot_id INT NOT NULL,
    factory_id INT NOT NULL,
    model_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);
GO


/*---------------VIEWS----------------- */

/* 1. ALL_WORKERS */
CREATE OR ALTER VIEW ALL_WORKERS AS
SELECT
    w.worker_id,
    w.lastname,
    w.firstname,
    w.age,
    c.start_date
FROM WORKERS w
JOIN CONTRACTS c ON w.worker_id = c.worker_id
WHERE c.end_date IS NULL;
GO


/* 2. ALL_WORKERS_ELAPSED */
CREATE OR ALTER VIEW ALL_WORKERS_ELAPSED AS
SELECT
    worker_id,
    lastname,
    firstname,
    DATEDIFF(DAY, start_date, GETDATE()) AS nb_days_elapsed
FROM ALL_WORKERS;
GO


/* 3. BEST_SUPPLIERS */
CREATE VIEW BEST_SUPPLIERS AS
SELECT
    s.supplier_name AS supplier,
    SUM(sp.quantity_supplied) AS nb_parts
FROM SUPPLIERS s
JOIN SUPPLIER_PARTS sp ON s.supplier_id = sp.supplier_id
GROUP BY s.supplier_name
HAVING SUM(sp.quantity_supplied) > 1000;
GO

/* 4. ROBOTS_FACTORIES */
CREATE VIEW ROBOTS_FACTORIES AS
SELECT
    f.name AS factory,
    COUNT(r.robot_id) AS nb_robots
FROM ROBOTS r
JOIN FACTORIES f ON r.factory_id = f.factory_id
GROUP BY f.name;
GO

