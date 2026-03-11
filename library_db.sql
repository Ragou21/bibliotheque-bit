-- ============================================================
-- CS27 – Système de Gestion de Bibliothèque
-- Burkina Institute of Technology
-- ============================================================

-- ============================================================
-- PARTIE 1.4 – NORMALISATION : Table non normalisée (UNF)
-- ============================================================
-- CREATE TABLE bibliotheque_brute (
--   emprunt_id INT,
--   membre_nom VARCHAR(100),
--   membre_email VARCHAR(100),
--   membre_telephone VARCHAR(20),
--   livre_titre VARCHAR(200),
--   livre_isbn VARCHAR(20),
--   auteur_nom VARCHAR(100),
--   auteur_nationalite VARCHAR(50),
--   categorie VARCHAR(50),
--   date_emprunt DATE,
--   date_retour_prevue DATE,
--   date_retour_reelle DATE,
--   amende_montant DECIMAL(6,2),
--   amende_payee BOOLEAN
-- );
--
-- Violations 1NF : pas de clé primaire claire, données répétées
-- Violations 2NF : membre_nom, membre_email dépendent seulement de membre_id (dépendance partielle)
-- Violations 3NF : amende_montant dépend de date_retour_reelle, pas de emprunt_id (dépendance transitive)
--
-- SOLUTION : Décomposition en 5 tables normalisées ci-dessous.

-- ============================================================
-- CRÉATION DE LA BASE DE DONNÉES
-- ============================================================
DROP DATABASE IF EXISTS bibliotheque_bit;
CREATE DATABASE bibliotheque_bit
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE bibliotheque_bit;

-- ============================================================
-- TABLE 1 : auteurs
-- PK : auteur_id (AUTO_INCREMENT, stable, unique)
-- ============================================================
CREATE TABLE auteurs (
  auteur_id     INT           NOT NULL AUTO_INCREMENT,
  nom           VARCHAR(100)  NOT NULL,
  prenom        VARCHAR(100)  NOT NULL,
  nationalite   VARCHAR(50)   NOT NULL DEFAULT 'Inconnue',
  date_naissance DATE,
  CONSTRAINT pk_auteurs PRIMARY KEY (auteur_id)
);

-- ============================================================
-- TABLE 2 : categories
-- PK : categorie_id (AUTO_INCREMENT, stable, unique)
-- ============================================================
CREATE TABLE categories (
  categorie_id  INT           NOT NULL AUTO_INCREMENT,
  nom           VARCHAR(80)   NOT NULL,
  description   TEXT,
  CONSTRAINT pk_categories PRIMARY KEY (categorie_id),
  CONSTRAINT uq_categorie_nom UNIQUE (nom)
);

-- ============================================================
-- TABLE 3 : livres
-- PK : livre_id (AUTO_INCREMENT)
-- FK : auteur_id → auteurs, categorie_id → categories
-- ============================================================
CREATE TABLE livres (
  livre_id      INT           NOT NULL AUTO_INCREMENT,
  titre         VARCHAR(200)  NOT NULL,
  isbn          VARCHAR(20)   NOT NULL,
  auteur_id     INT           NOT NULL,
  categorie_id  INT           NOT NULL,
  annee_publi   YEAR          NOT NULL,
  editeur       VARCHAR(100)  NOT NULL DEFAULT 'Inconnu',
  nb_exemplaires INT          NOT NULL DEFAULT 1,
  CONSTRAINT pk_livres       PRIMARY KEY (livre_id),
  CONSTRAINT uq_livres_isbn  UNIQUE      (isbn),
  CONSTRAINT fk_livres_auteur    FOREIGN KEY (auteur_id)    REFERENCES auteurs(auteur_id)     ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_livres_categorie FOREIGN KEY (categorie_id) REFERENCES categories(categorie_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- TABLE 4 : membres
-- PK : membre_id (AUTO_INCREMENT)
-- ============================================================
CREATE TABLE membres (
  membre_id     INT           NOT NULL AUTO_INCREMENT,
  nom           VARCHAR(100)  NOT NULL,
  prenom        VARCHAR(100)  NOT NULL,
  email         VARCHAR(150)  NOT NULL,
  telephone     VARCHAR(20),
  adresse       VARCHAR(200),
  date_adhesion DATE          NOT NULL DEFAULT (CURRENT_DATE),
  actif         BOOLEAN       NOT NULL DEFAULT TRUE,
  CONSTRAINT pk_membres       PRIMARY KEY (membre_id),
  CONSTRAINT uq_membres_email UNIQUE      (email)
);

-- ============================================================
-- TABLE 5 : emprunts
-- PK : emprunt_id (AUTO_INCREMENT)
-- FK : membre_id → membres, livre_id → livres
-- ============================================================
CREATE TABLE emprunts (
  emprunt_id         INT           NOT NULL AUTO_INCREMENT,
  membre_id          INT           NOT NULL,
  livre_id           INT           NOT NULL,
  date_emprunt       DATE          NOT NULL DEFAULT (CURRENT_DATE),
  date_retour_prevue DATE          NOT NULL,
  date_retour_reelle DATE,
  amende_montant     DECIMAL(8,2)  NOT NULL DEFAULT 0.00,
  amende_payee       BOOLEAN       NOT NULL DEFAULT FALSE,
  CONSTRAINT pk_emprunts PRIMARY KEY (emprunt_id),
  CONSTRAINT fk_emprunts_membre FOREIGN KEY (membre_id) REFERENCES membres(membre_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_emprunts_livre  FOREIGN KEY (livre_id)  REFERENCES livres(livre_id)   ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_dates CHECK (date_retour_prevue > date_emprunt)
);

-- ============================================================
-- PARTIE 2.2 – DONNÉES (min. 10 lignes par table)
-- ============================================================

-- Auteurs
INSERT INTO auteurs (nom, prenom, nationalite, date_naissance) VALUES
  ('Ouédraogo',  'Idrissa',     'Burkinabè',   '1970-04-12'),
  ('Diallo',     'Aminata',     'Sénégalaise',  '1985-09-03'),
  ('Traoré',     'Moussa',      'Malien',       '1962-11-27'),
  ('Sawadogo',   'Rasmané',     'Burkinabè',    '1978-06-15'),
  ('García',     'Mariana',     'Espagnole',    '1990-01-22'),
  ('Nkosi',      'Thabo',       'Sud-Africain', '1975-08-30'),
  ('Lefebvre',   'Claire',      'Française',    '1968-03-07'),
  ('Sow',        'Fatoumata',   'Guinéenne',    '1982-12-19'),
  ('Mbeki',      'Kwame',       'Ghanéen',      '1955-05-05'),
  ('Bernard',    'Pierre',      'Français',     '1960-07-14'),
  ('Koné',       'Adama',       'Ivoirien',     '1988-02-28'),
  ('Hassan',     'Naima',       'Marocaine',    '1993-10-11');

-- Catégories
INSERT INTO categories (nom, description) VALUES
  ('Informatique',   'Programmation, bases de données, réseaux'),
  ('Littérature',    'Romans, nouvelles, poésie africaine et mondiale'),
  ('Sciences',       'Mathématiques, physique, biologie'),
  ('Histoire',       'Histoire de l Afrique et du monde'),
  ('Philosophie',    'Éthique, logique, philosophie africaine'),
  ('Économie',       'Microéconomie, macroéconomie, développement'),
  ('Droit',          'Droit civil, droit pénal, droit international'),
  ('Médecine',       'Anatomie, pharmacologie, santé publique'),
  ('Agriculture',    'Agronomie, gestion des ressources naturelles'),
  ('Arts',           'Peinture, sculpture, musique, cinéma');

-- Livres
INSERT INTO livres (titre, isbn, auteur_id, categorie_id, annee_publi, editeur, nb_exemplaires) VALUES
  ('Introduction aux bases de données relationnelles', '978-2-100-12345-1',  1,  1, 2020, 'Éditions BIT',      3),
  ('Les étoiles de Ouaga',                             '978-2-070-98765-2',  2,  2, 2018, 'Présence Africaine', 2),
  ('Algorithmes et structures de données',             '978-0-262-03384-3',  3,  1, 2019, 'MIT Press',          2),
  ('Histoire du Burkina Faso',                         '978-2-845-67890-4',  4,  4, 2015, 'L Harmattan',        4),
  ('Réseaux informatiques',                            '978-2-744-07654-5',  5,  1, 2021, 'Dunod',              2),
  ('Philosophie africaine contemporaine',              '978-2-130-54321-6',  6,  5, 2017, 'PUF',                1),
  ('Mathématiques pour l ingénieur',                   '978-2-225-86543-7',  7,  3, 2022, 'Masson',             3),
  ('Économie du développement en Afrique',             '978-2-717-43210-8',  8,  6, 2016, 'Karthala',           2),
  ('Droit des contrats OHADA',                         '978-2-802-11111-9',  9,  7, 2020, 'Bruylant',           1),
  ('Santé publique en milieu tropical',                '978-2-257-20001-0', 10,  8, 2018, 'Lavoisier',          2),
  ('Programmation Python avancée',                     '978-1-491-91205-1', 11,  1, 2023, 'O Reilly',           4),
  ('Agriculture durable au Sahel',                     '978-2-811-22222-2', 12,  9, 2019, 'CTA',                2),
  ('Le roman de la savane',                            '978-2-070-33333-3',  2,  2, 2021, 'Présence Africaine', 3),
  ('Introduction à MySQL',                             '978-1-593-27791-4',  1,  1, 2022, 'No Starch Press',    2),
  ('Arts et cultures d Afrique de l Ouest',            '978-2-070-44444-4',  4, 10, 2014, 'Karthala',           1);

-- Membres
INSERT INTO membres (nom, prenom, email, telephone, adresse, date_adhesion, actif) VALUES
  ('Compaoré',  'Sylvain',   'sylvain.compaore@bit.bf',  '+226 70 11 22 33', 'Secteur 15, Ouagadougou', '2023-09-01', TRUE),
  ('Zongo',     'Mariam',    'mariam.zongo@bit.bf',      '+226 76 44 55 66', 'Secteur 22, Ouagadougou', '2023-09-01', TRUE),
  ('Kaboré',    'Eric',      'eric.kabore@bit.bf',       '+226 65 77 88 99', 'Koudougou',               '2023-10-15', TRUE),
  ('Tapsoba',   'Alice',     'alice.tapsoba@bit.bf',     '+226 71 23 45 67', 'Bobo-Dioulasso',          '2024-01-10', TRUE),
  ('Ouattara',  'Issouf',    'issouf.ouattara@bit.bf',   '+226 78 34 56 78', 'Secteur 8, Ouagadougou',  '2024-02-20', TRUE),
  ('Sawadogo',  'Nadège',    'nadege.sawadogo@bit.bf',   '+226 70 45 67 89', 'Secteur 30, Ouagadougou', '2024-03-05', TRUE),
  ('Diallo',    'Ibrahim',   'ibrahim.diallo@bit.bf',    '+226 76 56 78 90', 'Dédougou',                '2024-04-12', TRUE),
  ('Traoré',    'Fatima',    'fatima.traore@bit.bf',     '+226 65 67 89 01', 'Secteur 5, Ouagadougou',  '2024-05-01', TRUE),
  ('Ouédraogo', 'Jean-Paul', 'jeanpaul.ouedraogo@bit.bf','+226 71 78 90 12', 'Secteur 12, Ouagadougou', '2024-06-15', TRUE),
  ('Yameogo',   'Céline',    'celine.yameogo@bit.bf',    '+226 78 89 01 23', 'Ouahigouya',              '2024-07-01', TRUE),
  ('Belem',     'Raoul',     'raoul.belem@bit.bf',       '+226 70 90 12 34', 'Secteur 18, Ouagadougou', '2024-08-20', FALSE),
  ('Nana',      'Sophie',    'sophie.nana@bit.bf',       '+226 76 01 23 45', 'Fada N Gourma',           '2024-09-10', TRUE);

-- Emprunts
INSERT INTO emprunts (membre_id, livre_id, date_emprunt, date_retour_prevue, date_retour_reelle, amende_montant, amende_payee) VALUES
  (1,  1,  '2025-01-10', '2025-01-24', '2025-01-22', 0.00,   TRUE),
  (1,  3,  '2025-02-05', '2025-02-19', '2025-02-25', 300.00, TRUE),
  (2,  2,  '2025-01-15', '2025-01-29', '2025-01-29', 0.00,   TRUE),
  (2,  13, '2025-03-01', '2025-03-15', '2025-03-20', 250.00, FALSE),
  (3,  5,  '2025-02-10', '2025-02-24', '2025-02-23', 0.00,   TRUE),
  (3,  11, '2025-03-15', '2025-03-29', NULL,         0.00,   FALSE),
  (4,  7,  '2025-01-20', '2025-02-03', '2025-02-03', 0.00,   TRUE),
  (4,  4,  '2025-04-01', '2025-04-15', NULL,         0.00,   FALSE),
  (5,  6,  '2025-02-28', '2025-03-14', '2025-03-18', 200.00, FALSE),
  (5,  9,  '2025-03-20', '2025-04-03', '2025-04-03', 0.00,   TRUE),
  (6,  1,  '2025-04-05', '2025-04-19', NULL,         0.00,   FALSE),
  (6,  14, '2025-04-10', '2025-04-24', NULL,         0.00,   FALSE),
  (7,  8,  '2025-03-10', '2025-03-24', '2025-03-30', 300.00, TRUE),
  (7,  12, '2025-04-15', '2025-04-29', NULL,         0.00,   FALSE),
  (8,  10, '2025-02-01', '2025-02-15', '2025-02-14', 0.00,   TRUE),
  (8,  2,  '2025-04-20', '2025-05-04', NULL,         0.00,   FALSE),
  (9,  15, '2025-03-25', '2025-04-08', '2025-04-07', 0.00,   TRUE),
  (9,  3,  '2025-04-22', '2025-05-06', NULL,         0.00,   FALSE),
  (10, 11, '2025-03-01', '2025-03-15', '2025-03-14', 0.00,   TRUE),
  (10, 5,  '2025-04-25', '2025-05-09', NULL,         0.00,   FALSE),
  (11, 1,  '2025-01-05', '2025-01-19', '2025-01-28', 450.00, FALSE),
  (12, 7,  '2025-04-28', '2025-05-12', NULL,         0.00,   FALSE);

-- ============================================================
-- PARTIE 2.3 – UPDATE et DELETE
-- ============================================================

-- UPDATE 1 : Désactiver un membre
UPDATE membres
SET actif = FALSE
WHERE membre_id = 11;

-- UPDATE 2 : Mettre à jour le retour réel et calculer l'amende (50 FCFA/jour de retard)
UPDATE emprunts
SET date_retour_reelle = '2025-04-10',
    amende_montant = DATEDIFF('2025-04-10', date_retour_prevue) * 50
WHERE emprunt_id = 6
  AND DATEDIFF('2025-04-10', date_retour_prevue) > 0;

-- UPDATE 3 : Augmenter le nombre d'exemplaires d'un livre
UPDATE livres
SET nb_exemplaires = nb_exemplaires + 1
WHERE isbn = '978-1-491-91205-1';

-- UPDATE 4 : Marquer une amende comme payée
UPDATE emprunts
SET amende_payee = TRUE
WHERE emprunt_id IN (4, 9);

-- DELETE 1 : Supprimer une catégorie inutilisée (sans livres liés)
-- (Créer une catégorie temporaire pour la démo)
INSERT INTO categories (nom, description) VALUES ('Test_Temp', 'Catégorie de test à supprimer');
DELETE FROM categories WHERE nom = 'Test_Temp';

-- DELETE 2 : Supprimer un emprunt clôturé il y a plus de 2 ans (archivage)
-- (Aucun emprunt éligible dans nos données — insertion d'un enregistrement de démo)
INSERT INTO emprunts (membre_id, livre_id, date_emprunt, date_retour_prevue, date_retour_reelle, amende_montant, amende_payee)
  VALUES (1, 2, '2022-01-01', '2022-01-15', '2022-01-14', 0.00, TRUE);
DELETE FROM emprunts
WHERE date_retour_reelle IS NOT NULL
  AND DATEDIFF(CURRENT_DATE, date_retour_reelle) > 730
  AND amende_payee = TRUE;

-- INTÉGRITÉ RÉFÉRENTIELLE (exemple de violation)
-- La commande suivante échouera car le livre_id 999 n'existe pas :
-- INSERT INTO emprunts (membre_id, livre_id, date_emprunt, date_retour_prevue)
-- VALUES (1, 999, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY));
-- Erreur attendue : ERROR 1452 – Cannot add or update a child row: a foreign key constraint fails

-- ============================================================
-- PARTIE 2.4 – REQUÊTES SELECT
-- ============================================================

-- 1 mark : Tous les enregistrements d'une table
SELECT * FROM livres;

-- 1 mark : Colonnes spécifiques avec WHERE
SELECT nom, prenom, email
FROM membres
WHERE actif = TRUE;

-- 1 mark : Résultats triés avec ORDER BY
SELECT titre, annee_publi, editeur
FROM livres
ORDER BY annee_publi DESC;

-- 1 mark : Résultats limités avec LIMIT
SELECT nom, prenom, date_adhesion
FROM membres
ORDER BY date_adhesion DESC
LIMIT 5;

-- 2 marks : Filtre avec BETWEEN, LIKE, IN
SELECT titre, annee_publi
FROM livres
WHERE annee_publi BETWEEN 2018 AND 2022;

SELECT nom, prenom
FROM membres
WHERE email LIKE '%@bit.bf';

SELECT titre, categorie_id
FROM livres
WHERE categorie_id IN (1, 3, 6);

-- 2 marks : INNER JOIN sur deux tables
SELECT l.titre, a.nom AS auteur_nom, a.prenom AS auteur_prenom
FROM livres l
INNER JOIN auteurs a ON l.auteur_id = a.auteur_id;

-- 2 marks : LEFT JOIN (retourne tous les membres, même sans emprunts)
SELECT m.nom, m.prenom, COUNT(e.emprunt_id) AS nb_emprunts
FROM membres m
LEFT JOIN emprunts e ON m.membre_id = e.membre_id
GROUP BY m.membre_id, m.nom, m.prenom;
-- Différence : INNER JOIN n'aurait retourné que les membres ayant au moins un emprunt.

-- 3 marks : JOIN sur 3 tables ou plus
SELECT
  m.nom        AS membre_nom,
  m.prenom     AS membre_prenom,
  l.titre      AS livre_titre,
  a.nom        AS auteur_nom,
  c.nom        AS categorie,
  e.date_emprunt,
  e.date_retour_prevue,
  e.date_retour_reelle
FROM emprunts e
INNER JOIN membres m  ON e.membre_id  = m.membre_id
INNER JOIN livres  l  ON e.livre_id   = l.livre_id
INNER JOIN auteurs a  ON l.auteur_id  = a.auteur_id
INNER JOIN categories c ON l.categorie_id = c.categorie_id
ORDER BY e.date_emprunt DESC;

-- 2 marks : IS NULL / IS NOT NULL
-- Emprunts pas encore retournés
SELECT m.nom, m.prenom, l.titre, e.date_retour_prevue
FROM emprunts e
INNER JOIN membres m ON e.membre_id = m.membre_id
INNER JOIN livres  l ON e.livre_id  = l.livre_id
WHERE e.date_retour_reelle IS NULL;

-- Emprunts déjà retournés
SELECT emprunt_id, membre_id, livre_id, date_retour_reelle
FROM emprunts
WHERE date_retour_reelle IS NOT NULL;

-- ============================================================
-- PARTIE 3 – FONCTIONS D'AGRÉGATION & RAPPORTS
-- ============================================================

-- 2 marks : COUNT total
SELECT COUNT(*) AS total_livres FROM livres;

-- 2 marks : MAX et MIN
SELECT
  MAX(amende_montant) AS amende_max,
  MIN(amende_montant) AS amende_min
FROM emprunts
WHERE amende_montant > 0;

-- 2 marks : AVG
SELECT ROUND(AVG(nb_exemplaires), 2) AS moyenne_exemplaires
FROM livres;

-- 3 marks : GROUP BY avec agrégat
SELECT c.nom AS categorie, COUNT(l.livre_id) AS nb_livres
FROM categories c
LEFT JOIN livres l ON c.categorie_id = l.categorie_id
GROUP BY c.categorie_id, c.nom
ORDER BY nb_livres DESC;

-- 3 marks : HAVING pour filtrer les groupes
SELECT m.nom, m.prenom, COUNT(e.emprunt_id) AS nb_emprunts
FROM membres m
INNER JOIN emprunts e ON m.membre_id = e.membre_id
GROUP BY m.membre_id, m.nom, m.prenom
HAVING COUNT(e.emprunt_id) >= 2
ORDER BY nb_emprunts DESC;

-- 3 marks : Rapport de synthèse JOIN + GROUP BY + HAVING
-- Rapport : Membres avec des amendes impayées supérieures à 200 FCFA
SELECT
  m.nom               AS membre_nom,
  m.prenom            AS membre_prenom,
  m.email,
  COUNT(e.emprunt_id)                         AS total_emprunts,
  SUM(e.amende_montant)                        AS total_amendes,
  SUM(CASE WHEN e.amende_payee = FALSE THEN e.amende_montant ELSE 0 END) AS amendes_impayees
FROM membres m
INNER JOIN emprunts e ON m.membre_id = e.membre_id
WHERE e.amende_montant > 0
GROUP BY m.membre_id, m.nom, m.prenom, m.email
HAVING amendes_impayees > 200
ORDER BY amendes_impayees DESC;
