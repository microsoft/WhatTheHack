# Challenge 2: Extract, transform and load patient clinical data

[< Previous Challenge](./Challenge01.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge03.md)

## Introduction

In this challenge, you will implement the Health Architecture FHIR Converter sample reference architecture to extract, transform, and load patient clinical data from EHR (Electronic Health Record) systems.  You will generate synthetic patient clinical data in C-CDA format for conversion to FHIR Bundle and ingest them into FHIR server.  To generate synthetic patient data, you will use **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** open source Java tool to simulate patient clinical data in HL7 C-CDA format.  

### Clinical data ingest and convert Scenario
In this scenario, you will develop a logic app based workflow to perform the conversion from C-CDA to FHIR using the **[FHIR Converter Conversion API](https://github.com/microsoft/FHIR-Converter/blob/master/docs/api-summary.md)** with C-CDA template and import the resulting FHIR bundle into FHIR server.

![Ingest and Convert](../images/fhir-convert-samples-architecture.jpg)


## Description

You will deploy Health Architecture samples for C-CDA to FHIR ingest and convert scenarios below:
- Deploy **[FHIR Converter to Azure](https://github.com/microsoft/FHIR-Converter#deploying-the-fhir-converter)** using the **[Quickstart template](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent)** to expose the C-CDA Conversion service at `https://<SERVICE_NAME>.azurewebsites.net/api/convert/cda/ccd.hbs`.
- Create and deploy a logic app based workflow to perform the conversion from Synthea generated C-CDA XML to FHIR bundle JSON and import the resulting FHIR bundle into FHIR server.  You logic app needs to perform the following steps for C-CDA to FHIR conversion and load workflow:
    - Step 1: Create a new Logic App that is triggered whenever a new BLOB is added or modified.
    - Step 2: Get BLOB content for the HTTP Request body of FHIR Convert API call.
    - Step 3: Get HTTP Response body from FHIR Convert API call.
    - Step 4: Import response body (FHIR bundle) into FHIR Server using **[FHIR Server Proxy](https://github.com/rsliang/health-architectures/blob/master/FHIR/FHIRProxy/readme.md)** connection.
- Generate simulated patient data in C-CDA format using **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**.
- Copy the Synthea generated C-CDA patient data XML file in `./output/cda` folder to `fhirimport` BLOB container.  This will trigger the CCDAtoFHIR logic app convert and load workflow.
   - Hint: You can **[copy data to Azure Storage using Azure AzCopy via commandline](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)** or **[copy data to Azure Storage via Azure Storage Explorer UI](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)**.  
- Retrieve newly loaded FHIR patient data in Postman.

## Success Criteria

   - You have provisioned the FHIR Converter environment in Azure.
   - You have auto generated synthetic FHIR patient clinical data in C-CDA format.
   - You have converted C-CDA format to FHIR bundle.
   - You have loaded the patient clinical data into FHIR server.
   - You have use Postman to retrieve the newly loaded patient clinical data in FHIR Server.

## Learning Resources

- **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** 
- **[FHIR Converter to Azure](https://github.com/microsoft/FHIR-Converter#deploying-the-fhir-converter)** 
- **[Quickstart template to deploy FHIR Converter](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent)** 
- **[FHIR Server Proxy](https://github.com/rsliang/health-architectures/blob/master/FHIR/FHIRProxy/readme.md)**
- **[HL7 Ingest, Conversion Samples](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#ingest)**
- **[Synthea Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**
- **[Synthea wiki](https://github.com/synthetichealth/synthea/wiki)**
- **[Copy data to Azure Storage using Azure AzCopy tool](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
- **[Copy data to Azure Storage using Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)** 
- **[Access Azure API for FHIR using Postman](https://docs.microsoft.com/en-us/azure/healthcare-apis/access-fhir-postman-tutorial)**
