# Challenge 06 - Log Queries with Kusto Query Language (KQL)

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction

Understand the Kusto Query Language (KQL) write and save queries, which we can run on our Log Analytics Workspace

## Description

Write a performance query that renders a time chart for the last 4 hours for both of the Web Servers and the SQL Server for the following perf metrics. Save each query to your favorites.
* Processor Utilization: Processor / % Processor Time
* Memory Utilization: Memory / % Committed Bytes In Use
* Disk Utilization (IO): Disk Reads/sec and Disk Writes/sec
* Disk Utilisation (MB/GB): Disk Free Space (% or MB)
* Create a heartbeat query for Web Servers and SQL Server
* Write a performance query that renders a time chart for the last hour of the max percentage CPU usage of the AKS Cluster nodes
- Combine infrastructure and application logs to create a single timeseries chart that includes:
  - CPU usage from the node in your AKS cluster hosting the eshoponweb app
  - Duration of page views on your eshoponweb app hosted on the cluster
  - Save each query to your favorites.
* Deploy Grafana using Web App for Container
* Configure the Azure Monitor Data Source for Azure Monitor, Log Analytics and Application Insights
* Create a CPU Chart with a Grafana variable used to select Computer Name
* Add an Annotation to your chart overlaying Computer Heartbeat

Bonus question:
How can we save our log queries and share them across multiple workspaces?

## Success Criteria
- Show the above 3 charts
- Show the saved queries

## Learning Resources
- [Getting started with Kusto](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/concepts/)
* [Log queries in Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview)
* [Overview of queries](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/)
* [Query best practises](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/best-practices)
* [Query operators](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/queries)
* [Telemetry correlation in Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/correlation)
* [Query Packs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/query-packs)
