USE HUMAN_BOT;
GO

/* =========================================================
   1. SEED_DATA_WORKERS
   Génère des workers avec dates aléatoires entre 2065 et 2070
========================================================= */

CREATE OR ALTER PROCEDURE SEED_DATA_WORKERS
    @NB_WORKERS INT,
    @FACTORY_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @worker_id INT;
    DECLARE @start_date DATE;
    DECLARE @days_range INT;

    SET @days_range = 1825;

    WHILE @i <= @NB_WORKERS
    BEGIN
        INSERT INTO WORKERS (lastname, firstname, age)
        VALUES (
            'worker_l_' + CAST(@i AS VARCHAR(10)),
            'worker_f_' + CAST(@i AS VARCHAR(10)),
            ABS(CHECKSUM(NEWID())) % 50 + 18
        );

        SET @worker_id = SCOPE_IDENTITY();

        SET @start_date = DATEADD(
            DAY,
            ABS(CHECKSUM(NEWID())) % @days_range, 
            '2065-01-01'
        );

        -- Insertion du contrat (pas de end_date = travailleur actif)
        INSERT INTO CONTRACTS (worker_id, factory_id, start_date)
        VALUES (@worker_id, @FACTORY_ID, @start_date);

        SET @i += 1;
    END

    PRINT 'Génération de ' + CAST(@NB_WORKERS AS VARCHAR(10)) + 
          ' travailleurs pour l''usine ' + CAST(@FACTORY_ID AS VARCHAR(10)) + 
          ' avec dates entre 2065 et 2070.';
END;
GO

/* =========================================================
   2. ADD_NEW_ROBOT
   Ajoute un robot depuis la vue ROBOTS_FACTORIES
========================================================= */
CREATE OR ALTER PROCEDURE ADD_NEW_ROBOT
    @MODEL_NAME VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @model_id INT;
    DECLARE @factory_id INT;

    SELECT @model_id = model_id
    FROM ROBOT_MODELS
    WHERE model_name = @MODEL_NAME;

    IF @model_id IS NULL
    BEGIN
        RAISERROR('Modèle de robot inexistant', 16, 1);
        RETURN;
    END

    -- Choix simple : première usine
    SELECT TOP 1 @factory_id = factory_id
    FROM FACTORIES
    ORDER BY factory_id;

    INSERT INTO ROBOTS (model_id, factory_id)
    VALUES (@model_id, @factory_id);
END;
GO

/* =========================================================
   3. SEED_DATA_SPARE_PARTS
   Génère des pièces détachées
========================================================= */
CREATE OR ALTER PROCEDURE SEED_DATA_SPARE_PARTS
    @NB_SPARE_PARTS INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;

    WHILE @i <= @NB_SPARE_PARTS
    BEGIN
        INSERT INTO SPARE_PARTS (part_name)
        VALUES ('part_' + CAST(@i AS VARCHAR));

        SET @i += 1;
    END
END;
GO
