# What The Hack - Challenge 3

# Challenge \3 - \Read patient record from FHIR Server and store them in Azure Cosmos DB

[< Previous Challenge](./Challenge-X-1.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge-X+1.md)

## Pre-requisites (Optional)

## Introduction (Optional)

**Goal**
Build a patient search react application with a serverless backend in 24 hours.

## Description

**Technical skills leveraged**
- Serverless Compute - Azure Functions in Node.js
- Serverless Database/Search - ComosDB/Azure Search, likely w/ mongo or cassandra cleint
- Event-driven architecture - Azure Event Hub
- Real-time Streaming - Azure Streaming Analytics
- React/Redux - For the front end application

## Challenges
- Deploy an Eventhub
- Update the Azure Function to read from FHIR server and drop to Eventhub
- Deploy a new Azure Function that is triggered by Event Hub and pushes data to Azure CosmosDB
- (Optional) Deploy Azure Streaming Analytics to ingest data from Azure Event Hub (intead of Azure Functions) and pushes data to Azure Cosmos DB

## Success Criteria
- Provision Azure Cosmos DB
- Use serverless function or real-time streaming service to get data into Azure Cosmos DB.


## Learning Resources

*List of relevant links and online articles that should give the attendees the knowledge needed to complete the challenge.*

## Tips (Optional)

Hint:

## Advanced Challenges (Optional)

*Too comfortable?  Eager to do more?  Try these additional challenges!*

