# Challenge 03 - Queries Behavior

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Pre-requisites
- You have to complete **Challenge 02 - Queries best practice**

## Introduction

In this challenge you will troubleshoot queries in stuck, not running queries and will optimize query executions.

You can find all the files for this challnge into the Zip file provided by your coach at this path: _./Resources/Challenge-03/_ 

## Description

**Learning objectives:**
- Understand locking behavior 
- Understand concurrency behavior
- Optimize query with result set caching and materialized views

### Concurrent writings

An user is complaining his workload (an UPDATE  T-SQL command) is running forever, never completes. It usually takes few minutes to get completed.
Investigate why the transaction is not completing in the expected timeframe and fix it
- Execute [C3_A_Simulate_Writings.ps1](./Resources/Challenge-03/C3_A_Simulate_Writings.ps1?raw=true) powershell script available at this path **./Resources/Challenge-03/C3_A_Simulate_Writings.ps1** provide required parameters and wait for completion. **Do not close the powershell session until you complete the excercise**
- Open [C3_1_Blocking.sql](./Resources/Challenge-03/C3_1_Blocking.sql?raw=true) using your preferred editor, run the batch and explain why it never completes.
  - Can you identify why your query never completes ?

### Concurrency limits

_Before run this excercise please scale your DWH to DW100c using the Azure Portal._ 

Many users are complaining their reporting queries (very simple SELECT T-SQL command) are not completing in the expected period. 
Investigate why their SELECT commands are taking so long and fix it.
  - Execute [C3_B_Simulate_ Queries.ps1](./Resources/Challenge-03/C3_B_Simulate_Queries.ps1?raw=true) powershell script available at this path **./Resources/Challenge-03/C3_B_Simulate_ Queries.ps1**"_ and provide required parameters. **Do not close the powershell session until you complete the excercise**
  - Open and execute [C3_2_Concurrency.sql](./Resources/Challenge-03/C3_2_Concurrency.sql?raw=true) using your preferred editor and identify why it is taking so long to complete.
    - Can you explain why the query is in stuck and fix it ?
  - Once you completed this exercise, in case of need, execute [C3_C_Force_Stop_Queries.ps1](./Resources/Challenge-03/C3_C_Force_Stop_Queries.ps1?raw=true) available at this path **./Resources/Challenge-03/C3_C_Force_Stop_Queries.ps1** to kill all executions.

### Result set cache and Materialized Views

Users are running the same reporting query multiple time per day and each execution take a while.
Tables are well distributed, query is using compatible join and is not wasting resources.
Is there a way to speed-up the execution ?
  - Open [C3_3_Result_Set_Cache_Materialized_View.sql](./Resources/Challenge-03/C3_3_Result_Set_Cache_Materialized_View.sql?raw=true) and try to optimize further the proposed query.
    - Is there a feature you could leverage on to make the query faster ?
    - And what if the resultset is bigger than 10 GB ? Is there something you can leverage on further ?

## Success Criteria

- Understanding locking behavior and transactions in Dedicated Sql Pool 
- Recognize if a query is blocked by other transaction or due to a lack in system resources
- Manage Result Set Cache and Materialized view to improve performance

## Learning Resources

- [Transactions (Azure Synapse Analytics)](https://docs.microsoft.com/en-us/sql/t-sql/language-elements/transactions-sql-data-warehouse?view=aps-pdw-2016-au7)
- [Who is blocking me ?](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/who-is-blocking-me/ba-p/1431932)
- [Memory and concurrency limits](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/memory-concurrency-limits)
- [Performance tuning with result set caching](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-result-set-caching) 
- [Performance tune with materialized views](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-materialized-views)
