# What The Hack - Driving Miss Data (ARCHIVED)

**NOTE: This hack has been marked as "archived" since one of the data sources used by students is no longer available.**

If you would like to update this hack so we can "un-archive" it, please submit a proposal to the What The Hack team as per our [WTH Contribution Guide](https://aka.ms/wthcontribute). We welcome contributions and can provide you more details on what would be needed to update it.

We recommend you consider our [This Old Data Warehouse](/019-ThisOldDataWarehouse/README.md) hack as superseding this one.

## Introduction
You are working with the New York City Taxi and Limousine Commission. They have several years of data about taxi trips in New York City, but have no way to analyze it.

You will build a modern data estate to enable analytic and real-time data analysis and visualization. Your task is to use Azure data technologies to build this data estate, including:

- Ingesting and storing raw data
- Cleaning and enriching data
- Loading data into a serving layer
- Consuming data in a BI layer
- Orchestrating the overall data flow for repeatability

## Architecture
![Architecture](Student/Resources/Data_Architecture.png)

## Challenges
- Challenge 1: **[Preparation - Ready, Set, GO!](Student/Challenge01-Prep.docx)**
    - Prepare your workstation for this hack.
- Challenge 2: **[Data Ingestion to Blob Storage](Student/Challenge02-IngestPrepData.docx)**
    - Ingest and Store Source Data in Blob Storage
- Challenge 3: **[Databricks](Student/Challenge03-ETL.docx)**
    - Clean and Merge Data in Databricks
    - Ingest cleaned/merged data from blob storage in Azure Data Warehouse using Polybase and Azure Data Factory
- Challenge 4: **[Model and Consume Data](Student/Challenge04-SemanticModel+Reports.docx)**
    - Create Data model in Azure Analysis Services using SQL DW as source
    - Consume Data in Power BI from Databricks and Azure Analysis Services
- Challenge 5: **[Weather Data](Student/Challenge05-Weather.docx)**
    - Access a Weather API, store weather data in Cosmos DB, join to transaction data in Power BI

**NOTE:** Some of the challenges can be worked on in parallel; others require preceding challenges to be completed. We suggest you read all the challenges before starting work and discuss/assign them as a team.

## Outcomes
An end-to-end solution spanning the data lifecycle, with functional Power BI dashboard(s).

## Repository Contents
- `../Coach`
  - Coach's Guide for each challenge
- `../Coach/Solutions`
  - Solution code for each challenge
- `../Student`
  - Guides for each challenge
- `../Student/Resources`
  - Architecture diagram for reference during the hack.

## Contributors
- Patrick El-Azem
- Neelam Gupta
