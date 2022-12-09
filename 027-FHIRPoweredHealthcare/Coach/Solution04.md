# Coach's Guide: Challenge 4 - Explore and Analyze FHIR EHR Data

[< Previous Challenge](./Solution03.md) - **[Home](../README.md)** - [Next Challenge>](./Solution05.md)

## Introduction

In this challenge, you will deploy the OSS **[FHIR-to-Synapse Analytics Pipeline](https://github.com/microsoft/FHIR-Analytics-Pipelines/blob/main/FhirToDataLake/docs/Deployment.md)** to move FHIR data from Azure FHIR service to a Azure Data Lake storage in near real time and making it available to a Synapse workspace, which will enable you to query against the entire FHIR dataset with tools such as Synapse Studio, SSMS, and/or Power BI.

This pipeline is an Azure Function solution that extracts data from the FHIR server using FHIR Resource APIs, converts them to hierarchical Parquet files, and writes them to Azure Data Lake storage in near real time. It contains a script to create External Tables and Views in Synapse Serverless SQL pool pointing to the Parquet files.  You can also access the Parquet files directly from a Synapse Spark Pool to perform custom transformation to downstream systems, i.e. USCDI datamart, etc.

**First, you need to deploy an instance of FHIR service (done in challenge 1) and a **[Synapse Workspace](https://docs.microsoft.com/en-us/azure/synapse-analytics/quickstart-create-workspace)**.**
- First, create ADLSGEN2 storage account in Azure Portal for use by Synapse workspace
    - Search for Data Lake Storage Gen 2
    - Select Data Lake Storage Gen 2
    - Create new ADLSGEN2 storage account
    - Select File System and name it `users` 
- Create Synapse workspace
    - Search for Synapse in Azure Portal
    - Select Azure Synapse Analytics
    - Select Add to create workspace

**Deploy the FHIR-to-Synapse Analytics Pipeline**
- To **[deploy the pipeline](https://github.com/microsoft/FHIR-Analytics-Pipelines/blob/main/FhirToDataLake/docs/Deployment.md#1-deploy-the-pipeline)**, run this **[ARM template](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2FFHIR-Analytics-Pipelines%2Fmain%2FFhirToDataLake%2Fdeploy%2Ftemplates%2FFhirSynapsePipelineTemplate.json)** for pipeline deployment through the Azure Portal.  You will need to provide the following Azure and script parameters (at minimum):    
    - Subscription
    - Resource Group (Name of the resource group where you want the pipeline related resources to be created)
    - Region
    - App Name (A name for the Azure Function)
    - Fhir server Url (The URL of the FHIR server)
    - Authentication (Whether to access the FHIR server with managed identity authentication. Set it to false if you are using an instance of the FHIR server for Azure with public access)
    - Fhir Version (defaults to `R4`)
    - Container name (A name for the Storage Account container to which Parquet files will be written - defaults to `fhir`)
    - Filter Scope (For data filtering use. The export scope can be System or Group. Defaults to `System`)
    - Customized Schema (If enabled, pipeline Generate customized data based on given schema - defaults to `false`)
    - Package url(The build package of the agent. You need not change this)
    - Storage Account Type (Defaults to `Standard_LRS`)
    - Location (Location for all resources - Defaults to Resource group location)
    - Deploy App Insights (Whether to deploy the Application Insights - Defaults to `true`)
    - App Insight Location (The location to deploy the App Insight)

Hint: Ensure to make note of the names of the Storage Account and the Azure Function App created during the deployment.

**Provide Access of the FHIR server to the Azure Function**
- Assign the FHIR Data Reader role to the Azure Function created from the deployment above

**Verify the data movement**
- Azure Function app deployed runs automatically. 
- Time taken to write the FHIR dataset to the storage account depends on the amount of data stored in the FHIR server. 
- After the Azure Function execution is completed, you should have Parquet files stored in the Storage Account. 
- Browse to the results folder inside the container. You should see folders corresponding to different FHIR resources. 

Hint: you will see folders for only those Resources that are present in your FHIR server. Running the PowerShell **[script](https://github.com/microsoft/FHIR-Analytics-Pipelines/blob/main/FhirToDataLake/scripts/Set-SynapseEnvironment.ps1)** will create folders for other Resources.

**Provide privilege to your account**
- You must provide the following roles to your account to run the PowerShell script in the next step. You may revoke these roles after the installation is complete.
    - Assign Synapse Administrator role in your Synapse Workspace
        - Select Synapse Studio> Manage > Access Control
        - Provide `Synapse Administrator` role to your account
    - Assign the Storage Blob Data Contributor role in your Storage Account
        - Select Access Control (IAM) 
        - Assign `Storage Blob Data Contributor` role to your account

**Provide access of the Storage Account to the Synapse Workspace**
- Assign the Storage Blob Data Contributor role to your Synapse Workspace.
    - Select Managed identify while adding members to `Storage Blob Data Contributor` role. 
    - Select your Synapse workspace instance from the list of managed identities shown on the portal.
    
**Run the PowerShell script**
- Run the PowerShell **[script](https://github.com/microsoft/FHIR-Analytics-Pipelines/blob/main/FhirToDataLake/scripts/Set-SynapseEnvironment.ps1)** to create External Tables and Views in Synapse Serverless SQL Pool pointing to the Parquet files in the Storage Account.
    - Clone the **[FHIR-Analytics Pipeline](https://github.com/microsoft/FHIR-Analytics-Pipelines)** GitHub repo.
    - Open PowerShell console (ensure you have the latest version of PowerShell)
    - Install `Az` and `Az.Synapse` (if not exist)
        ```PowerShell
        Install-Module -Name Az
        Install-Module -Name Az.Synapse
        ```
    - Log into Azure subscription where Synapse exists
        ```PowerShell
        Connect-AzAccount -SubscriptionId 'yyyy-yyyy-yyyy-yyyy'
        ```
    - Run PowerShell script under the scripts folder (..\FhirToDataLake\scripts)
        ```PowerShell
        ./Set-SynapseEnvironment.ps1 -SynapseWorkspaceName "{Name of your Synapse workspace instance}" -StorageName "{Name of your storage account where Parquet files are written}".
        ```
    - Query data from Synapse Studio
        - Go to your Synapse workspace serverless SQL pool
            - Select `fhirdb` database
            - Expand External Tables and Views
            - Query FHIR data in the entities
