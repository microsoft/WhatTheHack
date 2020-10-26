# Event-driven FHIR Patient Search
## Introduction
Contoso Healthcare Company currently uses a FHIR-based data management solution to rapidly exchange data in the HL7 FHIR standard format with Electronic Health Record (EHR) systems and HLS research databases.  To help its medical practitioners/administrators manage and lookup patient data for day-to-day operations, your team's assistance is needed in implementing a new event-driven architecture to aggregate patient data from various EHR systems into FHIR-based standard format and persist to a consolidated database backend.  You will develope a new frontend web app to display a paginated list of patient search results to support a new Patient Lookup capability.  

 
## Learning Objectives
In the Event-driven FHIR Patient Search hack, you will implement a new event-driven architecture in Azure for streaming patient data and persist them to an aggregated patient data store for patient lookup.  You will build a frontend to lookup patients and display the patient search result in a paginated list of patients.

To get you started, you will be guided through a sequence of challenges to extract, transform, load and search patient data using the following Azure managed services (PaaS):
1. Azure API for FHIR as a centralized FHIR-based data management solution to ingest/transform HL7 FHIR Patient data from EHR systems.
2. Azure Event Hubs for Apache Kafka event-driven architecture that handles data streaming/ingestion of patient data from the FHIR Server.
3. Azure Functions as the event trigger mechanism to auto write patient data to Azure Cosmos DB whenever patient data are retrieved from the FHIR Server and pushed to the Azure Event Hubs partition(s).
4. Azure Search to index patient data persisted in Azure Cosmos DB to optimize patient lookup.
5. Azure App Service to host the frontend web app to lookup patients and display the patient search results in a set of paginated web pages.

## Scenario
Contoso Healthcare Company is implementing a new event-driven architecture for ingest and transform patient data from EHR systems into a FHIR-based standard format and stream them to an aggregated data store, and a new patient lookup frontend to enable medical practitioners and administrators to quickly lookup patients.  This new patient lookup function will provide quick access to patient data for day-to-day operations and management of the medical professionals.  

Your team's assistance is needed to implement this new event-driven ecosystem to build-out the following scenarios:
1. Extract patient data from EHR systems and transform them into a common FHIR-based standard format.
2. Stream these aggregated FHIR patient data into a common data store to suppport a new patient search frontend.
3. Optimize the persisted patient data to enable faster patient lookup through a web/mobile frontend. 
4. Expose patient lookup function through a web or mobile frontend for medical practitioners and administrator to easily and quickly lookup a patient.

## Challenges
- Challenge 0: **[Pre-requisites - Ready, Set, GO!](Student/Challenge00.md)**
- Challenge 1: **[Extract, transform and load patient data](Student/Challenge01.md)**
- Challenge 2: **[Stream FHIR patient data and unit testing](Student/Challenge02.md)**
- Challenge 3: **[Stream patient data with event-driven architecture](Student/Challenge03.md)**
- Challenge 4: **[Index patient data for patient lookup](Student/Challenge04.md)**
- Challenge 5: **[Display patient search results](Student/Challenge05.md)**

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
- `../Student`
  - Student Challenge Guides
- `../Student/Resources`
  - Student's resource files, code, and templates to aid with challenges
- `../Coach`
   - Example solutions to the challenges (If you're a student, don't cheat yourself out of an education!)
- `../Coach/Guides`
  - [Lecture presentation](Coach/Guides/Lectures.pptx) with short presentations to introduce each challenge.

## Contributors
- Richard Liang (Microsoft)
- Peter Laudati (Microsoft)
- Gino Filicetti (Microsoft)
- Brett Philips (athenahealth)


