# This Old [Title]House  {“Title”: [“Data Ware”, “Data Lake”, “…..”]}
Modern Data Warehouse What the Hack

## Introduction
Modern Data Warehouse is a key upgrade motion for organizations to scale out their on-premise analytical workloads to the cloud.  This hack will help data engineers and administrators upgrade their skills to migrate to Azure Synapse Analytics. The hack will be the sequential migration steps required to migrate from on-premise to Synapse Analytics and re-platform attached workloads like ETL and reporting.

## Learning Objectives
In this hack, data engineers will learn how to migrate their platform to the cloud (data, schema and code).  Additionally, they need to build out Data Warehouse architectures that can scale for large data volumes, different data structures and real-time ingestions.  Azure Synapse Analytics provides all these capabilities as an integrated platform and we'll help you better understand how to refactor your existing data warehouse to Azure.  
1. Modern Data Warehouse Architecture
1. Azure Synapse Decision Tree
1. Refactor T-SQL code to be compatible with Synapse
1. ETL/ELT design patterns and how to build them with ADF + ADLS
1. Setup a streaming data pipeline with HDInsight Kafka
1. Tune Synapse for analytical workloads and design report for best performance

## Challenges

0. [Setup](/Student/Challenges/Challenge0/readme.md)
1. [Data Warehouse Migration](/Student/Challenges/Challenge1/readme.md)
   - Migrate EDW from SQL Server to Azure Synapse Analytics.  Lift & Shift ETL code to SSIS Runtime
1. [Data Lake integration](/Student/Challenges/Challenge2/README.md)
   - Build out Staging tier in Azure Data Lake.  Architect Lake for staging, cleansed and presentation tiers with POSIX setup
1. [Data pipeline Migration](/Student/Challenges/Challenge3/README.md) 
   - Rewrite SSIS jobs from ETL data flow  to ADF as a ELT data flow.
1. [Realtime Data pipelines](/Student/Challenges/Challenge4/README.md)
   - Real-time data with Kafka and Databricks
1. [Analytics migration](/Student/Challenges/Challenge5/README.md)
   - Migrate reporting into Azure

## Technologies
1. Azure Synapse Analytics
2. Azure Data Factory
3. Azure HDInsight Kafka Cluster
4. Azure Databricks
5. Power BI

## Prerequisites
- Your own Azure subscription with Owner access
- Visual Studio Code
- Azure CLI
- Download WorldWide Importers Database (OLTP & OLAP)

## Repository Contents
- `../Coach/Solutions`
  - Coach's Guide for challenges
  - Solution files for challenges
- `../Student`
  - Student's Challenge Guide
- `../images`
  - Generic image files

## Learning Path for Modern Data Warehouse

- [Modern Data Warehouse](https://github.com/bhitney/Learning-Plans/wiki/Modern-Data-Warehouse)


## Contributors
- Alex Karasek
- Jason Virtue
- Annie Xu
- Chris Mitchell