# Challenge 01 - Ingest Data From Blob Storage

**[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Pre-requisites
- Your own Azure subscription with Owner access
- An already in-place [Dedicated SQL pool](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/create-data-warehouse-portal#:~:text=Create%20a%20SQL%20pool%201%20Select%20Create%20a,Notifications%20to%20monitor%20the%20deployment%20process.%20See%20More.). **Configure it using SLO = DW500c**
- Your choice of database management tool:
  - [SQL Server Management Studio (SSMS) (Windows)](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
  - [Azure Data Studio (Windows, Mac OS, and Linux)](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15)

## Introduction

In this challenge you will import several parquet files from Blob Storage into your data warehouse and then you will move data from staging area to the production one. 

You can find all the files for this challnge into the Zip file provided by your coach at this path: _./Resources/Challenge-01/_ 

## Description

**Learning objectives:**
- Get understanding about tables architecture in Dedicated Sql Pool
- Distributed
- Round Robin
- Replicated
- How to identify Data Skew and how to fix it

### Ingest Data from Azure Data Lake Gen2 – Blob container

Define staging tables architecture, then import all parquet files using the link your coach will provide you.
Data should land in a staging area (schema “Staging”) optimized to ingest data at maximum speed using the “COPY INTO” T-SQL command.

- Open [C1_1_Import_into_staging_tables.sql](./Resources/Challenge-01/C1_1_Import_into_staging_tables.sql?raw=true) 
  - Complete the provided T-SQL code to create the staging tables by choosing the proper structure and storage. 
  - Import data from Parquet files into Staging tables using the suggested COPY INTO T-SQL command
  
### Move data from staging area to production tables

Optimize each table structure considering whether it is a “dimension” or a “fact” table. Production tables should belong to “Sales” schema. Check the Database diagram [(Download available here)](./Resources/DedicatedSqlPool-TablesRelationships.pdf?raw=true) to identify relationships between tables and decide which is the proper distribution method. Consider also tables will be queried by filtering using the CustomerKey, ProductionKey, DataKey columns. Choose the proper one to guarantee an even distribution of data across all distributions. Use the suggested “CREATE TABLE AS” T-SQL command.

- Open [C1_2_Create_Actual_Tables.sql](./Resources/Challenge-01/C1_2_Create_Actual_Tables.sql?raw=true) and complete T-SQL code to move data from staging to production tables, distributing data using the most efficient method considering tables relations as described in the database diagram [(Download available here)](./Resources/DedicatedSqlPool-TablesRelationships.pdf?raw=true).
  - Are Dimension tables (DimAccount, DimCustomer etc...) good candidates to be replicated ?
  - Most of your queries will join tables using CustomerKey, ProductKey, CurrencyKey and FinanceKey fields. Choose the most selective column
  - Example: Check FactInternetSales table: Is it better to distribute it using CustomerKey or ProductKey column ?
  
### Investigate slowness due to data skew

Users are complaining that a query is taking too much to complete and need your assistance to fix the issue. Investigate why the query is so slow and make it faster.
- Open folder [C1_3_Check_and_Fix_Table_Skew.sql](./Resources/Challenge-01/C1_3_Check_and_Fix_Table_Skew.sql?raw=true) and investigate the issue using the suggested set of T-SQL commands, then fix the issue.
  - Check for table skew
  - Is the distribution column for the FactSales table good enough ?
 

## Success Criteria

- Identify the best design for Staging tables to improve performance during load
- Verify all the methods you can use to load data from Blob storage 
- Choose the best design (distribution method) for production tables 
- Check Data Skew and fix it

## Learning Resources

- [Distributed tables design guidance](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute)
- [Design guidance for replicated tables](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/design-guidance-for-replicated-tables)
- [COPY INTO (Transact-SQL) - (Azure Synapse Analytics)](https://docs.microsoft.com/en-us/sql/t-sql/statements/copy-into-transact-sql?view=azure-sqldw-latest)
- [Authentication mechanisms with the COPY statement](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/quickstart-bulk-load-copy-tsql-examples)
- [Quickstart: Bulk load data using a single T-SQL statement](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/quickstart-bulk-load-copy-tsql)
- [Design a PolyBase data loading strategy for dedicated SQL pool](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/load-data-overview#4-load-the-data-into-dedicated-sql-pool-staging-tables-using-polybase)
- [CREATE TABLE AS SELECT (CTAS)](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-develop-ctas)
- [Distributed tables design guidance](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute)
- [Design guidance for replicated tables](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/design-guidance-for-replicated-tables)
- [Distributed tables design guidance - Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute#how-to-tell-if-your-distribution-column-is-a-good-choice)

