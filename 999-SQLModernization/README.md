# SQL Modernization and Migration
SQL Modernization and Migration What the Hack

## Introduction
SQL Server has come a long way!  From OLTP to OLAP, on-premises to cloud, big data clusters to hyperscale -- SQL Server has evolved in many ways.  With that evolution comes complexity as organizations seek to take advantage of new features and cloud efficiency.  This hack puts you (and your team) in the role of an SI (Systems Integrator), working with many clients to modernize their environments and applications.

## Related Hacks
For more in-depth work with Azure Synapse Analytics and Data Ops, see these hacks:

* [Modern Data Warehouse What the Hack](https://github.com/)
* [Data Ops What the Hack](https://github.com/)
* [OSS DB Migration to Azure](https://github.com/)

## Learning Objectives
In this hack, database administrators, developers who work extensively with SQL Server, and architects will migrate solutions to Azure. Several different scenarios are presented that are based on real-world scenarios, and in most cases there are multiple ways to solve the problem given the requirements of each challenge.  This hack also prepares participants for the DP-300 exam.  While some challenges will touch on topics such as ETL/SSIS and modernizing data deployment (ie data ops), there are What The Hacks that focus extensively on these topics; see related hacks above.

## Challenges

0. [Setup](./Student/Challenge00.md)
1. [Migration]


0. [Setup](./Student/Challenges/Challenge0/readme.md)
1. [Data Warehouse Migration](./Student/Challenges/Challenge1/readme.md)
   - Migrate EDW from SQL Server to Azure Synapse Analytics.  Lift & Shift ETL code to SSIS Runtime
1. [Data Lake integration](./Student/Challenges/Challenge2/README.md)
   - Build out Staging tier in Azure Data Lake.  Architect Lake for different refinement layers (staging, cleansed and presentation tiers) with POSIX setup
1. [Data pipeline Migration](./Student/Challenges/Challenge3/README.md) 
   - Rewrite SSIS jobs from ETL data flow  to ADF as a ELT data flow.
1. [Realtime Data pipelines](./Student/Challenges/Challenge4/README.md)
   - Real-time data with Kafka and Databricks
1. [Analytics migration](./Student/Challenges/Challenge5/README.md)
   - Migrate reporting into Azure

## Technologies
1. Azure Synapse Analytics
2. Azure Data Factory
3. Azure Event Hubs w/ Kafka Cluster
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
- Brian Hitney
- Israel Ekpo