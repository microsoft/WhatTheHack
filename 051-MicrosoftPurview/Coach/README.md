# What The Hack – Data Governance with Microsoft Purview - Coach Guide

## Introduction

Welcome to the coach's guide for the Data Governance with Microsoft Purview What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional lecture presentation that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

NOTE: If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides 

- [Solution 0: Setting up Microsoft Purview from the Portal and other required services](./Solution0.md)
	 - Review the general deployment options, create collections under the root collection and review options on setting permissions using collections 

- [Solution 1: Scanning Azure Data Lake Storage](./Solution1.md)
	 - Begin the first scann by scanning the datalake storage and review the scan results 

- [Solution 2: Scan Azure SQL Database and Azure Synapse Analytics (Serverless and Dedicated)](./Solution2.md)) 
	 - Continue with scanning by scanning by scanning databases 

- [Solution 3: Scan an on-prem SQL Server](./Solution3.md)
	 - Continue the database scan by scanning an on-prem SQL Server 

- [Solution 4: Create custom classifications](./Solution4.md)
	 - Setup custom classficiations and review the scan results with incremental scans 

- [Solution 5: Business glossary](./Solution5.md)
	 - Setup business glossary and associate assets to glossary items 

- [Solution 6: Data lineage](./Solution6.md)
	 - Learn to produce lineage using ADF and Synapse pipelines 

- [Solution 7: Data insights](./Solution7.md)
	 - Produce insights on the work done so far 

- [Solution 8: Enhancing Microsoft Purview with Atlas API](./Solution8.md)
	 - Meet the requirements that are not available out of the box 
  
## Coach Prerequisites
- During the hack, students will deploy multiple services to their subscribtion. Some of them (2x Virtual Machine, Azure Synapase dedicated SQL Pool) should be instantly removed/paused after the hack. Keeping these services online for days after hack, can significantly impact the cost.

## Student Resources
- All required resources for this hack (sample data, required .csv files etc) can be found it this storage account below. They can be accessed with Azure Storage Explorer:
    - https://stpurviewfasthack.blob.core.windows.net/purviewfasthack/

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.  

## Azure Requirements

- Azure subscription with Owner access 
- See the challenge 0 for information on other pre-requisites 
- Azure Storage Explorer
- Postman client

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


## Repository Contents

- \`./Coach\`
  - Coach's Guide and related files
- \`./Coach/Resources\`
  - Additional files for Coach which can help solve challenges
- \`./Student\`
  - Student's Challenge Guide


