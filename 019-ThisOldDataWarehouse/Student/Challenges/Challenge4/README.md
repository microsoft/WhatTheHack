# Challenge 4 -- Real-time Data Pipelines

[< Previous Challenge](../Challenge3/README.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge>](../Challenge5/README.md)

## Introduction

Worldwide importers wanted to build out their data warehouse to include clickstream data.  There are a number of online stores that the marketing department wants to track for campaign and online ads.  These marketing users want to monitor the clickstream data and have the ability to run exploratory data analysis to support ad-hoc research.  This data needs to be in real-time so the campaigns and ads are timely based on user activity in the online stores.

## Description

Build a streaming pipeline using Kafka on HDInsight to ingest simulated click stream data into enterprise Delta Lake via Azure Databricks.

### Data Source: 
In order to generate the source data stream for this exercise, you will need to execute sample .Net application (Stream Generator).  This code will randomly generate product related data, and write it to a Kafka topic.

### Data Sink:
Azure Databricks will be used to consume Kafka topic, and write streaming data to Delta Lake tables stored in Azure Data Lake.


## Success Criteria
1. Deploy Kafka Instance on HDInsight
1. Update Kafka Configuration settings
1. Setup and configure data source
1. Deploy Azure Databricks
1. Create Azure Data Lake Storage Account
1. Import and Configure Databricks Notebook
1. Start Data stream
1. Ingest data stream

## Learning Resources

1. [Kafka Setup instructions](https://docs.microsoft.com/en-us/azure/hdinsight/kafka/apache-kafka-get-started) 
1. [Kafka Configuration](https://docs.microsoft.com/en-us/azure/hdinsight/kafka/apache-kafka-connect-vpn-gateway#configure-kafka-for-ip-advertising)
1. [End to End Event Streaming Guidebook](https://lenadroid.github.io/posts/kafka-hdinsight-and-spark-databricks.html) (Optional)
1. [Stream Generator](https://github.com/alexkarasek/ClickStreamGenerator)
1. [Databricks Vnet Peering](https://docs.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/vnet-peering)

## Tips 

1. If you don't already have one configured before you start, be sure to create a Virtual Network in your Resource Group first so that it can be configured for your cluster.  This will be required for future steps.

1. While in Ambari management screen for HDInsight, take note of IP addresses for Kafka brokers.  You will need these later to configure topic publishers and consumers.

1. Create a Visual Studio VM in the same Resource Group as your new HDInsight cluster.  Once project is open in visual studio, update the necessary configuration settings and IP addresses for Kafka brokers.

1. Deploy Databricks Workspace and create a new cluster in the same Resource Group as above.  Once configured, be sure to peer the Databricks Virtual Network with the other virtual network that was created in steps above.

1. Start new Databricks Cluster and import Notebook contained in this solution.  Once imported, update configuration settings for Kafka topics and Azure Data Lake Storage.

1. Once all items above have been deployed and configured, you can log into your new Visual Studio VM, and start the solution.  This will begin writing data to the new Kafka topic.

1. Execute the Databricks notebook configured above to create streaming dataset, and start writing data to Delta Lake.  Once this notebook is running, you can begin to interactively query Delta Lake tables and streaming Data Frame.

## Additional Challenges

*Too comfortable?  Eager to do more?  Try these additional challenges!*

1. Setup external table in Azure Synapse Analytics
1. Create Power BI report to use clickstream data
1. Recreate this pipeline using Synapse Spark Pool