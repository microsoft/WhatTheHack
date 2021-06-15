# Challenge 5: Log Analytics Query

[Previous Challenge](./04-Azure-Monitor-For-Containers.md) - **[Home](../README.md)** - [Next Challenge>](./06-Optional-Logs.md)

## Introduction
Azure Monitor Logs is based on Azure Data Explorer, and log queries are written using the same Kusto query language (KQL). This is a rich language designed to be easy to read and author, so you should be able to start writing queries with some basic guidance.

## Description

Write a performance query that renders a time chart for the last 4 hours for both of the Web Servers and the SQL Server for the following perf metrics. Save each query to your favorites.
* Processor Utilization: Processor / % Processor Time
* Memory Utilization: Memory / % Committed Bytes In Use
* Disk Utilization (IO): Disk Reads/sec and Disk Writes/sec
* Disk Utilisation (MB/GB): Disk Free Space (% or MB)
* Create a heartbeat query for Web Servers and SQL Server
* Write a performance query that renders a time chart for the last hour of the max percentage CPU usage of the AKS Cluster nodes

## Success Criteria
Queries return data to match challenge

## Learning Resources
* [Log queries in Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview)
* [Overview of queries](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/)
* [Query best practises](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/best-practices)
* [Query operators](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/queries)
