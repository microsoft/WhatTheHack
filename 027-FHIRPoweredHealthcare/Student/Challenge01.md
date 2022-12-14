# Challenge 1: Extract and Load FHIR EHR Data

[< Previous Challenge](./Challenge00.md) - **[Home](../README.md)** - [Next Challenge>](./Challenge02.md)

## Introduction

In this challenge, you will implement the **[FHIR Bulk Loader](https://github.com/microsoft/fhir-loader)** function app-based event-driven architecture to ingest and load patient data in FHIR.  You will generate synthetic FHIR patient data for bulk load into FHIR Server.  To generate synthetic patient data, you will use the **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** open source Java tool to simulate patient records in FHIR format.  

### FHIR bulk load scenario
In this scenario, you will deploy a storage account with a BLOB container and copy Synthea generated FHIR patient data files (JSON Bundles) into it.  These FHIR Bundles will be automatically ingested into a FHIR server.  This bulk ingestion process will be kicked-off by an Event Grid Trigger (blobCreatedEvent) Function App as depicted below:

<center><img src="../images/challenge01-architecture.png" width="550"></center>

## Description

First you will deploy **[Azure Health Data Services workspace](https://docs.microsoft.com/en-us/azure/healthcare-apis/workspace-overview)** and **[deploy a FHIR service](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/fhir-portal-quickstart)** within the workspace.

You will then implement the **[FHIR Bulk Loader](https://github.com/microsoft/fhir-loader)** Function App solution to ingest and load Synthea generated FHIR patient data into the FHIR service in near real-time.
- Install and configure FHIR Bulk Loader with the deploy **[script](https://github.com/microsoft/fhir-loader/blob/main/scripts/Readme.md#getting-started)**.
- Validate your deployment, check Azure components installed:
   - Function App with App Insights and Storage
   - Function App Service plan
   - EventGrid
   - Storage Account (with containers)
   - Key Vault

To test the FHIR Bulk Loader, you will copy Synthea generated test FHIR patient data files to a specified Data Lake storage for bulk load into the FHIR service.
- Generate simulated patient data in FHIR format using **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**.
   - Configure the **[Synthea default properties](https://github.com/synthetichealth/synthea#changing-the-default-properties)** for FHIR output.  Below are the recommended properties setting for this challenge:
      - Set Synthea export directory: 
      `exporter.baseDirectory = ./output/fhir`
      - Enable FHIR bundle export: 
      `exporter.fhir.export = true`
      - Generate 1000 patient records: 
      `generate.default_population = 1000`
        
 - Load Synthea generated FHIR bundle JSON files
   - Copy from Synthea project subfolder `./output/fhir` to `bundles` BLOB container.
   - You can copy data to Azure Storage using **[Azure AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)** commandline tool or **[Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-storage-explorer#upload-blobs-to-the-container)** user interface.
- Test the results of FHIR bulk load using Postman `FHIR API` collection to retreive FHIR patient data loaded.
   - You need to first register your **[public client application](https://learn.microsoft.com/en-us/azure/healthcare-apis/register-application)**  to connect Postman desktop app to FHIR service in Azure Health Data Services.
   - Then **[Configure RBAC roles](https://learn.microsoft.com/en-us/azure/healthcare-apis/configure-azure-rbac)**  to assign access to the Azure Health Data Services data plane.
   - To **[access FHIR service using Postman](https://learn.microsoft.com/en-us/azure/healthcare-apis/fhir/use-postman)**, you need to import the FHIR API Postman collection and environment variables:
      - You can find the Postman template files (`WTHFHIR.postman_collection.json` and `WTHFHIR.postman_environment.json`) in the `/Postman` folder of the Resources.zip file provided by your coach. 
      - **[Import](https://learning.postman.com/docs/getting-started/importing-and-exporting-data/)** the environment and collection template files into your Postman
      - Configure Postman environment variables specific to your FHIR service instance

## Success Criteria

   - You have provisioned FHIR service and FHIR Bulk Load environment in Azure.
   - You have generated synthetic patient data in FHIR format.
   - You have loaded FHIR patient data into FHIR Server.
   - You have retrieved the new FHIR patient data using Postman.

## Learning Resources

- **[What is Azure Health Data Services?](https://docs.microsoft.com/en-us/azure/healthcare-apis/healthcare-apis-overview)**
- **[Get started with FHIR service](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/get-started-with-fhir)**
- **[FHIR Bulk Loader](https://github.com/microsoft/fhir-loader)**
- **[Synthea Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**
- **[Synthea wiki](https://github.com/synthetichealth/synthea/wiki)**
- **[Copy data to Azure Storage using Azure AzCopy tool](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
- **[Copy data to Azure Storage using Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-storage-explorer#upload-blobs-to-the-container)** 
- **[Register a client application in Azure Active Directory](https://learn.microsoft.com/en-us/azure/healthcare-apis/register-application)**
- **[Import Postman data, including collections, environments, data dumps, and globals.](https://learning.postman.com/docs/getting-started/importing-and-exporting-data/)**
- **[Access FHIR service using Postman](https://learn.microsoft.com/en-us/azure/healthcare-apis/fhir/use-postman)**
- **[Configure RBAC roles](https://learn.microsoft.com/en-us/azure/healthcare-apis/configure-azure-rbac)**
