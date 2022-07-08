# Challenge 05 - Monitoring Workload

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)**

## Pre-requisites
- You have to complete **Challenge 04 - Partitioned table and Clustered Columnstore Indexes**

## Introduction

In this challenge you will understand how to monitor your workload to identify poor performing and failed queries using T-SQL DMVs and Azure Monitor

You can find all the files for this challnge into the Zip file provided by your coach at this path: _./Resources/Challenge-05/_ 

## Description

**Learning objectives:**
- How to monitor workload with T-SQL DMVs
- Store and query historical data using Azure Monitor

### Monitor Dedicated SQL pool using T-SQL

Create a set of T-SQL commands to get information about:
- Top 10 Slowest queries and their steps
- Errors occurred during the last 24 hours
- Tables size 


### Monitor Dedicated SQL pool using Log Analytic - Diagnostics

- Configure Log Analytics and activate Diagnostic logs for [queries], [steps] and [waits] for your Dedicated SQL pool
- Configure Diagnostic settings and configure data retention to ensure at least 2 months for delayed troubleshooting. 

## Success Criteria

- Understand how DMVs works in Dedicated Sql pool and their persistence.
- Being able to leverage Log Analytics to export DMVs data and store them for more than 1 month for delayed troubleshooting.


## Learning Resources

- [sys.dm_pdw_exec_requests (Transact-SQL)](https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-exec-requests-transact-sql?view=aps-pdw-2016-au7)
- [sys.dm_pdw_request_steps (Transact-SQL)](https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-request-steps-transact-sql?view=aps-pdw-2016-au7)
- [sys.dm_pdw_errors (Transact-SQL)](https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-errors-transact-sql?view=aps-pdw-2016-au7)
- [Designing tables - Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-overview#table-size-queries)
- [Create diagnostic settings to send Azure Monitor platform metrics and logs to different destinations](https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings?WT.mc_id=Portal-Microsoft_Azure_Monitoring&tabs=CMD)
- [Designing your Azure Monitor Logs deployment](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/design-logs-deployment)
