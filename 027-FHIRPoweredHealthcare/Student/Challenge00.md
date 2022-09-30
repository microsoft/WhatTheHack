# Challenge 0: Pre-requisites - Ready, Set, GO!

**[Home](../readme.md)** - [Next Challenge>](./Challenge01.md)

## Pre-requisites

**Make sure that you have joined Teams group for this track.  The first person on your team at your table should create a new channel in this Team with your team name.**

## Introduction

This hack presents a series of challenges to help learners build knowledge, experience, and skills in working with Azure Health Data Services. It features solutions for use in real-world health data production environments. After working through the challenges, learners will have a better understanding of how to build their own solutions using the latest health data tools from Microsoft.

In general, you will walk away with the capabilities of Azure Health Data Services platform and a sense of confidence in deploying, configuring, and implementing health data solutions within the platform.  You will know how to ingest, transform, and connect health data using the Azure Health Data Service platform, and understand how these components fit together, which will prepare you to use Microsoft's health data tools in real-world solutions.

Thank you for participating in the FHIR Powered Healthcare What The Hack. Before you can hack, you will need to set up some prerequisites.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Windows Subsystem for Linux](../../000-HowToHack/WTH-Common-Prerequisites.md#windows-subsystem-for-linux)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell CmdLets](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
  - [VS Code plugin for ARM Templates](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code-plugins-for-arm-templates)
- [Azure Storage Explorer](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-storage-explorer)

## Description

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specifc to this hack.

Your coach will provide you with a Resources.zip file that contains resources you will need to complete the hack. If you plan to work locally, you should unpack it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unpack it there.

Please install these additional tools:

- [Azure IoT Tools](https://marketplace.visualstudio.com/items?itemName=vsciot-vscode.azure-iot-tools) extension for Visual Studio Code
- .NET SDK 6.0 or later installed on your development machine. This can be downloaded from [here](https://www.microsoft.com/net/download/all) for multiple platforms.

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

- Verify Azure Subscription is ready for use
- Verfiy Powershell is installed
- Verify Azure Ad and Az modules are installed
- Verify Bash shell (WSL, Mac, Linux or Azure Cloud Shell) is installed
- Verfiy .NET Core is installed
- Verify Java JDK is installed
- Verfiy Visual Studio Code and required extensions are installed
- Verfiy Node.js and npm are installed
- Verify Postman is installed

## Learning Resources

- **[Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)**
- **[Setting up Visual Studio Code](https://code.visualstudio.com/docs/setup/setup-overview)**
- **[VS Code Extension Marketplace](https://code.visualstudio.com/docs/editor/extension-gallery)**
- **[NodeJS pre-built installer downloads](https://nodejs.org/en/download/)**
- **[Downloading and installing Node.js and npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)**
- **[Azure Health Data Services](https://docs.microsoft.com/en-us/azure/healthcare-apis/healthcare-apis-overview)** is a set of managed API services that support multiple health data standards for the exchange of structured data. You can deploy multiple instances of different service types (FHIR, DICOM, and MedTech) that seamlessly work with one another within a workspace.  All service instances within a workspace share a compliance boundary and common configuration settings.
- **[FHIR service in Azure Health Data Services](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/)** is a managed, centralized Fast Healthcare Interoperability Resources (FHIR®) Compliant data management solution to ingest, manage, and persist Protected Health Information PHI in the cloud.  It enables rapid exchange of data through FHIR APIs, backed by a managed Platform-as-a Service (PaaS) offering for high performance and low latency.  
- **[FHIR Bulk Load](https://github.com/microsoft/fhir-loader)** is a Function App solution for bulk ingestions of FHIR Bundle (compressed and non-compressed) and NDJSON files that is triggered whenever new or modified BLOB arrives in the designated BLOB container.  It uses a High Speed Parallel Event Grid that triggers from storage accounts or other event grid resources, and has a comprehensive Auditing, Error logging and Retry for throttled transactions.
- **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** is an open source project that enables conversion of health data from legacy formats to FHIR.  It supports four types of conversions, HL7v2 to FHIR, C-CDA to FHIR, JSON to FHIR and FHIR STU3 to R4. The converter uses templates that define mappings between these different data formats. The templates are written in Liquid templating language and make use of custom filters.
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



