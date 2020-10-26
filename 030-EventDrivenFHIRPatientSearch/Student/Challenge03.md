# Challenge 3: Stream patient data with event-driven architecture

[< Previous Challenge](./Challenge02.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge04.md)

## Introduction

In this challenge, you will implement an event-driven architecture for streaming patient data from the FHIR Server to Azure Cosmos DB.

## Description

- Deploy an Event Hub instance and configure patition(s) to receive patient data event streams
- Update the Azure Functions to read from FHIR server and drop to Event Hubs partition(s)
- Deploy new serverless function in Azure Functions that is triggered by new patient data event sent to Event Hubs and pushes the data to Azure Cosmos DB
- (Optional) Alternatively, deploy Azure Stream Analytics to ingest data from Azure Event Hub and pushes them to Azure Cosmos DB

## Success Criteria
- Deployg Azure Cosmos DB service in Azure Portal to persist aggregated patient data
- Use serverless function auto trigger writes of Patient data to Azure Cosmos DB by retrieving patient data events from Event Hubs
- Alternatively, use a real-time streaming service to retrieve patient data event in Event Hubs and push them top Azure Cosmos DB


## Learning Resources

- **[Quickstart: Create an event hub using Azure portal](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-create)**
- **[Send events to or receive events from event hubs by using JavaScript](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-node-get-started-send)**
- **[Azure Event Hubs trigger for Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-event-hubs-trigger?tabs=javascript)**
- **[Azure Event Hubs output binding for Azure Functions in JavaScript](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-event-hubs-output?tabs=javascript)**
- **[What is Azure Stream Analytics?](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction)**
- **[Quickstart: Create a Stream Analytics job by using the Azure portal](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-quick-create-portal)**
- **[Stream data as input into Stream Analytics](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-define-inputs)**
- **[Azure Stream Analytics output to Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-documentdb-output)**

