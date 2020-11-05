# Challenge 1: Extract, transform and load patient data

[< Previous Challenge](./Challenge00.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge02.md)

## Introduction

In this challenge, you will implement the FHIR Server samples architecture to ingest and convert FHIR and legacy patient data from Electronic Health Record (EHR) systems.  To generate synthetic patient data for this hack, you will use the open source Synthea Patient Generator tool to simulate patient records in FHIR and C-CDA formats.  

Health Architectures includes a collection of best practices reference architectures to illustrate use cases for the Azure API for FHIR. Below is the holistic conceptual end to end architecture for Azure API for FHIR.
![Health Architecture](../images/HealthArchitecture.png)

## Description

You will deploy Health Architecture samples for each usage scenarios below:
### Bulk load FHIR Bundle batch data
![FHIR Server Bulk Load](../images/fhir-serverless-bulk-load.jpg)
### Ingest and convert legacy C-CDA patient data and HL7 messages
![Ingest and Convert](../images/fhir-hl7-ingest-conversion-bulkload-samples-architecture.jpg)

- Deploy FHIR Server for data ingestion and transformation of FHIR patient data.
- Auto-generate simulated patient data using **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**.
   - SyntheaTM is a Synthetic Patient Population Simulator that outputs synthetic patient data and associated health records in FHIR and C-CDA formats to its ./output folder.
- Deploy **[FHIR Server sample (PaaS scenario) Bulk Import components](https://github.com/microsoft/fhir-server-samples)** to load Synthea generated FHIR patient bundle data into FHIR Server.

   Note: In the Azure API for FHIR (PaaS scenario) deployments depicted above, a storage account will be deploy and in this storage account there is a BLOB container called fhirimport, patient bundles generated with Synthea can dumped in this storage container and they will be loaded into the FHIR server. The bulk load is performed by an Azure Function.

   - First, clone this 'FHIR Server Samples' git repo to your local project repo, i.e. c:/projects.

   - Deploy FHIR Server Samples Function Bulk Load and Storage fhirimport via deployment template (azuredeploy-importer.json) in fhir-server-samples/deploy/templates.
- Copy Synthea generated FHIR patient bundle JSON file(s) in ./output/fhir folder to fhirimport Blob container.  This will trigger a function app to bulk load FHIR Bundle(s) into FHIR Server.
   - You can **[copy data to Azure Storage using Azure AzCopy via commandline](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
   - Alternatively, you can **[copy data to Azure Storage using Azure Storage Explorer UI](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)**.  
- Deploy **[HL7 Ingest, Conversion Samples](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#ingest)** to ingest HL7 messages into FHIR Server and publish FHIR CRUD event to Event Hubs for FHIR Post-Processing.
- Deploy a new CDAtoFHIR Logic App to convert Synthea generated C-CDA XML file to FHIR Bundle and load them into fHIR Bundle.  You will call FHIR Convert API for C-CDA template and ingest resulted FHIR Bundle JSON into FHIR Server.
    - Logic App is triggered to run whenever a new blob is added or modified.
    - Get Blob content for HTTP Request body of FHIR Convert API call.
    - Get HTTP Response body and import resulted FHIR Bundle into FHIR Server.
- Copy Synthea generated C-CDA patient data files in ./output/cda folder to fhirstore/cda Blob container.  This will trigger a Logic App run that converts CDA data to FHIR Bundle and load them into FHIR Server.
- From the linux command shell run the following command to test the hl7 ingest and conversion workflow.
    ```
    curl --trace-ascii - -H "Content-Type:text/plain" --data-binary @samplemsg.hl7 <your ingest host name from above>/api/hl7ingest?code=<your ingest host key from above>
    ```
- Setup Postman to access patient data inserted into FHIR Server.

## Success Criteria

   - You have provisioned FHIR Server PaaS scenario (Azure API for FHIR) in Azure.
   - You have auto generated test FHIR patient data and loaded them into FHIR Server.
   - Validate FHIR patient data loaded in FHIR Server by retrieving them in Postman

## Learning Resources

- **[Create Mock Data Server in Azure Function](https://medium.com/@hharan618/create-your-own-mock-data-server-in-azure-functions-7a93972fbfd1)**
- **[Azure API for FHIR samples](https://github.com/microsoft/fhir-server-samples)**
- **[Azure FHIR Importer Function](https://github.com/microsoft/fhir-server-samples/tree/master/src/FhirImporter)**
- **[Synthea Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**
- **[Synthea wiki](https://github.com/synthetichealth/synthea/wiki)**
- **[Copy data to Azure Storage using Azure AzCopy tool](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
- **[Copy data to Azure Storage using Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)** 
- **[HL7 Ingest, Conversion Samples](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#ingest)**
- **[Quickstart: Register an app](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)**
- **[Quickstart: Config an app to expose a web API](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-configure-app-expose-web-apis)**
- **[Quickstart: Configure a client app to access a web API](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-configure-app-access-web-apis)**
