# Challenge 06 - Log Queries with Kusto Query Language (KQL)

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction

In this challenge we will use the Kusto Query Language (KQL) to write and save queries, which we can run on our Log Analytics Workspace.

### The difference between logs and metrics
In Azure Monitor, logs and metrics are two different types of data used for monitoring and troubleshooting applications and systems.

Metrics are numerical values that describe the performance of an application or system. Metrics are usually collected at regular intervals, such as every minute, and provide a snapshot of the system's performance at that time. Examples of metrics include CPU usage, memory usage, and network traffic. Metrics are useful for monitoring the overall health and performance of an application or system over time. Azure Monitor collects metrics from various sources, including virtual machines, Azure services, and custom applications.

Logs, on the other hand, are detailed records of events and activities that occur within an application or system. These events can include errors, warnings, informational messages, and other types of data that are useful for debugging and troubleshooting. Logs provide a rich source of data that can be analyzed and searched to identify patterns, trends, and anomalies. Azure Monitor collects logs from various sources, including virtual machines, applications, and Azure services.

In summary, logs are detailed records of events and activities, while metrics are numerical values that describe the performance of an application or system. Both logs and metrics are important sources of data for monitoring and troubleshooting applications and systems in Azure Monitor.

### What is Kusto Query Language (KQL)?
KQL (Kusto Query Language) is a query language used for log analytics in Microsoft Azure Monitor, Azure Data Explorer, and Azure Log Analytics. It allows users to analyze and search through large volumes of log data using a syntax similar to SQL. With KQL, users can write queries to extract information from logs, filter results, and perform various analytical operations, such as aggregating, sorting, and joining data from multiple sources. KQL is designed to handle high-volume, real-time data processing, making it a powerful tool for log analysis and troubleshooting in various industries, including IT, security, and business intelligence.

### Sample Kusto Query Language (KQL)

```
Heartbeat

| where TimeGenerated >= ago(1d)

| summarize heartbeat_count = count() by Computer

| project Computer, heartbeat_count

| order by heartbeat_count desc
```
In this query, the following elements are being used:

* **Heartbeat**: This is the name of the table that contains the heartbeat data.
* **where**: This is a filter operator that limits the query to only include data where the `TimeGenerated` field is within the last 24 hours.
* **summarize**: This operator groups the data by computer and counts the number of heartbeats for each one.
* **project**: This operator selects the Computer and heartbeat_count columns and removes all other columns.
* **order by**: This operator sorts the results in descending order by the number of heartbeats.

This query essentially counts the number of heartbeats received from each computer in the last 24 hours and orders the results by the number of heartbeats.

## Description

Write a performance query that renders a time chart for the last 4 hours for both of the Web Servers and the SQL Server for the following performance metrics. Save each query to your favorites.
* Processor Utilization: Processor / % Processor Time
* Memory Utilization: Memory / % Committed Bytes In Use
* Disk Utilization (IO): Disk Reads/sec and Disk Writes/sec
* Disk Utilization (MB/GB): Disk Free Space (% or MB)
* Create a heartbeat query for Web Servers and SQL Server
* Write a performance query that renders a time chart for the last hour of the max percentage CPU usage of the AKS Cluster nodes
- Combine infrastructure and application logs to create a single timeseries chart that includes:
  - CPU usage from the node in your AKS cluster hosting the eshoponweb app
  - Save each query to your favorites.
* Pin each of your charts to an Azure dashboard.

Bonus challenge (if you also completed challenge 04)
  - Write a query to show the duration of page views on your eshoponweb app hosted on the cluster and add the result to your dashboard

Bonus question:
How can we save our log queries and share them across multiple workspaces?

## Success Criteria
- Show the above 3 charts on a single dashboard
- Show the saved queries

## Learning Resources
* [Getting started with Kusto](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/)
* [Log queries in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview/)
* [Overview of queries](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/)
* [Query best practises](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/best-practices/)
* [Query operators](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/queries/)
* [Application Insights telemetry data model](https://learn.microsoft.com/en-us/azure/azure-monitor/app/data-model-complete)
* [Query Packs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/query-packs)
