CREATE TABLE animateur (
    id_anim TEXT UNIQUE NOT NULL,
    nom TEXT UNIQUE NOT NULL,
    PRIMARY KEY(id_anim)
    );

CREATE TABLE activities (
    id_acti serial PRIMARY KEY,
    type_class TEXT NOT NULL,
	nb_participant INT NOT NULL,
    id_anim TEXT NOT NULL,
	CONSTRAINT animateur
        FOREIGN KEY (id_anim)
        REFERENCES animateur(id_anim)
	);

INSERT INTO animateur (id_anim, nom) VALUES
    ('anim1', 'choco'),
    ('anim2', 'Jen');

INSERT INTO activities (type_class, nb_participant, id_anim) VALUES
    ('Classe enfants', '10', 'anim1'),
    ('Cercle etudes', '5', 'anim2'),
    ('Atelier reflexion', '7', 'anim1');

--=======  EXO 2  ============

-- 1)
ALTER TABLE activities ADD COLUMN debut date DEFAULT '1970-01-01' NOT NULL ;

ALTER TABLE activities ADD COLUMN fin date ;

-- 2)
INSERT INTO activities (type_class, nb_participant,debut,fin,id_anim) VALUES
    ('Livret 1', '9','2022-11-22',null, 'anim1'),
    ('Livret 1', '10','2021-07-30','2021-12-04', 'anim2'),
    ('Livret 3', '7','2022-04-28',null, 'anim2'),
    ('Livret 7', '5','2019-01-01','2019-08-09', 'anim2'),
    ('Livret 11', '12','2020-02-12', '2020-06-17', 'anim1');

-- 3)
SELECT DISTINCT activities.type_class FROM activities;

-- 4)
SELECT type_class, activities.debut FROM activities
        WHERE activities.fin is not null AND type_class LIKE 'Livret%' ;

-- 5)
SELECT type_class, activities.debut FROM activities
        WHERE activities.fin < '2020-01-01' AND type_class LIKE 'Livret%' ;

-- 6)
SELECT activities.type_class FROM activities
        WHERE nb_participant > '7' AND (type_class  NOT IN ('Livret 3', 'Livret 4'));

--=======  EXO 3  ============

-- DELETE
ALTER TABLE activities DROP CONSTRAINT animateur, ADD CONSTRAINT animateur_null FOREIGN KEY (id_anim)
    REFERENCES animateur(id_anim) ON DELETE SET NULL;

ALTER TABLE activities ALTER COLUMN id_anim DROP NOT NULL ;

SELECT * FROM animateur;
SELECT * FROM activities;
-- Attention la colonne id_anim config en non null : à changer (cf ci-dessus)
DELETE FROM animateur WHERE nom = 'Jen';

-- UPDATE

INSERT INTO animateur VALUES ('anim3', 'Choco2');
INSERT INTO animateur VALUES ('anim2', 'Jen2');
UPDATE activities
    SET id_anim = (SELECT animateur.id_anim FROM animateur WHERE nom = 'Jen2')
    WHERE id_anim IS NULL;

-- AS

SELECT type_class AS "Type", activities.debut AS Begin  FROM activities
        WHERE activities.fin is not null AND type_class LIKE 'Livret%' ;


-- ORDER BY
SELECT * FROM activities
    WHERE activities.fin is not null
    ORDER BY nb_participant;

-- GROUP BY
SELECT type_class, sum(nb_participant) somme FROM activities
    WHERE type_class LIKE 'Livret%'
    GROUP BY type_class;
-- ici regroupe les type et fais la somme ( ici 10 + 9)

--HAVING
SELECT type_class, SUM(nb_participant) FROM activities
    WHERE type_class LIKE 'Livret%'
    GROUP BY type_class
    HAVING SUM(nb_participant) > 0;
-- ici HAVING permet une condition

--======================== JOINTURE ==================

SELECT * FROM activities
   JOIN animateur ON activities.id_anim = animateur.id_anim;

