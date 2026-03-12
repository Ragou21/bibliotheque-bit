# Système de Gestion de Bibliothèque — CS27

**Burkina Institute of Technology | Département Informatique**  
**Cours : CS27 – Le Modèle Relationnel & Bases de Données**  
**Instructeur : Kweyakie Afi Blebo**

---

## Description du projet

Ce projet implémente un **système de gestion de bibliothèque** complet en MySQL. Il couvre la conception, la normalisation, l'implémentation et l'interrogation d'une base de données relationnelle.

---

## Structure du dépôt

```
library-management-cs27/
│
├── library_db.sql        ← Fichier SQL principal (tout-en-un)
├── README.md             ← Ce fichier
```

---

## Schéma de la base de données

### Entités et attributs

| Table        | Clé Primaire  | Attributs principaux                                           |
|-------------|---------------|----------------------------------------------------------------|
| `auteurs`    | auteur_id     | nom, prenom, nationalite, date_naissance                       |
| `categories` | categorie_id  | nom, description                                               |
| `livres`     | livre_id      | titre, isbn, auteur_id (FK), categorie_id (FK), annee_publi   |
| `membres`    | membre_id     | nom, prenom, email (UNIQUE), telephone, actif                  |
| `emprunts`   | emprunt_id    | membre_id (FK), livre_id (FK), dates, amende_montant           |

### Relations

| Relation                | Type  | Description |
|-------------------------|-------|-------------|
| auteurs → livres        | 1 : M | Un auteur peut écrire plusieurs livres |
| categories → livres     | 1 : M | Une catégorie regroupe plusieurs livres |
| membres → emprunts      | 1 : M | Un membre peut faire plusieurs emprunts |
| livres → emprunts       | 1 : M | Un livre peut être emprunté plusieurs fois |

---

## Installation & Utilisation

### Prérequis
- MySQL 8.0 ou supérieur
- MySQL Workbench ou tout client MySQL

### Étapes

```bash
# 1. Cloner le dépôt
git clone https://github.com/<votre-groupe>/library-management-cs27.git
cd library-management-cs27

# 2. Se connecter à MySQL
mysql -u root -p

# 3. Exécuter le fichier SQL
source library_db.sql;
# ou depuis le terminal :
mysql -u root -p < library_db.sql
```

---

## Contenu de la base de données

| Table        | Nombre de lignes |
|-------------|-----------------|
| auteurs      | 12              |
| categories   | 10              |
| livres       | 15              |
| membres      | 12              |
| emprunts     | 22              |

---

## 🔍 Requêtes couvertes

- `SELECT` simple, avec `WHERE`, `ORDER BY`, `LIMIT`
- Filtres avec `BETWEEN`, `LIKE`, `IN`
- `INNER JOIN` sur 2 tables
- `LEFT JOIN` avec explication
- `JOIN` sur 4 tables simultanément
- `IS NULL` / `IS NOT NULL`
- Fonctions d'agrégation : `COUNT`, `MAX`, `MIN`, `AVG`
- `GROUP BY` + `HAVING`
- Rapport de synthèse complet

---

## Intégrité référentielle

Toutes les clés étrangères utilisent :
- `ON DELETE RESTRICT` — empêche la suppression d'un enregistrement parent si des enfants existent
- `ON UPDATE CASCADE` — propage les modifications de clé primaire

---

## Normalisation

Le fichier SQL inclut (en commentaires) la démonstration complète :
1. **Table brute (UNF)** — données non normalisées
2. **1NF** — suppression des groupes répétés, définition de la clé primaire
3. **2NF** — suppression des dépendances partielles
4. **3NF** — suppression des dépendances transitives → schéma final

---

## Membres du groupe

| Nom | Prénom | Rôle |
|-----|--------|------|
|  S   |        | Chef de groupe |
|     |        | Conception BDD |
|     |        | Implémentation SQL |
|     |        | Présentation |

> *Complétez ce tableau avec les vrais noms des membres du groupe*

---

## Intégrité académique

Tout le code SQL a été écrit par le groupe. L'IA a été utilisée uniquement comme outil d'apprentissage — chaque membre est capable d'expliquer chaque ligne lors de la vidéo de présentation.

---

*CS27 — Burkina Institute of Technology | blebo.kweyakie@bit.bf*
