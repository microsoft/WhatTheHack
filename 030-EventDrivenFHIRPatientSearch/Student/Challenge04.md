# Challenge 4: Index patient data for patient lookup

[< Previous Challenge](./Challenge03.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge05.md)

## Introduction

In this challenge, you will index the patient data stored in Azure Cosmos DB and expose an indexer API for patient lookup.

## Description

- Deploy Azure Cognitive Search service to index Azure Cosmos DB patient data
- Configure Azure Cosmos DB indexer to crawl patient data and make it searchable in Azure Cognitive Search 
- Add search capability through REST API operations
- Build Serverless REST API in Azure Functions with HTTP Activation

## Success Criteria
- Create search indexer on-top of Patient dataset stored in Azure Cosmos DB.
- Expose Patient search indexer REST API.

## Learning Resources

- **[How to index Cosmos DB data using an indexer in Azure Cognitive Search](https://docs.microsoft.com/en-us/azure/search/search-howto-index-cosmosdb)**
- **[Indexer operations (Azure Cognitive Search REST API)](https://docs.microsoft.com/en-us/rest/api/searchservice/indexer-operations)**
- **[Azure Cognitive Search Service REST](https://docs.microsoft.com/en-us/rest/api/searchservice/)**
- **[Azure Functions HTTP trigger](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-http-webhook-trigger?tabs=javascript)**


