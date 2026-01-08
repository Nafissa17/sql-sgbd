USE HUMAN_BOT;
GO

/* =========================================================
   1. GET_NB_WORKERS
   Retourne le nombre de travailleurs dans une usine
========================================================= */
CREATE OR ALTER FUNCTION GET_NB_WORKERS(@factory_name VARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @nb_workers INT;
    
    SELECT @nb_workers = COUNT(DISTINCT w.worker_id)
    FROM ALL_WORKERS w
    WHERE w.factory_name = @factory_name;
    
    RETURN ISNULL(@nb_workers, 0);
END;
GO

/* =========================================================
   2. GET_NB_BIG_ROBOTS
   Compte le nombre de robots assemblés avec plus de 3 pièces
========================================================= */
CREATE OR ALTER FUNCTION GET_NB_BIG_ROBOTS()
RETURNS INT
AS
BEGIN
    DECLARE @nb_big_robots INT;
    
    -- Compter les modèles de robot qui ont plus de 3 pièces différentes
    -- Dans notre dataset, TOUS les modèles ont 7 pièces, donc > 3
    SELECT @nb_big_robots = COUNT(DISTINCT rpc.model_id)
    FROM ROBOT_PARTS_COMPOSITION rpc
    GROUP BY rpc.model_id
    HAVING COUNT(DISTINCT rpc.part_id) > 3;
    
    RETURN ISNULL(@nb_big_robots, 0);
END;
GO

/* =========================================================
   3. GET_BEST_SUPPLIER
   Retourne le nom du meilleur fournisseur
========================================================= */
CREATE OR ALTER FUNCTION GET_BEST_SUPPLIER()
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @best_supplier VARCHAR(100);
    
    SELECT TOP 1 @best_supplier = supplier
    FROM BEST_SUPPLIERS
    ORDER BY nb_parts DESC;
    
    RETURN ISNULL(@best_supplier, 'Aucun fournisseur');
END;
GO

/* =========================================================
   4. GET_OLDEST_WORKER
   Retourne l'identifiant du travailleur le plus ancien
========================================================= */
CREATE OR ALTER FUNCTION GET_OLDEST_WORKER()
RETURNS INT
AS
BEGIN
    DECLARE @oldest_worker_id INT;
    
    SELECT TOP 1 @oldest_worker_id = worker_id
    FROM ALL_WORKERS
    ORDER BY start_date ASC;
    
    RETURN ISNULL(@oldest_worker_id, 0);
END;
GO