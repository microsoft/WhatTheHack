# Challenge 05 - Monitoring workload - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)**

## Notes & Guidance

In this challenge you will understand how to monitor your workload to identify poor performing and  failed queries 

**Learning objectives:**
- How to monitor workload with T-SQL DMVs
- Store and query historical data using Azure Monitor

**Condition of success**
- Understand how DMVs works in Dedicated Sql pool and their persistence.
- Being able to leverage Log Analytics to export DMVs data and store them for more than 1 month for delayed troubleshooting.

## Monitor Dedicated SQL pool using T-SQL ##

Create a set of T-SQL commands to get information about requests, steps and errors. Yet, write a query to identify skewed tables.

- [sys.dm_pdw_exec_requests (Transact-SQL)](https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-exec-requests-transact-sql?view=aps-pdw-2016-au7)
- [sys.dm_pdw_request_steps (Transact-SQL)](https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-request-steps-transact-sql?view=aps-pdw-2016-au7)
- Get the error description for all the Failed queries
- [sys.dm_pdw_errors (Transact-SQL)](https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-errors-transact-sql?view=aps-pdw-2016-au7)
- Identify Skewed tables
- [Designing tables - Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-overview#table-size-queries)

- Open [C5_1_Basic_Monitoring_Dmvs.sql](./Solutions/Challenge05/C5_1_Basic_Monitoring_Dmvs.sql) and follow provided steps and instructions to clarify how Dmvs work.


## Log Analytic - Diagnostics ##

Configure Log Analytics and activate Diagnostic logs for [queries], [steps] and [waits] for your Dedicated SQL pool

Show attendess how to configure retention period, then query Log-analytics to get most recent requests

- [Create diagnostic settings to send Azure Monitor platform metrics and logs to different destinations](https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings?WT.mc_id=Portal-Microsoft_Azure_Monitoring&tabs=CMD)
- [Designing your Azure Monitor Logs deployment](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/design-logs-deployment)
- [Configure Retention period](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/data-retention-archive?tabs=api-1%2Capi-2)
- [Monitor your Dedicated SQL Pool](https://docs.microsoft.com/en-us/azure/synapse-analytics/monitoring/how-to-monitor-using-azure-monitor#:~:text=Configure%20diagnostic%20settings%201%20In%20the%20portal%2C%20go,prompted%20to%20create%20a%20setting.%20...%20See%20More)
- [AzureDiagnostics](https://docs.microsoft.com/en-us/azure/azure-monitor/reference/tables/azurediagnostics)


If you're using Dedicated SQL Pool (formerly SQL DW) use this queries:
```
//Getting all queries using the same table
AzureDiagnostics 
| where Category == "ExecRequests" and Label_s != "health_checker"
| where Command_s contains "FactInternetSales" 
| order by StartTime_t desc 

//getting queries with specific Label
AzureDiagnostics 
| where Category == "ExecRequests" and Label_s != "health_checker"
| where Label_s == "Not Partitioned Table"
| order by StartTime_t desc 

//getting overlapping queries
AzureDiagnostics 
| where Category == "ExecRequests" and Label_s != "health_checker"
| where Status_s in("Running","Suspended")
| order by StartTime_t desc 

```

If you're using Dedicated SQL Pool within a Synapse workspace:

```

//Getting all queries using the same table
SynapseSqlPoolExecRequests
| where Label != "health_checker"
| where Command contains "FactInternetSales"
| order by TimeGenerated desc

//getting queries with specific Label
SynapseSqlPoolExecRequests
| where Label == "Not Partitioned Table"
| order by TimeGenerated desc

//getting overlapping queries
SynapseSqlPoolExecRequests
| where Status in("Running","Suspended")
| order by StartTime desc 

```

