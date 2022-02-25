/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name LIKE '%mon';
SELECT name from animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-01-01';
SELECT name from animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth from animals WHERE name IN('Agumon', 'Pikachu');
SELECT name, escape_attempts from animals WHERE weight_kg > 10.5;
SELECT * from animals WHERE neutered = true;
SELECT * from animals WHERE name != 'Gabumon';
SELECT * from animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


/*Inside a transaction update the animals table by setting the species column to 'unspecified' and rollback the change*/
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
 id |    name    | date_of_birth | escape_attempts | neutered | weight_kg |   species
----+------------+---------------+-----------------+----------+-----------+-------------
  5 | Agumon     | 2020-02-02    |               0 | t        |     10.23 | unspecified
  6 | Gabumon    | 2018-09-15    |               2 | t        |         8 | unspecified
  7 | Pikachu    | 2021-01-07    |               1 | f        |     15.04 | unspecified
  8 | Devimon    | 2017-05-12    |               5 | t        |        11 | unspecified
  9 | Charmander | 2020-02-08    |               0 | f        |        11 | unspecified
 10 | Plantmon   | 2022-11-15    |               2 | t        |       5.7 | unspecified
 11 | Squirtle   | 1993-04-02    |               3 | f        |     12.13 | unspecified
 12 | Angemon    | 2005-06-12    |               1 | t        |        45 | unspecified
 13 | Boarmon    | 2005-06-07    |               7 | t        |      20.4 | unspecified
 14 | Blossom    | 1998-10-13    |               3 | t        |        17 | unspecified
(10 rows)

ROLLBACK;

/*Inside a transaction update the animals table by setting the species column and commit the change*/

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;
 id |    name    | date_of_birth | escape_attempts | neutered | weight_kg | species
----+------------+---------------+-----------------+----------+-----------+---------
  5 | Agumon     | 2020-02-02    |               0 | t        |     10.23 | digimon
  6 | Gabumon    | 2018-09-15    |               2 | t        |         8 | digimon
  8 | Devimon    | 2017-05-12    |               5 | t        |        11 | digimon
 10 | Plantmon   | 2022-11-15    |               2 | t        |       5.7 | digimon
 12 | Angemon    | 2005-06-12    |               1 | t        |        45 | digimon
 13 | Boarmon    | 2005-06-07    |               7 | t        |      20.4 | digimon
  7 | Pikachu    | 2021-01-07    |               1 | f        |     15.04 | pokemon
  9 | Charmander | 2020-02-08    |               0 | f        |        11 | pokemon
 11 | Squirtle   | 1993-04-02    |               3 | f        |     12.13 | pokemon
 14 | Blossom    | 1998-10-13    |               3 | t        |        17 | pokemon
(10 rows)

/*Inside a transaction delete all records from animals table and rollback the change*/

BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
 id | name | date_of_birth | escape_attempts | neutered | weight_kg | species
----+------+---------------+-----------------+----------+-----------+---------
(0 rows)
ROLLBACK;

/*after rollback*/
SELECT * FROM animals;
 id |    name    | date_of_birth | escape_attempts | neutered | weight_kg | species
----+------------+---------------+-----------------+----------+-----------+---------
  5 | Agumon     | 2020-02-02    |               0 | t        |     10.23 | digimon
  6 | Gabumon    | 2018-09-15    |               2 | t        |         8 | digimon
  8 | Devimon    | 2017-05-12    |               5 | t        |        11 | digimon
 10 | Plantmon   | 2022-11-15    |               2 | t        |       5.7 | digimon
 12 | Angemon    | 2005-06-12    |               1 | t        |        45 | digimon
 13 | Boarmon    | 2005-06-07    |               7 | t        |      20.4 | digimon
  7 | Pikachu    | 2021-01-07    |               1 | f        |     15.04 | pokemon
  9 | Charmander | 2020-02-08    |               0 | f        |        11 | pokemon
 11 | Squirtle   | 1993-04-02    |               3 | f        |     12.13 | pokemon
 14 | Blossom    | 1998-10-13    |               3 | t        |        17 | pokemon
(10 rows)

/*Inside a transaction create a savepoint, rollback to a savepoint, update animals' weights and commit the transaction*/
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT date_of_birth_before_jan1_2_2022;
UPDATE animals SET weight_kg = (weight_kg * -1);
SELECT * FROM animals;
 id |    name    | date_of_birth | escape_attempts | neutered | weight_kg | species
----+------------+---------------+-----------------+----------+-----------+---------
  5 | Agumon     | 2020-02-02    |               0 | t        |     -10.23 | digimon
  6 | Gabumon    | 2018-09-15    |               2 | t        |         -8 | digimon
  8 | Devimon    | 2017-05-12    |               5 | t        |        -11 | digimon
 12 | Angemon    | 2005-06-12    |               1 | t        |        -45 | digimon
 13 | Boarmon    | 2005-06-07    |               7 | t        |      -20.4 | digimon
  7 | Pikachu    | 2021-01-07    |               1 | f        |     -15.04 | pokemon
  9 | Charmander | 2020-02-08    |               0 | f        |        -11 | pokemon
 11 | Squirtle   | 1993-04-02    |               3 | f        |     -12.13 | pokemon
 14 | Blossom    | 1998-10-13    |               3 | t        |        -17 | pokemon
(9 rows)

ROLLBACK TO date_of_birth_before_jan1_2_2022;
SELECT * FROM animals;
 id |    name    | date_of_birth | escape_attempts | neutered | weight_kg | species
----+------------+---------------+-----------------+----------+-----------+---------
  5 | Agumon     | 2020-02-02    |               0 | t        |      10.23 | digimon
  6 | Gabumon    | 2018-09-15    |               2 | t        |          8 | digimon
  8 | Devimon    | 2017-05-12    |               5 | t        |         11 | digimon
 12 | Angemon    | 2005-06-12    |               1 | t        |         45 | digimon
 13 | Boarmon    | 2005-06-07    |               7 | t        |       20.4 | digimon
  7 | Pikachu    | 2021-01-07    |               1 | f        |      15.04 | pokemon
  9 | Charmander | 2020-02-08    |               0 | f        |         11 | pokemon
 11 | Squirtle   | 1993-04-02    |               3 | f        |      12.13 | pokemon
 14 | Blossom    | 1998-10-13    |               3 | t        |         17 | pokemon
(9 rows)

UPDATE animals SET weight_kg = (weight_kg * -1) WHERE weight_kg < 0;
COMMIT;

/*How many animals are there?*/
SELECT COUNT(*) FROM animals;

 count
-------
     9
/*How many animals have never tried to escape*/
SELECT COUNT(escape_attempts) FROM animals WHERE escape_attempts = 0;

 count
-------
     2
/*What is the average weight of animals?*/
 SELECT AVG(weight_kg) FROM animals;

 avg
---------------------
 16.6444444444444444
/*Who escapes the most, neutered or not neutered animals?*/
SELECT neutered, sum(escape_attempts) FROM animals GROUP BY neutered;

 neutered | sum
----------+-----
 f        |   4
 t        |  18
/*What is the minimum and maximum weight of each type of animal?*/
 SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

 species | min | max
---------+-----+-----
 pokemon |  11 |  17
 digimon |   8 |  45
/*What is the average number of escape attempts per animal type of those born between 1990 and 2000?*/
SELECT species, AVG(escape_attempts) AS avg_escape_attempts FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-01-01' GROUP BY species;

 species |        avg_escape_attempts
---------+--------------------
 pokemon | 3.0000000000000000
(1 row)

/*What animals belong to Melody Pond?*/

SELECT O.id, full_name, owner_id, name 
FROM owners O inner join animals A 
ON O.id = A.owner_id 
WHERE full_name = 'Melody Pond';
 id |  full_name  | owner_id |    name
----+-------------+----------+------------
  4 | Melody Pond |        4 | Blossom
  4 | Melody Pond |        4 | Squirtle
  4 | Melody Pond |        4 | Charmander

/*List of all animals that are pokemon */

select A.name, S.name as species_name from species S inner join animals A on S.id = A.species_id where S.name = 'Pokemon';
    name    | species_name
------------+--------------
 Blossom    | Pokemon
 Squirtle   | Pokemon
 Charmander | Pokemon
 Pikachu    | Pokemon
(4 rows)

/*List all owners and their animals, remember to include those that don't own any animal.*/

select O.id, full_name, owner_id, name from owners O left join animals A on O.id = A.owner_id;
 id |    full_name    | owner_id |    name
----+-----------------+----------+------------
  1 | Sam Smith       |        1 | Agumon
  2 | Jennifer Orwell |        2 | Pikachu
  2 | Jennifer Orwell |        2 | Gabumon
  3 | Bob             |        3 | Devimon
  4 | Melody Pond     |        4 | Blossom
  4 | Melody Pond     |        4 | Squirtle
  4 | Melody Pond     |        4 | Charmander
  5 | Dean Winchester |        5 | Boarmon
  5 | Dean Winchester |        5 | Angemon
  6 | Jodie Whittaker |          |
(10 rows)

/*How many animals are there per species*/
SELECT S.name as species_name, COUNT(species_id) as animals 
FROM species S 
INNER JOIN animals
ON S.id = species_id
GROUP BY S.id;

 species_name | animals
--------------+---------
 Pokemon      |       4
 Digimon      |       5
(2 rows)
/*How many animals are there per species?*/
SELECT S.name as species_name, count(species_id)
FROM species S
INNER JOIN animals
ON species_id = S.id
GROUP BY S.name;

 species_name | count
--------------+-------
 Digimon      |     5
 Pokemon      |     4
(2 rows)

/*List all Digimon owned by Jennifer Orwell.*/
SELECT o.full_name as owner_name, count(species_id) as count_of_digimon 
FROM owners o JOIN animals a 
ON o.id = a.owner_id
JOIN species s
ON s.id = a.species_id
GROUP BY o.full_name, a.species_id
HAVING o.full_name = 'Jennifer Orwell' AND a.species_id = 2;
   owner_name    | count_of_digimon
-----------------+------------------
 Jennifer Orwell |                1
(1 row)
/*List all animals owned by Dean Winchester that haven't tried to escape.*/
 SELECT o.full_name as owner_name, name as animal_not_escaped 
 FROM owners o 
 JOIN animals a 
 ON a.owner_id = o.id 
 WHERE o.full_name = 'Dean Winchester' AND escape_attempts = 0;
 owner_name | animal_not_escaped
------------+--------------------
(0 rows)
/*Who owns the most animals?*/

SELECT owner_name, no_of_animals_owned 
FROM 
    (SELECT o.full_name as owner_name, count(owner_id) as no_of_animals_owned 
        FROM owners o 
        JOIN animals 
        ON o.id =owner_id 
        GROUP BY o.full_name) 
as tb1 
ORDER BY no_of_animals_owned DESC;
   owner_name    | no_of_animals_owned
-----------------+---------------------
 Melody Pond     |                   3
 Dean Winchester |                   2
 Jennifer Orwell |                   2
 Bob             |                   1
 Sam Smith       |                   1
