# Challenge 1: Extract, transform (convert) and load patient data

[< Previous Challenge](./Challenge00.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge02.md)

## Introduction

Health Architectures includes a collection of best practices reference architectures to illustrate use cases for the Azure API for FHIR. Below is the holistic conceptual end to end architecture for Azure API for FHIR.
![Health Architecture](../images/HealthArchitecture.png)

In this challenge, you will implement the FHIR Server PaaS scenario reference architecture to extract, transform and load patient data from Electronic Health Record (EHR) systems.  For this hack, you will generate synthetic patient data in both the FHIR format for bulk load into FHIR Server and legacy C-CDA format for the ingest and conversion to FHIR Bundle.  To generate synthetic patient data, you will use the open source Synthea Patient Generator Java tool to simulate patient records in both FHIR and C-CDA formats.  

### FHIR bulk load scenario
In this scenario, you will deploy a storage account with a BLOB container called `fhirimport`, patient FHIR bundles generated with Synthea can be coplied into this storage container and they will be auto ingested into the FHIR server.  This bulk ingestion is performed by an Azure Function as depicted below:

![FHIR Server Bulk Load](../images/fhir-serverless-bulk-load.jpg)

### C-CDA ingest and convert scrinario
In this scenario, you will deploy a logic app based workflow to perform the conversion from C-CDA to FHIR via the **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** using the **[Conversion API](https://github.com/microsoft/FHIR-Converter/blob/master/docs/api-summary.md)** component and import the resulting FHIR bundle into FHIR server.

![Ingest and Convert](../images/fhir-convert-samples-architecture.jpg)


## Description

You will deploy Health Architecture samples for each scenarios below:
### FHIR Bulk Load
- Deploy FHIR Server for data ingestion and transformation of FHIR patient data.
- Auto-generate simulated patient data in FHIR format using **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**.
   - SyntheaTM is a Synthetic Patient Population Simulator that outputs synthetic patient data and associated health records in FHIR and C-CDA formats to its `./output` folder.
- Deploy **[FHIR Server sample (PaaS scenario) Bulk Import components](https://github.com/microsoft/fhir-server-samples)** to load Synthea generated FHIR patient bundles into FHIR Server.
   - First, clone this 'FHIR Server Samples' git repo to your local project repo, i.e. c:/projects.
   - Deploy FHIR Server Samples Bulk Load function app and storage fhirimport BLOB container via deployment template (azuredeploy-importer.json) in the fhir-server-samples/deploy/templates folder.
- Copy Synthea generated FHIR bundle JSON files in the `./output folder` to `fhirimport` BLOB container.  This will trigger a function app to bulk load FHIR Bundle(s) into FHIR Server.
   - You can **[copy data to Azure Storage using Azure AzCopy via commandline](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
   - Alternatively, you can **[copy data to Azure Storage using Azure Storage Explorer UI](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)**.

### C-CDA ingest and convert
- Auto-generate simulated patient data in C-CDA format using **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**.
- Deploy **[FHIR Converter to Azure](https://github.com/microsoft/FHIR-Converter#deploying-the-fhir-converter)** using the **[Quickstart template](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent)** to expose the C-CDA Conversion service at `https://<SERVICE_NAME>.azurewebsites.net/api/convert/cda/ccd.hbs`.
- Deploy a logic app based workflow to perform the conversion from Synthea generated C-CDA XML to FHIR bundle JSON and load the resulting FHIR bundle into FHIR server.  You will call FHIR Convert API for C-CDA template and ingest resulted FHIR Bundle into FHIR Server.
    - Create a new Logic App that is triggered whenever a new blob is added or modified.
    - Get BLOB content for the HTTP Request body of FHIR Convert API call.
    - Get HTTP Response body 
    - Import response body (FHIR bundle) into FHIR Server using **[FHIR Server Proxy](https://github.com/rsliang/health-architectures/blob/master/FHIR/FHIRProxy/readme.md)** connection.
- Copy the Synthea generated C-CDA patient data XML file in `./output/cda` folder to `fhirimport` BLOB container.  This will trigger the CCDAtoFHIR logic app to call the FHIR Convert API with C-CDA patient data payload and load the resulted FHIR bundle nto FHIR Server.
   - You can **[copy data to Azure Storage using Azure AzCopy via commandline](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
   - Alternatively, you can **[copy data to Azure Storage using Azure Storage Explorer UI](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)**.  

## Success Criteria

   - You have provisioned FHIR Server PaaS scenario (Azure API for FHIR) in Azure.
   - You have auto generated synthetic FHIR patient data in both FHIR and C-CDA formats.
   - You have converted legacy C-CDA format to FHIR bundle patient data.
   - YOu have loaded both FHIR and C-CDA patient data into FHIR server.
   - You have validate the loaded patient data in FHIR Server by retrieving them in Postman or FHIR Dashboard.

## Learning Resources

- **[Create Mock Data Server in Azure Function](https://medium.com/@hharan618/create-your-own-mock-data-server-in-azure-functions-7a93972fbfd1)**
- **[Azure API for FHIR samples](https://github.com/microsoft/fhir-server-samples)**
- **[Azure FHIR Importer Function](https://github.com/microsoft/fhir-server-samples/tree/master/src/FhirImporter)**
- **[FHIR Converter to Azure](https://github.com/microsoft/FHIR-Converter#deploying-the-fhir-converter)** 
- **[Quickstart template to deploy FHIR Converter](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent)** 
- **[FHIR Server Proxy](https://github.com/rsliang/health-architectures/blob/master/FHIR/FHIRProxy/readme.md)**
- **[HL7 Ingest, Conversion Samples](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#ingest)**
- **[Use SMART on FHIR Proxy](https://docs.microsoft.com/en-us/azure/healthcare-apis/use-smart-on-fhir-proxy)**
- **[Quickstart: Register an app](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)**
- **[Quickstart: Config an app to expose a web API](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-configure-app-expose-web-apis)**
- **[Quickstart: Configure a client app to access a web API](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-configure-app-access-web-apis)**
- **[Synthea Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**
- **[Synthea wiki](https://github.com/synthetichealth/synthea/wiki)**
- **[Copy data to Azure Storage using Azure AzCopy tool](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
- **[Copy data to Azure Storage using Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)** 
