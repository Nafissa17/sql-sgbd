# sql-sgbd

## OBJECTIF GLOBAL

* **concevoir une base SQL Server**
* **cacher la structure des tables** aux applications
* **exposer uniquement des vues, fonctions, procédures et triggers**
* livrer **5 fichiers SQL strictement nommés**

Le dataset fourni est **un exemple de données métiers**, pas la base finale telle quelle.

---

## LIVRABLES OBLIGATOIRES (à la racine du repo)

```
schema.sql
data.sql
functions.sql
procedures.sql
triggers.sql
```


## 1️ Ce que vous devez faire

Vous devez **transformer une gestion papier en un système SQL Server propre et robuste**, avec :

* Une **base de données bien conçue**
* Des **vues** (pour cacher la structure aux applications)
* Des **fonctions**
* Des **procédures**
* Des **triggers**
* Le tout livré dans **5 fichiers SQL séparés** dans un repo Git

Les applications **n’accèdent JAMAIS directement aux tables**, uniquement via **vues + fonctions + procédures**.

---

## 2️⃣ Rôle de ton dataset Excel

Ton dataset représente déjà une partie métier essentielle :

### Ce que contient ton dataset

Il correspond à :

* La **production de robots**
* Par **usine**
* Par **date**
* Par **modèle de robot**
* Avec une **quantité produite**

Il va servir principalement à :

* Alimenter les tables **ROBOTS / FACTORIES / PRODUCTION**
* Construire la vue **ROBOTS_FACTORIES**
* Tester :

  * le nombre de robots assemblés
  * les usines les plus productives

Il sera utilisé **dans `data.sql`**

---

## 3️⃣ Découpage du travail en 5 (groupe de 5)

### 👤 SAMB NAfissatou — **Modélisation & schéma SQL**

`schema.sql`

**Responsabilités :**

* Concevoir toutes les tables
* Définir les clés primaires / étrangères
* Ajouter les contraintes métier

**Tables principales à créer :**

* FACTORIES
* WORKERS
* CONTRACTS (car un worker peut avoir plusieurs contrats)
* ROBOTS
* ROBOT_MODELS
* SUPPLIERS
* SPARE_PARTS
* SUPPLIER_PARTS
* ROBOT_PARTS
* AUDIT_ROBOT

**Contraintes importantes :**

* Un worker peut travailler dans plusieurs usines
* Paris → age obligatoire
* Caracas → age nullable
* Suppression d’un worker si aucun contrat depuis 5 ans
* Une usine ne peut assembler un robot que si toutes les pièces sont présentes

C’est **la base du projet**, personne très importante.

---

### 👤 Diallo ALPHA — **Données & alimentation**

`data.sql`

**Responsabilités :**

* Transformer le fichier Excel en `INSERT INTO`
* Créer :

  * usines (Paris, Caracas, Beijing)
  * modèles de robots
  * données de production
  * fournisseurs
  * pièces détachées

**À partir de ton dataset :**

* 1 ligne Excel = production d’un robot
* Lier :

  * Robot → Modèle
  * Usine → Factory
  * Date → Production date

Cette personne valide que **tout fonctionne avec des données réelles**.

---

### 👤 Mariam Marwo ABDILLAHI ABDI — **Vues SQL**

inclus dans `schema.sql` (ou fichier séparé si autorisé)

**Responsabilités :**
Créer **exactement** les vues demandées :

1. `ALL_WORKERS`
2. `ALL_WORKERS_ELAPSED`
3. `BEST_SUPPLIERS`
4. `ROBOTS_FACTORIES`

**Points critiques :**

* Respect **exact des noms**
* Résultats triés correctement
* Données manquantes conservées
* Lecture seule

Toutes les **fonctions et triggers dépendent de ces vues**.

---

### 👤 Orlane Emmanuelle NKIBAN ITCHIRI — **Fonctions SQL**

 `functions.sql`

**Responsabilités :**
Créer les 4 fonctions demandées :

1. `GET_NB_WORKERS(factory)`
2. `GET_NB_BIG_ROBOTS`
3. `GET_BEST_SUPPLIER`
4. `GET_OLDEST_WORKER`

**Règle importante :**
Les fonctions doivent utiliser **les vues**, pas les tables.

Cette personne doit tester chaque fonction avec des `SELECT`.

---

### 👤 Mansour Djamil NDIAYE — **Procédures & Triggers**

`procedures.sql` & `triggers.sql`

**Procédures :**

* Génération automatique de workers
* Ajout de robots
* Génération de pièces détachées

**Triggers :**

* Insertion via vue `ALL_WORKERS_ELAPSED`
* Audit automatique des robots
* Blocage si incohérence usines / tables
* Calcul automatique de durée de contrat


---

## 4️⃣ Ordre de travail recommandé

1. **Schéma SQL**
2. **Vues**
3. **Données**
4. **Fonctions**
5. **Procédures**
6. **Triggers**
7. Tests finaux
