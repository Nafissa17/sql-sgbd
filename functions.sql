USE HUMAN_BOT;
GO

/* =========================================================
   1. GET_NB_WORKERS
   Retourne le nombre de travailleurs présents dans une usine
   Paramètre : nom de l’usine
   Vue utilisée : ALL_WORKERS
========================================================= */
CREATE OR ALTER FUNCTION GET_NB_WORKERS(@factory_id INT)
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM ALL_WORKERS aw
        JOIN CONTRACTS c ON aw.worker_id = c.worker_id
        WHERE c.factory_id = @factory_id
    );
END;
GO

/* =========================================================
   2. GET_NB_BIG_ROBOTS
   Compte le nombre de robots assemblés avec plus de 3 pièces
   Vue utilisée : ROBOTS_FACTORIES
========================================================= */
CREATE OR ALTER FUNCTION GET_NB_BIG_ROBOTS ()
RETURNS INT
AS
BEGIN
    DECLARE @nb_big_robots INT;

    /*
      Hypothèse métier :
      - Un "big robot" = robot nécessitant > 3 types de pièces
      - On passe par la vue ROBOTS_FACTORIES pour rester conforme
    */

    SELECT @nb_big_robots = COUNT(DISTINCT r.robot_id)
    FROM ROBOTS r
    JOIN ROBOT_PARTS rp ON r.robot_id = rp.robot_id
    JOIN ROBOTS_FACTORIES rf ON rf.factory IS NOT NULL
    GROUP BY r.robot_id
    HAVING COUNT(rp.part_id) > 3;

    RETURN ISNULL(@nb_big_robots, 0);
END;
GO

/* =========================================================
   3. GET_BEST_SUPPLIER
   Retourne le nom du fournisseur ayant livré le plus de pièces
   Vue utilisée : BEST_SUPPLIERS
========================================================= */
CREATE OR ALTER FUNCTION GET_BEST_SUPPLIER ()
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @best_supplier VARCHAR(100);

    SELECT TOP 1
        @best_supplier = supplier
    FROM BEST_SUPPLIERS
    ORDER BY nb_parts DESC;

    RETURN @best_supplier;
END;
GO

/* =========================================================
   4. GET_OLDEST_WORKER
   Retourne l'identifiant du travailleur le plus ancien
   Vue utilisée : ALL_WORKERS
========================================================= */
CREATE OR ALTER FUNCTION GET_OLDEST_WORKER ()
RETURNS INT
AS
BEGIN
    DECLARE @oldest_worker_id INT;

    SELECT TOP 1
        @oldest_worker_id = w.worker_id
    FROM ALL_WORKERS aw
    JOIN WORKERS w
        ON aw.lastname = w.lastname
       AND aw.firstname = w.firstname
    ORDER BY aw.start_date ASC;

    RETURN @oldest_worker_id;
END;
GO