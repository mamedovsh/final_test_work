CREATE DATABASE man_friends;

USE man_friends;

-- 8. Создать таблицы с иерархией из диаграммы в БД

CREATE TABLE animals
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	animal_type VARCHAR(30)
);

INSERT INTO animals (animal_type)
VALUES ('Домашние животные'), ('Вьючные животные');

CREATE TABLE pets
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	animal_kind VARCHAR(30),
	animal_type_id INT DEFAULT 1,
	FOREIGN KEY (animal_type_id) REFERENCES animals (id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO pets (animal_kind)
VALUES ('Собаки'), ('Кошки'), ('Хомяки');

CREATE TABLE pack_animals
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	animal_kind VARCHAR(30),
	animal_type_id INT DEFAULT 2,
	FOREIGN KEY (animal_type_id) REFERENCES animals (id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO pack_animals (animal_kind)
VALUES ('Лошади'), ('Верблюды'), ('Ослы');

-- 9. Заполнить низкоуровневые таблицы именами(животных), командами
--    которые они выполняют и датами рождения.

CREATE TABLE dog 
(       
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(30), 
    commands VARCHAR(100),
    birthday DATE,
    animal_kind_id INT DEFAULT 1,
    Foreign KEY (animal_kind_id) REFERENCES pets (id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO dog (name, commands, birthday)
VALUES ('Шарик', 'лежать', '2021-05-28'),
('Бобик', 'сидеть', '2016-05-08'),
('Алабаш', ' голос', '2020-03-25');

CREATE TABLE cat 
(       
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(30), 
    commands VARCHAR(100),
    birthday DATE,
    animal_kind_id INT DEFAULT 2,
    Foreign KEY (animal_kind_id) REFERENCES pets (id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO cat (name, commands, birthday)
VALUES ('Арчи', 'стоять', '2021-03-14'),
('Мурка', 'скажи мяу', '2017-03-09'),
('Клякса', 'гулять', '2019-02-21');

CREATE TABLE hamster 
(       
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(30), 
    commands VARCHAR(100),
    birthday DATE,
    animal_kind_id INT DEFAULT 3,
    Foreign KEY (animal_kind_id) REFERENCES pets (id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO hamster (name, commands, birthday)
VALUES ('Хома', 'лезь в рукав', '2022-02-07'),
('Плейбой', 'крути колесо', '2022-02-07'),
('Хам', 'кушать', '2022-02-07');

CREATE TABLE horse 
(       
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(30), 
    commands VARCHAR(100),
    birthday DATE,
    animal_kind_id INT DEFAULT 1,
    Foreign KEY (animal_kind_id) REFERENCES pack_animals (id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO horse (name, commands, birthday)
VALUES ('Нильхи', 'Ноо, Тпрр', '2021-03-12'),
('Плотва', 'стой, шагом', '2020-05-20'),
('Ураган', 'стой, шагом', '2018-02-27');

CREATE TABLE camel 
(       
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(30), 
    commands VARCHAR(100),
    birthday DATE,
    animal_kind_id INT DEFAULT 2,
    Foreign KEY (animal_kind_id) REFERENCES pack_animals (id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO camel (name, commands, birthday)
VALUES ('Денеб', 'гит, дурр', '2020-02-15'),
('Арлекин', 'дурр','цок-цок', '2020-11-05'),
('Гизмо', 'каш, гит', '2020-07-21');

CREATE TABLE donkey 
(       
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(30), 
    commands VARCHAR(100),
    birthday DATE,
    animal_kind_id INT DEFAULT 3,
    Foreign KEY (animal_kind_id) REFERENCES pack_animals (id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO donkey (name, commands, birthday)
VALUES ('Негр', 'пошел,стой', '2020-03-19'),
('Семён', 'пошел,стой', '2017-10-15'),
('Иа', 'пошел,стой, сесть', '2022-08-24');

-- 10. Удалив из таблицы верблюдов, т.к. верблюдов решили перевезти в другой
--     питомник на зимовку. Объединить таблицы лошади, и ослы в одну таблицу.

DELETE FROM camel;

CREATE TABLE horses_and_donkeys SELECT * FROM horses
UNION SELECT * FROM donkeys;

-- 11. Создать новую таблицу “молодые животные” в которую попадут все
--     животные старше 1 года, но младше 3 лет и в отдельном столбце с точностью
--     до месяца подсчитать возраст животных в новой таблице

CREATE TEMPORARY TABLE all_animals
SELECT * FROM dog
UNION SELECT * FROM cat
UNION SELECT * FROM hamster
UNION SELECT * FROM horse
UNION SELECT * FROM camel
UNION SELECT * FROM donkey;

CREATE TABLE young_animals
SELECT name, commands, birthday, animal_kind_id, TIMESTAMPDIFF(MONTH, birthday, CURDATE()) AS age_in_month
FROM all_animals
WHERE birthday BETWEEN ADDDATE(CURDATE(), INTERVAL -3 YEAR) AND ADDDATE(CURDATE(), INTERVAL -1 YEAR);

-- 12. Объединить все таблицы в одну, при этом сохраняя поля, указывающие на
--     прошлую принадлежность к старым таблицам.

SELECT dog.name, dog.commands, dog.birthday, pets.animal_kind, animals.animal_type
FROM dog
LEFT JOIN pets ON pets.id = dog.animal_kind_id
LEFT JOIN animals ON animals.id=pets.animal_type_id
UNION
SELECT cat.name, cat.commands, cat.birthday, pets.animal_kind, animals.animal_type
FROM cat
LEFT JOIN pets ON pets.id = cat.animal_kind_id
LEFT JOIN animals ON animals.id=pets.animal_type_id
UNION
SELECT hamster.name, hamster.commands, hamster.birthday, pets.animal_kind, animals.animal_type
FROM hamster
LEFT JOIN pets ON pets.id = hamster.animal_kind_id
LEFT JOIN animals ON animals.id=pets.animal_type_id
UNION
SELECT horse.name, horse.commands, horse.birthday, pack_animals.animal_kind, animals.animal_type
FROM horse
LEFT JOIN pack_animals ON pack_animals.id = horses.animal_kind_id
LEFT JOIN animals ON animals.id=pack_animals.animal_type_id
UNION
SELECT camel.name, camel.commands, camel.birthday, pack_animals.animal_kind, animals.animal_type
FROM camel
LEFT JOIN pack_animals ON pack_animals.id = camels.animal_kind_id
LEFT JOIN animals ON animals.id=pack_animals.animal_type_id
UNION
SELECT donkey.name, donkey.commands, donkey.birthday, pack_animals.animal_kind, animals.animal_type
FROM donkey
LEFT JOIN pack_animals ON pack_animals.id = donkey.animal_kind_id
LEFT JOIN animals ON animals.id=pack_animals.animal_type_id;