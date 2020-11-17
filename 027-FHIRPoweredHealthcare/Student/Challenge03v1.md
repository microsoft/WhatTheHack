# Challenge 3: Stream patient data with event-driven architecture

[< Previous Challenge](./Challenge02.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge04.md)

## Introduction

In this challenge, you will implement an event-driven architecture for streaming patient data from the FHIR Server to Azure Cosmos DB.

In the end-to-end **[Serverless streaming with Event Hubs](https://azure.microsoft.com/en-us/services/event-hubs/#features)** platform below, the data flow (blue) shows a serverless function retrieves patient data from FHIR Server and drops them to Event Hubs, and then a Stream Analytics job ingests patient data from Event Hubs and writes stream processing results as JSON output to Cosmos DB.
![Serverless streaming with Event Hubs](../images/fhir-serverless-streaming.jpg)


## Description

- Create a new database collection in existing Cosmos DB to persist FHIR patient data.  This will be used as Output source for a Stream Analytics job later.
- Deploy an Event Hubs instance to receive patient data event streams from FHIR server.  This will be used as Input source for a Stream Analytics job later.
- Update the function app to read from FHIR server and stream them to Event Hubs.
- Deploy Stream Analytics instance and setup a Stream Analytics job to ingest data from Azure Event Hubs (Input) and output query processing results to Cosmos DB (Output).

## Success Criteria
- You have created a new database collection in Cosmos DB to persist patient data.
- You have standup a new Event Hubs instance for streaming patient data from FHIR Server.
- You have standup a new Stream Analytics instance for real-time stream of patient data.
- You have setup a Stream Analytics job to retrieve patient data from Event Hubs and output processing results to Cosmos DB.

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

