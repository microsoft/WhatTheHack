# Welecome to the Event-driven FHIR Patient Search Hack!

This is a challenge-based hack. It's NOT step-by-step. Don't worry, you will do great whatever your level of experience! You will be guided through different tasks to implement a Patient Search app by leveraging FHIR API in an event driven architecture in Azure.  You will be using a combination of Azure API for FHIR, Azure Functions, Azure Event Hubs, Azure Streaming Analytics, Azure Cosmos DB, Azure Search, Azure App Service and Azure Storage. The goal is to build a centralized environment to host a FHIR server to be populated with patient data.  You will be using Azure API for FHIR managed service and populated it with the auto-generated test patient data. You'll then build an Event-driven architecture that triggers writes to Azure Cosmos DB.  This serverless function trigger will kick-off whenever patient data are retrieved from the FHIR Server and pushed to Azure Event Hub queue.  You will then implement Azure search to index patient data stored in Azure Cosmos DB and expose an indexer API for consumption in a Web App.  Finally, you will build a patient search frontend web app to display a paginated list of patients and a search box to lookup patient record by calling the indexer API. 

The intent of the hack is to have you practice the tools, technologies and services our partners are asking you about.  Let's try to go out of your comfort zone, try and learn something new.  And let's have fun!  And don't forget there are proctors around you, just raise your hand at any time!

Estimated duration is 6-8 hours depending on student skill level

# Event-driven FHIR Patient Search
## Introduction
In the Event-driven FHIR Patient Search hack, you will create an instance of Azure API for FHIR and deploy Azure Functions to create a set of auto-generated test patient records and store them in the FHIR Server.  You'll then deploy another Azure Function to retreive the patient data from the FHIR Server and insert them into Azure Event Hub.  This event stream will trigger the execution of another Azure Function that will retrieve the FHIR-based patient recrod in the queue and persist them in Azure Cosmos DB for consumption by the frontend Patient Search web app.

## Learning Objectives
In this hack you will be building a Patient Search web app with a event-driven serverless backend that triggers auto write of patient records to Azure Cosmos DB whenever new patient data is pushed to Azure Event Hub.

## Scenario
In the hack, your team will create the following:
1. Create test patient records in FHIR format
2. Populate patient records in FHIR Server
3. Add event stream from the FHIR Server and push to Azure Event Hub, and then add a trigger to write to Azure Cosmos DB whenever new event arrives in Azure Event Hub
4. Create Patient Search API to be consumed in a web app
5. Build a Patient Search frontend web app to display patient records and a search function to lookup patient record

## Challenges
1. Prepare your auto-generated FHIR data and FHIR Server
   - Develop a serverless function to auto-generate FHIR-format patient data. Sample NodeJS code snippet to be provided.
   - Provision Azure API for FHIR service in Azure to be use for staging FHIR patient data.
2. Load patient data into FHIR Server
   - Provision Azure Cosmos DB
   - Develop a serverless function to get auto-generated patient data into FHIR Server.  Sample NodeJS code snippet to be provided.
3. Deploy Event-driven architecture to read patient record from FHIR Server and store them in Azure Cosmos DB
   - Provision Azure Event Hubs
   - Develop a serverless function to trigger auto write patient data to Azure Cosmos DB whenever new patient event data arrives in Azure Event Hub
   - (Optional) Alternatively, use real-time event streaming service to get data into Azure Cosmos DB from Azure Event Hub.
4. Build Patient Search API
   - Provision Azure Search to create a patient search index on top of Azure Cosmos DB.
   - Expose Azure Search indexer via REST API for consumption in Patient Search Web App
   - Create Azure Functions as the frontend to call the Azure Search index API.
5. Build a Patient Search web app to display patient records
   - Create web app, i.e. React, Java, etc., to display a list of patient data
   - Implement a search box to find a ptient record in Azure Cosmos DB by calling the Patient Search indexer API

## Prerequisites
- Your own Azure subscription with Owner (minimum Contributor) access 
- Visual Studio Code with Azure Functions extension
- Azure CLI
- Node module

## Repository Contents
- `../Coach`
  - Coach's Guide and solution files
   - `../Solutions/Soluitonxx.md`
  - `./readme.md`
- `../Student`
  - Student's Challenge Guide and resource folders
  - `./Challengexx.md`
  - `../Resources/Challengexx-xxx/`

## Contributors
- Richard Liang
- Peter Laudati
- Gino Filicetti


