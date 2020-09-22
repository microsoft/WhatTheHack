# Welecome to the Event-driven FHIR Patient Search Hack!

This is a challenge-based hack. It's NOT step-by-step. Don't worry, you will do great whatever your level of experience! You will be guided through different tasks to implement a Patient Search app by leveraging FHIR API in an event driven architecture within Azure.  You will be using a combination of Azure API for FHIR, Azure Functions, Azure Event Hubs, Azure Streaming Analytics, Azure Cosmos DB, Azure Search and Azure Storage. The goal is to build a centralized environment to host a FHIR server that is pre-populated with patient data.  You will be using Azure API for FHIR managed service and populated it with the auto-generated test patient data. You'll then build an Event-driven architecture that triggers writes to Azure Cosmos DB whenever the patient data are retrieved from the FHIR Server and pushed to an instance of Event Hub.  Finally, you will implement Azure search to index the patient data stored in Azure Cosmos DB, and build a patient search frontend web app to display the patient data and includes a search box for finding patient record by calling the exposed Azure Search indexer API. 

The intent of the hack is to have you practice the tools, technologies and services our partners are asking you about.  Let's try to go out of your comfort zone, try and learn something new.  And let's have fun!  And don't forget there are proctors around you, just raise your hand at any time!

Estimated duration is 6-8 hours depending on student skill level

# Event-driven FHIR Patient Search
## Introduction
In the Event-driven FHIR Patient Search hack, you will create an instance of Azure API for FHIR and deploy Azure Functions to create a set of auto-generated test patient records and store them in the FHIR Server.  You'll then deploy another Azure Function to retreive the patient data from the FHIR Server and insert them into an instance of Event Hub queue.  This will trigger execution of another Azure Function that will retrieve the FHIR-based patient recrod in the queue and persist them in Azure Cosmos DB for consumption by the frontend Patient Search web app.

## Learning Objectives
In this hack you will be building a Patient Search web app with a event-driven serverless backend that calls FHIR Server APIs to ingest the patient data in a Event Hub queue, which will automatically trigger another serverless function that will perist them in Azure Cosmos DB.

## Scenario
In the hack, your team will create the following:
1. Auto-generate test patient records in FHIR format and persist them in FHIR Server
2. Setup event stream from the FHIR Server and push the data to Event Hub
3. Develop Azure Functions with Trigger binding for Azure Event Hub to listen for new events and write the event data to the Azure Cosmos DB Output binding.  
   - Repeat above with no code using real-time streaming with Azure Streaming Analytics.  Setup Azure Streaming Analytics service to ingest data from the Azure Event Hub Input source, process the data and then store them in Azure Cosmos DB Output source.
4. Setup Azure Search to create a search indexer on Azure Cosmos DB patient dataset and expose an API to be consumed by the web app for the patient search implementation.
5. Build a Patient Search web app to display a list of patients stored in Azure Cosmos DB and implement a search box to find patient record by calling the Azure Search indexer API.

## Challenges
1. Prepare your auto-generated FHIR data and FHIR Server
   - Develop a serverless function to auto-generate your FHIR data. Sample NodeJS code snippet to be provided.
   - Provision Azure API for FHIR service in Azure for data ingestion
2. Load patient data into FHIR Server
   - Provision Azure Cosmos DB
   - Use serverless function to get data into Azure Cosmos DB.  Sample NodeJS code snippet to be provided.
3. Read patient record from FHIR Server and store them in Azure Cosmos DB
   - Provision Azure Cosmos DB
   - Use serverless function to get data into Azure Cosmos DB.  Sample NodeJS code snippet to be provided.
   - (Optional) Use real-time streaming service to get data into Azure Cosmos DB.
4. Build index for Patient Search
   - Provision Azure Search to create a paitent search index on top of Azure Cosmos DB.
   - Expose Azure Search index via a REST API for consumption in the Web App
   - Create Azure Function as the frontend to call the Azure Search index API.
5. Build a Patient Search web app to display patient record
   - Create a web app, i.e. React, Java, etc., to call the Patient Search API and list the results

## Prerequisites
- Your own Azure subscription with Owner (minimum Contributor) access 
- Visual Studio Code with Azure Functions extension
- Azure CLI
- Node module

## Repository Contents (Optional)
- `../Coach/Guides`
  - Coach's Guide and related files
  - `../Lectures`
  - `./Proctor Guide.docx`
  - `./Screnario Design.docx`
- `../Student/Guides`
  - Student's Challenge Guide
  - Sample Code
  - `../Code/datagen.js`
  - `../Code/dataread.js`

## Contributors
- Richard Liang
- Peter Laudati
- Gino Filicetti


