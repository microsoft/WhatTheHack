# Event-driven FHIR Patient Search
## Introduction
Contoso Healthcare Company currently uses FHIR-based data management solution to rapidly exchange data in the HL7 FHIR standard format with Electronic Health Record (EHR) systems and HLS research databases.  To help its medical practitioners manage and lookup patient data, your team's assistance is needed in implementing a new event-driven architecture to automatically stream new patient data to a NoSQL Document database and a frontend web app to display a paginated list of patient search result dataset.  

 
## Learning Objectives
In the Event-driven FHIR Patient Search hack, you will implement a new event-driven architecture to stream patient data stored in a FHIR Server to a NoSQL Document database, and build a patient search frontend to display a paginated list of patients from the search result dataset.

You will be guided through a sequence of challenges to extract, transform and load patient data, and a search function frontend to lookup a patient using the following Azure services:
1. Azure API for FHIR as a centralized FHIR-based data management solution to extract HL7 FHIR Patient data from EHR systems.
2. Azure Event Hubs event-driven architecture that handles the event stream of patient data from the FHIR Server.
3. Azure Functions that triggers write to Azure Cosmos DB whenever patient data are retrieved from the FHIR Server and pushed to Azure Event Hub queue..
4. Azure Search to index patient data persisted in Azure Cosmos DB and exposed the indexer as an API.
5. Azure App Service to host a frontend web app to search for a patient by calling the indexer API and disploy the results in paginated web pages

## Scenario
Contoso Healthcare Company is implementing a new event-driven architecture for streaming patient data from EHR systems to a common NoSQL document store, which will enable its medical practitioners to quickly lookup patient data.  Your team's assistance is needed to implement a new event-driven architecture to stream FHIR-based patient data to a NoSQL Document database and a frontend web app to display a paginated list of patient search result dataset.  

Your team will assist in the build-out of the following scenarios:
1. Extract patient data from EHR systems in FHIR-based standard format.
2. Stream FHIR patient data to a modern NoSQL Document database to suppport a new patient search frontend web app.
3. Index the patient data to enable quick patient lookup. 
4. Provide a web frontend for medical practitioners and administrator to lookup a patient.

## Challenges
- Challenge 0: **[Pre-requisites - Ready, Set, GO!](Student/Challenge00.md)**
   - Prepare your workstation to work with Azure Functions, Azure Cosmos DB, Azure Search, Azure Event Hubs, and Azure App Services.
- Challenge 1: **[Extract patient data](Student/Challenge01.md)**
   - Develop a serverless function to auto-generate FHIR-format patient data. Sample NodeJS code snippet to be provided.
   - Provision Azure API for FHIR service in Azure to ingest FHIR patient data.
- Challenge 2: **[Transform and Load patient data into FHIR Server](Student/Challenge02.md)**
   - Develop a serverless function to load patient data into FHIR Server.  Sample NodeJS code snippet to be provided.
   - Provision Azure Cosmos DB
- Challenge 3: **[Stream patient data from FHIR Server to Azure Cosmos DB](Student/Challenge03.md)**
   - Provision Azure Event Hubs
   - Develop a serverless function to trigger auto write patient data to Azure Cosmos DB whenever new patient event data arrives in Azure Event Hub
   - (Optional) Alternatively, use real-time event streaming service to get data into Azure Cosmos DB from Azure Event Hub.
- Challenge 4: **[Index patient data for patient lookup](Student/Challenge04.md)**
   - Provision Azure Search to create a patient search index on top of Azure Cosmos DB.
   - Expose Azure Search indexer via REST API for consumption in Patient Search Web App
   - Create Azure Functions as the frontend to call the Azure Search index API.
- Challenge 5: **[Display patient search results](Student/Challenge05.md)**
   - Create web app, i.e. React, Java, etc., to display a list of patient data
   - Implement a search box to find a ptient record in Azure Cosmos DB by calling the Patient Search indexer API

## Prerequisites
- Access to an Azure subscription with Owner access
   - If you don't have one, [Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)
- [**Windows Subsystem for Linux (Windows 10-only)**](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [**Azure CLI**](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   - (Windows-only) Install Azure CLI on Windows Subsystem for Linux
   - Update to the latest
   - Must be at least version 2.7.x
- Alternatively, you can use the [**Azure Cloud Shell**](https://shell.azure.com/)
- [**Visual Studio Code**](https://code.visualstudio.com/)
- [**Node Module Extension**](https://code.visualstudio.com/docs/nodejs/extensions)

## Repository Contents
- `../Coach/Guides`
  - [Lecture presentation](Coach/Guides/Lectures.pptx) with short presentations to introduce each challenge.
- `../Coach/Solutions`
   - Example solutions to the challenges (If you're a student, don't cheat yourself out of an education!)
- `../Student/Resources`
   - Node.js app code and sample templates to aid with challenges

## Contributors
- Richard Liang
- Peter Laudati
- Gino Filicetti
- Brett Philips (Athena Health)


