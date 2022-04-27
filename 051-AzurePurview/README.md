# What The Hack - Microsoft Purview
## Introduction
Most companies struggle to deal with humungous amount of data that is being generated across their business and across thier IT estate (on-prem, multiple clouds). The more a company understands their data, the more effective they are to use it.

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
-  Challenge 0: Setting up Microsoft Purview from the Portal and other required services
   -  Review the general deployment, create collections under the root collection (TBD: What type of collections (ADLS, Azure Synapse, Azure SQL or Sales, Mktg,            Finance..) and review options on setting permissions using collections
-  Challenge 1: Scanning Azure Datalake Storage
   -  Begin the first scanning by scanning the datalake storage and review the scan results
-  Challenge 2: Scan Azure SQL Database and Azure Synapse Analytics (Serverless and Dedicated)
   -  Continue with scanning by scanning by scanning databases
-  Challenge 3: Scan a on-prem SQL Server
   -  Continue the database scan by scanning an on-prem SQL Server
-  Challenge 4: Create custom classifications
   -  Setup custom classficiations and review the scan results with incremental scans
-  Challenge 5: Business glossary
   -  Setup business glossary and associate assets to glossary items
-  Challenge 6: Data lineage
   -  Learn to produce lineage using ADF and Synapse pipelines
-  Challenge 7: Data insights
   -  Produce insights on the work done so far
-  Challenge 8: Enhancing Microsoft Purview with Atlas API
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
-  See the challenge 0 for information on other pre-requisites

## Repository Contents
- `../Coach/Guides`

- `../Coach/Solutions`

- `../Student/Resources`


## Contributors
- Michal Golojuch
- Situmalli Chandra Mohan
