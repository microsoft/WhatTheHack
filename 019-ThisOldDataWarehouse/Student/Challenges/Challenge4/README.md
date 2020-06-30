# Challenge 4 -- Real-time Data Pipelines

[< Previous Challenge](../Challenge3/README.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge>](../Challenge5/README.md)

## Introduction

Worldwide importers wanted to build out their data warehouse to include clickstream data.  There are a number of online stores that the marketing department wants to track for campaign and online ads.  These marketing users want to monitor the clickstream data and have the ability to run exploratory data analysis to support ad-hoc research.  This data needs to be in real-time so the campaigns and ads are timely based on user activity in the online stores.

## Description

Build a streaming pipeline to ingest simulated click stream data into enterprise Delta Lake via Azure Databricks.

### Data Source: 
In order to generate the source data stream for this exercise, you will need to execute sample .Net application (Stream Generator).  This code will randomly generate product related data, and write it to an Azure Event Hub.

### Data Sink:
Azure Databricks will be used to consume data from Event Hub and write the stream to Delta Lake tables stored in Azure Data Lake.


## Success Criteria
1. Deploy new Event Hub in Azure
1. Setup and configure data source
1. Deploy Azure Databricks
1. Create Azure Data Lake Storage Account
1. Import and Configure Databricks Notebook
1. Start Data stream
1. Ingest data stream

## Learning Resources

1. [Event Hub Quickstart](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-create)
1. [Stream Generator](https://github.com/alexkarasek/ClickStreamGenerator)
1. [Azure Databricks & Kafka Enabled Event Hubs](https://techblog.fexcofts.com/2019/01/17/azure-databricks-kafka-enabled-event-hubs/)

## Tips 

1. In order to publish data to and consume data from Event Hubs, you will need to generate a shared access policy, and use this key and the host name of the namespace in your connection string.  These values will need to be configured in both the click stream generator application, and the Azure Databricks notebook.


## Additional Challenges

*Too comfortable?  Eager to do more?  Try these additional challenges!*

1. Setup external table in Azure Synapse Analytics
1. Create Power BI report to use clickstream data
