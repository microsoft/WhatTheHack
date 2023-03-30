# Challenge 04 - Real-time Data Pipelines - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Story
Worldwide importers wanted to build out their data warehouse to include clickstream data.  There are a number of online stores that the marketing department wants to track for campaign and online ads.  These marketing users want to monitor the clickstream data and have the ability to run exploratory data analysis to support ad-hoc research.  This data needs to be real-time so the campaigns and ads are timely based on user activity in the online stores.

## Tools
1. Visual Studio 2019 or Visual Studio Code
1. Azure Databricks Workspace
1. Azure Event Hubs
1. Solution contains the Azure Databricks notebook which should be shared with students.  We don't expect them to setup this notebook ahead of time.

## Real-time Streaming Overview
Build a streaming pipeline using Azure Event Hub to ingest simulated click stream data into enterprise Delta Lake via Azure Databricks.

## Dataset

### Data Source
In order to generate the source data stream for this exercise, you will need to execute sample .Net application (Step 2).  This code will randomly generate product related data, and write it to a Kafka endpoint on an Azure Event Hub.
(Note: this solution guide was built with an Event Hub named 'test'.  If you create an Event Hub with a different name, there may be further modifications required to configuration settings in order to successfully create your data stream.)

### Data Sink 
Azure Databricks will be used to consume Event Hub, and write streaming data to Delta Lake tables stored in Azure Data Lake.

## Step by Step Guidance

**Step 1 - Deploy Azure Event Hub**
Follow Event Hub quickstart instructions [here](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-create).

**Step 2 - Set up and configure data source**
Open and configure Click Stream Generator application found [here](https://github.com/alexkarasek/ClickStreamGenerator).  You will need to provide your host name and shared access policy key in the appsettings.json file. You can use the code below to create and deploy the container instance in Azure instead of using docker. 

Here is a script to simplify deployment and reduce setup time for the hack.  This script is provided in the student's challenge. The code below creates Azure container instances, you can use an existing resource group name and use a new name for EH Host Name. Get the 'sasKeyValue' from 'Shared Access policies' tab within the Events Hub Namespace area. 

``` 
az container create -g [Resource Group Name] --name [container name] --image
alexk002/wwiclickstreamgenerator:1 --environment-variables 'hostName'='[EH Host Name]'
'sasKeyName'='RootManageSharedAccessKey' 'sasKeyValue'='[SAS Key]' 'eventHubName'='[Event Hub Name]'
```

**Step 3 - Create Azure Data Lake Storage Account**
Create a new ADLS Gen 2 storage account (or new folder in existing storage account) in your Resource Group.  This will be used as the backend storage for Delta Lake tables created in subsequent steps. The folder structure could have been created in the previous challenge.

**Step 4 - Import and Configure Databricks Notebook**
Create a new Azure Databricks Workspace, and import Notebook contained in this solution.  Once imported, update configuration settings for Event Hub connections and Azure Data Lake Storage. A cluster will need to be created to run the Databricks notebook. Note: if the Total Regional vCPU quota is at capacity, resolve this by creating a different Azure Databricks Workspace with a different region eg: UK West (make sure to delete the previous Azure Databricks workspace). 

**Step 5 - Start data stream**
Once all items above have been deployed and configured, you can start the stream generator app.  This will begin writing data to the new Event Hub.

**Step 6 - Ingest data stream**
Execute the Databricks notebook configured above to create streaming dataset, and start writing data to Delta Lake.  Once this notebook is running, you can begin to interactively query Delta Lake tables and streaming Data Frame.

## Query the Data
Have the team reuse the queries in the Databricks notebook and create an aggregate query to show their SQL, Scala or Python skills.  This is a standalone table and doesn't directly integrate into Azure Synapse Analytics. 
