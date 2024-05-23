# Coach's Guide: Challenge 5 - Export and Anonymize FHIR EHR Data

[< Previous Challenge](./Solution04.md) - **[Home](./README.md)** - [Next Challenge>](./Solution06.md)

## Notes & Guidance

In this challenge, you will use Azure Health Data Services platform to export and de-identify FHIR data according to a set of data redaction/transformation rules specified in a **[configuration file](https://github.com/microsoft/Tools-for-Health-Data-Anonymization/blob/master/docs/FHIR-anonymization.md#configuration-file-format)**. The goal of the of this challenge is to apply the **[HIPAA Safe Harbor Method](https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html#safeharborguidance)** de-id requirements against FHIR data to create a research datasets.

**[FHIR Tool for Anonymization](https://github.com/microsoft/FHIR-Tools-for-Anonymization)** provides tooling to anonymize healthcare FHIR data, on-premises or cloud, for secondary usage such as research, public health, etc. in the following methods:
- Command line tool, 
- Azure Data Factory (ADF) pipeline 
- De-ID $export FHIR service operation  

**You will deploy a **[FHIR Anonymization ADF pipeline](https://github.com/microsoft/Tools-for-Health-Data-Anonymization/blob/master/docs/FHIR-anonymization.md#anonymize-fhir-data-using-azure-data-factory)** to de-identify FHIR data.** 

- **Setup ADF pipeline configuration for anonymization**
    - Download or Clone the **[Tools-for-Health-Data-Anonymization](https://github.com/microsoft/Tools-for-Health-Data-Anonymization)** GitHub repo
    - Navigate to the project subfolder at: `FHIR-Tools-for-Anonymization\FHIR\src\Microsoft.Health.Fhir.Anonymizer.R4.AzureDataFactoryPipeline` folder and configure `AzureDataFactorySettings.json` file as follows:
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
        - Navigate to the project subfolder at: `FHIR-Tools-for-Anonymization\FHIR\src\Microsoft.Health.Fhir.Anonymizer.R4.AzureDataFactoryPipeline` and run the script with parameters as follows:
            ```powershell
            .\DeployAzureDataFactoryPipeline.ps1 -SubscriptionId $SubscriptionId -BatchAccountName $BatchAccountName -BatchAccountPoolName $BatchAccountPoolName -BatchComputeNodeSize $BatchComputeNodeSize -ResourceGroupName $ResourceGroupName   ```
- **Upload test FHIR patient data for anonymization**
    - **[Configure](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/configure-export-data)** and **[perform](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/export-data)** the bulk FHIR export using the $export operation in the FHIR service via Postman.
    - Or you can simply upload Synthea generated FHIR patient data to the source container configured in the linked service of ADF pipeline for testing the Anonymization pipeline.
- **Trigger and monitor pipeline run to anonymize the uploaded test FHIR patient data**
    - Run in PowerShell:
        ```powershell
        .\DeployAzureDataFactoryPipeline.ps1 -SubscriptionId $SubscriptionId -BatchAccountName $BatchAccountName -BatchAccountPoolName $BatchAccountPoolName -BatchComputeNodeSize $BatchComputeNodeSize -ResourceGroupName $ResourceGroupName
        ```
        Hint: If you get **Azure Batch error**, either Azure Batch is not enabled in your subscription or Azure Batch already deployed the max number of time in your subscription.
- **Validate export and anonymization** 
    - Compare pre de-identified data in the 'source' container  and post de-identified data in the 'destination' container. 
