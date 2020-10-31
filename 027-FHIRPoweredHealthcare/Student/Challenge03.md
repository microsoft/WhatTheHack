# Challenge 3: Stream patient data with event-driven architecture

[< Previous Challenge](./Challenge02.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge04.md)

## Introduction

In this challenge, you will implement an event-driven architecture for streaming patient data from the FHIR Server to Azure Cosmos DB.

**[Serverless streaming with Event Hubs](https://azure.microsoft.com/en-us/services/event-hubs/#features)** architecture for building an end-to-end serverless streaming platform (depicted below):  

In the architecture diagram below, the data flow in blue shows a serverless function retrieves patient data from FHIR Server and drops them to Event Hubs, and then a Stream Analytics job ingests patient data from Event Hubs and writes stream processing results as JSON output to Cosmos DB.
![Serverless streaming with Event Hubs](../images/fhir-serverless-streaming.jpg)


## Description

- Deploy an Azure Event Hubs to receive patient data event streams from FHIR server
- Update the Azure Functions to read from FHIR server and drop to Azure Event Hubs
- Deploy new serverless function app that is triggered by new patient data event sent to Azure Event Hubs and pushes the data to Azure Cosmos DB
- (Optional) Alternatively, deploy Azure Stream Analytics job to ingest data from Azure Event Hubs and pushes them to Azure Cosmos DB

## Success Criteria
- Deploy Azure Cosmos DB service in Azure Portal to persist aggregated patient data
- Auto write patient data to Azure Cosmos DB when patient data is retreived from FHIR Server and stream to Azure Event Hubs
- Alternatively, use a streaming service to retrieve patient data event in Event Hubs and push them to Azure Cosmos DB


## Learning Resources

- **[Quickstart: Create an event hub using Azure portal](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-create)**
- **[Send events to or receive events from event hubs by using JavaScript](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-node-get-started-send)**
- **[Azure Event Hubs trigger for Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-event-hubs-trigger?tabs=javascript)**
- **[Azure Event Hubs output binding for Azure Functions in JavaScript](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-event-hubs-output?tabs=javascript)**
- **[What is Azure Stream Analytics?](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction)**
- **[Quickstart: Create a Stream Analytics job by using the Azure portal](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-quick-create-portal)**
- **[Process data from your event hub using Azure Stream Analytics](https://docs.microsoft.com/en-us/azure/event-hubs/process-data-azure-stream-analytics)**
- **[Stream data as input into Stream Analytics](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-define-inputs)**
- **[Azure Stream Analytics output to Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-documentdb-output)**

