# Challenge 6: Log Queries with KQL and Grafana

[Previous Challenge](./05-Azure-Monitor-For-Containers.md) - **[Home](../README.md)** - [Next Challenge>](./07-Visualizations.md)

## Introduction

## Description

Write a performance query that renders a time chart for the last 4 hours for both of the Web Servers and the SQL Server for the following perf metrics. Save each query to your favorites.
* Processor Utilization: Processor / % Processor Time
* Memory Utilization: Memory / % Committed Bytes In Use
* Disk Utilization (IO): Disk Reads/sec and Disk Writes/sec
* Disk Utilisation (MB/GB): Disk Free Space (% or MB)
* Create a heartbeat query for Web Servers and SQL Server
* Write a performance query that renders a time chart for the last hour of the max percentage CPU usage of the AKS Cluster nodes

* Deploy Grafana using Web App for Container
* Configure the Azure Monitor Data Source for Azure Monitor, Log Analytics and Application Insights
* Create a CPU Chart with a Grafana variable used to select Computer Name
* Add an Annotation to your chart overlaying Computer Heartbeat

## Success Criteria
* Grafana dashboards deployed

## Learning Resources
* [Run Grafana Docker image](http://docs.grafana.org/installation/docker/)
* [Monitor your Azure services in Grafana](https://docs.microsoft.com/en-us/azure/azure-monitor/visualize/grafana-plugin)
* [Log queries in Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview)
* [Overview of queries](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/)
* [Query best practises](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/best-practices)
* [Query operators](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/queries)
* [Telemetry correlation in Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/correlation)