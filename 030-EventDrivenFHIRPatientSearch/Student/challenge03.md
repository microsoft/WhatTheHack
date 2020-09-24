# What The Hack - Challenge 3

# Challenge \3 - \Deploy Event-driven architecture to read patient record from FHIR Server and store them in Azure Cosmos DB

[< Previous Challenge](./Challenge02.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge04.md)

## Pre-requisites (Optional)

## Introduction (Optional)

**Goal**
Build a patient search react application with a serverless backend in 24 hours.

## Description

**Technical skills leveraged**
- FHIR Server - Azure API for FHIR (PaaS)
- Serverless Compute - Azure Functions in Node.js
- Serverless Database/Search - Azure Comos DB w/SQL Interface, Azure Search
- Event-driven architecture - Azure Event Hubs
- Real-time streaming - Azure Streaming Analytics
- React/Redux, Java, etc. - For the front end application

## Challenges
- Deploy an Event Hub instance
- Update the Azure Functions to read from FHIR server and drop to Eventhub
- Deploy new serverless function in Azure Functions that is triggered by Event Hub and pushes data to Azure Cosmos DB
- (Optional) Alternatively, deploy Azure Streaming Analytics to ingest data from Azure Event Hub and pushes them to Azure Cosmos DB

## Success Criteria
- Provision Azure Cosmos DB
- Use serverless function or real-time streaming service to get data into Azure Cosmos DB.


## Learning Resources

*List of relevant links and online articles that should give the attendees the knowledge needed to complete the challenge.*

## Tips (Optional)

Hint:

## Advanced Challenges (Optional)

*Too comfortable?  Eager to do more?  Try these additional challenges!*

