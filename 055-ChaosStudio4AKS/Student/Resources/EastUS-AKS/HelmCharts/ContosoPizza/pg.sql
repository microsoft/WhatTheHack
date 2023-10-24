--Create the wth database
CREATE DATABASE wth;

-- Create user contosoapp that would own the application schema

 CREATE ROLE CONTOSOAPP WITH LOGIN NOSUPERUSER INHERIT CREATEDB CREATEROLE NOREPLICATION PASSWORD 'OCPHack8';

