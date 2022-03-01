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

CREATE TABLE species (id int generated always as identity,
    name varchar(50),
    primary key(id)
);

ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD COLUMN species_id INT;
ALTER TABLE animals ADD FOREIGN KEY (species_id) REFERENCES species(id);
ALTER TABLE animals ADD COLUMN owner_id INT;
ALTER TABLE animals ADD FOREIGN KEY (owner_id) REFERENCES owners(id);

CREATE TABLE vets (id int generated always as identity, 
    name varchar(50),
    age int,
    date_of_graduations date,
    primary key(id)
);

CREATE TABLE specialization (species_id int, vet_id int, 
    FOREIGN KEY (species_id) REFERENCES species (id), 
    FOREIGN KEY (vet_id) REFERENCES vets(id)
);

CRETE TABLE visits (animal_id int, vet_id int, 
foreign key(animal_id) references animals(id), 
foreign key(vet_id) references vets(id)
);
ALTER TABLE visits add column date_of_visit date;

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);
