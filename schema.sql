/* Database schema to keep the structure of entire database. */

 CREATE TABLE animals (
    id int generated always as identity, 
    name varchar(250),
    date_of_birth date,
    escape_attempts int,
    neutered boolean,
    weight_kg decimal,
    primary key(id)
);
ALTER TABLE animals ADD column species VARCHAR(50);

CREATE TABLE owners (id int generated always as identity,
    full_name varchar(50),
    age int,
    primary key(id)
);
