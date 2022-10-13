# Coach's Guide: Challenge 2 - Extract and Load HL7v2 & C-CDA EHR Data

[< Previous Challenge](./Solution01.md) - **[Home](./README.md)** - [Next Challenge>](./Solution03.md)

## Notes & Guidance

In this challenge, you will use the **[\$convert-data](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data#use-the-convert-data-endpoint)** operation, which is a service integrated into the FHIR service within Azure Health Data platform, to convert HL7v2 message and C-CDA XML legacy formats for persistance in FHIR.  The $convert-data endpoint in FHIR service uses the Liquid template engine and default templates from the **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** OSS project to perform data mapping between these legacy formats to FHIR. 

**Prepare API Request to convert legacy health data into FHIR**
- Setup API request **[using the $convert-data endpoint](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data#using-the-convert-data-endpoint)** in the FHIR service and configure **[Parameter Resource](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data#parameters-resource)** in the request body.

**Convert data using the $convert-data endpoint**
- Test send **[sample HL7v2](https://github.com/microsoft/FHIR-Converter/tree/main/data/SampleData/Hl7v2)** and **[sample C-CDA](https://github.com/microsoft/FHIR-Converter/tree/main/data/SampleData/Ccda)** requests in the request body payload and make the appropriate $convert-data API calls to receive FHIR Bundle response.

**Use Postman to retrieve Patients clinical data via FHIR Patients API**
- Open Postman and import Postman collection and environment variables for FHIR API (if you have not imported them).
- Run FHIR API HTTP Requests to validate imported clinical data.

**Note:** See **[challenge 1 solution file](./Solution01.md)** for detailed guide on using Postman to access FHIR Server APIs.




