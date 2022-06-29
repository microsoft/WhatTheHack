# What The Hack - Data Governance with Microsoft Purview
## Introduction
Most companies struggle to deal with the humongous amount of data that is being generated across their business and across their IT estate (on-prem, multiple clouds). The more a company understands their data, the more effective they are to use it.

You will hack your way through to implement Microsoft Purview in your fictious organization - Fabrikam. You will implement Microsoft Purview so that Fabrikam can find, understand, govern, and consume data sources

## Learning Objectives
In this hack you will:
- Setup Microsoft Purview.
- Scan multiple data sources.
- Classify scanned data.
- Setup Business Glossary.
- Create lineage for data movement.
- Provide insights on the data estate.
- Use Atlas API for some use cases.

## Challenges
-  Challenge 0: [Setting up Microsoft Purview from the Portal and other required services](./Student/Challenge0.md)
   -  Review the general deployment options, create collections under the root collection and review options on setting permissions using collections
-  Challenge 1: [Scanning Azure Datalake Storage](./Student/Challenge1.md)
   -  Begin the first scan by scanning the datalake storage and review the scan results
-  Challenge 2: [Scan Azure SQL Database and Azure Synapse Analytics (Serverless and Dedicated)](./Student/Challenge2.md)
   -  Continue with scanning by scanning by scanning databases
-  Challenge 3: [Scan a on-prem SQL Server](./Student/Challenge3.md)
   -  Continue the database scan by scanning an on-prem SQL Server
-  Challenge 4: [Create custom classifications](./Student/Challenge4.md)
   -  Setup custom classifications and review the scan results with incremental scans
-  Challenge 5: [Business glossary](./Student/Challenge5.md)
   -  Setup the business glossary and associate assets to glossary items
-  Challenge 6: [Data lineage](./Student/Challenge6.md)
   -  Learn to produce lineage using ADF and Synapse pipelines
-  Challenge 7: [Data insights](./Student/Challenge7.md)
   -  Produce insights on the work done so far
-  Challenge 8: [Enhancing Microsoft Purview with Atlas API](./Student/Challenge8.md)
   -  Meet the requirements that are not available out of the box

## Technologies
-  Microsoft Purview
-  Azure Data Lake Storage
-  Azure SQL Database
-  Azure Synapse Analytics
-  Azure Data Factory
-  SQL Server on IaaS

## Prerequisites
-  Azure subscription with Owner access
-  See challenge 0 for information on other pre-requisites

## Contributors
- Michal Golojuch
- Situmalli Chandra Mohan
