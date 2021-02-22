# Challenge 0: Pre-requisites - Ready, Set, GO!

**[Home](../readme.md)** - [Next Challenge>](./Challenge01.md)

## Pre-requisites

**Make sure that you have joined Teams group for this track.  The first person on your team at your table should create a new channel in this Team with your team name.**

## Introduction

**Goal** is to complete all pre-requisites needed to finish all challenges.

## Description

**Install the recommended tool set:** 
- Access to an **Azure subscription** with Owner access. **[Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)**
- **[Windows Subsystem for Linux (Windows 10-only)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)**
- **[Windows PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7)** version 5.1
  - Confirm PowerShell version is **[5.1](https://www.microsoft.com/en-us/download/details.aspx?id=54616)** `$PSVersionTable.PSVersion`
  - **[PowerShell modules](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_modules?view=powershell-7)**
    - Confirm PowerShell module versions.  Re-install the required version below (if needed):
      - Az version 4.1.0 
      - AzureAd version 2.0.2.4
        ```PowerShell
        Get-InstalledModule -Name Az -AllVersions
        Get-InstalledModule -Name AzureAd -AllVersions
        ```
- **[Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)**
   - (Windows-only) Install Azure CLI on Windows Subsystem for Linux
   - Update to the latest
   - Must be at least version 2.7.x
- Alternatively, you can use the **[Azure Cloud Shell](https://shell.azure.com/)**
- **[.NET Core 3.1](https://dotnet.microsoft.com/download/dotnet-core/3.1)**
- **[Java 1.8 JDK](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)** (needed to run Synthea Patient Generator tool)
- **[Visual Studio Code](https://code.visualstudio.com/)**
- **[Node Module Extension for VS Code](https://code.visualstudio.com/docs/nodejs/extensions)**
- **[App Service extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureappservice)**
- **[Node.js Window Installer](https://nodejs.org/en/download/)**
- **[Node.js and npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)**
- **[Postman](https://www.getpostman.com)**

## Success Criteria

- Azure Subscription is ready for use
- Powershell is installed
- Azure Ad and Az modules are installed
- Bash shell (WSL, Mac, Linux or Azure Cloud Shell) is installed
- .NET Core is installed
- Java JDK is installed
- Visual Studio Code and required extensions are installed
- Node.js and npm are installed
- Postman is installed

## Learning Resources

- **[Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)**
- **[Setting up Visual Studio Code](https://code.visualstudio.com/docs/setup/setup-overview)**
- **[VS Code Extension Marketplace](https://code.visualstudio.com/docs/editor/extension-gallery)**
- **[NodeJS pre-built installer downloads](https://nodejs.org/en/download/)**
- **[Downloading and installing Node.js and npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)**

- **[Azure API for FHIR](https://docs.microsoft.com/en-us/azure/healthcare-apis/overview)** as a centralized FHIR Compliant data management solution to persist FHIR bundles.
- **[FHIR Bulk Load](https://github.com/microsoft/fhir-server-samples)** for bulk ingestions performed by a function app that is triggered whenever new or modified BLOB arrives in the `fhirimport` BLOB container.
- **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** is a logic app based workflow to ingest and convert C-CDA and HL7v2 message into FHIR bundle.
- **[FHIR Proxy](https://github.com/microsoft/health-architectures/tree/master/FHIR/FHIRProxy)** is a function app solution that acts as an intelligent and secure gateway (reverse proxy) to FHIR Server and provides a consolidated approach to **[pre and post processing](https://github.com/microsoft/health-architectures/tree/master/FHIR/FHIRProxy#pre-and-post-processing-support)** of FHIR Server, i.e. `PublishFHIREventPostProcess` to publish FHIR CUD events for resources to a configured eventhub.  It acts as a FHIR specific reverse proxy rewriting responses and brokering requests to FHIR Servers.
- **[SMART on FHIR](https://docs.microsoft.com/en-us/azure/healthcare-apis/use-smart-on-fhir-proxy)** proxy to integrate partner apps with FHIR Servers and EMR systems through FHIR interfaces.
- **[Azure Event Hubs](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-about)** event-driven architecture that handles FHIR CUD events from the FHIR Server to enable post-processing for topic subscribers to kickoff downstream workflows.
- **[Azure Logic Apps](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-overview)** conversion workflow to ingest C-CDA data, call FHIR Converter API for C-CDA to FHIR bundle conversion and load the resulted FHIR bundle into FHIR Server.
- **[Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)** as the event trigger mechanism to auto ingest and convert HL7v2 messages, pushed to the FHIR Service Bus, into FHIR bundles.
- **[Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/overview)** to host the frontend web app to search for patient(s) stored in FHIR Server and display the results in web page(s).
- **[Azure Batch](https://docs.microsoft.com/en-us/azure/batch/)** runs large-scale applications efficiently in the cloud. Schedule compute-intensive tasks and dynamically adjust resources for your solution without managing infrastructure.
- **[Azure Service Bus](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview)** is a fully managed enterprise integration message broker. Service Bus can decouple applications and services. 
- **[Azure Blob Storage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction)** is Microsoft's object storage solution, optimized for storing massive amounts of unstructured data. 
- **[Azure Data Lake Store Gen2](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction)** is a set of capabilities dedicated to big data analytics, is the result of converging the capabilities of our two existing storage services, Azure Blob storage and Azure Data Lake Storage Gen1.
- **[Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/)** is Azure storage management used to upload, download, and manage Azure blobs, files, queues, and tables, as well as Azure Cosmos DB and Azure Data Lake Storage entities.
- **[Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/)** is Azure's cloud ETL service for scale-out serverless data integration and data transformation.
- **[Azure Databricks](https://docs.microsoft.com/en-us/azure/databricks/scenarios/what-is-azure-databricks)** is an Apache Spark-based analytics platform optimized for the Microsoft Azure cloud services platform. 
- **[Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/)** is a managed, secure, and intelligent product that use the SQL Server database engine in the Azure cloud.
- **[PowerBI](https://docs.microsoft.com/en-us/power-bi/fundamentals/power-bi-overview)** is a collection of software services, apps, and connectors that work together to turn your unrelated sources of data into coherent, visually immersive, and interactive insights.
- **[IoT Central](https://docs.microsoft.com/en-us/azure/iot-central/healthcare/concept-continuous-patient-monitoring-architecture)** helps create, customize, and manage healthcare IoT solutions using IoT Central application templates. Continuous patient monitoring is one application template in healthcare IoT space.



