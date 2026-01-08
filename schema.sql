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

/* -------------SUPPLIERS----------------- */
IF OBJECT_ID('SUPPLIERS', 'U') IS NOT NULL
    DROP TABLE SUPPLIERS;
GO

CREATE TABLE SUPPLIERS (
    supplier_id INT IDENTITY PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL UNIQUE
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

/* -------------ROBOT_PARTS (Composition des robots)----------------- */
IF OBJECT_ID('ROBOT_PARTS_COMPOSITION', 'U') IS NOT NULL
    DROP TABLE ROBOT_PARTS_COMPOSITION;
GO

CREATE TABLE ROBOT_PARTS_COMPOSITION (
    composition_id INT IDENTITY PRIMARY KEY,
    model_id INT NOT NULL,
    part_id INT NOT NULL,
    supplier_id INT NOT NULL,
    CONSTRAINT fk_rpc_model
        FOREIGN KEY (model_id) REFERENCES ROBOT_MODELS(model_id),
    CONSTRAINT fk_rpc_part
        FOREIGN KEY (part_id) REFERENCES SPARE_PARTS(part_id),
    CONSTRAINT fk_rpc_supplier
        FOREIGN KEY (supplier_id) REFERENCES SUPPLIERS(supplier_id),
    CONSTRAINT uq_model_part UNIQUE (model_id, part_id)
);
GO

/* -------------SUPPLIER_DELIVERIES (Livraisons de pièces)----------------- */
IF OBJECT_ID('SUPPLIER_DELIVERIES', 'U') IS NOT NULL
    DROP TABLE SUPPLIER_DELIVERIES;
GO

CREATE TABLE SUPPLIER_DELIVERIES (
    delivery_id INT IDENTITY PRIMARY KEY,
    supplier_id INT NOT NULL,
    part_id INT NOT NULL,
    factory_id INT NOT NULL,
    delivery_date DATE NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    CONSTRAINT fk_delivery_supplier
        FOREIGN KEY (supplier_id) REFERENCES SUPPLIERS(supplier_id),
    CONSTRAINT fk_delivery_part
        FOREIGN KEY (part_id) REFERENCES SPARE_PARTS(part_id),
    CONSTRAINT fk_delivery_factory
        FOREIGN KEY (factory_id) REFERENCES FACTORIES(factory_id)
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

/* -------------AUDIT_ROBOT----------------- */
IF OBJECT_ID('AUDIT_ROBOT', 'U') IS NOT NULL
    DROP TABLE AUDIT_ROBOT;
GO

CREATE TABLE AUDIT_ROBOT (
    audit_id INT IDENTITY PRIMARY KEY,
    model_name VARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);
GO

/* -------------VUE 1: ALL_WORKERS----------------- */
CREATE OR ALTER VIEW ALL_WORKERS AS
SELECT
    w.worker_id,
    w.lastname,
    w.firstname,
    w.age,
    c.start_date,
    f.name as factory_name
FROM WORKERS w
JOIN CONTRACTS c ON w.worker_id = c.worker_id
JOIN FACTORIES f ON c.factory_id = f.factory_id
WHERE c.end_date IS NULL;
GO

/* -------------VUE 2: ALL_WORKERS_ELAPSED----------------- */
CREATE OR ALTER VIEW ALL_WORKERS_ELAPSED AS
SELECT
    worker_id,
    lastname,
    firstname,
    DATEDIFF(DAY, start_date, GETDATE()) AS nb_days_elapsed
FROM ALL_WORKERS;
GO

/* -------------VUE 3: BEST_SUPPLIERS----------------- */
CREATE OR ALTER VIEW BEST_SUPPLIERS AS
SELECT
    s.supplier_name AS supplier,
    SUM(sd.quantity) AS nb_parts
FROM SUPPLIERS s
JOIN SUPPLIER_DELIVERIES sd ON s.supplier_id = sd.supplier_id
GROUP BY s.supplier_name
HAVING SUM(sd.quantity) > 1000;
GO

/* -------------VUE 4: ROBOTS_FACTORIES----------------- */
CREATE OR ALTER VIEW ROBOTS_FACTORIES AS
SELECT
    f.name AS factory,
    SUM(p.quantity) AS nb_robots
FROM PRODUCTION p
JOIN FACTORIES f ON p.factory_id = f.factory_id
GROUP BY f.name;
GO