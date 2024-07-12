# Challenge 5  - Monitoring Serverless with DMVs.

[< Previous Solution](./Solution-04.md) - **[Home](../README.md)** 

## Notes & Guidance

In this challenge you will check the DMVs available to monitor SQL Serverless workload inside of the Synapse.

**Learning objectives:**

- Understand how to monitor serverless workload using the DMVs available 

**Condition of success:**
- Understand how you can monitor SQL Serverless Synapse Workload using DMVs
- Be able to look over the DMVs and find things like: waits, query execution time, open sessions etc.
  

**Run Workload**

Open in the proper order all the [C5_small_query_*.sql](./solutions/Challenge05/) and ran them. 
[TIP]]Open the scripts in different Sessions, the idea is create a small workload.

Open [C5_Monitoring.sql](./solutions/Challenge05/C5_Monitoring.sql). Show attendee how to: 

Run the DMVs one by one and discuss the results with the attendees

## Learning Resources

[Full script with a solution for monitoring by Jovan Popovic](https://github.com/JocaPC/qpi/blob/master/src/qpi.sql)  
[Troubleshooting SQL On-demand or Serverless DMVs - Microsoft Tech Community](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/troubleshooting-sql-on-demand-or-serverless-dmvs/ba-p/1955869)  