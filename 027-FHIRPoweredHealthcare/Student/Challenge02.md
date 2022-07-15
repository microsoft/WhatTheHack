# Challenge 2: Extract, transform and load HL7v2 and C-CDA Electronic Health Record (EHR) data

[< Previous Challenge](./Challenge01.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge03.md)

## Introduction

In this challenge, you will use the **[convert-data operation](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data#use-the-convert-data-endpoint)**, which is a service integrated into the FHIR service within Azure Health Data platform, to convert HL7v2 message and C-CDA XML legacy formats for persistance in FHIR.  The $convert-data endpoint in FHIR service uses the Liquid template engine and default templates from the **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** OSS project to perform data mapping between these legacy formats to FHIR.  

Optionally, you can use the $convert-data endpoint within a Logic Apps or Azure Data Factory ETL pipeline to convert raw healthcare data from legacy formats into FHIR format and persist results to FHIR Server. This workflow may includes the following Pre/Post Processing: 
- Data ingestion
- Data validation
- Data transformation 
- Data enrichment
- Data de-duplication

<center><img src="../images/challenge02-architecture.png" width="550"></center>

**[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** is an open source project that transforms health data sources from legacy formats to FHIR bundles that are persisted to a FHIR server.  Microsoft FHIR Converter with Liquid engine supports HL7v2, C-CDA, JSON and FHIR STU3 to FHIR R4 conversions.  It uses default **[Liquid templates](https://shopify.github.io/liquid/)** to define data mapping between these legacy data formats to FHIR, and the template can be **[customized](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data#customize-templates)** to meet your specific conversion requirements.

**[$convert-data operation](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data#use-the-convert-data-endpoint)** is the custom API endpoint in the FHIR service meant to convert data from different data types to FHIR.

## Description

- **Use the $convert-data endpoint** to convert HL7v2 message to FHIR bundle
    - Create a new POST HTTP request in Postman to convert HL7v2 message into FHIR JSON bundle
    - Setup HL7 **[Parameter Resource](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data#parameter-resource)** in the $convert-data API request body
    - **[Convert HL7 data](https://github.com/microsoft/azure-health-data-services-workshop/tree/main/Challenge-02%20-%20Convert%20HL7v2%20and%20C-CDA%20to%20FHIR#step-3---convert-data)** by calling the configured HL7 $convert-data operation in Postman
- **Use the $convert-data endpoint** to convert C-CDA XML file format to FHIR bundle
    - Create a new POST HTTP request in Postman to convert C-CDA XML into FHIR JSON bundle
    - Setup C-CDA **[Parameter Resource](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data#parameter-resource)** in the $convert-data API request body
    - **[Convert C-CDA data](https://github.com/microsoft/azure-health-data-services-workshop/tree/main/Challenge-02%20-%20Convert%20HL7v2%20and%20C-CDA%20to%20FHIR#step-4---prepare-a-request-to-convert-c-cda-data-into-fhir)** by calling the configured C-CDA $convert-data operation in Postman

- Test send sample HL7v2 and C-CDA data in the request body payload and make the appropriate $convert-data API calls to receive FHIR bundle response.

## Success Criteria
- You have created new HL7 and C-CDA request operations in Postman.
- You have tested sending sample HL7v2 message and received a FHIR "resourceType": "Bundle" response after calling $convert-data with a HL7v2 payload.
- You have tested sending sample C-CDA XML data and received a FHIR "resourceType": "Bundle" response after calling $convert-data with a C-CDA payload.

## Learning Resources

- **[Convert legacy health data to FHIR](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data)**
- **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)**
- **[FHIR Converter pre-installed templates for C-CDA and HL7v2](https://github.com/microsoft/FHIR-Converter/tree/main/data/Templates)**
- **[Sample HL7v2 messages](https://github.com/microsoft/FHIR-Converter/tree/main/data/SampleData/Hl7v2)**
- **[Sample C-CDA XML data](https://github.com/microsoft/FHIR-Converter/tree/main/data/SampleData/Ccda)**
- **[HL7v2 to FHIR Conversion template](https://github.com/microsoft/FHIR-Converter/blob/main/docs/HL7v2-templates.md)**
- **[VS Code FHIR Converter template authoring tool](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-health-fhir-converter)**




