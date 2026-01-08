USE HUMAN_BOT;
GO

/* =========================================================
   1. SEED_DATA_WORKERS
   Génère des workers fictifs avec dates aléatoires
========================================================= */
CREATE OR ALTER PROCEDURE SEED_DATA_WORKERS
    @NB_WORKERS INT,
    @FACTORY_ID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @i INT = 1;
    
    WHILE @i <= @NB_WORKERS
    BEGIN
        INSERT INTO WORKERS (lastname, firstname, age)
        VALUES (
            'worker_L_' + CAST(@i AS VARCHAR(10)),
            'worker_F_' + CAST(@i AS VARCHAR(10)),
            ABS(CHECKSUM(NEWID())) % 50 + 18
        );
        
        DECLARE @worker_id INT = SCOPE_IDENTITY();
        DECLARE @start_date DATE = DATEADD(DAY, 
            ABS(CHECKSUM(NEWID())) % 1825, 
            '2065-01-01'
        );
        
        INSERT INTO CONTRACTS (worker_id, factory_id, start_date)
        VALUES (@worker_id, @FACTORY_ID, @start_date);
        
        SET @i = @i + 1;
    END
    
    PRINT 'Génération de ' + CAST(@NB_WORKERS AS VARCHAR) + 
          ' travailleurs pour l''usine ID ' + CAST(@FACTORY_ID AS VARCHAR);
END;
GO

/* =========================================================
   2. ADD_NEW_ROBOT
   Ajoute un nouveau modèle de robot
========================================================= */
CREATE OR ALTER PROCEDURE ADD_NEW_ROBOT
    @MODEL_NAME VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Vérifier si le modèle existe déjà
    IF EXISTS (SELECT 1 FROM ROBOT_MODELS WHERE model_name = @MODEL_NAME)
    BEGIN
        PRINT 'Le modèle ' + @MODEL_NAME + ' existe déjà.';
        RETURN;
    END
    
    -- Insérer le nouveau modèle
    INSERT INTO ROBOT_MODELS (model_name)
    VALUES (@MODEL_NAME);
    
    PRINT 'Modèle ' + @MODEL_NAME + ' ajouté avec succès.';
    
    -- Déclencher l'audit via la vue
    DECLARE @model_id INT = SCOPE_IDENTITY();
    
    -- Pour déclencher le trigger d'audit, on simule une insertion
    -- (Dans notre schéma, l'audit se fait sur ROBOT_MODELS directement)
    INSERT INTO AUDIT_ROBOT (model_name)
    VALUES (@MODEL_NAME);
    
END;
GO

/* =========================================================
   3. SEED_DATA_SPARE_PARTS
   Génère des pièces détachées fictives
========================================================= */
CREATE OR ALTER PROCEDURE SEED_DATA_SPARE_PARTS
    @NB_SPARE_PARTS INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @i INT = 1;
    
    WHILE @i <= @NB_SPARE_PARTS
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM SPARE_PARTS 
                      WHERE part_name = 'part_' + CAST(@i AS VARCHAR(10)))
        BEGIN
            INSERT INTO SPARE_PARTS (part_name)
            VALUES ('part_' + CAST(@i AS VARCHAR(10)));
        END
        
        SET @i = @i + 1;
    END
    
    PRINT 'Génération de ' + CAST(@NB_SPARE_PARTS AS VARCHAR) + ' pièces détachées.';
END;
GO