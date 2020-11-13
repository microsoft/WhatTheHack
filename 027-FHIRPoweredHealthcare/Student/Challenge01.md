# Challenge 1: Bulk ETL FHIR patient data

[< Previous Challenge](./Challenge00.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge02.md)

## Introduction

In this challenge, you will implement the FHIR Server Samples reference architecture to extract, transform, load and read patient data from Electronic Health Record (EHR) systems.  You will generate synthetic patient data in FHIR format for bulk load into FHIR server.  To generate synthetic patient data, you will use **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** open source Java tool to simulate patient records in FHIR format.  

### FHIR bulk load scenario
In this scenario, you will deploy a storage account with a BLOB container called `fhirimport`, patient FHIR bundles generated with Synthea can be coplied into this storage container and they will be auto ingested into the FHIR server.  This bulk ingestion is performed by an Azure Function as depicted below:

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
- Auto-generate simulated patient data in FHIR format using **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**.
- Copy Synthea generated FHIR bundle JSON files in the `./output folder` to `fhirimport` BLOB container for auto batch load.
   - You can **[copy data to Azure Storage using Azure AzCopy via commandline](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)** or **[copy data to Azure Storage via Azure Storage Explorer UI](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)**.

## Success Criteria

   - You have provisioned FHIR Bulk Load evnironment in Azure.
   - You have auto generated synthetic patient data in FHIR format.
   - YOu have loaded FHIR patient data into FHIR server.
   - You have validate the loaded patient data in FHIR Server by retrieving them in Postman 

## Learning Resources

- **[Azure API for FHIR samples](https://github.com/microsoft/fhir-server-samples)**
- **[Synthea Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**
- **[Synthea wiki](https://github.com/synthetichealth/synthea/wiki)**
- **[Copy data to Azure Storage using Azure AzCopy tool](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
- **[Copy data to Azure Storage using Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)** 
