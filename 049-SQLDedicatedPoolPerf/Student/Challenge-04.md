# Challenge 04 - Partitioned Table And Clustered Columnstore Indexes

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Pre-requisites
- You have to complete **Challenge 03 - Queries behavior**

## Introduction

Users partitioned the FactInternetSales table by [OrderDateKey] column and are now complaining about performance running a simple query against it. 
If they run the same query against the old table (not partitioned), performance is good.

You can find all the files for this challnge into the Zip file provided by your coach at this path: _./Resources/Challenge-04/_ 

## Description

**Learning objectives:**
- How partitioning affects performance
- Columnstore Indexes health

### Table Partitioning – Clustered columnstore health check

Investigate why query against partitioned table is slower than the original one and fix it. 
- Open [C4_1_Partitioning_CCI.sql](./Resources/Challenge-04/C4_1_Partitioning_CCI.sql?raw=true) and identify why the partitioned table is so slow
  - Is the partitioning affecting the Columnstore health ?
  - Is the Columnstore index in good shape ?

## Success Criteria

- Understand when partitions could be helpful and when not 
- Deep understanding in Columnstore Index health and how they heavily affect performance
- Beeing able to identify unhealthy Columnstore indexes

## Learning Resources
- [Partitioning tables in dedicated SQL pool](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-partition)
- [Best practices for dedicated SQL pools](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-dedicated-sql-pool#do-not-over-partition)
- [Indexing tables - Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-index)