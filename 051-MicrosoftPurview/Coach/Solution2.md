# Challenge 2: Scan Azure SQL Database and Azure Synapse Analytics (Serverless and Dedicated) - Coach Guide 

[< Previous Solution](./Solution1.md) - [Home](./README.md) - [Next Solution >](./Solution3.md)


## Introduction

Duration: 30 – 45 minutes. 

Pre-requisites: This challenge needs an Azure SQL DB, Azure Synapse Analytics workspace. 

Optionally use the PS script provided to deploy the Azure SQL DB. 

Azure SQL DB: If done manually, deploy an Azure SQL DB with the lowest tier level possible and restore the existing sample database – [AdventureWorksLT](https://stpurviewfasthack.blob.core.windows.net/purviewfasthack/AzureDatabasebackup/AdventureWorksLT2019.bak).

This challenge could be a bit demanding if the attendees are new to Azure Synapse. It is recommended to check with the attendees that they know the differences between serverless and dedicated pools. Use the below links for creating the databases for the serverless and dedicated pools: 

Synapse Serverless: https://github.com/Azure-Samples/Synapse/blob/main/SQL/Samples/LdwSample/ContosoDW.sql 

Synapse Dedicated SQL Pool: https://docs.microsoft.com/en-us/azure/synapse-analytics/get-started-analyze-sql-pool 

Note that the script in the above link for the dedicated SQL pool currently is pointing to a non-existent parquet file. Until the doc is fixed you may want to point the script to the parquet file below: 

https://azuresynapsestorage.blob.core.windows.net/sampledata/NYCTaxiSmall/NYCTripSmall.parquet 

Azure SQL DB allows us to turn on lineage collection which will be discussed in another challenge. Discuss the output of the scans. 
Similar to the previous challenge, it is useful to discuss various tabs of a given asset (table) 
