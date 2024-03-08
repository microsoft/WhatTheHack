#!/bin/bash -x
# Variables
RGName="wth-serverless-rg"
location="eastus"
computerVisionServiceName="wth-serverless-ocr"
eventGridTopicName="wth-serverless-topic"

# The following values all must be globally unique
# You should change the numeric suffixes of each value to be a unique value
cosmosDbAccountName="wth-serverless-cosmosdb-1452644"
storageAccountName="wthserverless1452644"
keyVaultName="wth-kv-1452644"
functionTollBoothApp="wth-serverless-app-1452644"
functionTollBoothEvents="wth-serverless-events-1452644"

# Register Resource Providers
az provider register -n 'Microsoft.DocumentDB'
az provider register -n 'Microsoft.EventGrid'
az provider register -n 'Microsoft.KeyVault'
az provider register -n 'Microsoft.Web'
az provider register -n 'Microsoft.CognitiveServices' --accept-terms

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
az functionapp create --name $functionTollBoothApp --runtime dotnet --runtime-version 6 --storage-account $storageAccountName --consumption-plan-location "$location" --resource-group $RGName --functions-version 4
az functionapp create --name $functionTollBoothEvents --runtime node --runtime-version 18 --storage-account $storageAccountName --consumption-plan-location "$location" --resource-group $RGName --functions-version 4

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