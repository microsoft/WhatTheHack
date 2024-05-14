# Challenge 0: Pre-requisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge>](./Challenge01.md)

## Pre-requisites

**Make sure that you have joined Teams group for this track.  The first person on your team at your table should create a new channel in this Team with your team name.**

## Introduction

This hack presents a series of challenges to help learners build knowledge, experience, and skills in working with Azure Health Data Services. It features solutions for use in real-world health data production environments. After working through the challenges, learners will have a better understanding of how to build their own solutions using the latest health data tools from Microsoft.

In general, you will walk away with the capabilities of Azure Health Data Services platform and a sense of confidence in deploying, configuring, and implementing health data solutions within the platform.  You will know how to ingest, transform, and connect health data using the Azure Health Data Service platform, and understand how these components fit together, which will prepare you to use Microsoft's health data tools in real-world solutions.

Prerequisit knowledge in the following area is needed in completing this hack:
- A solid foundation in Azure fundamentals and basic knowledge of Azure Active Directory
- Familiarity with FHIR® and the solutions it provides versus other health data formats
- Experience with making RESTful API requests using Postman or a similar API testing tool (like cURL or Fiddler)
- Experience using Postman as your API testing tool

Thank you for participating in the FHIR Powered Healthcare What The Hack. Before you can hack, you will need to set up some prerequisites.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

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

Your coach will provide you with a `Resources.zip` file that contains resources you will need to complete the hack. If you plan to work locally, you should unpack it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unpack it there.

Please install these additional tools:

- **[.NET Core 3.1](https://dotnet.microsoft.com/download/dotnet-core/3.1)**
- **[Java 1.8 JDK](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)** (Used in challenge 1 for compiling Synthea Patient Generator tool)
- **[Node Module Extension for VS Code](https://code.visualstudio.com/docs/nodejs/extensions)** (Used in challenge 3 for Patient Search app development)
- **[App Service extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureappservice)** (Used in challenge 3 for Patient Search app deployment)
- **[Node.js Window Installer](https://nodejs.org/en/download/)** (Used in challenge 3 for Patient Search app development)
- **[Node.js and npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)** (Used in challenge 3 for Patient Search app development)
- **[Postman](https://www.getpostman.com)** (Used in various challenges for API testing of Azure Health Data Services endpoints)

## Success Criteria

- You have verified Azure Subscription is ready for use
- You have validated Powershell is installed
- You have validated Azure Ad and Az modules are installed
- You have validated Bash shell (WSL, Mac, Linux or Azure Cloud Shell) is installed
- You have validated .NET Core is installed
- You have validated Java JDK is installed
- Youh ave validated Visual Studio Code and required extensions are installed
- You have validated Node.js and npm are installed
- You have validated Postman is installed

## Learning Resources

- **[Azure Health Data Services](https://docs.microsoft.com/en-us/azure/healthcare-apis/healthcare-apis-overview)** is a set of managed API services that support multiple health data standards for the exchange of structured data. You can deploy multiple instances of different service types (`FHIR`, `DICOM`, and `MedTech`) that seamlessly work with one another within a workspace.  All service instances within a workspace share a compliance boundary and common configuration settings.
- **[FHIR service in Azure Health Data Services](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/)** is a managed, centralized Fast Healthcare Interoperability Resources (FHIR®) Compliant data management solution to ingest, manage, and persist Protected Health Information (PHI) in the cloud.  It enables rapid exchange of data through FHIR APIs, backed by a managed Platform-as-a Service (PaaS) offering for high performance and low latency.  
- **[FHIR Bulk Load](https://github.com/microsoft/fhir-loader)** is an OSS Function App solution for bulk ingestions of FHIR Bundle (compressed and non-compressed) and NDJSON files that is triggered whenever new or modified BLOB arrives in the designated BLOB container.  It uses a High Speed Parallel Event Grid that triggers from storage accounts or other event grid resources, and has a comprehensive Auditing, Error logging and Retry for throttled transactions.
- **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** is an open source project that enables conversion of health data from legacy formats to FHIR.  It currently supports four types of conversions, `HL7v2` to `FHIR R4`, `C-CDA` to `FHIR R4`, `JSON` to `FHIR R4` and `FHIR STU3` to `FHIR R4`. The converter uses templates that define mappings between these different data formats. The templates are written in `Liquid` templating language and make use of custom filters.
- **[Tools for Health Data Anonymization](https://github.com/microsoft/Tools-for-Health-Data-Anonymization/blob/master/docs/FHIR-anonymization.md)** is available as a command line tool, Azure Data Factory (ADF) pipeline or De-identified `$export` operation in FHIR service to export and anonymize FHIR data.
- **[Azure Event Hubs](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-about)** is an event-driven architecture used by `MedTech service` to ingest and asynchronously processes millions of IoT medical device data over the Internet in real time for persistence into the `FHIR service`.
- **[Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)** is used in the `FHIR-Bulk Loader` pipeline to provide services for ingesting FHIR data.
- **[Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/overview)** to host the frontend web app to search for patient(s) stored in FHIR service and display the results in web page(s).
- **[Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/)** is Azure's cloud ETL service for scale-out serverless data integration and data transformation.  The ADF pipeline is one of the options in `Tools for Health Data Anonymiation` that reads from an Azure blob container, anonymizes it as per the configuration file, and writes the output to another blob container.
- **[Azure Batch](https://docs.microsoft.com/en-us/azure/batch/)** runs large-scale applications efficiently in the cloud, and is used in the `Tools for Health Data Anonymization` to perform the deidentification.
- **[Azure Blob Storage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction)** is Microsoft's object storage solution, optimized for storing massive amounts of unstructured data. 
- **[Azure Data Lake Store Gen2](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction)** is a set of capabilities dedicated to big data analytics, is the result of converging the capabilities of our two existing storage services, Azure Blob storage and Azure Data Lake Storage Gen1.
- **[Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/)** is Azure storage management used to upload, download, and manage Azure blobs, files, queues, and tables, as well as Azure Cosmos DB and Azure Data Lake Storage entities.
- **[VS Code Extension Marketplace](https://code.visualstudio.com/docs/editor/extension-gallery)** lets you browse and install languages, debuggers, and tools to your default VS Code installation to support your development workflow.
- **[Postman](https://learning.postman.com/docs/getting-started/introduction/)** is an API Testing Tool to work with `FHIR`, `DICOM` and `MedTech` services in `Azure Health Data Services`.
  - [Installing and updating Postman](https://learning.postman.com/docs/getting-started/installation-and-updates/)
  - [Navigating Postman](https://learning.postman.com/docs/getting-started/navigating-postman/)
  - [Sending your first request](https://learning.postman.com/docs/getting-started/sending-the-first-request/)
  - [Creating a workspace](https://learning.postman.com/docs/getting-started/creating-your-first-workspace/)
  - [Creating your first collection](https://learning.postman.com/docs/getting-started/creating-the-first-collection/)
  - [Managing environments](https://learning.postman.com/docs/sending-requests/managing-environments/)

