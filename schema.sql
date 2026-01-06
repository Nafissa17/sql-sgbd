CREATE DATABASE HUMAN_BOT;


USE HUMAN_BOT;
GO


CREATE TABLE FACTORIES (
    factory_id INT IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL
);



CREATE TABLE WORKERS (
    worker_id INT IDENTITY PRIMARY KEY,
    lastname VARCHAR(100) NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    age INT NULL,  
    CONSTRAINT chk_worker_age_positive CHECK (age IS NULL OR age > 0)
);



CREATE TABLE CONTRACTS (
    contract_id INT IDENTITY PRIMARY KEY,
    worker_id INT NOT NULL,
    factory_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    duration_days AS DATEDIFF(day, start_date, ISNULL(end_date, GETDATE())), 

    CONSTRAINT fk_contract_worker
        FOREIGN KEY (worker_id) REFERENCES WORKERS(worker_id),

    CONSTRAINT fk_contract_factory
        FOREIGN KEY (factory_id) REFERENCES FACTORIES(factory_id),

    CONSTRAINT chk_contract_dates
        CHECK (end_date IS NULL OR end_date >= start_date)
);




CREATE TABLE ROBOT_MODELS (
    model_id INT IDENTITY PRIMARY KEY,
    model_name VARCHAR(50) NOT NULL UNIQUE
);
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



CREATE TABLE SPARE_PARTS (
    part_id INT IDENTITY PRIMARY KEY,
    part_name VARCHAR(100) NOT NULL
);
GO



CREATE TABLE SUPPLIERS (
    supplier_id INT IDENTITY PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL
);
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





CREATE TABLE AUDIT_ROBOT (
    audit_id INT IDENTITY PRIMARY KEY,
    robot_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);
GO

