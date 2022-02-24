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


