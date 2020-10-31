# Challenge 2: Stream FHIR Patient Data 

[< Previous Challenge](./Challenge01.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge03.md)

## Introduction

In this challenge, you will stream FHIR Patient Data from the FHIR Server and for unit testing, load them directly into Azure Cosmos DB.

## Description

- Deploy CosmosDB instance supporting SQL interface.
- Deploy a serverless function app that reads from FHIR server and writes to the SQL interface of Azure CosmosDB (for unit testing).
    - Look for these files for sample code on how to read from FHIR Server
        - dataread.js
        - config.json
    - Trigger your function manually for now

## Success Criteria
- Extract patient records from FHIR Server via API.
- Unit testing: Load the extracted patient data directly to Azure Cosomos DB

## Learning Resources

- **[Quickstart: Create an Azure Cosmos account, database, container, and items from the Azure portal](https://docs.microsoft.com/en-us/azure/cosmos-db/create-cosmosdb-resources-portal)**
- **[Quickstart: Create a JavaScript function in Azure using Visual Studio Code](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-function-vs-code?pivots=programming-language-javascript)**