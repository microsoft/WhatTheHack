# Challenge 3: Offline Cutover and Validation

[< Previous Challenge](./02-offline-migration.md) - **[Home](./README.md)** - [Next Challenge >](./04-online-migration.md)

## Coach Tips

* If using MySQL Workbench tool to migrate mysql database, make sure to use the "MySQL Workbench Migration Wizard". This is available under the "home icon" as shown [here](./mysql_workbench_migration_wizard.jpg) 

* This is the SQL command to change the ingredient table value for MySQL

* The attendees can get example JDBC connection strings from the Azure portal for the Azure DB database under Settings. 

```sql

use wth ;
update ingredient set name = 'Shallot' where name = 'Onion' ;

```

* This is the SQL command to change the ingredient table value for PostgreSQL

```sql

\c wth 
update ingredient set name = 'Shallot' where name = 'Onion' ;


```
