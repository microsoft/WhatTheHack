# Challenge 04 - Real-time Data Pipelines

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

Worldwide importers wanted to build out their data warehouse to include clickstream data.  There are a number of online stores that the marketing department wants to track for campaign and online ads.  These marketing users want to monitor the clickstream data and have the ability to run exploratory data analysis to support ad-hoc research.  This data needs to be in real-time so the campaigns and ads are timely based on user activity in the online stores.

## Description

Build a streaming pipeline to ingest simulated click stream data into enterprise Delta Lake.

![The Solution diagram is described in the text following this diagram.](../Coach/images/Challenge4.png)

### Data Source: 
In order to generate the source data stream for this exercise, you will need to execute sample .Net application ([Stream Generator](https://github.com/alexkarasek/ClickStreamGenerator)).  This code will randomly generate product related data, and write it to an Azure Event Hub.

Note: You can start the stream of data by executing script below in Azure Cloud Shell:

``` 
az container create -g [Resource Group Name] --name [container name] --image
alexk002/wwiclickstreamgenerator:1 --environment-variables 'hostName'='[EH Host Name]'
'sasKeyName'='RootManageSharedAccessKey' 'sasKeyValue'='[SAS Key]' 'eventHubName'='[Event Hub Name]' 
```

### Data Sink:
Azure Databricks will be used to consume data from Event Hub and write the stream to Delta Lake tables stored in Azure Data Lake.

## Success Criteria

- Query current number of clicks per product.  Reuse notebook and show coach query polling table on regular intervals

## Learning Resources

1. [Event Hub Quickstart](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-create)
1. [Stream Generator](https://github.com/alexkarasek/ClickStreamGenerator)
1. [Azure Databricks & Kafka Enabled Event Hubs](https://techblog.fexcofts.com/2019/01/17/azure-databricks-kafka-enabled-event-hubs/)
1. [Ingest and process real-time data streams with Azure Synapse Analytics](https://www.mssqltips.com/sqlservertip/6748/real-time-data-streams-azure-synapse-analytics/)

## Tips

1. In order to publish data to and consume data from Event Hubs, you will need to generate a shared access policy, and use this key and the host name of the namespace in your connection string.  These values will be needed on the consumer side of your Event hub.
1. Deploy new Event Hub in Azure
1. Setup and configure data source
1. Start Data Stream
1. Ingest data stream

## Advanced Challenges (Optional)

Too comfortable?  Eager to do more?  Try these additional challenges!

1. Setup external table in Azure Synapse Analytics
1. Create Power BI report to use clickstream data
1. Create an Azure Stream Analytics job to process streaming data and write to Data Lake and/or Azure Synapse Analytics SQL Pool directly
