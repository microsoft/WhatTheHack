# Coach's Guide: Challenge 1 - Extract and load FHIR patient medical records

[< Previous Challenge](./Solution00.md) - **[Home](./readme.md)** - [Next Challenge>](./Solution02.md)

# Notes & Guidance

In this challenge, you will implement the FHIR Server Samples reference architecture to ingest and load patient data in FHIR.  You will generate synthetic FHIR patient data for bulk load into FHIR server.  To generate synthetic patient data, you will use **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** open source Java tool to simulate patient records in FHIR format.  

### FHIR bulk load scenario
In this scenario, you will deploy a storage account with a BLOB container called `fhirimport`.  Synthea generated FHIR patient data files (JSON) are copied into this storage container, and automatically ingested into FHIR server.  This bulk ingestion is performed by a BLOB triggered function app as depicted below:

![FHIR Server Bulk Load](../images/fhir-serverless-bulk-load.jpg)

## Deploy FHIR Server Samples reference architecture for Bulk Load scenario
- To deploy **[FHIR Server Samples PaaS scenario (above)](https://github.com/microsoft/fhir-server-samples)**:
    - First, clone the **['FHIR Server Samples' git repo](https://github.com/microsoft/fhir-server-samples)** to your local project repo, i.e. c:/projects and find the deployment scripts folder
        ```
        git clone https://github.com/Microsoft/fhir-server-samples
        cd fhir-server-samples/deploy/scripts
        ```
    - Before running the **[FHIR Server Samples deployment script](https://github.com/microsoft/fhir-server-samples/blob/master/deploy/scripts/Create-FhirServerSamplesEnvironment.ps1)**, you MUST login to your Azure subscription and connect to Azure AD with your secondary tenant that has directory admin role access required for this setup.
        ```
        Login-AzAccount
        Connect-AzureAd -TenantDomain <AAD TenantDomain>
        ```

        NOTE: 
        - If you have full Administrator access to a AD tenant where you can create App Registrations, Role Assignments, Azure Resources, i.e. Visual Studio Subscription, then Primary AD tenant is same as Secondary AD tenant, use the same AD tenant for both.
        - If you don't have Administrator access:
            - Primary (Resource) AD tenant: This tenant is Resource Control Plane where all your Azure Resources will be deployed to.
            - Secondary (Data) AD tenant: This tenant is Data Control Plane where all your App Registrations will be deployed to.
    - **[Deploy FHIR Server Samples](https://github.com/microsoft/fhir-server-samples#deployment)** with the managed Azure API for FHIR (PaaS) scenario:
        - Run `Create-FhirServerSamplesEnvironment.ps1` from the cloned `./deploy/scripts` folder.
    - To Validate your deployment, 
        - Check Azure resources created in {ENVIRONMENTNAME} and {ENVIRONMENTNAME}-sof Resource Groups
        - Check App Registration in secondary AAD tenat that **[all three different client application types are registered for Azure API for FHIR](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir-app-registration)**
        - Check 'Azure API for FHIR' > Authentication > 'Allowed object IDs' configuration in Azure Portal to ensure that the Azure AD object IDs of the 3 registered client applications have been added. This will allow these client apps to access this Azure API for FHIR.


## Generate FHIR patient data using SyntheaTM Patient Generator tool

**[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)**
SyntheaTM is a Synthetic Patient Population Simulator. The goal is to output synthetic, realistic (but not real), patient data and associated health records in a variety of formats.  Read **[Synthea wiki](https://github.com/synthetichealth/synthea/wiki)** for more information.
- **[Developer Quick Start](https://github.com/synthetichealth/synthea#developer-quick-start)**
    - **[Installation](https://github.com/synthetichealth/synthea#installation)**
        - System Requirements: SyntheaTM requires Java 1.8 or above.
        - Clone the SyntheaTM repo, then build and run the test suite:
            ```
            $ git clone https://github.com/synthetichealth/synthea.git
            $ cd synthea
            $ ./gradlew build check test
            ```
    - **[Changing the default properties](https://github.com/synthetichealth/synthea#changing-the-default-properties)**
        ```
        exporter.baseDirectory = ./output/fhir
        ...
        exporter.ccda.export = false
        exporter.fhir.export = true
        ...
        # the number of patients to generate, by default
        # this can be overridden by passing a different value to the Generator constructor
        generate.default_population = 1000
        ```
        
        Note:The default properties file values can be found at src/main/resources/synthea.properties. By default, synthea does not generate CCDA, CPCDA, CSV, or Bulk FHIR (ndjson). You'll need to adjust this file to activate these features. See the **[wiki](https://github.com/synthetichealth/synthea/wiki)** for more details.
    - Generate Synthetic Patients
        Generating the population 1000 at a time...
        ```
        ./run_synthea -p 1000
        ```
    - For this configuration, Synthea will output 1000 patient records in FHIR formats in `./output/fhir` folder.

## Bulk Load Synthea generated patient FHIR Bundles to FHIR Server
- Copy Synthea generated patient data to `fhirimport` BLOB, which will automatically trigger a function app to persist them into FHIR Server 
    - To **[Copy data to Azure Storage using AzCopy commandline](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
        - **[Download AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#download-azcopy)**
        - **[Run AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#run-azcopy)**
        - Add directory location of AzCopy executable to your system path
        - Type `azcopy` or `./azcopy` in Windows PowerShell commmand prompts to get started
        - Use a SAS token to copy Synthea generated patient bundle JSON file(s) to fhirimport Azure Blob storage
               Sample AzCopy command:
               ```
               azcopy copy "<your Synthea ./output director>" "<fhirimport blob container URL appended with SAS token>"
               ```
    - Alternatively **[Copy data to Azure Storage using Azure Storage Explorer UI](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)**
        - Navigate to Storage Account blade in Azure Portal, expand BLOB CONTAINERS and click on 'fhirimport' to list container content
        - Click 'Upload', and in 'Upload blob' window, browse to Synthea './result' folder and select a FHIR Patient bundle .json file(s)
    - Monitor Log Stream in function app 'FhirBundleBlobTrigger'
        - Verify in log that 'FhirBundleBlobTrigger' function auto runs when new blob detected
            Sample log output:
            ```
            Executing 'FhirBundleBlobTrigger' (Reason='New blob detected...)...
            ...
            Uploaded /...
            ...
            Executed 'FhirBundleBlobTrigger' (Succeeded, ...)
            ```
## Use Postman to retreive Patients data via FHIR Patients API
- Open Postman and import a pre-defined set of API calls. 
    - Go to the Collection and click the Raw button. 
    - Copy all of this json to your clipboard. 
    - Back in the Postman app, click the Import button near the upper-left corner of the app. 
    - Click the Raw Text tab and paste the json content you copied here. 
    - Click the Continue button and then the Import button. 
    - You should see a FHIR OpenHack collection in the left-hand pane in Postman.
- Create an Environment. A Postman Environment is just a set of variables used across one or more of your API calls. 
    - Go to the Environment and click the Raw button. 
    - Copy all of this json to your clipboard. Open Notepad, paste the json you just copied and save the file on your Desktop as fhirenv.txt. 
    - Back in Postman, in the upper-right, click the Manage Environments button (a gear icon). 
    - Click the Import button and click the Choose Files button. 
    - Browse to the fhirenv.txt file on your Desktop. 
    - Click the FHIR OpenHack environment to see it's list of variables. 
    - In the Current and Initial Value columns for each of the following variables, enter the corresponding values:
        - adtenantId: This is the tenant Id of the Secondary (Data) AD tenant
        - clientId: This is the client Id that is stored in Secret "{your resource prefix}-service-client-id" in "{your resource prefix}-ts" Key Vault.
        - clientSecret: This is the client Secret that is stored in Secret "{ENVIRONMENTNAME}-service-client-secret" in "{ENVIRONMENTNAME}-ts" Key Vault.
        - bearerToken: The value will be set when "AuthorizeGetToken SetBearer" request below is sent.
        - fhirurl: This is https://{ENVIRONMENTNAME}.azurehealthcareapis.com from Azure API for FHIR you created in Task #1 above.
        - resource: This is the Audience of the Azure API for FHIR https://{ENVIRONMENTNAME}.azurehealthcareapis.com you created in Task #1 above. You can find this Audience when you click Authetication in Azure API for FHIR you created in Task #1 above.
    - Click the Update button and close the MANAGE ENVIRONMENTS dialog.
- In the Environments drop-down, select the WTH FHIR option.
    - You will see both the Collection on the left and the Environment on the top right.
    - Configure Postman Global VAR Environment, i.e. "Azure API for FHIR Env", and include the following variables:
        - tenant_id: {yourtenantid}
        - grant_type: client_credentials
        - client_id: {yourclientidforpostman}
        - client_secret: {yourclientsecretforpostman}
        - resource: http://management.azure.com
        - subscriptionid: {yoursubscriptionid}
- Create Postman collection for FHIR API that configure the following http requests:
    - AuthorzeGetToken - Get New Access Token
    - HTTP Request:
        - Type=POST
        - URL=https://login.microsoftonline.com/{{tenantId}}/oauth2/token
    - Auth
        - Type=OAuth 2.0
    - Headers
        - Content-Type: application/x-www-form-urlencoded
            - Body
                - grant_type: client_credentials
                - client_id: {{clientId}}
                - client_secret: {{clientSecret}}
                - resource: {{resource}}        
-Run Requests:
    - Open "AuthorizeGetToken SetBearer". Confirm the environment you imported is selected in the drop-down in the top right. Click the Send button. This should pass the values in the Body to AD Tenant, get the bearer token back and assign it to variable bearerToken. The Body results also show how many seconds the token is valid before expires_in.
    - Open "Get Metadata" and click the Send button. This will return the CapabilityStatement with a Status of 200 ....This request doesn't use the bearerToken.
    - Open "Get Patient" and click the Send button. This will return all Patients stored in your FHIR server. (Postman may not show all of the results.)
    - Open "Get Patient Count" will return Count of Patients stored in your FHIR server.
    - Open "Get Patient Sort LastUpdated" will returns Patients sorted by LastUpdated date. This is the default sort.
    - Open "Get Patient Filter ID" will return one Patient with that ID. Change the ID to one you have loaded and analyze the results.
    - Open "Get Patient Filter Missing" will return data where gender is missing. Select a different column and analyze the results.
    - Open "Get Patient Filter Exact" will return a specific Patient with a given name. Select a different name and analyze the results.
    - Open "Get Patient Filter Contains" will return Patients with letters in the given name. Select different letters and analyze the results.
    - Open "Get Filter Multiple ResourceTypes" will return multiple resource types in _type. Select another resource type and analyze the results.
    
    NOTE: bearerToken expires soon, so if you get Authentication errors in any requests, re-run "AuthorizeGetToken SetBearer" to get a new bearerToken.



