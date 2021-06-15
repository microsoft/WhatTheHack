# Challenge 6: Optional Logs

[Previous Challenge](./06-Log-Analytics-Query.md) - **[Home](../README.md)** - [Next Challenge>](./08-Dashboard-And-Analytics.md)

## Introduction
Azure Monitor Logs is based on Azure Data Explorer, and log queries are written using the same Kusto query language (KQL). This is a rich language designed to be easy to read and author, so you should be able to start writing queries with some basic guidance.

This challenge contains more complex queries than the first query challenge.

## Description

Combine infrastructure and application logs to create a single timeseries chart that includes:
* CPU usage from the node in your AKS cluster hosting the eshoponweb app
* Duration of requests on your eshoponweb app hosted on the cluster

## Success Criteria
Queries return data as per challenge

## Learning Resources
* [Log queries in Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview)
* [Overview of queries](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/)
* [Query best practises](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/best-practices)
* [Query operators](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/queries)
* [Telemetry correlation in Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/correlation)
