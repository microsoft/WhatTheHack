# Challenge 1: Assessment 

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-size-analysis.md)

## Introduction

Make sure your database is ready to move

## Description

In this challenge you'll be connecting to your "on-prem" environment using the database tools you installed in the prerequisites. You will take an inventory of the databases that need to be migrated, check the database versions, check the database engine and determine if they are ready to migrate to Azure. You can use either the GUI or CLI tools mentioned in the [Prerequisites](./00-prereqs.md) to get this information. Note: for Oracle, do not use ora2pg for this challenge. You will do use it later. 

## Success Criteria

* You have connected to the "on-prem" databases using the database tools and taken an inventory of the databases such as the database version, size, schema objects, dependency between schema objects.
* You have verified that the "on-prem" database versions and size are supported in Azure DB for PostgreSQL/MySQL.
* You have checked for any other database compatibility issues that need to be resolved before migrating it to Azure. For specific compatibilty issues, refer to the Limitations pages below.

## References

* [Limitations in Azure Database for MySQL](https://docs.microsoft.com/en-us/azure/mysql/concepts-limits)
* [Migrating MySQL On-Premises to Azure Database for MySQL](https://github.com/Azure/azure-mysql/tree/master/MigrationGuide)
* [Limitations in Azure Database for Postgres](https://docs.microsoft.com/en-us/azure/postgresql/concepts-limits)
* [Migrate Oracle to Azure Database for Postgres](https://docs.microsoft.com/en-us/azure/postgresql/howto-migrate-from-oracle)
* [White Paper: Oracle to Azure Database for Postgres migration guide](https://github.com/microsoft/OrcasNinjaTeam/blob/master/Oracle%20to%20PostgreSQL%20Migration%20Guide/Oracle%20to%20Azure%20Database%20for%20PostgreSQL%20Migration%20Guide.pdf)
