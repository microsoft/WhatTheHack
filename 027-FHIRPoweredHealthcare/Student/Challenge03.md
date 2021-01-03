# Challenge 3: Extract, transform and load clinical healthcare data

[< Previous Challenge](./Challenge02.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge04.md)

## Introduction

In this challenge, you will use the FHIR Converter reference architecture in Microsoft Health Architectures, deployed in challenge 2, to ingest, transform, and load clinical healthcare data into FHIR Server.  You will generate synthetic patient clinical data (C-CDA), convert them into FHIR Bundle and ingest them into FHIR Server.  To generate synthetic patient data, you will use **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** open source Java tool to simulate patient clinical data in HL7 C-CDA format.  

### Clinical data ingest and convert scenario
In this scenario, you will develop a logic app based workflow to perform the C-CDA-to-FHIR conversion using **[FHIR Converter API](https://github.com/microsoft/FHIR-Converter/blob/master/docs/api-summary.md)** and import the resulting FHIR Bundle into FHIR Server.

![Ingest and Convert](../images/fhir-convert-samples-architecture.jpg)

### Let's put it all together...
You will extend the FHIR Server Samples reference architecture from previous challenges with HL7 Ingest and FHIR Converter reference architectures to form the end-to-end ingest, transform and load event-driven platform as shown below:
![HL7 ingest, conversion and bulk load](../images/fhir-hl7-ingest-conversion-bulkload-samples-architecture.jpg)


## Description

You will use the Microsoft Health Architectures environment and add a new logic app based workflow to for C-CDA-to-FHIR ingest and convert scenarios as follows:
- Use **[HL7toFHIR Conversion](https://github.com/rsliang/health-architectures/tree/master/HL7Conversion#hl7tofhir-conversion)** infrastructure deployed in challenge 2 to expose the C-CDA Conversion service endpoint: 

   `https://<SERVICE_NAME>.azurewebsites.net/api/convert/cda/ccd.hbs`.

- Create a new logic app based workflow to perform the C-CDA-to-FHIR conversion and import the resulting FHIR Bundle into FHIR Server.  
   Hint:
   Your new logic app needs to perform the following steps in the workflow:
    - Step 1: Create a new BLOB triggered Logic App.
    - Step 2: Get BLOB content into the request body and call the FHIR Converter API.
    - Step 3: Get response body returned from FHIR Converter API call into Input object.
    - Step 4: Import response body (FHIR bundle) in Input object into FHIR Server connected through a **[FHIR Server Proxy](https://github.com/rsliang/health-architectures/blob/master/FHIR/FHIRProxy/readme.md)**.
- Generate simulated patient data in C-CDA format using **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**.
- Copy the Synthea generated C-CDA patient data (XML) in `./output/cda` folder to `cda` BLOB container in `{ENVIRONMENTNAME}store` Storage Account created for FHIR Converter.  This will trigger the `CCDAtoFHIR` logic app convert and load workflow.

   Hint: 
   You can **[copy data to Azure Storage using Azure AzCopy via commandline](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)** or **[copy data to Azure Storage via Azure Storage Explorer UI](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)**.  

- Retrieve new FHIR patient clinical data using Postman.

## Success Criteria

   - You have add a new logic app based workflow in the Microsoft Health Architectures environment to handle C-CDA to FHIR conversion.
   - You have generated synthetic FHIR patient clinical data in C-CDA format.
   - You have converted Synthea generated patient clinical data in C-CDA format to FHIR bundle.
   - You have loaded the patient clinical data into FHIR Server.
   - You have use Postman to retrieve the newly loaded patient clinical data in FHIR Server.

## Learning Resources

- **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** 
- **[FHIR Converter to Azure](https://github.com/microsoft/FHIR-Converter#deploying-the-fhir-converter)** 
- **[Deploy FHIR Converter ARM template locally](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-tutorial-local-template?tabs=azure-powershell)**
- **[Deploy FHIR Converter template using Azure portal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-portal)**
- **[Quickstart template to deploy FHIR Converter](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent)** 
- **[FHIR Server Proxy](https://github.com/rsliang/health-architectures/blob/master/FHIR/FHIRProxy/readme.md)**
- **[HL7 Ingest, Conversion Samples](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#ingest)**
- **[Synthea Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**
- **[Synthea wiki](https://github.com/synthetichealth/synthea/wiki)**
- **[Copy data to Azure Storage using Azure AzCopy tool](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
- **[Copy data to Azure Storage using Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)** 
- **[Access Azure API for FHIR using Postman](https://docs.microsoft.com/en-us/azure/healthcare-apis/access-fhir-postman-tutorial)**
