# Challenge 4: Offline Cutover and Validation

[< Previous Challenge](./03-offline-migration.md) - **[Home](./README.md)** - [Next Challenge >](./05-online-migration.md)

## Coach Tips

* If using MySQL Workbench tool to migrate mysql database, make sure to use the "MySQL Workbench Migration Wizard". This is available under the "home icon" as shown [here](./mysql_workbench_migration_wizard.jpg) 

* This is the SQL command to change the ingredient table value for MySQL

```sql

use wth ;
update ingredient set name = 'Shallot' where name = 'Onion' ;

```

* This is the SQL command to change the ingredient table value for PostgreSQL

```sql

\c wth 
update ingredient set name = 'Shallot' where name = 'Onion' ;


```
