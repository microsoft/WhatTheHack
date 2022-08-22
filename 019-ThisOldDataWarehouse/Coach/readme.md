# Overview

This workshop is intended to give Data Engineers a level 400 understanding of the Modern Data Warehouse architecture and development skills to build it with Azure Synapse Analytics.  First, data engineers will learn how to migrate their SQL Server on-premise workloads to Azure Synapse analytics.  Likewise, the workshop will provide the skills and best practices to integrate a Data Lake into the existing data warehouse platform.  This will require the existing ETL (SSIS package) be refactored into Azure Data Factory pipelines.  Additionally, Modern Data Warehouse platforms are starting to integrate real-time data pipelines into the data lake.  Lastly, the students will be able to build out a Power BI Data model and tune it and the Synapse platform for optmial performance.  This will showcase Synapse Analytics performance with Dashboards.

The format we're following for this is similar to other initiatives like OpenHack and What the Hack. The material is intended to be light on presentations and heavy on hands on experience. The participants will spend the majority of their time working on challenges. The challenges are not designed to be hands on labs, but rather a business problem with success criteria. The focus here is encouraging the participants to think about what they're doing and not just blindly following steps in a lab.

## Expected / Suggested Timings

The following is expected timing for a standard delivery.

|                                            |                                                                                                                                                       |
| ------------------------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------: |
| **Topic** |  **Duration**  |
| Presentation 0:  [Welcome and Introduction](./MDWWTHIntro.pptx)  | 5 mins |
| Challenge 0: Environment Setup | 30 mins|
| Presentation 1: [Intro to Modern Data Warehouse](./MDWWTHIntro.pptx) | 30 mins|
| Challenge 1: Data Warehouse Migration | 240 mins |
| Challenge 2: Data Lake Integration | 120 mins |
| Challenge 3: Data pipeline Migration | 240 mins |
| Challenge 4: Realtime Data Pipelines | 120 mins |
| Challenge 5: Analytics Migration | 120 mins |

## Content

In order to deliver this hack there is a variety of supporting content.   This content is indexed below.  The guidance provided is one of many potential solutions to the different challenges and we encourage you to choose the best adventure for your team.

### Challenges
1.  [Data Warehouse Migration](./Solutions/Challenge1/readme.md)
2.  [Data Lake Integration](./Solutions/Challenge2/Readme.md)
3.  [Data Pipeline Migration](./Solutions/Challenge3/Readme.md)
4.  [Real-time Data pipeline](./Solutions/Challenge4/README.md)
5.  [Analytics migration](./Solutions/Challenge5/README.md)

### Ideas for other Challenges

This area is for us to keep a running list of things we would like to incorporate into the Core or Optional challenges.  Please contribute if you would like to pick one of these to work on, or want to add a new one yourself.  Help and collaboration are always welcome.  All Pull Requests will be accepted.

1. [Generate new data and load into Synapase](https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-generate-data?view=sql-server-ver15)
1. Deploy Spark Pools to Data Lake and enable interactive queries and analytics
1. Refactor the T-SQL code in Polybase to leverage Python or Scala
1. Build out these data pipelines using Azure Data Factory Mapping Data Flows
1. Setup external table in Azure Synapse Analytics
1. Create Power BI report to use clickstream data
1. Recreate this pipeline using Synapse Spark Pool
   