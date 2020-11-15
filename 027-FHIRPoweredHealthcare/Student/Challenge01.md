# Challenge 1: Extract and load FHIR patient medical records

[< Previous Challenge](./Challenge00.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge02.md)

## Introduction

In this challenge, you will implement the FHIR Server Samples reference architecture to extract, transform and load patient data from Electronic Health Record (EHR) systems.  You will generate synthetic patient data in FHIR format for bulk load into FHIR server.  To generate synthetic patient data, you will use **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** open source Java tool to simulate patient records in FHIR format.  

### FHIR bulk load scenario
In this scenario, you will deploy a storage account with a BLOB container called `fhirimport`.  Patient FHIR bundle JSON files generated with Synthea are copied into this storage container, which will automatically ingested into the FHIR server.  This bulk ingestion is performed by an Azure Function as depicted below:

![FHIR Server Bulk Load](../images/fhir-serverless-bulk-load.jpg)

## Description

You will deploy Health Architecture samples for the FHIR Bulk Load scenario below:
- Deploy **[FHIR Server Samples PaaS scenario (shown above)](https://github.com/microsoft/fhir-server-samples)** to ingest and batch load Synthea generated FHIR patient bundles into FHIR Server.
   - First, clone this **['FHIR Server Samples' git repo](https://github.com/microsoft/fhir-server-samples)** to your local project repo, i.e. c:/projects.
   - **[Deploy FHIR Server Samples](https://github.com/microsoft/fhir-server-samples#deployment)** environment.

      Hint: Before running the **[PowerShell deployment script](https://github.com/microsoft/fhir-server-samples/blob/master/deploy/scripts/Create-FhirServerSamplesEnvironment.ps1)**, you MUST login to your Azure subscription and connect to Azure AD with your secondary tenant that provides you with 'Global Administrator' directory role access required for this setup.

   - Validate your FHIR Server Samples environment deployment
      - Check Azure resources created in {ENVIRONMENTNAME} and {ENVIRONMENTNAME}-sof Resource Groups
      - Check App Registration in secondary AAD tenat that **[all three different client application types are registered for Azure API for FHIR](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir-app-registration)**
- Generate simulated patient data in FHIR format using **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**.
- Copy Synthea generated FHIR bundle JSON files in the `./output folder` to `fhirimport` BLOB container.
   - Hint: You can **[copy data to Azure Storage using Azure AzCopy via commandline](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)** or **[copy data to Azure Storage via Azure Storage Explorer UI](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)**.

## Success Criteria

   - You have provisioned FHIR Bulk Load evnironment in Azure.
   - You have generated synthetic patient data in FHIR format.
   - You have loaded FHIR patient data into FHIR server.
   - You have use Postman to retreived the newly loaded patient data in FHIR Server.

## Learning Resources

- **[Azure API for FHIR samples](https://github.com/microsoft/fhir-server-samples)**
- **[Synthea Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**
- **[Synthea wiki](https://github.com/synthetichealth/synthea/wiki)**
- **[Copy data to Azure Storage using Azure AzCopy tool](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
- **[Copy data to Azure Storage using Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)** 
- **[Access Azure API for FHIR using Postman](https://docs.microsoft.com/en-us/azure/healthcare-apis/access-fhir-postman-tutorial)**
