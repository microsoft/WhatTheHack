# Coach's Guide: Challenge 1 - Extract and Load FHIR EHR Data

[< Previous Challenge](./Solution00.md) - **[Home](./README.md)** - [Next Challenge>](./Solution02.md)

## Notes & Guidance

In this challenge, you will implement the **[FHIR Bulk Loader](https://github.com/microsoft/fhir-loader)** function app based event-driven architecture to ingest and load patient data in FHIR.  You will generate synthetic FHIR patient data for bulk data load into the FHIR service.  To generate synthetic patient data, you will use **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** open source Java tool to simulate patient records in FHIR format.  

### FHIR bulk load scenario
In this scenario, you will deploy a storage account with a BLOB container and copy Synthea generated FHIR patient data files (JSON Bundles) into it.  These FHIR Bundles will be automatically ingested into the FHIR service.

**First you will deploy **[Azure Health Data Services workspace](https://docs.microsoft.com/en-us/azure/healthcare-apis/workspace-overview)** and then **[deploy a FHIR service](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/fhir-portal-quickstart)** instance within the workspace.**

Hint: 
- You can deploy separate AHDS workspace to enable data segregation for each project/customer.
- You can deploy 1 or more instance(s) of FHIR service in the ADHS workspace based on your requirements/use cases. 

**You will then implement the **[FHIR Bulk Loader](https://github.com/microsoft/fhir-loader)** Function App solution to ingest and load Synthea generated FHIR patient data into the FHIR service in near real-time.**

Hint: These scripts will gather (and export) information necessary for the proper deployment and configuration of FHIR Bulk Loader. Credentials and other secure information will be stored in the existing Key Vault attached to your FHIR Service deployment.

- Install and configure FHIR Bulk Loader with the deploy **[script](https://github.com/microsoft/fhir-loader/blob/main/scripts/Readme.md#getting-started)**.
    - Launch Azure Cloud Shell (Bash Environment) in your Azure Portal
    - Clone the repo to your Bash Shell (CLI) environment
        ```bash
        git clone https://github.com/microsoft/fhir-loader
        ```
    - Change working directory to the repo `scripts` directory
        ```bash
        cd $HOME/fhir-loader/scripts
        ```
    - Make the Bash Shell script used for deployment and setup executable
        ```bash
        chmod +x *.bash
        ```
    - Run `deployFHIRBulk.bash` script
        ```bash
        cd $HOME/fhir-loader/scripts
        ./deployFhirBulk.bash 
        ```
        Hint: 
        1) This deployment script prompts users for Azure parameters and FHIR Service Client Application connection information (if not found in Key Vault):
        - Subscription ID (Accept default value if correct)
        - Resource Group Name (This script will look for an existing resource group, otherwise a new one will be created)
        - Resource Group Location, i.e. eastus (If creating a *new* resource group, you need to set a location)
        - Deployment prefix (Enter your deploy prefix - bulk components begin with this prefix)
        - Function App Name (Enter the bulk loader function app name - this is the name of the function app)
        - Operation Mode (Enter `fhir` to set FHIR Bulk Loader to the FHIR Service for this challege)
        - Key Vault Name (Script searches for FHIR Service values in the Key Vault, and if found, loads them; otherwise script prompts for the FHIR Service configuration values)
            - FHIR Service URL (FS-URL), 
            - Resource ID (FS-URL), 
            - Tenant Name (FS-TENANT-NAME), 
            - Client ID (FS-CLIENT-ID), 
            - Client Secret (FS-SECRET), 
            - Audience (FS-Resource)
        2) The deployment script connects the Event Grid System Topics with the respective function app
    - Optionally the deployment script can be used with command line options
        ```bash
        ./deployFhirBulk.bash -i <subscriptionId> -g <resourceGroupName> -l <resourceGroupLocation> -n <deployPrefix> -k <keyVaultName> -o <fhir or proxy> 
        ```
- Validate your deployment, check Azure components installed:
   - Function App with App Insights and Storage
   - Function App Service plan
   - EventGrid
   - Storage Account (with containers)
   - Key Vault (if none exist)

**Generate FHIR patient data using **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** tool**

**[SyntheaTM](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** is a Synthetic Patient Population Simulator. The goal is to output synthetic, realistic (but not real), patient data and associated health records in a variety of formats.  Read **[Synthea wiki](https://github.com/synthetichealth/synthea/wiki)** for more information.
- **[Developer Quick Start](https://github.com/synthetichealth/synthea#developer-quick-start)**
    - **[Installation](https://github.com/synthetichealth/synthea#installation)**
        - System Requirements: SyntheaTM requires Java 1.8 or above.
        - Clone the SyntheaTM repo, then build and run the test suite:
            ```bash
            $ git clone https://github.com/synthetichealth/synthea.git
            $ cd synthea
            $ ./gradlew build check test
            ```
    - Update the **[default properties](https://github.com/synthetichealth/synthea#changing-the-default-properties)** for FHIR output
        - Change the Synthea export directory to `./output/fhir`, set `exporter.baseDirectory = ./output/fhir`
        - Enable FHIR bundle export, set `exporter.fhir.export = true` property
        - Configure Synthea to generate 1000 patient records, set `generate.default_population = 1000` property
        ```properties
        exporter.baseDirectory = ./output/fhir
        ...
        exporter.ccda.export = false
        exporter.fhir.export = true
        ...
        # the number of patients to generate, by default
        # this can be overridden by passing a different value to the Generator constructor
        generate.default_population = 1000
        ```
        
        **Note:** The default properties file values can be found at src/main/resources/synthea.properties. By default, synthea does not generate CCDA, CPCDA, CSV, or Bulk FHIR (ndjson). You'll need to adjust this file to activate these features. See the **[wiki](https://github.com/synthetichealth/synthea/wiki)** for more details.
    - Generate Synthetic Patients
        Generating the population 1000 at a time...
        ```bash
        ./run_synthea -p 1000
        ```
    - For this configuration, Synthea will output 1000 patient records in FHIR formats in `./output/fhir` folder.

**Bulk Load Synthea generated patient FHIR Bundles to FHIR service**
- Copy Synthea generated patient data to `bundles` BLOB, which will automatically trigger a function app to persist them to FHIR Server 
    - To copy data to Azure Storage using **[AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)** commandline tool
        - **[Download AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#download-azcopy)**
        - **[Run AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#run-azcopy)**
        - Add directory location of AzCopy executable to your system path
        - Type `azcopy` or `./azcopy` in Windows PowerShell command prompts to get started
        - Use a SAS token to copy Synthea generated patient bundle JSON file(s) to fhirimport Azure Blob storage
            - Sample AzCopy command:
               ```bash
               azcopy copy "<your Synthea ./output/fhir directory>" "<fhirimport blob container URL appended with SAS token>"
               ```
    - Alternatively, copy data to Azure Storage using **[Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-storage-explorer#upload-blobs-to-the-container)** user interface
        - Navigate to Storage Account blade in Azure Portal, expand BLOB CONTAINERS and click on `fhirimport` to list container content
        - Click `Upload`, and in `Upload blob` window, browse to Synthea `./result/fhir` folder and select a FHIR Patient bundle .json file(s)
    - Monitor Log Stream in function app 'FhirBundleBlobTrigger'
        - Verify in log that 'FhirBundleBlobTrigger' function auto runs when new blob detected
            - Sample log output:
            ```bash
            Executing 'FhirBundleBlobTrigger' (Reason='New blob detected...)...
            ...
            Uploaded /...
            ...
            Executed 'FhirBundleBlobTrigger' (Succeeded, ...)
            ```
**Use Postman to retrieve Patients data via FHIR Patients API**
- You need to first register your **[public client application](https://learn.microsoft.com/en-us/azure/healthcare-apis/register-application)**  to connect Postman desktop app to FHIR service in Azure Health Data Services.
- Then **[Configure RBAC roles](https://learn.microsoft.com/en-us/azure/healthcare-apis/configure-azure-rbac)**  to assign access to the Azure Health Data Services data plane.
- To **[access FHIR service using Postman](https://learn.microsoft.com/en-us/azure/healthcare-apis/fhir/use-postman)**, open Postman and **[import Postman data](https://learning.postman.com/docs/getting-started/importing-and-exporting-data/)**: 
    - In Postman, click Import.
    - In your **[Student Resources folder for Postman](../Student/Resources/Postman)**, select **[Environment](../Student/Resources/Postman/WTHFHIR.postman_environment.json)** and **[Collection](../Student/Resources/Postman/WTHFHIR.postman_collection.json)** JSON files.
    - Confirm the name, format, and import as, then click Import to bring your data into your Postman.
    - You will get confirmation that `WTH FHIR` Collection and Environment were imported and see in Postman a new `WTH FHIR` in `Collections` (left) blade and top right `Manage Environments` drop-down list.
   - Select `WTH FHIR` environment and click `Environment Quick Look` button to see a list of env vars: 
    - Click `Edit` to open `Management Environments` window and input the corresponding FHIR environment values:
        - `adtenantId`: This is the tenant Id of the Secondary (Data) AD tenant
        - `clientId`: This is the client Id that is stored in Secret `{your resource prefix}-service-client-id`" in `{your resource prefix}-ts` Key Vault.
        - `clientSecret`: This is the client Secret that is stored in Secret `{ENVIRONMENTNAME}- service-client-secret` in `{ENVIRONMENTNAME}-ts` Key Vault.
        - `bearerToken`: The value will be set when `AuthorizeGetToken SetBearer` request below is sent.
        - `fhirurl`: This is the FHIR URL `https://{ENVIRONMENTNAME}.azurehealthcareapis.com` from Azure API for FHIR you created in Task #1 above.
        - `resource`: This is the Audience of the Azure API for FHIR `https://{ENVIRONMENTNAME}.azurehealthcareapis.com` you created. You can find this Audience in Azure Portal when you click Authetication in Azure API for FHIR resource.
    - Click the Update button and close the `MANAGE ENVIRONMENTS` window.
- Run FHIR API HTTP Requests:
    - First, open `AuthorizeGetToken SetBearer` and confirm `WTH FHIR` environment is selected in the top-right `Environment` drop-down. 
        - Click the Send button to pass the values in the Body to AD Tenant, get the bearer token back and assign it to variable bearerToken.
    - Open `Get Patient` and click the `Send` button. This will return all Patients stored in your FHIR Server. (Postman may not show all the results.)
    - Open `Get Patient Count` and click the `Send` button.  This will return Count of Patients stored in your FHIR Server.  
    - Open `Get Patient Filter ID` and click the `Send` button.  This will return a Patient with that ID. Change the ID to one you have loaded and validate that it exists.
    - Open `Get Patient Filter Exact` and click the `Send` button.  This will return a Patient with the specified given name. Specify a given name from your FHIR import and validate it exists.
    - Open `Get Patient Filter Contains` and click the `Send` button.  This will return Patients with Given name that contains the specified letters. Specify a partial given name from your FHIR import and validate it exists.
    
    **Note:** `bearerToken` has expiration, so if you get Authentication errors in any requests, re-run `AuthorizeGetToken SetBearer` to get a new `bearerToken`.



