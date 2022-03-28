# Challenge 01 - SQLDedicatedPoolPerf - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-02.md)

# Notes & Guidance
[Database diagram](./Solutions/DedicatedSqlPool-TablesRelationships.pdf)

## Ingest Data from Azure Data Lake Gen2 – Blob container

We do not want attendees waste time producing basic T-SQL code. Encourage discussions about MPP tables and indexes design.
Once all attendees agree and understand why Round Robin/Heap is a good option for staging tables, once they, and once is it clear they understood COPY INTO syntax, share with them the solution script, this can save time since they should manually prepare more than 20 COPY INTO commands. (one for each staging table)

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

Optimize each table structure considering whether it is a “dimension” or a “fact” table. Production tables should belong to “Sales” schema. Check the provided [Database diagram](./Solutions/DedicatedSqlPool-TablesRelationships.pdf) to identify relationships between tables and decide which is the proper distribution method. 
Choose the proper one to guarantee an even distribution of data across all distributions. In order to move data from staging to production area they can use CTAS

  - [CREATE TABLE AS SELECT (CTAS)](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-develop-ctas)
  - [Distributed tables design guidance](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute)
  - [Design guidance for replicated tables](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/design-guidance-for-replicated-tables)

Open [C1_2_Create_Actual_Tables.sql](./Solutions/Challenge01/C1_2_Create_Actual_Tables.sql) and follow provided steps and instructions. 