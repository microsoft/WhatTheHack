# Challenge 1: Extract and load FHIR patient medical records

[< Previous Challenge](./Challenge00.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge02.md)

## Introduction

In this challenge, you will implement the FHIR Server Samples reference architecture to ingest and load patient data in FHIR.  You will generate synthetic FHIR patient data for bulk load into FHIR Server.  To generate synthetic patient data, you will use **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** open source Java tool to simulate patient records in FHIR format.  

### FHIR bulk load scenario
In this scenario, you will deploy a storage account with a BLOB container called `fhirimport`.  Synthea generated FHIR patient data files (JSON) are copied into this storage container, and automatically ingested into FHIR Server.  This bulk ingestion is performed by a BLOB triggered function app as depicted below:

![FHIR Server Bulk Load](../images/fhir-serverless-bulk-load.jpg)

## Description

You will implement the FHIR Bulk Load scenario in Microsoft Health Architecture as follows:
- Deploy **[FHIR Server Samples PaaS scenario (above)](https://github.com/microsoft/fhir-server-samples)** to ingest and bulk load Synthea generated FHIR patient data into FHIR Server in near real-time.
   - Hint:
      - First, clone **['FHIR Server Samples' git repo](https://github.com/microsoft/fhir-server-samples)** to your local project repo, i.e. c:/projects.
      - **[Deploy FHIR Server Samples](https://github.com/microsoft/fhir-server-samples#deployment)** environment.
         - Before running this **[PowerShell deployment script](https://github.com/microsoft/fhir-server-samples/blob/master/deploy/scripts/Create-FhirServerSamplesEnvironment.ps1)**, you MUST login to your Azure subscription and connect to Azure AD with your secondary tenant (can be primary tenant if you already have directory admin privilege) that provides you with directory admin role access required for this setup.

         NOTE: The connection to Azure AD can be made using a different tenant domain than the one tied to your Azure subscription. If you don't have privileges to create app registrations, users, etc. in your Azure AD tenant, you can create a new secondary tenant, which will just be used for demo identities, etc. 
         - Post deployment, save your admin tenant credential to be used in later challenges.
         
      - To Validate your deployment, 
         - Check Azure resources created in {ENVIRONMENTNAME} and {ENVIRONMENTNAME}-sof Resource Groups
         - Check App Registration in secondary AAD tenant that **[all three different client application types are registered for Azure API for FHIR](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir-app-registration)**
- Generate simulated patient data in FHIR format using **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**.
- Copy Synthea generated FHIR bundle JSON files in its `./output/fhir` folder to `fhirimport` BLOB container.
   - Hint: You can **[copy data to Azure Storage using Azure AzCopy via commandline](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)** or **[copy data to Azure Storage via Azure Storage Explorer UI](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)**.

## Success Criteria

   - You have provisioned FHIR Bulk Load environment in Azure.
   - You have generated synthetic patient data in FHIR format.
   - You have loaded FHIR patient data into FHIR Server.
   - You have retrieved the new FHIR patient data using Postman.

## Learning Resources

- **[Azure API for FHIR samples](https://github.com/microsoft/fhir-server-samples)**
- **[Synthea Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**
- **[Synthea wiki](https://github.com/synthetichealth/synthea/wiki)**
- **[Copy data to Azure Storage using Azure AzCopy tool](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
- **[Copy data to Azure Storage using Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)** 
- **[Access Azure API for FHIR using Postman](https://docs.microsoft.com/en-us/azure/healthcare-apis/access-fhir-postman-tutorial)**
