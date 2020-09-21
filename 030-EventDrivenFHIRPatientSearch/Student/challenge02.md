# What The Hack - Challenge 2

# Challenge \2 - \Load patient data into FHIR Server

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

## Challenges:
- Deploy CosmosDB instance supporting SQL interface through the portal.
- Deploy an Azure Function that reads from FHIR server and writes to the SQL interface of CosmosDB.
    - Look for these files for sample code on how to read from FHIR
        - dataread.js
        - config.json
    - Trigger your function manually for now

## Success Criteria
- Provision Azure Cosmos DB
- Use serverless function to get data into Azure Cosmos DB.  Sample NodeJS code snippet to be provided.




## Learning Resources

*List of relevant links and online articles that should give the attendees the knowledge needed to complete the challenge.*

## Tips (Optional)

Hint: @azure/cosmos NPM library

## Advanced Challenges (Optional)

*Too comfortable?  Eager to do more?  Try these additional challenges!*

