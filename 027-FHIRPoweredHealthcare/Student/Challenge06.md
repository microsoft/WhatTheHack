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

You will deploy a **[FHIR Anonymization ADF pipeline](https://github.com/microsoft/Tools-for-Health-Data-Anonymization/blob/master/docs/FHIR-anonymization.md#anonymize-fhir-data-using-azure-data-factory)** to de-identify FHIR data.  You will run a PowerShell **[script](https://github.com/microsoft/Tools-for-Health-Data-Anonymization/blob/master/docs/FHIR-anonymization.md#anonymize-fhir-data-using-azure-data-factory)** to create an ADF pipeline that reads data from a source container in Azure Blob storage and writes the outputted anonymized data to a destination containter in Azure Blob storage.  You have the option to call the $export operation in FHIR service to **[bulk export](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/export-data)** FHIR data into a pre-defined source container in the Azure Blob store for Anonymization pipeline.  Alternatively, you can simply upload a test Synthea generate FHIR patient data to this container.

- **Setup ADF pipeline configuration for anonymization**
    - Download or Clone the **[Tools-for-Health-Data-Anonymization](https://github.com/microsoft/Tools-for-Health-Data-Anonymization)** GitHub repo
    - Navigate to the project subfolder at: 'FHIR-Tools-for-Anonymization\FHIR\src\Microsoft.Health.Fhir.Anonymizer.R4.AzureDataFactoryPipeline' folder and configure 'AzureDataFactorySettings.json' file as follows:
        ```
        {
            "dataFactoryName": "[Custom Data Factory Name]",
            "resourceLocation": "[Region for Data Factory]",
            "sourceStorageAccountName": "[Storage Account Name for source files]",
            "sourceStorageAccountKey": "[Storage Account Key for source files]",
            "destinationStorageAccountName": "[Storage Account Name for destination files]",
            "destinationStorageAccountKey": "[Storage Account Key for destination files]",
            "sourceStorageContainerName": "[Storage Container Name for source files]",
            "sourceContainerFolderPath": "[Optional: Directory for source resource file path]",
            "destinationStorageContainerName": "[Storage Container Name for destination files]",
            "destinationContainerFolderPath": "[Optional: Directory for destination resource file path]",
            "activityContainerName": "[Container name for anonymizer tool binraries]"
        }
        ```
    - In PowerShell command window, execute the following commands to define variables needed during the script execution to create and configure the Anonymization Batch service:
        ```powershell
        $SubscriptionId = "SubscriptionId"
        $BatchAccountName = "BatchAccountName. New batch account would be created if account name is null or empty."
        $BatchAccountPoolName = "BatchAccountPoolName"
        $BatchComputeNodeSize = "Node size for batch node. Default value is 'Standard_d1'"
        $ResourceGroupName = "Resource group name for Data Factory. Default value is $dataFactoryName + 'resourcegroup'"
        ```
- **Deploy ADF pipeline for FHIR data anonymization**
    - Run the following PowerShell commands to create the Data Factory anonymization pipeline:
        - First, log into Azure using PowerShell
            ```powershell
            Connect-AzAccount
            Get-AzSubscription
            Select-AzSubscription -SubscriptionId "<SubscriptionId>"
            ```
        - Navigate to the project subfolder at: 'FHIR-Tools-for-Anonymization\FHIR\src\Microsoft.Health.Fhir.Anonymizer.R4.AzureDataFactoryPipeline' and run the script with parameters as follows:
            ```powershell
            .\DeployAzureDataFactoryPipeline.ps1 -SubscriptionId $SubscriptionId -BatchAccountName $BatchAccountName -BatchAccountPoolName $BatchAccountPoolName -BatchComputeNodeSize $BatchComputeNodeSize -ResourceGroupName $ResourceGroupName
            ```
- **Upload test FHIR patient data for anonymization**
    - Upload Synthea generated FHIR patient data to the source container configured in the ADF pipeline.
    - [Optional], **[Configure](https://github.com/microsoft/fhir-server/blob/main/docs/BulkExport.md)** and **[perform](https://github.com/rsliang/FHIR-Tools-for-Anonymization/blob/master/docs/FHIR-anonymization.md#how-to-perform-de-identified-export-operation-on-the-fhir-server)** the de-ID FHIR export using the $export operation in the FHIR service.
- **Trigger and monitor pipeline run to anonymize the uploaded test FHIR patient data**
    - Run in PowerShell:
        ```powershell
        .\DeployAzureDataFactoryPipeline.ps1 -SubscriptionId $SubscriptionId -BatchAccountName $BatchAccountName -BatchAccountPoolName $BatchAccountPoolName -BatchComputeNodeSize $BatchComputeNodeSize -ResourceGroupName $ResourceGroupName
        ```
- **Validate export and anonymization** 
    - Compare pre de-identified data in the 'source' container  and post de-identified data in the 'destination' container. 

## Success Criteria
- You have successfully configured FHIR Bulk Export
- You have successfully configure and deploy the FHIR anonyization tool.
- You have compared pre de-ided and post de-ided FHIR data.

## Learning Resources

- **[HIPPA Safe Harbor Method](https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html)**
- **[Bulk export](https://github.com/microsoft/fhir-server/blob/main/docs/BulkExport.md)**
- **[FHIR Tools for Anonymization](https://github.com/microsoft/FHIR-Tools-for-Anonymization)**
