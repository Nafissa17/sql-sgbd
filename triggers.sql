USE HUMAN_BOT;
GO

/* =========================================================
   1. INSERT via ALL_WORKERS_ELAPSED
   → redirige vers WORKERS + CONTRACTS
   UPDATE / DELETE interdits
========================================================= */
CREATE OR ALTER TRIGGER TRG_ALL_WORKERS_ELAPSED_INSERT
ON ALL_WORKERS_ELAPSED
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        RAISERROR('UPDATE et DELETE interdits sur cette vue', 16, 1);
        RETURN;
    END

    INSERT INTO WORKERS (lastname, firstname)
    SELECT lastname, firstname
    FROM inserted;

    INSERT INTO CONTRACTS (worker_id, factory_id, start_date)
    SELECT
        w.worker_id,
        (SELECT TOP 1 factory_id FROM FACTORIES),
        GETDATE()
    FROM inserted i
    JOIN WORKERS w
        ON w.lastname = i.lastname
       AND w.firstname = i.firstname;
END;
GO

/* =========================================================
   2. AUDIT automatique des robots
========================================================= */
CREATE OR ALTER TRIGGER TRG_AUDIT_ROBOT
ON ROBOTS
AFTER INSERT
AS
BEGIN
    INSERT INTO AUDIT_ROBOT (robot_id, factory_id, model_id)
    SELECT robot_id, factory_id, model_id
    FROM inserted;
END;
GO

/* =========================================================
   3. Blocage si incohérence usines / ROBOTS_FACTORIES
========================================================= */
CREATE OR ALTER TRIGGER TRG_BLOCK_ROBOTS_FACTORIES
ON ROBOTS_FACTORIES
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @nb_factories INT;
    DECLARE @nb_factories_robots INT;

    SELECT @nb_factories = COUNT(*) FROM FACTORIES;
    SELECT @nb_factories_robots = COUNT(DISTINCT factory_id) FROM ROBOTS;

    IF @nb_factories <> @nb_factories_robots
    BEGIN
        RAISERROR(
            'Incohérence entre usines et robots assemblés',
            16,
            1
        );
        RETURN;
    END
END;
GO

/* =========================================================
   4. Calcul automatique durée contrat
   (colonne ajoutée si absente)
========================================================= */
IF COL_LENGTH('CONTRACTS', 'duration_days_real') IS NULL
BEGIN
    ALTER TABLE CONTRACTS
    ADD duration_days_real INT NULL;
END
GO

CREATE OR ALTER TRIGGER TRG_CONTRACT_END_DATE
ON CONTRACTS
AFTER UPDATE
AS
BEGIN
    UPDATE c
    SET duration_days_real =
        DATEDIFF(DAY, c.start_date, c.end_date)
    FROM CONTRACTS c
    JOIN inserted i ON c.contract_id = i.contract_id
    WHERE i.end_date IS NOT NULL;
END;
GO
