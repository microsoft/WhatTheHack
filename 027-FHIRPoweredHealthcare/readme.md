# FHIR Powered Healthcare
## Introduction
Contoso Healthcare is implementing a FHIR-based data management solution to rapidly exchange data in the HL7 FHIR standard format with Electronic Health Records (EHR) systems and Health and Life Science (HLS) research databases.  To help its medical practitioners/administrators manage and access patient data for day-to-day operations, your team's assistance is needed in implementing new FHIR powered event-driven health architectures to aggregate and convert patient data from disparate EHR systems into FHIR-based standard format and persist them to a FHIR Compliant store.

You will leverage Health Architecture samples and implement its collection of reference architectures for Azure API for FHIR use cases that best fit Contoso Healthcare requirements. Below is the holistic conceptual end to end Microsoft Health architecture for Azure API for FHIR.
![Health Architecture](./images/HealthArchitecture.png)

 
## Learning Objectives
In the FHIR Powered Healthcare hack, you will implement healthcare reference architecture samples in Azure to extract, transform and load patient data in standardize FHIR format to a FHIR Compliant store to support patient recrord access frontends.  You will deploy a FHIR Event Processing event-driven architecture to publish FHIR CRUD events to an Event Hub.  Consumers subcribed to these events can trigger downstream workflows whenever a new event is published.

To get you started, you will be guided through a sequence of challenges to implement Health Architecture for FHIR server use cases using the following Azure managed services (PaaS):
1. **[Azure API for FHIR](https://docs.microsoft.com/en-us/azure/healthcare-apis/overview)** as a centralized FHIR Compliant data management solution to persist FHIR bundles.
2. **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** to ingest and convert C-CDA or HL7 message into FHIR bundle.
3. **[FHIR Event Processor](https://github.com/microsoft/health-architectures/tree/master/FHIR/FHIREventProcessor)** is a function app solution that provides services for ingesting FHIR Resources into FHIR server and publishes successful FHIR server CRUD events to an Event Hub for topic subscribers to facilitate FHIR post-processing orchestrated workflows, i.e. CDS, Audits, Alerts, etc.
4. **[FHIR Proxy](https://github.com/rsliang/health-architectures/tree/master/FHIR/FHIRProxy)** is a function app solution that acts as an intelligent and secure gateway (reverse proxy) to FHIR server and provides a consolidated approach to **[pre and post processing](https://github.com/rsliang/health-architectures/tree/master/FHIR/FHIRProxy#pre-and-post-processing-support)** of FHIR server, i.e. PublishFHIREventPostProcess to publish FHIR CUD events for resources to a configured eventhub.  It acts as a FHIR specific reverse proxy rewriting responses and brokering requests to FHIR servers
5. **[SMART on FHIR](https://docs.microsoft.com/en-us/azure/healthcare-apis/use-smart-on-fhir-proxy)** proxy to integrate partner apps with FHIR servers and EMR systems through FHIR interfaces.
6. **[FHIR Bulk Load](https://github.com/microsoft/fhir-server-samples)** for bulk ingestions performed by a function app that is triggered whenever new or modified BLOB arrives in the fhirimport BLOB container.
7. **[Azure Event Hubs](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-about)** event-driven architecture that handles FHIR CRUD events from the FHIR Server to enable post-processing for topic subscribers to kickoff downstream workflows.
8. **[Azure Logic Apps](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) conversion workflow to ingest C-CDA data, call FHIR Converter API for C-CDA to FHIR bundle conversion and load the resulted FHIR bundle into FHIR server.
9. **[Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)** as the event trigger mechanism to auto ingest and convert HL7 messages, pushed to the FHIR Service Bus, into FHIR bundles.
10. **[Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/overview)** to host the frontend web app to display the patient search results in a set of paginated web pages.

## Scenario
Contoso Healthcare is implementing a new FHIR powered event-driven architecture to ingest and transform patient data from multiple EHR systems in legacy formats into a FHIR standard format and load them to a centralized FHIR Compliant store.  A new patient search frontend will enable medical practitioners and administrators to quickly lookup patients.  It will provide medical professionals quick access to patient data needed in day-to-day operations and management in a common frontend.  

Your team's assistance is needed to implement this new event-driven FHIR ecosystem to build-out the following scenarios:
1. Extract and transform patient data from EHR systems into a centralized FHIR standard format.
2. Import and process valid HL7 messages into FHIR bundles, persist them into a FHIR Compliant store and publish the successful FHIR CRUD events to an Event Hub for post-processing.
3. Create a sample JavaScript app that securely connects and reads FHIR data from FHIR server.
4. Explore the use of SMART on FHIR applications with the Azure API for FHIR to to integrate partner apps with FHIR servers and EMR systems through FHIR interfaces.
5. Extend the sample JavaScript app to improve the user experience, such as patient lookup, paginated web pages.

## Challenges
- Challenge 0: **[Pre-requisites - Ready, Set, GO!](Student/Challenge00.md)**
- Challenge 1: **[Extract, transform (convert) and load patient data](Student/Challenge01.md)**
- Challenge 2: **[Stream FHIR CRUD events to Event Hub for topic subscribers](Student/Challenge02.md)**
- Challenge 3: **[Deploy JavaScript app to connect to FHIR server and read FHIR data](Student/Challenge03.md)**
- Challenge 4: **[Deploy SMART on FHIR app with FHIR server](Student/Challenge04.md)**
- Challenge 5: **[Extend JavaScript app to improve the user experience](Student/Challenge05.md)**

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
   - [Lecture presentation](Coach/Lectures.pptx) with short presentations to introduce each challenge.
- `../Coach/Resources`
  - Coach's guide to solutions for each challenge, including tips/tricks.

## Contributors
- Richard Liang (Microsoft)
- Peter Laudati (Microsoft)
- Gino Filicetti (Microsoft)


