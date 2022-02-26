# Challenge 1 -- Data Warehouse Migration

[< Previous Challenge](../Challenge0/readme.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge>](../Challenge2/README.md)

## Introduction

WWI wants to modernize their data warehouse in phases.  The first stage will be to scale-out horizontally their existing data warehouse.  The data warehouse migration will be from their on-premise WWI Data Warehouse to Azure Synapse Analytics.  They like to reuse their existing ETL code and leave their source systems as-is (no migration).  This will require a hybrid architecture for on-premise OLTP and Azure Synapse Analytics as the end state.  This exercise will be showcasing how to migrate your traditional SQL Server (SMP) to Azure Synapse Analytics (MPP).

## Description

The objective of this lab is to migrate the WWI DW (OLAP) to Azure Synapse Analytics.  Azure Synapse Analytics is a MPP (Massive Parallel Processing) platform that allows you to scale out your datawarehouse by adding new server nodes (compute) rather than adding more cores to the server.  

There will be four different object types we'll migrate:

* Database Schemas and Tables
* Database code (Stored Procedure, Function, Triggers, etc)
* SSIS code set refactor (Refactor has been done for you and not part of success criteria of this hack)
* Data migration (with SSIS)

## Success Criteria
1. Migrated all database schemas to Synapse
2. Created one table per schema in Synapse
    - Tables to create are; Dimension.City, Fact.Order & Integration.Order_Staging
    - Coach will provide remaining DDL scripts
3. Refactor one Stored Procedure per design pattern.  Parathensis contains recommended objects
    - Dimension Tables (Integration.MigratedCityData)
    - Fact Table (Appends Only; Integration.MigratedStagedSaleData)
    - Fact Table (Merge; Integration.MigratedStagedMovementData)
    - Coach will share remaining T-SQL Scripts
4. Run SSIS jobs based on new mappings
    - Coach will share DailyETLMDWLC package
    - Review data setup instructions before you execute the SSIS jobs
    - Run end-to-end load in Synapse
5. Run Power BI Report (WWI_Sales.pbit) and share screen shot with coach to confirm success
    - Coach will share pbit file with you

## Stage 1 Architecture
![The Solution diagram is described in the text following this diagram.](../../../images/Challenge1.png)

## Learning Resources

### Overall Migration
1. [SQL Server Database to Azure Synapse Analytics - Data Migration Guide](https://datamigration.microsoft.com/scenario/sql-to-sqldw?step=1)

### Database Schema Migration
1. [Architecture Document of the MPP platform](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/massively-parallel-processing-mpp-architecture)
1. [Distributed Tables](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute)
1. [Distribution Keys](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-overview) 
1. [Distribution Key Best Practices](https://techcommunity.microsoft.com/t5/datacat/choosing-hash-distributed-table-vs-round-robin-distributed-table/ba-p/305247)
1. [Data Types](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-data-types)  A list of unsupported data types at this link.
1. [Table Constraints](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-table-constraints)
1. [Unsupported Table Features](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-overview#unsupported-table-features)
1. [Create Table Syntax](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-table-azure-sql-data-warehouse?view%253Daps-pdw-2016-au7=&view=aps-pdw-2016-au7)
1. [Identity Column](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-identity)
1. [Data Migration Utility](https://www.sqlservercentral.com/articles/azure-dwh-part-11-data-warehouse-migration-utility)
    - Talk with coach for need of tool and trade-offs.  

### Database code rewrite (T-SQL)
1. [Common table Expression (WITH)](https://docs.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql?view=sql-server-ver15#features-and-limitations-of-common-table-expressions-in--and-)
1. [Check your T-SQL for incompatibilies #3](https://www.blue-granite.com/blog/5-important-steps-when-migrating-to-your-scaled-out-data-warehouse)
1. [SQL Differences in T-SQL](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-troubleshoot#differences-from-sql-database)
1. [T-SQL Reference Doc](https://docs.microsoft.com/en-us/sql/t-sql/language-reference?view=sql-server-ver15)

### SSIS Job
1. [Provision SSIS Runtime in Azure](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-deploy-ssis-packages-azure)
1. [Deploy SSIS Package](https://docs.microsoft.com/en-us/sql/integration-services/lift-shift/ssis-azure-deploy-run-monitor-tutorial?view=sql-server-ver15)

### Data Setup in Synapse
For the first time setup only, you will need to execute the "Master Create.sql" script to populate all control tables before you execute the SSIS job.  This is required and it is only done on the initial setup.  After this is complete, you can run the SSIS job.  For all subsequent runs after the initial setup, execute the Reseed ETL Stored Procedure only.  This stored procedure will rollback the database to it's original state.

## Tips
1. Determine your distribution column (HINT IDENTITY Column can not be your distribution key)
1. Run this query to identify which columns are not supported by Azure Synapse Analytics
```
SELECT  t.[name], c.[name], c.[system_type_id], c.[user_type_id], y.[is_user_defined], y.[name]
	FROM sys.tables  t
	JOIN sys.columns c on t.[object_id]    = c.[object_id]
	JOIN sys.types   y on c.[user_type_id] = y.[user_type_id]
	WHERE y.[name] IN ('geography','geometry','hierarchyid','image','text','ntext','sql_variant','timestamp','xml')
	OR  y.[is_user_defined] = 1;
```
1. Review the SSIS jobs that are at this [GitHub repo](https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0) (Daily.ETL.ispac)  This job leverages stored procedures in the Source and Target databases extensively.  This will require a refactoring of the Stored procedures for the OLAP database when you repoint the ETL target to Azure Synapse.
1. For you to work in the SSIS Catalog on your server after setup follow these instructions.  Open SQL Server Management Studio. Connect to the SSISDB database. Select Options to expand the Connect to Server dialog box. In the expanded Connect to Server dialog box, select the Connection Properties tab. In the Connect to database field, select or enter SSISDB.
1. ADF SSIS Runtime is not supported in Azure Synapse Analytics Pipelines.

## Additional Challenges

*Too comfortable?  Eager to do more?  Try these additional challenges!*

1. Setup Virtual Machine to use Self-hosted runtime with proxy in SSIS job.  [Read instructions](https://docs.microsoft.com/en-us/azure/data-factory/self-hosted-integration-runtime-proxy-ssis)
1. [Generate new data and load into Synapase](https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-generate-data?view=sql-server-ver15)