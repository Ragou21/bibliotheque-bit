# Library Management System - CS27

**Burkina Institute of Technology | Computer Science Department**
**Course: CS27 - The Relational Model & Databases**
**Instructor: Kweyakie Afi Blebo**

---

## Project Description

This project is a fully functional library management system built with MySQL. It covers the full process of designing, normalizing, implementing and querying a relational database.

---

## Database Schema

### Tables

| Table        | Primary Key   | Main Attributes                                                |
|-------------|---------------|----------------------------------------------------------------|
| auteurs      | auteur_id     | nom, prenom, nationalite, date_naissance                       |
| categories   | categorie_id  | nom, description                                               |
| livres       | livre_id      | titre, isbn, auteur_id (FK), categorie_id (FK), annee_publi   |
| membres      | membre_id     | nom, prenom, email, telephone, actif                           |
| emprunts     | emprunt_id    | membre_id (FK), livre_id (FK), dates, amende_montant           |

### Relationships

| Relationship            | Type  | Description |
|-------------------------|-------|-------------|
| auteurs -> livres       | 1 : M | One author can write multiple books |
| categories -> livres    | 1 : M | One category groups multiple books |
| membres -> emprunts     | 1 : M | One member can have multiple borrowings |
| livres -> emprunts      | 1 : M | One book can be borrowed multiple times |

---

## How to Run

### Requirements
- MySQL 8.0 or higher

### Steps

```bash
# Clone the repository
git clone https://github.com/Ragou21/bibliotheque-bit.git
cd bibliotheque-bit

# Import the database
sudo mysql < library_db.sql
```

---

## Database Content

| Table        | Number of rows |
|-------------|----------------|
| auteurs      | 12             |
| categories   | 10             |
| livres       | 15             |
| membres      | 12             |
| emprunts     | 22             |

---

## Queries Covered

- Simple SELECT with WHERE, ORDER BY, LIMIT
- Filters with BETWEEN, LIKE, IN
- INNER JOIN on 2 tables
- LEFT JOIN with explanation
- JOIN on 4 tables
- IS NULL / IS NOT NULL
- Aggregate functions: COUNT, MAX, MIN, AVG
- GROUP BY with HAVING
- Full summary report

---

## Group Members

| Last Name | First Name | Role |
|-----------|------------|------|
| N'ZOMBIE  | Rodrigue   |      |
| SOULAMA   | Ulrich     |      |
| DRABO     | Amine Farel Isao |  |
| SAWADOGO  | Azael Wend-Panga |  |
| OUEDRAOGO | Abdoulaye  |      |
| KERE      | H. Noeldinolippeu | |
| KOANDA    | Cheikib    |      |

---
Video Youtube walkthrought
https://youtu.be/CLCn74gKR6s?si=WT_kf_X4qDjRHwxf

*CS27 - Burkina Institute of Technology*
