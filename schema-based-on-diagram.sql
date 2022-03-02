 create database clinic;

create table patients (id int primary key generated always as identity,
  name varchar(100), 
  date_of_birth date);

create table medical_histories (id int primary key generated always as identity, 
admitted_at timestamp, 
patient_id int, 
constraint fk_patient_id 
    foreign key (patient_id) 
    references patients(id), 
status varchar(100));
