# Challenge 04 - Partitioned Table And Clustered Columnstore Indexes - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

In this challenge you will dig into table partitioning strategy and its impact on performance.
You will also get a deeper understanding about Columnstore Indexes behavior

**Learning objectives:**
- How partitioning affects performance
- Columnstore Indexes health

**Condition of success**
- Understand when partitions could be helpful and when not 
- Deep understanding in Columnstore Index health and how they heavily affect performance
- Beeing able to identify unhealthy Columnstore indexes


## Table Partitioning – Clustered columnstore health check

Users partitioned the FactInternetSales table by [OrderDateKey] column and are now complaining about performance when running a simple query against it. If they run the same query against the old table (not partitioned), performance is good.

Not enought records to benefith from Partitioning and CCI index

- [Partitioning tables in dedicated SQL pool](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-partition)
- [Best practices for dedicated SQL pools](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-dedicated-sql-pool#do-not-over-partition)
- Is the Columnstore index in good shape ?
- [Indexing tables - Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-index)

- Open [C4_1_Partitioning_CCI.sql](./Solutions/Challenge04/C4_1_Partitioning_CCI.sql) and follow provided steps and instructions to clarify why partitioning is not a good idea for the query.
