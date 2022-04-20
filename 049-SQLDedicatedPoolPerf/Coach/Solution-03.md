# Challenge 03 - Queries Behavior - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

In this challenge you will troubleshoot queries in stuck, not running queries and will optimize query executions.

**Learning objectives:**
- Understand locking behavior 
- Understand concurrency behavior
- Optimize query with result set caching and materialized views


**Condition of success**
- Understanding locking behavior and transactions in Dedicated Sql Pool 
- Recognize if a query is blocked by other transaction or due to a lack in system resources
- Manage Result Set Cache and Materialized view to improve performance


## Concurrent writings

An user is complaining his workload (UPDATE  T-SQL command) is running forever, never completes. It usually takes few minutes to get completed.

Blocking issue due to Exclusive Lock on the used table

- [Transactions (Azure Synapse Analytics)](https://docs.microsoft.com/en-us/sql/t-sql/language-elements/transactions-sql-data-warehouse?view=aps-pdw-2016-au7)
- [Who is blocking me ?](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/who-is-blocking-me/ba-p/1431932)


- Execute [C3_A_Simulate_Writings.ps1](./Solutions/Challenge03/C3_A_Simulate_Writings.ps1) powershell script, provide required parameters and wait for completion. **Do not close the powershell session until you complete the excercise**
- Open [C3_1_Blocking.sql](./Solutions/Challenge03/C3_1_Blocking.sql) and follow provided steps and instructions to clarify how writings work. 

## Concurrency limits

**Before run this excercise please scale your DWH to DW100c.**

Many users are complaining their reporting queries (very simple SELECT T-SQL command) are not completing in the expected period. 

DW100c allows up to 4 concurrent queries. The powershell script will run 4 concurrent queries, 5th will be queued.

- [Memory and concurrency limits](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/memory-concurrency-limits)


- Execute [C3_B_Simulate_ Queries.ps1](./Solutions/Challenge03/C3_A_Simulate_Writings.ps1) powershell script and provide required parameters. **Do not close the powershell session until you complete the excercise**
- Open and execute [C3_2_Concurrency.sql](./Solutions/Challenge03/C3_2_Concurrency.sql) and follow provided steps and instructions to demonstrate how concurrency works. 
  


## Result set cache and Materialized Views#

Users are running the same reporting query multiple time per day and each execution take a while.
Tables are well distributed, query is using compatible join and is not wasting resources.

To speed it up you can use Result_Set_Caching or Materialized views

- [Performance tuning with result set caching](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-result-set-caching) 
- [Performance tune with materialized views](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-materialized-views)


- Open [C3_3_Result_Set_Cache_Materialized_View.sql](./Solutions/Challenge03/C3_3_Result_Set_Cache_Materialized_View.sql) and follow provided steps and instructions to demonstrate how Cache and Materialized Views work. 
    