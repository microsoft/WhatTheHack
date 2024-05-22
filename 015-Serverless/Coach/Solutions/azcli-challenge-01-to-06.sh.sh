#!/bin/bash -x
# Variables
RGName="rg-wth-serverless"
location="canadacentral"
cosmosDbAccountName="wth-serverless-cosmosdbxx"
storageAccountName="wthserverless2014xxz"
funcStorageAccName="funccodewth2014xxz"
eventGridTopicName="wth-serverless-topic"
computerVisionServiceName="wth-serverless-ocr"
keyVaultName="wth-serverless-kvx"
functionTollBoothApp="wth-serverless-appz"
functionTollBoothEvents="wth-serverless-eventsz"

# Create a resource group
az group create --name $RGName --location $location

# Create an Azure Cosmos DB account and a SQL-compatible Database
az cosmosdb create --name $cosmosDbAccountName --kind GlobalDocumentDB --resource-group $RGName --locations regionName=$location 
az cosmosdb sql database create --account-name $cosmosDbAccountName --name LicensePlates --resource-group $RGName

# Create the containers inside the Cosmos DB account
az cosmosdb sql container create --account-name $cosmosDbAccountName --database-name LicensePlates --name Processed --partition-key-path /licensePlateText --resource-group $RGName
az cosmosdb sql container create --account-name $cosmosDbAccountName --database-name LicensePlates --name NeedsManualReview --partition-key-path /fileName --resource-group $RGName

# Create a storage account
az storage account create --name $storageAccountName --resource-group $RGName --location $location --sku Standard_LRS
az storage account create --name $funcStorageAccName --resource-group $RGName --location $location --sku Standard_LRS

# Create two blob containers "images" and "export"
az storage container create --name images --account-name $storageAccountName
az storage container create --name export --account-name $storageAccountName

# Create an Event Grid Topic
az eventgrid topic create --name $eventGridTopicName --location $location --resource-group $RGName

# Create a Computer Vision API service. WARNING: first you have to create a Cognitive Services instance via the web portal and ACCEPT the Responsable AI conditions
az cognitiveservices account create --name $computerVisionServiceName --kind ComputerVision --sku S1 --location $location --resource-group $RGName --yes

# Create a Key Vault (if done via the protal, set RBAC mode from the get-go, then add your ID as KV Admin role in order to read/write secrets)
#via CLI it's easier to create secrets if RBAC is disabled now, we'll enable RBAC later, so we avoid CLI permission issues
az keyvault create --name $keyVaultName --resource-group $RGName --location $location --sku standard --enable-rbac-authorization false

# Create secrets in the Key Vault
computerVisionApiKey=$(az cognitiveservices account keys list --name $computerVisionServiceName --resource-group $RGName --query key1 -o tsv)
eventGridTopicKey=$(az eventgrid topic key list --name $eventGridTopicName --resource-group $RGName --query key1 -o tsv)
cosmosDBAuthorizationKey=$(az cosmosdb keys list --name $cosmosDbAccountName --resource-group $RGName --type keys --query primaryMasterKey -o tsv)
blobStorageConnection=$(az storage account show-connection-string --name $storageAccountName --resource-group $RGName --query connectionString -o tsv)

az keyvault secret set --vault-name $keyVaultName --name "computerVisionApiKey" --value $computerVisionApiKey
az keyvault secret set --vault-name $keyVaultName --name "eventGridTopicKey" --value $eventGridTopicKey
az keyvault secret set --vault-name $keyVaultName --name "cosmosDBAuthorizationKey" --value $cosmosDBAuthorizationKey
az keyvault secret set --vault-name $keyVaultName --name "blobStorageConnection" --value $blobStorageConnection

# Creat the function Apps
az functionapp create --name $functionTollBoothApp --runtime dotnet-isolated --runtime-version 8 --storage-account $funcStorageAccName --consumption-plan-location "$location" --resource-group $RGName --functions-version 4
az functionapp create --name $functionTollBoothEvents --runtime node --runtime-version 18 --storage-account $funcStorageAccName --consumption-plan-location "$location" --resource-group $RGName --functions-version 4

# Grant permissions for the Functions to read secrets from KeyVault using RBAC
keyvaultResourceId=$(az keyvault show --name $keyVaultName --resource-group $RGName -o tsv --query id) 

## if the "identity assign" commands below fail via the CLI, perform this RBAC action from the Portal
az functionapp identity assign -g $RGName -n $functionTollBoothApp --role "Key Vault Secrets User"   --scope $keyvaultResourceId
az functionapp identity assign -g $RGName -n $functionTollBoothEvents  --role "Key Vault Secrets User"   --scope $keyvaultResourceId

# Setting up a KV secret for challenge 06 via the CLI before switching the KV to RBAC mode
cosmosDBConnString=$(az cosmosdb keys list --name $cosmosDbAccountName --resource-group $RGName --type connection-strings -o tsv --query "connectionStrings[?description=='Primary SQL Connection String'].connectionString")
az keyvault secret set --vault-name $keyVaultName --name "cosmosDBConnectionString" --value $cosmosDBConnString

# Enable RBAC access policy in the KV, which will make our CLI permissions to the KV insufficient from this point forward
az keyvault update --name $keyVaultName --resource-group $RGName --enable-rbac-authorization true

# Populate the Function App's AppSettings with the required values
kvuri=$(az keyvault show  --name $keyVaultName --resource-group $RGName -o tsv --query properties.vaultUri) #returns URI, ends in /
cognitiveEndpoint=$(az cognitiveservices account show --name $computerVisionServiceName -g $RGName  -o tsv --query properties.endpoint) #returns URI, ends in /
eventgridEndpoint=$(az eventgrid topic show --name $eventGridTopicName --resource-group $RGName -o tsv --query endpoint) #doesn't end in /
cosmosDBEndpoint=$(az cosmosdb show  --name $cosmosDbAccountName --resource-group $RGName -o tsv --query documentEndpoint) #returns URI, ends in /

#be careful, if running in WSL, it may pick up your windows AZ CLI instance and then append \r characters in the variable substitution. Ensure WSL has the interop setting to appendWindowsPath = false. It can also show up in the KV secrets, making .NET to complain "New-line characters are not allowed in header values."
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings "computerVisionApiUrl="$cognitiveEndpoint"vision/v3.2/ocr"
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings "computerVisionApiKey=@Microsoft.KeyVault(SecretUri="$kvuri"secrets/computerVisionApiKey/)"
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings eventGridTopicEndpoint=$eventgridEndpoint
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings "eventGridTopicKey=@Microsoft.KeyVault(SecretUri="$kvuri"secrets/eventGridTopicKey/)"
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings cosmosDBEndPointUrl=$cosmosDBEndpoint
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings "cosmosDBAuthorizationKey=@Microsoft.KeyVault(SecretUri="$kvuri"secrets/cosmosDBAuthorizationKey/)"
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings cosmosDBDatabaseId=LicensePlates
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings cosmosDBCollectionId=Processed
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings exportCsvContainerName=export
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings "blobStorageConnection=@Microsoft.KeyVault(SecretUri="$kvuri"secrets/blobStorageConnection/)"

###################################################################
## NOW IT'S TIME TO FINALIZE CHALLENGE 5 AND DEPLOY THE .NET APP ##
###################################################################

# EventGrid System Topic Subscriptions pointing to the .NET APP function
appFuncId=$(az functionapp function show -g $RGName --name $functionTollBoothApp --function-name ProcessImage -o tsv --query id)
storageAccId=$(az storage account show -n $storageAccountName -g $RGName -o tsv --query id)
az eventgrid event-subscription create  --name SubsProcessImage --source-resource-id $storageAccId --endpoint $appFuncId --endpoint-type azurefunction --included-event-types Microsoft.Storage.BlobCreated

# you can test the upload of images to the Storage via the Portal, or even easier with this CLI
# az storage blob upload --account-name $storageAccountName --container-name images --file .\us-1.jpg --overwrite


# Challenge 06 - Event functions
az functionapp config appsettings set -g $RGName -n $functionTollBoothEvents --settings "cosmosDBConnectionString=@Microsoft.KeyVault(SecretUri="$kvuri"secrets/cosmosDBConnectionString/)"
#The above uses KV. If you rader use "plaintext" in the app env variable, use the cli below
#az functionapp config appsettings set -g $RGName -n $functionTollBoothEvents --settings "cosmosDBConnectionString=$cosmosDBConnString"

##########################################################
## NOW IT'S TIME TO DEPLOY THE NODE.JS EVENTS FUNCTIONS ##
##########################################################

# EventGrid Custom Topic Subscriptions
eventFuncIdSave=$(az functionapp function show -g $RGName --name $functionTollBoothEvents --function-name savePlateData -o tsv --query id)
eventFuncIdQueue=$(az functionapp function show -g $RGName --name $functionTollBoothEvents --function-name queuePlateForManualCheckup -o tsv --query id)
eventGridTopicId=$(az eventgrid topic show --name $eventGridTopicName --resource-group $RGName --query id -o tsv)
az eventgrid event-subscription create  --name saveplatedatasub --source-resource-id $eventGridTopicId --endpoint $eventFuncIdSave --endpoint-type azurefunction --included-event-types savePlateData
az eventgrid event-subscription create  --name queueplateFormanualcheckupsub --source-resource-id $eventGridTopicId --endpoint $eventFuncIdQueue --endpoint-type azurefunction --included-event-types queuePlateForManualCheckup

#NOTE: in theory, event grid topic subscriptions should work this way
#az eventgrid topic event-subscription create  --name saveplatedatasub -g $RGName --topic-name $eventGridTopicName --endpoint $eventFuncIdSave --endpoint-type azurefunction --included-event-types savePlateData
#az eventgrid topic event-subscription create  --name queueplateFormanualcheckupsub -g $RGName --topic-name $eventGridTopicName --endpoint $eventFuncIdQueue --endpoint-type azurefunction --included-event-types queuePlateForManualCheckup