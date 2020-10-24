# Event-driven FHIR Patient Search
## Introduction
In the Event-driven FHIR Patient Search hack, you will be guided through a sequence of challenges to implement an event-driven Patient Search soluton that displays a paginated list of patients and a search box to lookup patient record.

First, you will provision an instance of Azure API for FHIR and then deploy a serverless app in Azure Functions that auto-generates test patient records and store them in the FHIR Server.  You'll then deploy another Azure Function to retreive the patient data from the FHIR Server and insert them into Azure Event Hubs queue.  This event stream will trigger the execution of another Azure Function that will retrieve patient recrods in the queue and persist them in Azure Cosmos DB for consumption by the frontend Patient Search web app. 

## Learning Objectives
In this hack you will be building a Patient Search web app with a event-driven serverless backend that triggers auto write of patient records to Azure Cosmos DB whenever new patient data is pushed to Azure Event Hub.  You will be using a combination of Azure managed services to perform the following:
1. Azure API for FHIR as a centralized FHIR-based data store and populated it with the auto-generated test patient data in FHIR format.
2. Azure Event Hubs event-driven architecture that stores the event stream of patient records from the FHIR Server.
3. Azure Functions Event Hub trigger binding that triggers writes to Azure Cosmos DB whenever patient data are retrieved from the FHIR Server and pushed to Azure Event Hub queue..
4. Azure Search to index patient data stored in Azure Cosmos DB and expose an indexer API for consumption in a Web App.

## Scenario
In the hack, your team will build the following usage scenarios:
1. Extract patient data from EHR system in FHIR-based format.  In this challenge you will auto-generate the test patient data programatically.
2. Expose patient data via FHIR-based APIs and data model
3. Build a NoSQL database backend to support patient search modern frontend web app 
4. Build an event-driven architecture to stream patient data from FHIR Server to Cosmos DB
5. Build a Patient Search frontend web app to display patient records and a search function to lookup indexed patient record

## Challenges
- Challenge 0: **[Pre-requisites - Ready, Set, GO!](Student/challenge00.md)**
   - Prepare your workstation to work with Azure Functions, Azure Cosmos DB, Azure Search, Azure Event Hubs, and Azure App Services.
- Challenge 1: **[Prepare your auto-generated FHIR data and FHIR Server](Student/challenge01.md)**
   - Develop a serverless function to auto-generate FHIR-format patient data. Sample NodeJS code snippet to be provided.
   - Provision Azure API for FHIR service in Azure to be use for staging FHIR patient data.
- Challenge 2: **[Load patient data into FHIR Server](Student/challenge02.md)**
   - Provision Azure Cosmos DB
   - Develop a serverless function to get auto-generated patient data into FHIR Server.  Sample NodeJS code snippet to be provided.
- Challenge 3: **[Deploy Event-driven architecture to read patient record from FHIR Server and store them in Azure Cosmos DB](Student/challenge03.md)**
   - Provision Azure Event Hubs
   - Develop a serverless function to trigger auto write patient data to Azure Cosmos DB whenever new patient event data arrives in Azure Event Hub
   - (Optional) Alternatively, use real-time event streaming service to get data into Azure Cosmos DB from Azure Event Hub.
- Challenge 4: **[Build Patient Search API](Student/challenge04.md)**
   - Provision Azure Search to create a patient search index on top of Azure Cosmos DB.
   - Expose Azure Search indexer via REST API for consumption in Patient Search Web App
   - Create Azure Functions as the frontend to call the Azure Search index API.
- Challenge 5: **[Build a Patient Search web app to display patient records](Student/challenge05.md)**
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
  - [Lecture presentation](Coach/Lectures.pptx) with short presentations to introduce each challenge.
- `../Coach/Solutions`
   - Example solutions to the challenges (If you're a student, don't cheat yourself out of an education!)
- `../Student/Resources`
   - Node.js app code and sample templates to aid with challenges

## Contributors
- Richard Liang
- Peter Laudati
- Gino Filicetti
- Brett Philips (Athena Health)


