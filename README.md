# Human Bot - Base de données SQL Server

## 👥 Équipe de développement

| Membre | Rôle | Responsabilités |
|--------|------|----------------|
| **SAMB Nafissatou** | Modélisation & schéma SQL | `schema.sql` - BDD, Tables, clés, contraintes |
| **Diallo ALPHA** | Données & alimentation | `data.sql` - Insertion des données du dataset Excel |
| **Mariam Marwo ABDILLAHI ABDI** | Vues SQL | Vues dans `schema.sql` - 4 vues demandées |
| **Orlane Emmanuelle NKIBAN ITCHIRI** | Fonctions SQL | `functions.sql` - 4 fonctions métier |
| **Mansour Djamil NDIAYE** | Procédures & Triggers | `procedures.sql` & `triggers.sql` - Automatisation |

## Installation et exécution

### Prérequis
- Docker Desktop
- Git

### 1. Cloner et démarrer le projet
```bash
git clone https://github.com/Nafissa17/sql-sgbd.git
cd sql-sgbd
docker-compose up -d
```

### 2. Initialiser la base de données
```bash
# Exécuter les fichiers dans l'ordre
docker exec -it sql-human-bot /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Str0ng!Passw0rd" -C -i /sql/schema.sql
docker exec -it sql-human-bot /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Str0ng!Passw0rd" -C -i /sql/data.sql
docker exec -it sql-human-bot /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Str0ng!Passw0rd" -C -i /sql/functions.sql
docker exec -it sql-human-bot /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Str0ng!Passw0rd" -C -i /sql/procedures.sql
docker exec -it sql-human-bot /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Str0ng!Passw0rd" -C -i /sql/triggers.sql
```

### 3. Tester le système
```bash
# Lancer tous les tests
docker exec -it sql-human-bot /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Str0ng!Passw0rd" -C -i /sql/test.sql
```

## Structure des fichiers

```
sql-sgbd/
├── schema.sql          # Tables + vues (SAMB Nafissatou + Mariam)
├── data.sql            # Données initiales (Diallo ALPHA)
├── functions.sql       # 4 fonctions métier (Orlane)
├── procedures.sql      # 3 procédures stockées (Mansour)
├── triggers.sql        # 4 triggers (Mansour)
├── test.sql           # Tests de validation
├── docker-compose.yml # Configuration Docker
└── README.md          # Documentation
```

## Fonctionnalités implémentées

### Vues (4)
1. `ALL_WORKERS` - Travailleurs actifs
2. `ALL_WORKERS_ELAPSED` - Jours travaillés
3. `BEST_SUPPLIERS` - Fournisseurs >1000 pièces
4. `ROBOTS_FACTORIES` - Production par usine

### Fonctions (4)
1. `GET_NB_WORKERS(usine)` - Nombre de travailleurs
2. `GET_NB_BIG_ROBOTS()` - Robots avec >3 pièces
3. `GET_BEST_SUPPLIER()` - Meilleur fournisseur
4. `GET_OLDEST_WORKER()` - Travailleur le plus ancien

### Procédures (3)
1. `SEED_DATA_WORKERS(nb, usine_id)` - Génération de travailleurs
2. `ADD_NEW_ROBOT(modèle)` - Ajout de robot
3. `SEED_DATA_SPARE_PARTS(nb)` - Génération de pièces

### Triggers (4)
1. Gestion INSERT via `ALL_WORKERS_ELAPSED`
2. Audit automatique des nouveaux robots
3. Vérification cohérence usines/production
4. Calcul automatique durée de contrat

## Tests rapides

```sql
-- Vérifier les vues
SELECT * FROM ALL_WORKERS;
SELECT * FROM BEST_SUPPLIERS;

-- Tester les fonctions
SELECT dbo.GET_NB_WORKERS('Usine Paris');
SELECT dbo.GET_NB_BIG_ROBOTS();

-- Exécuter une procédure
EXEC SEED_DATA_WORKERS 5, 1;
```

## Données incluses
- 3 usines (Paris, Caracas, Beijing)
- 10 modèles de robots
- 3 fournisseurs (Optimux, Boston Mimics, VCTech Robotics)
- 7 types de pièces
- 20 travailleurs avec contrats
- 4 mois de production (40 enregistrements)

## Arrêt du projet
```bash
docker-compose down
```

---

**Note** : Les applications clientes n'accèdent jamais directement aux tables, uniquement via les vues, fonctions et procédures exposées.
