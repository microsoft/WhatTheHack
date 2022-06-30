# What The Hack – Data Governance with Microsoft Purview - Coach Guide

## Introduction

Welcome to the coach's guide for the Data Governance with Microsoft Purview What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

NOTE: If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides 

- [Challenge 0: Setting up Microsoft Purview from the Portal and other required services](./Solution0.md)
	 - Review the general deployment options, create collections under the root collection and review options on setting permissions using collections 

- [Challenge 1: Scanning Azure Data Lake Storage](./Solution1.md)
	 - Begin the first scan by scanning the data lake storage and review the scan results 

- [Challenge 2: Scan Azure SQL Database and Azure Synapse Analytics (Serverless and Dedicated)](./Solution2.md)) 
	 - Continue with scanning, by scanning databases 

- [Challenge 3: Scan an on-prem SQL Server](./Solution3.md)
	 - Continue the database scan by scanning an on-prem SQL Server 

- [Challenge 4: Create custom classifications](./Solution4.md)
	 - Setup custom classifications and review the scan results with incremental scans 

- [Challenge 5: Business glossary](./Solution5.md)
	 - Setup business glossary and associate assets to glossary items 

- [Challenge 6: Data lineage](./Solution6.md)
	 - Learn to produce lineage using ADF and Synapse pipelines 

- [Challenge 7: Data insights](./Solution7.md)
	 - Produce insights on the work done so far 

- [Challenge 8: Enhancing Microsoft Purview with Atlas API](./Solution8.md)
	 - Meet the requirements that are not available out of the box 
  
## Coach Prerequisites
- During the hack, students will deploy multiple services to their subscription. Some of them (2x Virtual Machine, Azure Synapase dedicated SQL Pool) should be instantly removed/paused after the hack. Keeping these services online for days after hack, can significantly impact the cost.

## Student Resources
- All required resources for this hack (sample data, required .CSV files, etc.) can be found in the storage account below. They can be accessed with Azure Storage Explorer:
    - https://wthpurview.blob.core.windows.net/wthpurview

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.  

## Azure Requirements

- Azure subscription with Owner access 
- See challenge 0 for information on other pre-requisites 
- Azure Storage Explorer
- Postman client

## Deployment script 

- There are many services required in Azure to complete the hack. To save time, the attendee may use the script below to deploy the required services. 
- https://wthpurview.blob.core.windows.net/wthpurview/PurviewFastHack_Deployment.ps1  
- Before executing, edit the script and enter your subscription ID. 
- Change the names of the required services so that they are unique.
- Script will deploy: 
  - New resource group 
  - VM with SQL Server 2019 
  - VM (dedicated for SHIR) 
  - Virtual network 
  - Azure SQL Database with AdventureWorksLT 
  - Azure Data Factory 
  - Azure Data Lake Storage gen2 


## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Additional files for the coach which can help solve challenges
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Additional files for students which can help setup the environment
