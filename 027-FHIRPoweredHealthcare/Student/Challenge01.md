# Challenge 1: Extract and load FHIR synthetic Electronic Health Record (EHR)

[< Previous Challenge](./Challenge00.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge02.md)

## Introduction

In this challenge, you will implement the **[FHIR Bulk Loader](https://github.com/microsoft/fhir-loader)** function app-based event-driven architecture to ingest and load patient data in FHIR.  You will generate synthetic FHIR patient data for bulk load into FHIR Server.  To generate synthetic patient data, you will use **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** open source Java tool to simulate patient records in FHIR format.  

### FHIR bulk load scenario
In this scenario, you will deploy a storage account with a BLOB container and copy Synthea generated FHIR patient data files (JSON Bundles) into it.  These FHIR Bundles will be automatically ingested into a FHIR server.  This bulk ingestion process is kicked off by a Event Grid Trigger (blobCreatedEvent) Function App as depicted below:

<center><img src="../images/challenge01-architecture.png" width="550"></center>

## Description

First you will deploy **[Azure Health Data Services workspace](https://docs.microsoft.com/en-us/azure/healthcare-apis/workspace-overview)** and **[deploy a FHIR service](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/fhir-portal-quickstart)** within the workspace.

You will then implement the **[FHIR Bulk Loader](https://github.com/microsoft/fhir-loader)** Function App solution to to ingest and load Synthea generated FHIR patient data into the FHIR service in near real-time.
- Install and configure FHIR Bulk Loader with the deploy **[script](https://github.com/microsoft/fhir-loader/blob/main/scripts/Readme.md#getting-started)**.
- Validate your deployment, check Azure components installed in the specified Resource Group includes the following:
      - Function App with App Insights and Storage
      - Function App Service plan
      - EventGrid
      - Storage Account (with containers)
      - Keyvault

To test FHIR Bulk Loader, you will load Synthea generated FHIR patient data for bulk load into the FHIR service.
- Generate simulated patient data in FHIR format using **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**.
   - Configure the **[Synthea default properties](https://github.com/synthetichealth/synthea#changing-the-default-properties)** for FHIR output.
      - Set Synthea export directory: 
      `exporter.baseDirectory = ./output/fhir`
      - Enable FHIR bundle export: 
      `exporter.fhir.export = true`
      - Generate 1000 patient records: 
      `generate.default_population = 1000`
        
      ```properties
      exporter.baseDirectory = ./output/fhir
      ...
      exporter.ccda.export = false
      exporter.fhir.export = true
      ...
      # the number of patients to generate, by default
      # this can be overridden by passing a different value to the Generator constructor
      generate.default_population = 1000
      ```

      **Note:** The default properties file values can be found at src/main/resources/synthea.properties. By default, synthea does not generate CCDA, CPCDA, CSV, or Bulk FHIR (ndjson). You'll need to adjust this file to activate these features. See the **[wiki](https://github.com/synthetichealth/synthea/wiki)** for more details.

- Load Synthea generated FHIR bundle JSON files
   - Copy from Synthea project subfolder `./output/fhir` to `bundles` BLOB container.
   - You can copy data to Azure Storage using **[Azure AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)** commandline tool or **[Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-storage-explorer#upload-blobs-to-the-container)** user interface.
- Test FHIR bulk load using Postman `FHIR API` collection to retreive FHIR patient data loaded.
   - You can import Postman collection and environment variables for FHIR API from the **[Student Resources folder for Postman](./Resources/Postman)** folder.
   - You need to register your **[public client application](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/use-postman)** to connect Postman desktop app to FHIR Server.

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
- **[Import Postman data, including collections, environments, data dumps, and globals.](https://learning.postman.com/docs/getting-started/importing-and-exporting-data/)**
- **[Access FHIR service using Postman](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/use-postman)**
- **[Postman setup for FHIR service and sample Postman collection](https://github.com/rsliang/azure-healthcare-apis-workshop/blob/main/resources/docs/Postman_FHIR_service_README.md)**
