# Challenge 5: Online migration of database

[< Previous Challenge](./04-offline-cutover-validation.md) - **[Home](../README.md)** - [Next Challenge >](./06-online-cutover-validation.md)

## Introduction

Perform an online migration using the Azure Database Migration Service

## Steps -- PostgreSQL

Connect to database container and run the export 

* kubectl -n postgresql exec deploy/postgres -it -- bash
* pg_dump -o -h localhost -U contosoapp -d wth -s >dump_wth.sql

This creates a psql dump text file. We need to import it to the target - schema only. Create a separate database for online migration (suggeted ). Alternately you can drop and re-create the database wth.

To drop all the tables with indexes

*  \out drop_tables.sql
*  select 'drop table ' || tablename || ' cascade;'  from pg_tables where tableowner = 'contosoapp' and schemaname = 'public' ;

To import the schema only to target using psql

* psql -h pgtarget.postgres.database.azure.com -p 5432 -U contosoapp@pgtarget  -d wth <dump_wth.sql

postgres=> create database wth

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

There is no trigger in the application schema. Still it is best practice to check for it

* \out drop_trigger.sql
* SELECT DISTINCT CONCAT('ALTER TABLE ', event_object_schema, '.', event_object_table, ' DISABLE TRIGGER ', trigger_name, ';')
FROM information_schema.triggers

For Azure DMS,  you need to create a migration project

in DMS wizard, connect to source as the external IP from kubectl -n postgresql get svc command
Make sure the radio buttons are checked for Trust Server Certificate and Encrypt connection
The user contosoapp does not have replication role enabled. They should get an error (Insufficient permission on server. 'userepl' permission is required to perform migration). To resolve this, connect to psql as superuser

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



## Steps -- MySQL

Run the export 

```shell

 mysqldump -h <container ip> -u contosoapp -p --set-gtid-purged=off --databases wth --no-data  --skip-column-statistics >dump_nodata.sql

```

Import with no data. Create the wth database

```shell

mysql -h mytarget2.mysql.database.azure.com -u contosoapp@mytarget2 -p wth <dump_nodata.sql

```

Run script on the target to drop all the foreign keys

drop_fk_query.sql

 SET group_concat_max_len = 8192;
 SELECT GROUP_CONCAT(DropQuery SEPARATOR ';\n') as DropQuery
    FROM
    (SELECT
            KCU.REFERENCED_TABLE_SCHEMA as SchemaName,
            KCU.TABLE_NAME,
            KCU.COLUMN_NAME,
            CONCAT('ALTER TABLE ', KCU.TABLE_NAME, ' DROP FOREIGN KEY ', KCU.CONSTRAINT_NAME) AS DropQuery
            FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU, information_schema.REFERENTIAL_CONSTRAINTS RC
            WHERE
              KCU.CONSTRAINT_NAME = RC.CONSTRAINT_NAME
              AND KCU.REFERENCED_TABLE_SCHEMA = RC.UNIQUE_CONSTRAINT_SCHEMA
          AND KCU.REFERENCED_TABLE_SCHEMA = 'wth') Queries
  GROUP BY SchemaName
  
  Run the script and store the output to a file. Running this the following way requires to format the file again

```shell

 mysql -h mytarget2.mysql.database.azure.com -u contosoapp@mytarget2 -pOCPHack8 wth <drop_fk_query.sql >drop_fk.sql
 cat drop_fk.sql | sed 's/\\n/\n/g' | sed '/DropQuery/d' >drop.sql
 
 ```
 Run the sql script to drop all the FKs
 
 ```sql
 
 source drop.sql
 
 ```
 
 Grant replication client and save to contosoapp user for DMS online migration
 
 ```sql
 
  grant replication slave on *.* to 'contosoapp' ;
  grant replication client on *.* to 'contosoapp' ;
 
 ```
 
 If during the DMS online copy the copy fails with some error message "Migrating data to a mysql other than Azure DB for MySQL is not supported", it is because the
 user connecting to the target database does not have enough privilege on MySQL. The exact and minimum set of privileges is TBD but this works ( screenshot from Mysql workbench ) See this **[Image](./workbench.png)**
 
 
 
 
