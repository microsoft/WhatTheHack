# Challenge 1: Extract, transform and load patient data

[< Previous Challenge](./Challenge00.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge02.md)

## Introduction

In this challenge, you will extract patient data from Electronic Health Record (EHR) systems and load to FHIR Server.  Note: For this hack, you will auto-generate test FHIR patient data and load them to the FHIR Server.

## Description

   - Deploy Azure API for FHIR service in Azure for data ingestion of FHIR patient data
   - Auto-generate test patient data in FHIR-based standard format
      - Option1: Develop a serverless function to auto-generate test FHIR patient data and load them into FHIR Server one at a time. Note: Sample NodeJS code snippet to be provided.
      - Option 2: Use open source SyntheaTM Patient Generator to auto-generate FHIR patient data.
         -  **Note: [SyntheaTM](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** is a Synthetic Patient Population Simulator. The goal is to output synthetic, realistic (but not real), patient data and associated health records in a variety of formats.  Read the [Synthea wiki](https://github.com/synthetichealth/synthea/wiki) for more information.
         - **Hint:**
            - Follow the [Developer Quick Start](https://github.com/synthetichealth/synthea#developer-quick-start) to install, configure and gerenate simulated patient data in FHIR standard format.
            - Follow the [FHIR Server for Bulk Load](https://github.com/microsoft/fhir-server-samples) deployment sample (depicted below) to ingest Synthea generated patient bundle into FHIR Server.      
               - In this sample deplyoment, a storage account will be deploy and in this storage account there is a BLOB container called fhirimport, patient bundles generated with Synthea can dumped in this storage container and they will be ingested into the FHIR server. The bulk ingestion is performed by an Azure Function.

- Azure API for FHIR PaaS server:
![Azure API for FHIR PaaS server:](./Resources/fhir-server-samples-paas.png)

- open source FHIR Server for Azure:
![open source FHIR Server for Azure:](./Resources/fhir-server-samples-oss.png)
   
## Success Criteria

   - Standup Azure API for FHIR managed service in Azure.
   - Auto generated test patient data in FHIR-based format.
   - Load FHIR patient data into the FHIR Server.

## Learning Resources

**[Create Mock Data Server in Azure Function](https://medium.com/@hharan618/create-your-own-mock-data-server-in-azure-functions-7a93972fbfd1)**
**[Azure API for FHIR samples](https://github.com/microsoft/fhir-server-samples)**
**[Azure FHIR Importer Function](https://github.com/microsoft/fhir-server-samples/tree/master/src/FhirImporter)**
**[Synthea Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**
