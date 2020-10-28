# Coach's Guide: Challenge 1 - Extract, transform and load patient data

[< Previous Challenge](./Solution00.md) - **[Home](./readme.md)** - [Next Challenge>](./Solution02.md)

# Notes & Guidance

## Configure FHIR server
- Create a new service principal
    - Run `$ az ad sp create-for-rbac -o json`
    - Copy "appid" and "password" from output for use later
    - Find "objectid" of this new Service Principal
        - Run `$ az ad sp show --id {appId of the new SP} -o json | jq -r . objectId`
        - Note: You need to install jq on Windows beforehand, run in PowerShell https://chocolatey.org/packages/jq, 
         - i.e. Run `$ choco install jq`
- Deploy ARM template for the new FHIR service
    - Create resource group in "NorthCentralUS" (supported region for FHIR service preview)
        - Run `$ az group create --name myRG --location northcentralus`
    - Run the template and use the "objectId" from above,
        - Run `$ az group deployment create --template-file azuredeploy.json --parameters azuredeploy.parameters.json --parameters accessPolicyObjectId={objectId of SP} -g WTH-FHIR --no-wait`
        - Note: Need to update azuredeploy.parameters.json file to use all lower case name value, i.e. "myserver".
        - Monitor deployment progress from "Deployments" blade of the resource gorup

## API Load Option: 
### Auto generate test FHIR patient data via serverless function:
- Configure the node.js data generation app
    - We’ll be adding a new configuration section to the “config.json” file.
    - Copy and paste one of the pre-existing environments and change values that are different from the “default” configuration. Typically, these values include:
        - “tenant”: The Azure AD tenant in which you created the service principal above > microsoft.onmicrosoft.com , tenant id: {your tenant id}
        - “applicationId”: The “appId” value we saved during the creation of the service principal.
        - “clientSecret”: The “password” value we saved during the creation of the service principal.
    - “fhirApiUrl”: The URL to the FHIR service created above. You can find this on the Overview blade of the Azure API for FHIR resource under FHIR metadata endpoint or go to https://{yourfhirserverurl}/metadata

### Run the data generation app to insert auto-generated test patient records into FHIR Server
- Download all dependencies
    - Run `$ npm install` at the root folder of the project working directory.
- Setting NODE_ENV
    - Run `$ Set NODE_ENV=<environmentname>`
- (Optional) Install npm module dotenv to configure environment via .env file
    - Create ".env" file in project directory with the following content: "NODE_ENV=richard1"
    - Install dotenv npm module
        - Run `$ npm install dotenv --save`
- Install FHIR npm library
    - Run `$ npm install fhir`
- Run the datagen.js app to loop and create endless # of patients.  Press Ctrl-C when enough records have been created
    - First, set environment to {yourenvname} in config.json
        - Run `$ Set NODE_ENV={yourenvname}`
    - Run `$ node datagen.js`
- Test datagen.js app to make sure new patient records can be read
    - Run `$ node dataread.js`
    - Note: These recrods are read in pages of 100 at a time
- We’re now finished, make sure there at least 10,000 patient records in the server before starting the next challenge.

### (Optional) Setup Postman to access patient data inserted into FHIR Server via API call
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

## Bulk Load Option: 

### Auto generate FHIR patient data via SyntheaTM Patient Generator tool

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
    - The default properties file values can be found at src/main/resources/synthea.properties. By default, synthea does not generate CCDA, CPCDA, CSV, or Bulk FHIR (ndjson). You'll need to adjust this file to activate these features. See the **[wiki](https://github.com/synthetichealth/synthea/wiki)** for more details.

### **[Generate Synthetic Patients](https://github.com/synthetichealth/synthea#generate-synthetic-patients)**
- Generating the population one at a time...
    - $ ./run_synthea
- Command-line arguments may be provided to specify a state, city, population size, or seed for randomization.
    - Usage is:
    - run_synthea [-s seed] [-p populationSize] [-m moduleFilter] [state [city]]
    - For example:
        - `run_synthea Massachusetts`
        - `run_synthea Alaska Juneau`
        - `run_synthea -s 12345`
        - `run_synthea -p 1000`
        - `run_synthea -s 987 Washington Seattle`
        - `run_synthea -s 21 -p 100 Utah "Salt Lake City"`
        - `run_synthea -m metabolic*`
    - Note: Some settings can be changed in ./src/main/resources/synthea.properties.
- SyntheaTM will output patient records in C-CDA and FHIR formats in ./output.

### Deploy **[FHIR Server sample PaaS scenario for Bulk Load](https://github.com/microsoft/fhir-server-samples)**
In the Azure API for FHIR (PaaS scenario) deployments depicted below, a storage account will be deploy and in this storage account there is a BLOB container called fhirimport, patient bundles generated with Synthea can dumped in this storage container and they will be loaded into the FHIR server. The bulk load is performed by an Azure Function.

![Azure API for FHIR PaaS server:](../images/fhir-server-samples-paas.png)


- First, clone this 'FHIR Server Samples' git repo to local project repo, i.e. c:/projects and change directory to deploy/scripts folder:
    ```
    $ git clone https://github.com/Microsoft/fhir-server-samples
    $ cd fhir-server-samples/deploy/scripts
    ```
- Deploy FHIR Server Samples Bulk Load components (Function Bulk Load and Storage fhirimport) via azuredeploy-importer deployment template in Azure portal
    - Browse to Azure Portal and navigate to Resource Group for WhatTheHack FHIR Event-driven Patient Search project
    - Add 'Template Deployment' Azure resource
    - Deploy using Custom Template JSON file: 'azuredeploy-importer.json'
        - In 'Custom deployment', click 'Build your own template...'
        - In 'Edit template', Load 'azuredeploy-importer.json' file from 'fhirserversample/deployment/template' folder
        - Setup template parameters and create resources:
            Basics:
            - Subscription
            - Resource Group
            - Location/Region
            Settings:
            - App Name (Unique function app name in lowercase)
            - Storage Account Type (i.e. Standard_LRS)
            - Aad Authority (i.e. https://login.microsoftonline.com/microsoft.onmicrosoft.com)
            - Aad Audience (Leave blank, default to fhirServerURL)
            - fhir Server Url (Obtain from Azure API for FHIR)
            - Aad Service Client Id (Obtain from Azure API for FHIR)
            - Aad Service Client Secret (Obtain from Azure API for FHIR)
### Use Azure data utility tools to copy Synthea generated FHIR patient bundle data files to fhirimport Blob Container for bulk load into FHIR Server 
- Option 1: **[Copy data to Azure Storage using AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)**
    - **[Download AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#download-azcopy)**
    - **[Run AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#run-azcopy)**
        - Add directory location of AzCopy executable to your system path
        - Type `azcopy` or `./azcopy` in Windows PowerShell commmand prompts to get started
        - Use a SAS token to copy Synthea generated patient bundle JSON file(s) to fhirimport Azure Blob storage
               Sample AzCopy command:
               ```
               azcopy copy "<your Synthea ./output director>" "<fhirimport blob container URL appended with SAS token>"
               ```
- Option 2: **[Copy data to Azure Storage using Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#use-azcopy-in-azure-storage-explorer)**
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
- (Optional) Use Postman to retreive Patients data via FHIR Patients API (see above)          
            



