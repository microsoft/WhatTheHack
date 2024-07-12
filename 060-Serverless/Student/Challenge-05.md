# Challenge 5 - Monitoring Serverless with DMVs

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)**

## Pre-requisites

- Relevant permissions according to the documentation: [Azure Synapse RBAC roles - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/security/synapse-workspace-synapse-rbac-roles)
  
# Introduction:
In this challenge you will check the DMVs available to monitor SQL Serverless workload inside of the Synapse.


**Learning objectives:**
- Understand how to monitor serverless workload using the DMVs available 

**Run Workload**

Open in the proper order all the [C5_small_query_*.sql](./Resources/Challenge-05/) and ran them. 
[TIP]]Open the scripts in different Sessions, the idea is create a small workload.

**Queries and DMVs**

 You need to explore the content of all date_DW_Delta*" folders using T-SQL query:

1. Replace the storage and container details according to your configuration on :C5_small_query_*
2. Run the scripts C5_small_query_* at the same time on Synapse Studio or SSMS
3. Once you start this sample workload, run the C5_Monitoring.sql and review the different outputs for monitoring and troubleshooting.

**DMVs to monitor the workload**

Looking over the DMVs while you have your workload running allows you to understand if it could possibly be problems with excess of open sessions, or blockings, queries that are taking too long to execute. 


> [!TIP] 

>  Beside that you can also use Synapse Studio > Monitoring > Activities > SQL requests  to check the queries that were executing in a period of time


## Success Criteria

- Understand how you can monitor SQL Serverless Synapse Workload using DMVs
- Be able to look over the DMVs and find things like: waits, query execution time, open sessions etc.

## Learning Resources

[How to use OPENROWSET using serverless SQL pool in Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-openrowset)

[Full script with a solution for monitoring by Jovan Popovic](https://github.com/JocaPC/qpi/blob/master/src/qpi.sql)

[Troubleshooting SQL On-demand or Serverless DMVs - Microsoft Tech Community](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/troubleshooting-sql-on-demand-or-serverless-dmvs/ba-p/1955869)

