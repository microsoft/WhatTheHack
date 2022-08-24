# Challenge 6: Bulk export, anonymize and store FHIR data into Data Lake

[< Previous Challenge](./Challenge05.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge07.md)

## Introduction

In this challenge, you will use Azure Health Data Services platform to export and de-identify FHIR data according to a set of data redaction/transformation rules specified in a **[configuration file](https://github.com/microsoft/Tools-for-Health-Data-Anonymization/blob/master/docs/FHIR-anonymization.md#configuration-file-format)**. The goal of the of this challege is to apply the **[HIPAA Safe Harbor Method](https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html#safeharborguidance)** de-id requirements against FHIR data to create a research datasets.

**[FHIR Tool for Anonymization](https://github.com/microsoft/FHIR-Tools-for-Anonymization)** provides tooling to anonymize healthcare FHIR data, on-premises or cloud, for secondary usage such as research, public health, etc. in the following methods:
- Command line tool, 
- Azure Data Factory (ADF) pipeline 
- De-ID $export FHIR service operation  

<center><img src="../images/challenge06-architecture.png" width="550"></center>

## Description

You will deploy a **[FHIR Anonymization ADF pipeline](https://github.com/microsoft/Tools-for-Health-Data-Anonymization/blob/master/docs/FHIR-anonymization.md#anonymize-fhir-data-using-azure-data-factory)** to de-identify FHIR data.  You will run a PowerShell **[script](https://github.com/microsoft/Tools-for-Health-Data-Anonymization/tree/master/FHIR/src/Microsoft.Health.Fhir.Anonymizer.R4.AzureDataFactoryPipeline)** to create an ADF pipeline that reads data from a source container in Azure Blob storage and writes the outputted anonymized data to a destination containter in Azure Blob storage.  You have the option to call the $export operation in FHIR service to **[bulk export](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/export-data)** FHIR data into a pre-defined source container in the Azure Blob store for Anonymization pipeline.  Alternatively, you can simply upload a test Synthea generate FHIR patient data to this container.

- **Setup ADF pipeline configuration for anonymization**
    - Download or Clone the **[Tools-for-Health-Data-Anonymization](https://github.com/microsoft/Tools-for-Health-Data-Anonymization)** GitHub repo
    - Configure the Anonymization pipeline deployment **[script](https://github.com/microsoft/Tools-for-Health-Data-Anonymization/tree/master/FHIR/src/Microsoft.Health.Fhir.Anonymizer.R4.AzureDataFactoryPipeline)** execution for your environment.
    - Define command line environment variables needed during the script execution to create and configure the Anonymization pipeline.
- **Deploy ADF pipeline for FHIR data anonymization**
    - Execute **[script](https://github.com/microsoft/Tools-for-Health-Data-Anonymization/tree/master/FHIR/src/Microsoft.Health.Fhir.Anonymizer.R4.AzureDataFactoryPipeline)** to created the Anonymization pipeline.
- **Upload test FHIR patient data for anonymization**
    - **[Configure](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/configure-export-data)** and **[perform](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/export-data)** the bulk FHIR export using the $export operation in the FHIR service via Postman.
    - Or you can simply upload Synthea generated FHIR patient data to the source container configured in the linked service of ADF pipeline for testing the Anonymization pipeline.
- **Trigger and monitor pipeline run to anonymize the uploaded test FHIR patient data**
    - **[Trigger pipeline run](https://github.com/microsoft/Tools-for-Health-Data-Anonymization/blob/master/docs/FHIR-anonymization.md#trigger-and-monitor-pipeline-run-from-powershell)** to de-ID test FHIR patient data.
- **Validate FHIR data export and anonymization** 
    - Compare pre de-identified data in the 'source' container  and post de-identified data in the 'destination' container. 

## Success Criteria
- You have successfully configure and deploy the FHIR anonyization tool.
- You have successfully configured FHIR Bulk Export and called the $export operation to upload the test FHIR data for anonymization
- You have successfully trigger and monitor the Anonymization pipeline in ADF
- You have compared pre de-ided and post de-ided FHIR data in the resource and destination containers respectively.

## Learning Resources

- **[FHIR Tools for Anonymization](https://github.com/microsoft/FHIR-Tools-for-Anonymization)**
- **[Configure Bulk export FHIR service operation](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/configure-export-data)**
- **[How to export FHIR data with $export opertation in FHIR service](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/export-data)**
- **[HIPPA Safe Harbor Method](https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html)**
