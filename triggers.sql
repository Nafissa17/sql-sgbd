USE HUMAN_BOT;
GO

/* =========================================================
   1. Trigger pour ALL_WORKERS_ELAPSED
========================================================= */
CREATE OR ALTER TRIGGER TRG_ALL_WORKERS_ELAPSED_IO
ON ALL_WORKERS_ELAPSED
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Bloquer UPDATE et DELETE
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        RAISERROR('Les opérations UPDATE et DELETE sont interdites sur cette vue.', 16, 1);
        RETURN;
    END
    
    -- Pour INSERT, insérer dans les tables sous-jacentes
    DECLARE @factory_id INT;
    SELECT TOP 1 @factory_id = factory_id FROM FACTORIES;
    
    INSERT INTO WORKERS (lastname, firstname, age)
    SELECT lastname, firstname, NULL
    FROM inserted;
    
    DECLARE @worker_id INT;
    SELECT @worker_id = SCOPE_IDENTITY();
    
    INSERT INTO CONTRACTS (worker_id, factory_id, start_date)
    VALUES (@worker_id, @factory_id, GETDATE());
    
END;
GO

/* =========================================================
   2. Trigger d'audit pour nouveaux robots
========================================================= */
CREATE OR ALTER TRIGGER TRG_AUDIT_NEW_ROBOT_MODEL
ON ROBOT_MODELS
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO AUDIT_ROBOT (model_name, created_at)
    SELECT model_name, GETDATE()
    FROM inserted;
    
END;
GO

/* =========================================================
   3. Trigger de vérification cohérence usines
   (Adapté pour notre schéma sans WORKERS_FACTORY_<N>)
========================================================= */
CREATE OR ALTER TRIGGER TRG_CHECK_FACTORIES_CONSISTENCY
ON FACTORIES
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @factory_count INT;
    DECLARE @production_factory_count INT;
    
    SELECT @factory_count = COUNT(*) FROM FACTORIES;
    SELECT @production_factory_count = COUNT(DISTINCT factory_id) FROM PRODUCTION;
    
    -- Si des usines n'ont pas de production, on avertit mais on ne bloque pas
    IF @factory_count > @production_factory_count
    BEGIN
        PRINT 'ATTENTION: ' + CAST(@factory_count - @production_factory_count AS VARCHAR) + 
              ' usine(s) n''ont pas de production enregistrée.';
    END
    
END;
GO

/* =========================================================
   4. Trigger pour calcul durée contrat
========================================================= */
-- Ajouter la colonne si elle n'existe pas
IF COL_LENGTH('CONTRACTS', 'duration_days') IS NULL
BEGIN
    ALTER TABLE CONTRACTS
    ADD duration_days INT NULL;
    
    PRINT 'Colonne duration_days ajoutée à la table CONTRACTS.';
END
GO

CREATE OR ALTER TRIGGER TRG_CALCULATE_CONTRACT_DURATION
ON CONTRACTS
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE c
    SET duration_days = 
        CASE 
            WHEN i.end_date IS NOT NULL THEN 
                DATEDIFF(DAY, c.start_date, i.end_date)
            ELSE 
                DATEDIFF(DAY, c.start_date, GETDATE())
        END
    FROM CONTRACTS c
    INNER JOIN inserted i ON c.contract_id = i.contract_id
    WHERE i.end_date IS NOT NULL OR i.start_date != c.start_date;
    
END;
GO