# Challenge 1: Extract and load FHIR synthetic Electronic Health Record (EHR)

[< Previous Challenge](./Challenge00.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge02.md)

## Introduction

In this challenge, you will implement the **[FHIR Bulk Loader](https://github.com/microsoft/fhir-loader)** function app-based event-driven architecture to ingest and load patient data in FHIR.  You will generate synthetic FHIR patient data for bulk load into FHIR Server.  To generate synthetic patient data, you will use **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** open source Java tool to simulate patient records in FHIR format.  

### FHIR bulk load scenario
In this scenario, you will deploy a storage account with a BLOB container called `bundles`.  Synthea generated FHIR patient data files (JSON Bundles) are copied into this storage container, and automatically ingested into FHIR Server.  This bulk ingestion is performed by a Event Grid Trigger (blobCreatedEvent) Function App as depicted below:

<center><img src="../images/challenge01-architecture.png" width="550"></center>

## Description

You will implement the FHIR Bulk Load Function App solution as follows:
- Prequiste for deployment
   - Azure Health Data Services FHIR service
- Deploy **[FHIR Bulk Loader](https://github.com/microsoft/fhir-loader)** PaaS scenario (above) to ingest and bulk load Synthea generated FHIR patient data into FHIR Server in near real-time.
   - Validate your deployment, check Azure resources created in `{ENVIRONMENTNAME}` Resource Group includes the following Azure services:
      - Storage Account
      - App Service Plan
      - Function App
      - Event Grid
      - Key Vault
      - Application Insights

- Generate simulated patient data in FHIR format using **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**.

   - Update the **[default properties](https://github.com/synthetichealth/synthea#changing-the-default-properties)** for FHIR output
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

- Copy Synthea generated FHIR bundle JSON files in its `./output/fhir` folder to `bundles` BLOB container.
   - You can copy data to Azure Storage using **[Azure AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)** commandline tool or **[Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-storage-explorer#upload-blobs-to-the-container)** user interface.
- Test FHIR bulk load using Postman `FHIR API` collection to retreive FHIR patient data loaded.
   - You can import Postman collection and environment variables for FHIR API from the **[Student Resources folder for Postman](./Resources/Postman)** folder.
   - You need to register your **[public client application](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/use-postman)**  to connect Postman desktop app to FHIR Server.

## Success Criteria

   - You have provisioned FHIR Bulk Load environment in Azure.
   - You have generated synthetic patient data in FHIR format.
   - You have loaded FHIR patient data into FHIR Server.
   - You have retrieved the new FHIR patient data using Postman.

## Learning Resources

- **[FHIR Bulk Loader](https://github.com/microsoft/fhir-loader)**
- **[Synthea Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**
- **[Synthea wiki](https://github.com/synthetichealth/synthea/wiki)**
- **[Copy data to Azure Storage using Azure AzCopy tool](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
- **[Copy data to Azure Storage using Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-storage-explorer#upload-blobs-to-the-container)** 
- **[Import Postman data, including collections, environments, data dumps, and globals.](https://learning.postman.com/docs/getting-started/importing-and-exporting-data/)**
- **[Access FHIR service using Postman](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/use-postman)**
