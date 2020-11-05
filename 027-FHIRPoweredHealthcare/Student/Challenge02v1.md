# Challenge 2: Stream FHIR Patient Data with serverless function app

[< Previous Challenge](./Challenge01.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge03.md)

## Introduction

In this challenge, you will stream FHIR Patient Data from the FHIR Server to a test NoSQL Document database for unit testing.

## Description

- Deploy CosmosDB instance supporting SQL interface and create a test database collection.
- Deploy a serverless function app that reads from FHIR server and writes to the SQL interface of Azure CosmosDB.
    - Look for these files in student resources folder for sample code on how to read from FHIR Server
        - dataread.js
        - config.json
    - Trigger your function manually for now

## Success Criteria
- You have extracted patient data from FHIR Server and loaded them to Azure Cosmos DB.

## Learning Resources

- **[Quickstart: Create an Azure Cosmos account, database, container, and items from the Azure portal](https://docs.microsoft.com/en-us/azure/cosmos-db/create-cosmosdb-resources-portal)**
- **[Quickstart: Create a JavaScript function in Azure using Visual Studio Code](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-function-vs-code?pivots=programming-language-javascript)**