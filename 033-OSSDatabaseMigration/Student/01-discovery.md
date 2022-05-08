# Challenge 1: Discovery and Assessment

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-offline-migration.md)

## Introduction

Discover and assess aspects of the database environment that you will be migrating. You will also deploy an Azure DB for MySQL and/or PostgreSQL. 

## Description

In this challenge you will be connecting to your "on-prem" environment using the database tools you installed in the prerequisites. You will take an inventory of the database(s) that need to be migrated, check the database versions, check the database engine and determine if they are ready to migrate to Azure. You can use either the GUI or CLI tools mentioned in the [Prerequisites](./00-prereqs.md) to get this information. In an actual migration you would need to determine CPU/memory and I/O requirements as well. However, since this is not a production environment you will instead select either the default configuration for Azure DB for Postgres/MySQL Single Server (4 cores/100GB) or use the Production (Small/Medium-size) option for Workload type for Azure DB for Postgres/MySQL Flexible Server. 

## Success Criteria

* You have connected to the "on-prem" databases using the database tools and taken an inventory of the databases such as the database version, size, schema objects, and dependencies between schema objects.
* You have verified that the "on-prem" database versions and size are supported in Azure DB for PostgreSQL/MySQL.
* You have checked for any other database compatibility issues that need to be resolved before migrating it to Azure. For specific compatibilty issues, refer to the Limitations pages below.
* You have selected the appropriate database service tier (e.g. General Purpose or Memory Optimized) and can explain to your coach when to use which service tier
* You can explain to your coach the different database deployment option (Single Server/Flexible Server and HyperScale (PostgreSQL only))
* You have deployed Azure DB for Postgres and/or Azure DB for MySQL with the appropriate options

## Hints

* For Oracle you can use either GUI/CLI database tools or ora2pg to get the information requested. There is already an ora2pg container deployed in your environment that you can use. 


## References

* [Limitations in Azure Database for MySQL](https://docs.microsoft.com/en-us/azure/mysql/concepts-limits)
* [Migrating MySQL On-Premises to Azure Database for MySQL](https://github.com/Azure/azure-mysql/tree/master/MigrationGuide)
* [Limitations in Azure Database for Postgres](https://docs.microsoft.com/en-us/azure/postgresql/concepts-limits)
* [Migrate Oracle to Azure Database for Postgres](https://docs.microsoft.com/en-us/azure/postgresql/howto-migrate-from-oracle)
* [White Paper: Oracle to Azure Database for Postgres migration guide](https://github.com/microsoft/OrcasNinjaTeam/blob/master/Oracle%20to%20PostgreSQL%20Migration%20Guide/Oracle%20to%20Azure%20Database%20for%20PostgreSQL%20Migration%20Guide.pdf)
* [Choose the right MySQL Server option in Azure](https://docs.microsoft.com/en-us/azure/mysql/select-right-deployment-type)
* [Pricing tiers in Azure Database for PostgreSQL - Single Server](https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers)
* [Azure Database for PostgreSQL pricing](https://azure.microsoft.com/en-us/pricing/details/postgresql/flexible-server/)
* [Create an Azure Database for MySQL server](https://docs.microsoft.com/en-us/azure/mysql/quickstart-create-mysql-server-database-using-azure-portal)
* [Create an Azure Database for PostgreSQL server](https://docs.microsoft.com/en-us/azure/postgresql/quickstart-create-server-database-portal)
* [Firewall rules in Azure Database for PostgreSQL - Single Server](https://docs.microsoft.com/en-us/azure/postgresql/concepts-firewall-rules)
* [Firewall rules in Azure Database for MySQL](https://docs.microsoft.com/en-us/azure/mysql/concepts-firewall-rules)

