# What The Hack - Solution 01 

# Challenge \1: Coach's Guide \Prepare your auto-generated FHIR data and FHIR Server

[< Previous Challenge](./Solution00.md) - **[Home](../readme.md)** - [Next Challenge>](./Solution02.md)

## Notes & Guidance
# Configure FHIR server
- Create a new service principal
    - Run $ az ad sp create-for-rbac -o json
    - Copy "appid" and "password" from output for use later
    - Find "objectid" of this new Service Principal
        - Run $ az ad sp show --id {appId of the new SP} -o json | jq -r . objectId
        Note: You need to install jq on Windows beforehand - run in PowerShell https://chocolatey.org/packages/jq, 
        i.e. Run $ choco install jq
- Deploy ARM template for the new FHIR service
    - Create resource group in "NorthCentralUS" (supported region for FHIR service preview)
        - Run $ az group create --name myRG --location northcentralus
    - Run the template and use the "objectId" from above,
        - Run $ az group deployment create --template-file azuredeploy.json --parameters azuredeploy.parameters.json --parameters accessPolicyObjectId={objectId of SP} -g Athena-Hack --no-wait
        Note: Need to update azuredeploy.parameters.json file to use all lower case name value, i.e. "myserver".
        - Monitor deployment progress from "Deployments" blade of the resource gorup

# Configure the node.js data generation app
- We’ll be adding a new configuration section to the “config.json” file.
- Copy and paste one of the pre-existing environments and change values that are different from the “default” configuration. Typically, these values include:
    - “tenant”: The Azure AD tenant in which you created the service principal above > microsoft.onmicrosoft.com , tenant id: 72f988bf-86f1-41af-91ab-2d7cd011db47
    - “applicationId”: The “appId” value we saved during the creation of the service principal. > e8105de9-72f7-46ef-b787-e2be47a325d0
    - “clientSecret”: The “password” value we saved during the creation of the service principal. > 766268ed-a688-43f5-a0ff-d6ad24f27a74
- “fhirApiUrl”: The URL to the FHIR service created above. You can find this on the Overview blade of the Azure API for FHIR resource under FHIR metadata endpoint or go to https://{yourfhirserverurl}/metadata

# (Optional) (Optional) Setup Postman to access FHIR API
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
# Run the data generation app to insert auto-generated test patient records
- Download all dependencies
    - Run $ npm install at the root folder of the project working directory.
- Setting NODE_ENV
    - Run $ Set NODE_ENV=<environmentname>
- (Optional) Install npm module dotenv to configure environment via .env file
    - Create ".env" file in project directory with the following content: "NODE_ENV=richard1"
    - Install dotenv npm module
        - Run $ npm install dotenv --save
- Install FHIR npm library
    - Run $ npm install fhir
- Run the datagen.js app to loop and create endless # of patients.  Press Ctrl-C when enough records have been created
    - First, set environment to {yourenvname} in config.json
        - Run $ Set NODE_ENV={yourenvname}
    - Run $ node datagen.js 
- Test datagen.js app to make sure new patient records can be read
    - Run $ node dataread.js
    Note: These recrods are read in pages of 100 at a time

We’re now finished, make sure there at least 10,000 patient records in the server before the hack starts.
