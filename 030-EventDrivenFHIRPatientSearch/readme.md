# Welecome to the Event Driven FHIR Patient Search Hack!

This is a challenge-based hack. It's NOT step-by-step. Don't worry, you will do great whatever your level of experience! You will be guided through different tasks to implement a Patient Search app by leveraging FHIR API in an event driven architecture within Azure using a combination of Azure API for FHIR, Azure Functions, Azure Event Hubs, Azure Cosmos DB, Azure Search and Azure Storage. The goal is to build a centralized environment to host a FHIR server that is pre-populated with patient data.  You will be using Azure API for FHIR managed service and populated it with dummy patient data. You'll then build an Event Driven architecture that triggers writes to Azure Cosmos DB whenever patient data are retrieved from the FHIR Server and pushed to an instance of Event Hub.  Finally, you will implement Azure search to index the patient data stored in Cosmos DB, and build a patient search frontend web app to display the patient data and search for patients by calling the exposed Azure Search indexer API. The intent is to have you practice the tools, technologies and services our partners are asking you about. Let's try to go out of your comfort zone, try and learn something new. And let's have fun! And don't forget there are proctors around you, just raise your hand at any time!

Estimated duration is 6-8 hours depending on student skill level

# Event Driven FHIR Patient Search
## Introduction
In the Event Driven FHIR Patient Search hack, you will create an instance of Azure API for FHIR and deploy Azure Function to create a set of dummy patient records and store them in the FHIR Server.  You'll then deploy another Azure Function to retreive the patient data from the FHIR Server and insert them into an instance of Event Hub queue.  This will trigger execution of another Azure Function that will retrieve the FHIR-based patient recrod in the queue and persist them in Azure Cosmos DB for consumption by a frontend web app, i.e. React.

## Learning Objectives
In this hack you will be building a patient search web app with a event-driven serverless backend that calls FHIR Server APIs to ingest the patient data and perist them in Cosmos DB.

## Scenario
the team will create the following:
1. Product patient records in FHIR format and persist in the FHIR Server
2. Setup event stream from the FHIR Server and push the data to Event Hub
3. Develop an Azure Function Event Hub trigger (Source) to listen and write data to Azure Cosmos DB output (Sink). 
4. Repeat above without code using Streaming Analytics Azure service.  Setup Streaming Analytics service to ingest data from Event Hub input source, process the data and store them in Azure Cosmos DB output source.
5. Setup Azure Search to create a search index on Azure Cosmos and expose an API to be consumed by the web app for the patient search implementation.

## Challenges
1. Prepare your auto-generated FHIR data and FHIR Server
   - Develop a serverless function to auto-generate your FHIR data. Sample NodeJS code snippet to be provided.
   - Provision Azure API for FHIR service in Azure for data ingestion
2. Read patient record from FHIR Server and store them in Azure Cosmos DB
   - Provision Azure Cosmos DB
   - Use serverless function to get data into Azure Cosmos DB.  Sample NodeJS code snippet to be provided.
3. Build index on top of patient dataset in Azure Cosmos DB
   - Provision Azure Search to create a paitent search index on Azure Cosmos DB.
4. Expose Azure Search index via a REST API for consumption in the Web App
   - Create Azure Function as the frontend to call the Azure Search index API.
5. Create a JavaScript web app, i.e. React, Java, etc., to call the Patient Search API and list the results
   - Figure out the scale problem in the world of IoT. How do you hand trillions of data points of telemetry?

## Prerequisites
- Your own Azure subscription with Owner access
- Visual Studio Code with Azure Function extension
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
