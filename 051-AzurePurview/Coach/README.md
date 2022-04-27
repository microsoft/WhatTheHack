# What The Hack – Microsoft Purview 

## Introduction

Welcome to the coach's guide for the Microsoft Purview What The Hack. Here you will find links to specific coaches' guidance for each of the challenges. 

The hack builds loosely on top of each other in a modular way but obviously some challenges are a must for the next one to be done whereas some can be reordered or skipped too. Any dependencies will be called out in each challenge and coach guide. If you run into any problems, please open an issue so it can be looked at. 

This document provides guidance on the solution and links to files/scripts that will be used during the course of the hack. 

## Solutions 

- Solution 0: Setting up Microsoft Purview from the Portal and other required services 

    Review the general deployment, create collections under the root collection (TBD: What type of collections (ADLS, Azure Synapse, Azure SQL or Sales, Mktg, Finance..) and review options on setting permissions using collections 
- Solution 1: Scanning Azure Data Lake Storage 

    Begin the first scanning by scanning the Data Lake Storage and review the scan results 
- Solution 2: Scan Azure SQL Database and Azure Synapse Analytics (Serverless and Dedicated) 

    Continue with scanning databases 
- Solution 3: Scan an on-prem SQL Server 

    Continue with scanning on-prem SQL Server 
- Solution 4: Create custom classifications 

    Setup custom classifications and review the scan results with incremental scans 
- Solution 5: Business glossary 

    Setup business glossary and associate assets to glossary items 
- Solution 6: Data lineage 

    Learn to produce lineage using ADF and Synapse pipelines 
- Solution 7: Data insights 

    Produce insights on the work done so far 
- Solution 8: Enhancing Microsoft Purview with Atlas API 

    Meet the requirements that are not available out of the box 
  
  
## Technologies 

- Microsoft Purview 
- Azure Data Lake Storage 
- Azure SQL Database 
- Azure Synapse Analytics 
- Azure Data Factory 
- SQL Server on VM 

## Prerequisites 

- Azure subscription with Owner access 
- See the challenge 0 for information on other pre-requisites 
- Azure Storage Explorer 

## Deployment script 

- There are many services required in Azure to complete the hack. To save time, attendee may use script below to deploy required services. 
- https://stpurviewfasthack.blob.core.windows.net/purviewfasthack/PurviewFastHack_Deployment.ps1  
- Before executing, edit the script and enter your subscription ID. 
- Change also required unique names of the services. 
- Script will deploy: 
  - New resource group 
  - VM with SQL Server 2019 
  - VM (dedicated for SHIR) 
  - Virtual network 
  - Azure SQL Database with AdventureWorksLT 
  - Azure Data Factory 
  - Azure Data Lake Storage gen2 
