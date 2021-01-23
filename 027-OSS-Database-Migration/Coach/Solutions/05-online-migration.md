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

Verify count of tables and indexes created on the target database from psql. 26tables, 39 indices.

*\dt+

*\di+

The query to disable all foreign key in DMS  (https://docs.microsoft.com/en-us/azure/dms/tutorial-postgresql-azure-postgresql-online-portal )  shows more results than needed. It can be simplified bu saving the output of a SQL command that just drops the constraints. From psql,

* \out drop_fk.sql
* SELECT CONCAT('ALTER TABLE ', table_schema, '.', table_name, STRING_AGG(DISTINCT CONCAT(' DROP CONSTRAINT ', foreignkey), ','), ';') as DropQuery   
FROM
    (SELECT
    S.table_schema,
    S.foreignkey,
    S.table_name,
    STRING_AGG(DISTINCT S.column_name, ',') AS column_name,
    S.foreign_table_schema,
    S.foreign_table_name,
    STRING_AGG(DISTINCT S.foreign_column_name, ',') AS foreign_column_name
FROM
    (SELECT DISTINCT
    tc.table_schema,
    tc.constraint_name AS foreignkey,
    tc.table_name,
    kcu.column_name,
    ccu.table_schema AS foreign_table_schema,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
    FROM information_schema.table_constraints AS tc
    JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name AND ccu.table_schema = tc.table_schema
WHERE constraint_type = 'FOREIGN KEY'
    ) S
    GROUP BY S.table_schema, S.foreignkey, S.table_name, S.foreign_table_schema, S.foreign_table_name
    ) Q
    GROUP BY Q.table_schema, Q.table_name;

Edit the file drop_fk.sql to clean up to run as a  SQL statement
Run the file

* \i  drop_fk.sql

For Azure DMS,  you need to create a migration project

in DMS wizard, connect to source as the IP from kubectl -n postgresql get svc command
Make sure the radio buttons are checked for Trust Server Certificate and Encrypt connection
The user contosoapp does not have replication role enabled. They should get an error. To resolve this, connect to psql as superuser

* postgres=# alter role contosoapp with replication ;

IN DMS, trying to connect to the target service if you get a connection error, check "Allow access to Azure Services" in the azure portal for the database. After migration, do a cutover and re-nable the foreign keys. Run the followin on source and run it on target after cleaning the header.

* \out enable_fk.sql
* SELECT CONCAT('ALTER TABLE ', table_schema, '.', table_name, STRING_AGG(DISTINCT CONCAT(' ADD CONSTRAINT ', foreignkey, ' FOREIGN KEY (', column_name, ')', ' REFERENCES ', foreign_table_schema, '.', foreign_table_name, '(', foreign_column_name, ')' ), ','), ';') as AddQuery
FROM
    (SELECT
    S.table_schema,
    S.foreignkey,
    S.table_name,
    STRING_AGG(DISTINCT S.column_name, ',') AS column_name,
    S.foreign_table_schema,
    S.foreign_table_name,
    STRING_AGG(DISTINCT S.foreign_column_name, ',') AS foreign_column_name
FROM
    (SELECT DISTINCT
    tc.table_schema,
    tc.constraint_name AS foreignkey,
    tc.table_name,
    kcu.column_name,
    ccu.table_schema AS foreign_table_schema,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
    FROM information_schema.table_constraints AS tc
    JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name AND ccu.table_schema = tc.table_schema
WHERE constraint_type = 'FOREIGN KEY'
    ) S
    GROUP BY S.table_schema, S.foreignkey, S.table_name, S.foreign_table_schema, S.foreign_table_name
    ) Q
    GROUP BY Q.table_schema, Q.table_name;
