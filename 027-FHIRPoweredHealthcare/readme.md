# FHIR Powered Healthcare
## Introduction
Contoso Healthcare is implementing a FHIR ( Fast Healthcare Interoperability Resources) powered event-driven serverless platform to ingest and transform patient data and medical events from EHR (Electronic Health Record) systems into a HL7 FHIR standard format and persist them to a centralized FHIR Compliant store.  To support post-processing of medical events, an event is generated whenever FHIR CRUD (create, read, update and delete) operations occurs in FHIR.  The platform will enable exploration of FHIR patient data through frontend web apps and SMART on FHIR apps.

You will implement a collection of FHIR reference architectures in the Microsoft **[Health Architectures](https://github.com/rsliang/health-architectures)** for FHIR use cases that best fit Contoso Healthcare requirements. Below is the holistic conceptual end-to-end Microsoft Health architectures for Azure API for FHIR.
![Health Architecture](./images/HealthArchitecture.png)

## Learning Objectives
In this FHIR Powered Healthcare hack, you will implement Microsoft Health reference architectures to extract, transform and load patient data into a FHIR Compliant store.  You will deploy an event-driven serverless architecture to ingest HL7v2 messages and publish FHIR CRUD events to an Event Hub.  Topic subscribers to these events can then trigger downstream post-processing workflows whenever new medical event is published.  You will then write JavaScript code to connect and read FHIR data to explore FHIR patient data.

To get you started, you will be guided through a sequence of challenges to implement Microsoft Health Architectures for FHIR Server use cases using the following Azure managed services (PaaS):
1. **[Azure API for FHIR](https://docs.microsoft.com/en-us/azure/healthcare-apis/overview)** as a centralized FHIR Compliant data management solution to persist FHIR bundles.
2. **[FHIR Bulk Load](https://github.com/microsoft/fhir-server-samples)** for bulk ingestions performed by a function app that is triggered whenever new or modified BLOB arrives in the fhirimport BLOB container.
3. **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** is a logic app based workflow to ingest and convert C-CDA and HL7v2 message into FHIR bundle.
4. **[FHIR Event Processor](https://github.com/microsoft/health-architectures/tree/master/FHIR/FHIREventProcessor)** is a function app solution that provides services for ingesting FHIR Resources into FHIR Server and publishes successful FHIR Server CRUD events to an Event Hub for topic subscribers to facilitate FHIR post-processing orchestrated workflows, i.e. CDS, Audits, Alerts, etc.
5. **[FHIR Proxy](https://github.com/rsliang/health-architectures/tree/master/FHIR/FHIRProxy)** is a function app solution that acts as an intelligent and secure gateway (reverse proxy) to FHIR Server and provides a consolidated approach to **[pre and post processing](https://github.com/rsliang/health-architectures/tree/master/FHIR/FHIRProxy#pre-and-post-processing-support)** of FHIR Server, i.e. PublishFHIREventPostProcess to publish FHIR CUD events for resources to a configured eventhub.  It acts as a FHIR specific reverse proxy rewriting responses and brokering requests to FHIR Servers.
6. **[SMART on FHIR](https://docs.microsoft.com/en-us/azure/healthcare-apis/use-smart-on-fhir-proxy)** proxy to integrate partner apps with FHIR Servers and EMR systems through FHIR interfaces.
7. **[Azure Event Hubs](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-about)** event-driven architecture that handles FHIR CRUD events from the FHIR Server to enable post-processing for topic subscribers to kickoff downstream workflows.
8. **[Azure Logic Apps](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-overview)** conversion workflow to ingest C-CDA data, call FHIR Converter API for C-CDA to FHIR bundle conversion and load the resulted FHIR bundle into FHIR Server.
9. **[Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)** as the event trigger mechanism to auto ingest and convert HL7 messages, pushed to the FHIR Service Bus, into FHIR bundles.
10. **[Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/overview)** to host the frontend web app to display the patient search results in a set of paginated web pages.

## Scenario
Contoso Healthcare is implementing a FHIR-based data management solution to rapidly exchange data in the HL7 FHIR standard format with EHR (Electronic Health Record) systems and HLS (Life Science) research databases.  To help its healthcare practitioners and administrators manage and access patient data for day-to-day operations, your team's assistance is needed in implementing new FHIR powered **[Health Architectures](https://github.com/rsliang/health-architectures)**.  This FHIR powered event-driven platform will provide services to ingest and convert patient data from EMR (Electronic Medical Record), Clinical Data, Lab System, Scheduling System, etc. into FHIR Bundles and persist them into a FHIR Compliant store in near real-time.

Your team's assistance is needed to implement this new event-driven FHIR ecosystem to build-out the following scenarios:
1. Ingest and process patient record in HL7 FHIR or legacy formats from EHR systems into a common FHIR-based standard format and persist them into a FHIR Compliant store.
2. Generate FHIR CRUD (create, read, update or delete) events whenever FHIR CRUD operations take place in FHIR for post-processing.
3. Securely connect and read FHIR patient data from FHIR Server through a web app and add a patient lookup function to improve user experience.
4. Explore a patient's medical records and encounters in FHIR Patient Dashboard and SMART on FHIR apps.

## Challenges
- Challenge 0: **[Pre-requisites - Ready, Set, GO!](Student/Challenge00.md)**
- Challenge 1: **[Extract and load FHIR patient medical records](Student/Challenge01.md)**
- Challenge 2: **[Extract, transform and load patient clinical data](Student/Challenge02.md)**
- Challenge 3: **[Ingest and stream medical events for post-processing](Student/Challenge03.md)**
- Challenge 4: **[Connect to FHIR Server and read FHIR data through a JavaScript app](Student/Challenge04.md)**
- Challenge 5: **[Explore patient medical records and encounters through FHIR Patient Dashboard and SMART on FHIR apps](Student/Challenge05.md)**
- Challenge 6: **[Create a new Single Page App (SPA) for patient search](Student/Challenge06.md)**

## Disclaimer
**You MUST be able to log into your Azure subscription and connect to Azure AD primary tenant with directory admin role access (or secondary tenant if you don't have directory admin role access) required for the FHIR Server Sample deployment (challenge 1).**
  - **If you have full Administrator directory access to your AD tenant where you can create App Registrations, Role Assignments, Azure Resources and grant login directory admin consent, then your Primary AD tenant is same as Secondary AD tenant and should use the same AD tenant for both.**
  - **If you don't have directory Administrator access:**
      - **Primary (Resource) AD tenant: This tenant is Resource Control Plane where all your Azure Resources will be deployed to.**
      - **Secondary (Data) AD tenant: This tenant is Data Control Plane where all your App Registrations will be deployed to.**

## Prerequisites
- Access to an Azure subscription with Owner access
   - If you don't have one, **[Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)**
- **[Windows Subsystem for Linux (Windows 10-only)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)**
- **[Windows PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7)** version 5.1
  - Confirm PowerShell version is **[5.1](https://www.microsoft.com/en-us/download/details.aspx?id=54616)** `$PSVersionTable.PSVersion`
  - **[PowerShell modules](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_modules?view=powershell-7)**
    - Confirm PowerShell module versions.  Re-install the required version below (if needed):
      - Az version 4.1.0 
      - AzureAd version 2.0.2.4
        ```
        Get-InstalledModule -Name Az -AllVersions
        Get-InstalledModule -Name AzureAd -AllVersions
        ```
- **[Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)**
   - (Windows-only) Install Azure CLI on Windows Subsystem for Linux
   - Update to the latest
   - Must be at least version 2.7.x
- Alternatively, you can use the **[Azure Cloud Shell](https://shell.azure.com/)**
- **[.NET Core 3.1](https://dotnet.microsoft.com/download/dotnet-core/3.1)**
- **[Java 1.8 JDK](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)**
- **[Visual Studio Code](https://code.visualstudio.com/)**
- **[Node Module Extension](https://code.visualstudio.com/docs/nodejs/extensions)**
- **[App Service extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureappservice)**
- **[Download Node.js Window Installer](https://nodejs.org/en/download/)**
- **[Download and install Node.js and npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)**
- **[Postman](https://www.getpostman.com)**

## Repository Contents
- `../Student`
  - Student Challenge Guides
- `../Student/Resources`
  - Student's resource files, code, and templates to aid with challenges
- `../Coach`
   - Example solutions to the challenges (If you're a student, don't cheat yourself out of an education!)
   - [Lecture presentation](Coach/Lectures.pptx) with short presentations to introduce each challenge.
- `../Coach/Resources`
  - Coach's guide to solutions for challenges, including tips/tricks.

## Contributors
- Richard Liang (Microsoft)
- Peter Laudati (Microsoft)
- Gino Filicetti (Microsoft)


