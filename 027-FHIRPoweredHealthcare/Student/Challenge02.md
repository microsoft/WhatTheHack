# Challenge 2: Bulk ETL C-CDA patient data

[< Previous Challenge](./Challenge01.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge03.md)

## Introduction

In this challenge, you will implement the Health Architecture FHIR Converter sample reference architecture to extract, transform, load and read patient data from Electronic Health Record (EHR) systems.  You will generate synthetic patient data in legacy C-CDA format for conversion to FHIR Bundle and ingest them into FHIR server.  To generate synthetic patient data, you will use **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** open source Java tool to simulate patient records in HL7 C-CDA format.  

### C-CDA ingest and convert scrinario
In this scenario, you will deploy a logic app based workflow to perform the conversion from C-CDA to FHIR via the **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** using the **[Conversion API](https://github.com/microsoft/FHIR-Converter/blob/master/docs/api-summary.md)** component and import the resulting FHIR bundle into FHIR server.

![Ingest and Convert](../images/fhir-convert-samples-architecture.jpg)


## Description

You will deploy Health Architecture samples for C-CDA to FHIR ingest and convert scenarios below:
- Auto-generate simulated patient data in C-CDA format using **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**.
- Deploy **[FHIR Converter to Azure](https://github.com/microsoft/FHIR-Converter#deploying-the-fhir-converter)** using the **[Quickstart template](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent)** to expose the C-CDA Conversion service at `https://<SERVICE_NAME>.azurewebsites.net/api/convert/cda/ccd.hbs`.
- Deploy a logic app based workflow to perform the conversion from Synthea generated C-CDA XML to FHIR bundle JSON and load the resulting FHIR bundle into FHIR server.  You logic app perform the following steps for C-CDA to FHIR conversion and load workflow:
    - Step 1: Create a new Logic App that is triggered whenever a new blob is added or modified.
    - Step 2: Get BLOB content for the HTTP Request body of FHIR Convert API call.
    - Step 3: Get HTTP Response body from FHIR Convert API call.
    - Step 4: Import response body (FHIR bundle) into FHIR Server using **[FHIR Server Proxy](https://github.com/rsliang/health-architectures/blob/master/FHIR/FHIRProxy/readme.md)** connection.
- Copy the Synthea generated C-CDA patient data XML file in `./output/cda` folder to `fhirimport` BLOB container.  This will trigger the CCDAtoFHIR logic app convert and load workflow.
   - You can **[copy data to Azure Storage using Azure AzCopy via commandline](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)** or **[copy data to Azure Storage via Azure Storage Explorer UI](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)**.  
- Retrieve newly load FHIR data in Postman

## Success Criteria

   - You have provisioned the FHIR Converter environment in Azure.
   - You have auto generated synthetic FHIR patient data in C-CDA format.
   - You have converted legacy C-CDA format to FHIR bundle patient data.
   - You have loaded the C-CDA to FHIR patient data into FHIR server.
   - You have use Postman to retrieve the newly loaded patient data in FHIR Server 

## Learning Resources

- **[FHIR Converter to Azure](https://github.com/microsoft/FHIR-Converter#deploying-the-fhir-converter)** 
- **[Quickstart template to deploy FHIR Converter](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent)** 
- **[FHIR Server Proxy](https://github.com/rsliang/health-architectures/blob/master/FHIR/FHIRProxy/readme.md)**
- **[HL7 Ingest, Conversion Samples](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#ingest)**
- **[Synthea Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**
- **[Synthea wiki](https://github.com/synthetichealth/synthea/wiki)**
- **[Copy data to Azure Storage using Azure AzCopy tool](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
- **[Copy data to Azure Storage using Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)** 
