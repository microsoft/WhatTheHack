# Coach's Guide: Challenge 2 - Extract, transform and load patient clinical data

[< Previous Challenge](./Solution01.md) - **[Home](./readme.md)** - [Next Challenge>](./Solution03.md)

# Notes & Guidance

In this challenge, you will implement the Health Architecture FHIR Converter sample reference architecture to ingest, transform, and load patient clinical data into FHIR server.  You will generate synthetic patient clinical data, convert them into FHIR Bundle and ingest them into FHIR server.  To generate synthetic patient data, you will use **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** open source Java tool to simulate patient clinical data in HL7 C-CDA format.  

### Clinical data ingest and convert Scenario
In this scenario, you will develop a logic app based workflow to perform the C-CDA-to-FHIR conversion using **[FHIR Converter API](https://github.com/microsoft/FHIR-Converter/blob/master/docs/api-summary.md)** and import the resulting FHIR bundle into FHIR server.

![Ingest and Convert](../images/fhir-convert-samples-architecture.jpg)

## Deploy Health Architecture samples for C-CDA-to-FHIR ingest and convert scenarios

- Deploy **[FHIR Converter](https://github.com/microsoft/FHIR-Converter#deploying-the-fhir-converter)** reference architecture using the **[Quickstart template](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent)** to expose the C-CDA Conversion service endpoint: `https://<SERVICE_NAME>.azurewebsites.net/api/convert/cda/ccd.hbs`.
- Deploy a new logic app based workflow to perform the C-CDA-to-FHIR conversion and import the resulting FHIR bundle into FHIR server.  Your BLOB triggered logic app needs to perform the following steps in the workflow:
    - Step 1: Trigger workflow when a BLOB is added or modified in /cda container
    - Step 2: Get BLOB content from C-CDA XML file from `/cda` container.
    - Step 3: Compose BLOB content as Input object.
    - Step 3: HTTP - Call FHIR Converter API
        - Method: POST
        - URI: https://<your fhirhl7conv name>.azurewebsites.net/api/convert/cda/ccd.hbs
        - Body: Compose object output (file content)
    - Step 4: Import Response Body (FHIR bundle) to FHIR Server 
        - Connected to FHIR server through **[FHIR Server Proxy](https://github.com/rsliang/health-architectures/blob/master/FHIR/FHIRProxy/readme.md)**
        - Set message object to retuned FHIR resource

## Use Postman to retreive Patients clinical data via FHIR Patients API
- Open Postman and **[import Postman data](https://learning.postman.com/docs/getting-started/importing-and-exporting-data/)**.
- Run FHIR API HTTP Requests to validate imported clinical data.

Note: See challenge 1 soluton file for detailed guide for using Postman.




