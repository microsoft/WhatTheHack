# Challenge 02 - Queries Best Practice - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

In this challenge you will dig into best practices you have to consider writing query for your data warehouse.

**Learning objectives:**
- The importance of Statistics
- How to Join distributed/replicated tables
  - Incompatible and compatible Join

**Condition of success**
- Deep understanding about Table Statistics
- Understand how to identify columns to use with statistics
- Recognize if a given query is using unnecessary data movement due to incompatible joins and how to fix it 


## Auto Create Statistics

Users are complaining that after importing data into a production table using CTAS the first reporting query involving it is always slow. Subsequent queries are usually faster and with good performance.
Investigate why the first execution is taking longer than usual.

Auto Create statistics task is triggered and it takes a while to complete.

- [Create and update statistics using Azure Synapse SQL resources](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics)

- Open [C2_1_Statistics.sql](./Solutions/Challenge02/C2_1_Statistics.sql) and follow provided steps and instructions to demonstrate ho auto Create statistics works. 


## Replicated Tables

Despite the query is leveraging multiple Replicated Table users are complaining about poor performance and they noticed some potentially un-necessary data movement. 

Replicate table cache is not ready

- [Design guidance for replicated tables](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/design-guidance-for-replicated-tables)

- Open [C2_2_Replicated_Tables_and_Join.sql](./Solutions/Challenge02/C2_2_Replicated_Tables_and_Join.sql) and follow provided steps and instructions to demonstrate how replicate table works. 
 

## Incompatible vs Compatible joins

Users are complaining an important query is taking much more than expected to complete and ask for your help. 

Incompatible join, Sales.FactInternetSales has been distibuited using a column which is not good for the query

- [How to minimize data movements (Compatible and Incompatible Joins)](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/how-to-minimize-data-movements-compatible-and-incompatible-joins/ba-p/1807104)

- Open [C2_2_Incompatible_Join.sql](./Solutions/Challenge02/C2_3_Incompatible_Join.sql) and follow provided steps and instructions to fix the slowness due to incompatible join. 
 
