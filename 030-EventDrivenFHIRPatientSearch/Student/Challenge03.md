# Challenge 3: Stream patient data from FHIR Server to Azure Cosmos DB

[< Previous Challenge](./Challenge02.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge04.md)

## Introduction

In this challenge, you will implement an event-driven architecture for streaming patient data from the FHIR Server to Azure Cosmos DB.

## Description

- Deploy an Event Hub instance
- Update the Azure Functions to read from FHIR server and drop to Eventhub
- Deploy new serverless function in Azure Functions that is triggered by Event Hub and pushes data to Azure Cosmos DB
- (Optional) Alternatively, deploy Azure Streaming Analytics to ingest data from Azure Event Hub and pushes them to Azure Cosmos DB

## Success Criteria
- Provision Azure Cosmos DB
- Use serverless function or real-time streaming service to get data into Azure Cosmos DB.


## Learning Resources

*List of relevant links and online articles that should give the attendees the knowledge needed to complete the challenge.*
