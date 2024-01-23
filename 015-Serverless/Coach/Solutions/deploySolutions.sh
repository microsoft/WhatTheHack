#!/bin/bash -x
# Variables
RGName="rg-wth-serverless"
location="canadacentral"
cosmosDbAccountName="wth-serverless-cosmosdb"
storageAccountName="wthserverless2014xyz"
eventGridTopicName="wth-serverless-topic"
computerVisionServiceName="wth-serverless-ocr"
keyVaultName="wth-serverless-kv"
functionTollBoothApp="wth-serverless-app"
functionTollBoothEvents="wth-serverless-events"

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

# Create two blob containers "images" and "export"
az storage container create --name images --account-name $storageAccountName
az storage container create --name export --account-name $storageAccountName

# Create an Event Grid Topic
az eventgrid topic create --name $eventGridTopicName --location $location --resource-group $RGName

# Create a Computer Vision API service
az cognitiveservices account create --name $computerVisionServiceName --kind ComputerVision --sku S1 --location $location --resource-group $RGName --yes

# Create a Key Vault
az keyvault create --name $keyVaultName --resource-group $RGName --location $location --sku standard --enable-rbac-authorization false #we'll enable RBAC after creating the secrets via the CLI to avoid permission issues

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
az functionapp create --name $functionTollBoothApp --runtime dotnet --runtime-version 6 --storage-account $storageAccountName --consumption-plan-location "$location" --resource-group $RGName --functions-version 4
az functionapp create --name $functionTollBoothEvents --runtime node --runtime-version 18 --storage-account $storageAccountName --consumption-plan-location "$location" --resource-group $RGName --functions-version 4

# Grant permissions for the Functiosn to read secrets from KeyVault using RBAC
keyvaultResourceId=$(az keyvault show --name $keyVaultName --resource-group $RGName -o tsv --query id) 

## ATTENTION ##
## if the "identity assign" commands fail via the CLI, perform this RBAC action from the Portal
az functionapp identity assign -g $RGName -n $functionTollBoothApp --role "Key Vault Secrets User"   --scope $keyvaultResourceId
az functionapp identity assign -g $RGName -n $functionTollBoothEvents  --role "Key Vault Secrets User"   --scope $keyvaultResourceId

# Enable RBAC access policy in the KV, which will make our CLI permissions to the KV insufficient
az keyvault update --name $keyVaultName --resource-group $RGName --enable-rbac-authorization true

# Populate the Function App's AppSettings with the required values
kvuri=$(az keyvault show  --name $keyVaultName --resource-group $RGName -o tsv --query properties.vaultUri) #returns URI, ends in /
cognitiveEndpoint=$(az cognitiveservices account show --name $computerVisionServiceName -g $RGName  -o tsv --query properties.endpoint) #returns URI, ends in /
eventgridEndpoint=$(az eventgrid topic show --name $eventGridTopicName --resource-group $RGName -o tsv --query endpoint) #doesn't end in /
cosmosDBEndpoint=$(az cosmosdb show  --name $cosmosDbAccountName --resource-group $RGName -o tsv --query documentEndpoint) #returns URI, ends in /

az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings "computerVisionApiUrl="$cognitiveEndpoint"vision/v2.0/ocr"
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings "computerVisionApiKey=@Microsoft.KeyVault(SecretUri="$kvuri"computerVisionApiKey/)"
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings eventGridTopicEndpoint=$eventgridEndpoint
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings "eventGridTopicKey=@Microsoft.KeyVault(SecretUri="$kvuri"eventGridTopicKey/)"
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings cosmosDBEndPointUrl=$cosmosDBEndpoint
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings "cosmosDBAuthorizationKey=@Microsoft.KeyVault(SecretUri="$kvuri"cosmosDBAuthorizationKey/)"
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings cosmosDBDatabaseId=LicensePlates
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings cosmosDBCollectionId=Processed
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings exportCsvContainerName=export
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings "blobStorageConnection=@Microsoft.KeyVault(SecretUri="$kvuri"blobStorageConnection/)"
# TO-DO: EventGrid Topic Subscriptions

# Challenge 06
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings wth-serverless_DOCUMENTDB=$cosmosDBEndpoint
# TO-DO: EventGrid Topic Subscriptions