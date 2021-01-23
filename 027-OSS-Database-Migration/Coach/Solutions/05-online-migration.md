# Challenge 5: Online migration of database

[< Previous Challenge](./04-offline-cutover-validation.md) - **[Home](../README.md)** - [Next Challenge >](./06-online-cutover-validation.md)

## Introduction

Perform an online migration using the Azure Database Migration Service

## Steps

Connect to database container and run the export 

* kubectl -n postgresql exec deploy/postgres -it -- bash
* pg_dump -o -h localhost -U contosoapp -d wth -s >dump_wth.sql

This creates a psql dump text file. We need to import it to the target - schema only. Create a separate database for online migration (suggeted ). Alternately you can drop and re-create the database wth

* psql -h pgtarget.postgres.database.azure.com -p 5432 -U contosoapp@pgtarget  postgres
postgres=> create database wth2
postgres=>\q

Import the schema to target

* psql -h pgtarget.postgres.database.azure.com -U contosoapp@pgtarget -d wth2 < dump_wth.sql

Verify count of tables - 26 and indexes - 39 created on the target database from psql 

* \dt+

* \di+
