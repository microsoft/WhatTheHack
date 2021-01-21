# Challenge 1: Assessment (feature differences and compatibility) 

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-size-analysis.md)

## Introduction

Make sure your database is ready to move

## Description

In this challenge you'll be connecting to your "on-prem" environment using the database tools you installed in the prerequisites. You will take an inventory of the databases that need to be migrated, check the database versions, check the database engine and determine if they are ready to migrate to Azure. 

## Success Criteria

1. You have connected to the "on-prem" databases using the database tools and taken an inventory of the databases - the application database objects, the owner, schema object dependency
1. You have verified that the "on-prem" database versions are supported in Azure DB for PostgreSQL/MySQL
1. You have checked for any other compatibility of the database that needs to resolve before migrating it to Azure

## References

* Check Postgres Version: https://phoenixnap.com/kb/check-postgresql-version#:~:text=Check%20Postgres%20Version%20from%20SQL%20Shell,-The%20version%20number&text=Type%20the%20following%20SQL%20statement,information%20for%20the%20PostgreSQL%20server
* Check MySQL Version: https://phoenixnap.com/kb/how-to-check-mysql-version
* Check MySQL database engine: https://www.a2hosting.com/kb/developer-corner/mysql/working-with-mysql-database-engines
* Limitations in Azure Database for MySQL: https://docs.microsoft.com/en-us/azure/mysql/concepts-limits
* Migrating MySQL On-Premises to Azure Database for MySQL: https://github.com/Azure/azure-mysql/tree/master/MigrationGuide
