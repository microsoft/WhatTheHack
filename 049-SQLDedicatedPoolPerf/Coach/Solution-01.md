# Challenge 01 - Ingest Data From Blob Storage - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-02.md)

# Notes & Guidance

In this challenge you will import several parquet files from Blob Storage into your Datawarehouse and then you will move data from staging area to the production one. 

Here the proposed DB [database diagram](./Solutions/DedicatedSqlPool-TablesRelationships.pdf).

**Learning objectives:**
    - Get understanding about tables architecture in Dedicated Sql Pool 
    - Distributed
    - Round Robin
    - Replicated
    - How to identify Data Skew and how to fix it	

**Condition of success**
- Identify the best design for Staging tables to improve performance during load
- Identify all the methods you can use to load data from Blob storage 
- Identify the best design distribution method for production tables 
- Identify Data Skew and fix it

## Ingest Data from Azure Data Lake Gen2 – Blob container

We do not want attendees waste time producing basic T-SQL code. Let them dig into table's architecture and geometry/storage and then encourage discussions about MPP tables and indexes design.
Once all attendees agree and understand why Round Robin/Heap is a good option for staging tables, and once they understood COPY INTO syntax, share with them the solution script (COPY INTO portion), this can save time since they should manually prepare more than 20 COPY INTO commands. (1 for each staging table)

  - [Distributed tables design guidance](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute)
  - [Design guidance for replicated tables](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/design-guidance-for-replicated-tables)
  - [COPY INTO (Transact-SQL) - (Azure Synapse Analytics)](https://docs.microsoft.com/en-us/sql/t-sql/statements/copy-into-transact-sql?view=azure-sqldw-latest)
  - [Authentication mechanisms with the COPY statement](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/quickstart-bulk-load-copy-tsql-examples)
  - [Quickstart: Bulk load data using a single T-SQL statement](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/quickstart-bulk-load-copy-tsql)
  - [Design a PolyBase data loading strategy for dedicated SQL pool](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/load-data-overview#4-load-the-data-into-dedicated-sql-pool-staging-tables-using-polybase)

Open [C1_1_Import_into_staging_tables.sql](./Solutions/Challenge01/C1_1_Import_into_staging_tables_Public_Blob.sql) and follow provided steps and instructions. 
Show attendee how to:
-   Create Round Robin / Heap tables
-   Ingest data from ADSL Gen 2 Blob storage using Copy Into command 

## Move data from staging area to production tables

Optimize each table structure considering whether it is a “dimension” or a “fact” table. 
Production tables should belong to “Sales” schema. Check the provided [Database diagram](./Solutions/DedicatedSqlPool-TablesRelationships.pdf) to identify relationships between tables and decide which is the proper distribution method and distribution column. 
Choose the proper one to guarantee an even distribution of data across all distributions. In order to move data from staging to production area they can use CTAS

It can be a time consuming task, once they understood how to use CTAS and how to choose the proper distribution column provide them the T-SQL code to speed up the completion.

  - [CREATE TABLE AS SELECT (CTAS)](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-develop-ctas)
  - [Distributed tables design guidance](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute)
  - [Design guidance for replicated tables](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/design-guidance-for-replicated-tables)

Open [C1_2_Create_Actual_Tables.sql](./Solutions/Challenge01/C1_2_Create_Actual_Tables.sql) and follow provided steps and instructions. 

## Investigate slowness due to data skew

A query is taking too much to complete and attendees have tofix the issue. 
This is due to data skew.

Sales.FactSales has been distributed using RevisionNumber column which contains only 1 distinct value instead of the CustomerKey column with more than 2500 distinct values and used in the group by clause.

- Open folder [C1_3_Check_and_Fix_Table_Skew.sql](./Solutions/Challenge01/C1_3_Check_and_Fix_Table_Skew.sql) and follow provided steps and instructions. 

