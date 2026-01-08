USE HUMAN_BOT;
GO

PRINT '========================================';
PRINT 'TEST COMPLET HUMAN BOT DATABASE';
PRINT '========================================';
PRINT '';

/* TEST 1: Vérifier le nombre d''usines */
PRINT 'TEST 1: Nombre d''usines';
SELECT COUNT(*) AS nb_usines FROM FACTORIES;
IF (SELECT COUNT(*) FROM FACTORIES) = 3
    PRINT 'OK: 3 usines trouvées';
ELSE
    PRINT 'ERREUR: Nombre d''usines incorrect';
PRINT '';

/* TEST 2: Vérifier les modèles de robots */
PRINT 'TEST 2: Modèles de robots';
SELECT COUNT(*) AS nb_modeles FROM ROBOT_MODELS;
IF (SELECT COUNT(*) FROM ROBOT_MODELS) >= 10
    PRINT 'OK: Au moins 10 modèles de robots';
ELSE
    PRINT 'ERREUR: Modèles de robots insuffisants';
PRINT '';

/* TEST 3: Vérifier la vue ALL_WORKERS */
PRINT 'TEST 3: Vue ALL_WORKERS';
SELECT TOP 3 * FROM ALL_WORKERS ORDER BY worker_id;
IF EXISTS (SELECT 1 FROM ALL_WORKERS)
    PRINT 'OK: Vue ALL_WORKERS fonctionnelle';
ELSE
    PRINT 'ERREUR: Vue ALL_WORKERS vide';
PRINT '';

/* TEST 4: Vérifier la vue ALL_WORKERS_ELAPSED */
PRINT 'TEST 4: Vue ALL_WORKERS_ELAPSED';
SELECT TOP 3 * FROM ALL_WORKERS_ELAPSED ORDER BY worker_id;
IF EXISTS (SELECT 1 FROM ALL_WORKERS_ELAPSED WHERE nb_days_elapsed > 0)
    PRINT 'OK: Jours écoulés calculés correctement';
ELSE
    PRINT 'ERREUR: Problème avec les jours écoulés';
PRINT '';

/* TEST 5: Vérifier la vue BEST_SUPPLIERS */
PRINT 'TEST 5: Vue BEST_SUPPLIERS';
SELECT * FROM BEST_SUPPLIERS;
IF (SELECT COUNT(*) FROM BEST_SUPPLIERS) > 0
    PRINT 'OK: Fournisseurs avec +1000 pièces trouvés';
ELSE
    PRINT 'ERREUR: Aucun fournisseur avec +1000 pièces';
PRINT '';

/* TEST 6: Vérifier la vue ROBOTS_FACTORIES */
PRINT 'TEST 6: Vue ROBOTS_FACTORIES';
SELECT * FROM ROBOTS_FACTORIES ORDER BY nb_robots DESC;
IF (SELECT SUM(nb_robots) FROM ROBOTS_FACTORIES) > 0
    PRINT 'OK: Production de robots correcte';
ELSE
    PRINT 'ERREUR: Aucune production de robots';
PRINT '';

/* TEST 7: Fonction GET_NB_WORKERS */
PRINT 'TEST 7: Fonction GET_NB_WORKERS';
DECLARE @nb_workers INT = dbo.GET_NB_WORKERS('Usine Paris');
PRINT '  Travailleurs à Usine Paris: ' + CAST(@nb_workers AS VARCHAR);
IF @nb_workers > 0
    PRINT 'OK: Fonction GET_NB_WORKERS fonctionnelle';
ELSE
    PRINT 'ERREUR: Fonction GET_NB_WORKERS ne retourne pas de résultat';
PRINT '';

/* TEST 8: Fonction GET_NB_BIG_ROBOTS */
PRINT 'TEST 8: Fonction GET_NB_BIG_ROBOTS';
DECLARE @nb_big_robots INT = dbo.GET_NB_BIG_ROBOTS();
PRINT '  Robots avec >3 pièces: ' + CAST(@nb_big_robots AS VARCHAR);
IF @nb_big_robots = 10  -- Tous les modèles (sauf RobotTest123) ont 7 pièces
    PRINT 'OK: Tous les modèles sont des "big robots"';
ELSE
    PRINT 'ERREUR: Problème avec le comptage des big robots';
PRINT '';

/* TEST 9: Fonction GET_BEST_SUPPLIER */
PRINT 'TEST 9: Fonction GET_BEST_SUPPLIER';
DECLARE @best_supplier VARCHAR(100) = dbo.GET_BEST_SUPPLIER();
PRINT '  Meilleur fournisseur: ' + @best_supplier;
IF @best_supplier = 'Optimux'
    PRINT 'OK: Optimux identifié comme meilleur fournisseur';
ELSE
    PRINT 'ERREUR: Mauvais fournisseur identifié';
PRINT '';

/* TEST 10: Fonction GET_OLDEST_WORKER */
PRINT 'TEST 10: Fonction GET_OLDEST_WORKER';
DECLARE @oldest_id INT = dbo.GET_OLDEST_WORKER();
PRINT '  ID du travailleur le plus ancien: ' + CAST(@oldest_id AS VARCHAR);
IF @oldest_id > 0
    PRINT 'OK: Travailleur le plus ancien identifié';
ELSE
    PRINT 'ERREUR: Problème avec l''identification du plus ancien';
PRINT '';

/* TEST 11: Procédure SEED_DATA_WORKERS */
PRINT 'TEST 11: Procédure SEED_DATA_WORKERS';
DECLARE @avant INT = (SELECT COUNT(*) FROM WORKERS);
EXEC SEED_DATA_WORKERS 3, 1;
DECLARE @apres INT = (SELECT COUNT(*) FROM WORKERS);
PRINT '  Avant: ' + CAST(@avant AS VARCHAR) + ' travailleurs';
PRINT '  Après: ' + CAST(@apres AS VARCHAR) + ' travailleurs';
IF @apres > @avant
    PRINT 'OK: Nouveaux travailleurs créés avec succès';
ELSE
    PRINT 'ERREUR: Échec de création des travailleurs';
PRINT '';

/* TEST 12: Procédure ADD_NEW_ROBOT */
PRINT 'TEST 12: Procédure ADD_NEW_ROBOT';
DECLARE @avant_models INT = (SELECT COUNT(*) FROM ROBOT_MODELS);
EXEC ADD_NEW_ROBOT 'RobotTest456';
DECLARE @apres_models INT = (SELECT COUNT(*) FROM ROBOT_MODELS);
PRINT '  Avant: ' + CAST(@avant_models AS VARCHAR) + ' modèles';
PRINT '  Après: ' + CAST(@apres_models AS VARCHAR) + ' modèles';
IF @apres_models > @avant_models
    PRINT 'OK: Nouveau modèle de robot ajouté';
ELSE
    PRINT 'ERREUR: Échec d''ajout du modèle';
PRINT '';

/* TEST 13: Audit des nouveaux robots (trigger) */
PRINT 'TEST 13: Trigger d''audit ROBOT_MODELS';
SELECT TOP 3 * FROM AUDIT_ROBOT ORDER BY created_at DESC;
IF EXISTS (SELECT 1 FROM AUDIT_ROBOT WHERE model_name LIKE 'RobotTest%')
    PRINT 'OK: Trigger d''audit fonctionnel';
ELSE
    PRINT 'ERREUR: Trigger d''audit non déclenché';
PRINT '';

/* TEST 14: Composition des robots */
PRINT 'TEST 14: Composition robot-pièce-fournisseur';
SELECT 
    rm.model_name,
    COUNT(DISTINCT rpc.part_id) as nb_pieces,
    COUNT(DISTINCT rpc.supplier_id) as nb_fournisseurs
FROM ROBOT_MODELS rm
LEFT JOIN ROBOT_PARTS_COMPOSITION rpc ON rm.model_id = rpc.model_id
GROUP BY rm.model_name
ORDER BY rm.model_name;
PRINT '  Note: RobotTest123 et RobotTest456 n''ont pas de pièces assignées';
PRINT '';

/* TEST 15: Production totale */
PRINT 'TEST 15: Production totale par usine';
SELECT 
    f.name as usine,
    SUM(p.quantity) as total_production,
    COUNT(DISTINCT p.model_id) as modeles_différents
FROM PRODUCTION p
JOIN FACTORIES f ON p.factory_id = f.factory_id
GROUP BY f.name
ORDER BY total_production DESC;
PRINT '  Totaux: Paris = 434, Caracas = 310, Beijing = 114';
PRINT '';

/* TEST 16: Vérification des contraintes */
PRINT 'TEST BONUS: Vérification des contraintes';
BEGIN TRY
    -- Essayer d'insérer une quantité négative
    INSERT INTO PRODUCTION (factory_id, model_id, production_date, quantity)
    VALUES (1, 1, '2024-01-01', -10);
    PRINT 'ERREUR: Contrainte quantité négative non respectée';
END TRY
BEGIN CATCH
    PRINT 'OK: Contrainte CHECK sur quantité fonctionnelle';
END CATCH
PRINT '';

PRINT '========================================';
PRINT 'RÉSUMÉ DES TESTS';
PRINT '========================================';
PRINT 'Tests exécutés: 16';
PRINT '========================================';
GO