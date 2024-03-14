#!/bin/bash -x
# Variables
RGName="wth-bicep-serverless"
cosmosDbAccountName=$(az cosmosdb list -g $RGName --query [].name -o tsv)
echo $cosmosDbAccountName
storageAccountName=$(az storage account list -g $RGName --query [].name -o tsv | grep wth)
echo $storageAccountName
eventGridTopicName=$(az eventgrid topic list -g $RGName --query [].name -o tsv)
echo $eventGridTopicName
computerVisionServiceName=$(az cognitiveservices account list -g $RGName --query [].name -o tsv)
echo $computerVisionServiceName
keyVaultName=$(az keyvault list -g $RGName --query [].name -o tsv)
echo $keyVaultName

# Populate the Function App's AppSettings with the required values
kvuri=$(az keyvault show  --name $keyVaultName --resource-group $RGName -o tsv --query properties.vaultUri) #returns URI, ends in /
echo $kvuri
cognitiveEndpoint=$(az cognitiveservices account show --name $computerVisionServiceName -g $RGName  -o tsv --query properties.endpoint) #returns URI, ends in /
echo $cognitiveEndpoint
eventgridEndpoint=$(az eventgrid topic show --name $eventGridTopicName --resource-group $RGName -o tsv --query endpoint) #doesn't end in /
echo $eventgridEndpoint
cosmosDBEndpoint=$(az cosmosdb show  --name $cosmosDbAccountName --resource-group $RGName -o tsv --query documentEndpoint) #returns URI, ends in /
echo $cosmosDBEndpoint

functionTollBoothApp=$(az functionapp list -g $RGName --query [].name -o tsv | grep app)
echo $functionTollBoothApp
functionTollBoothEvents=$(az functionapp list -g $RGName --query [].name -o tsv | grep events)
echo $functionTollBoothEvents

#be careful, if running in WSL, it may pick up your windows AZ CLI instance and then append \r characters in the variable substitution. Ensure WSL has the interop setting to appendWindowsPath = false. It can also show up in the KV secrets, making .NET to complain "New-line characters are not allowed in header values."
az functionapp config appsettings set -g $RGName -n $functionTollBoothApp --settings "computerVisionApiUrl="$cognitiveEndpoint"vision/v2.0/ocr"
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
# az storage blob upload --account-name $storageAccountName --container-name images --file .\us-1.jpg --overwrite\

# Challenge 06 - Event functions

#The CLI below uses the classic connection string app environment. 
az functionapp config appsettings set -g $RGName -n $functionTollBoothEvents --settings "cosmosDBConnectionString=@Microsoft.KeyVault(SecretUri="$kvuri"secrets/cosmosDBConnectionString/)"

##########################################################
## NOW IT'S TIME TO DEPLOY THE NODE.JS EVENTS FUNCTIONS ##
##########################################################

# EventGrid Custom Topic Subscriptions
eventFuncIdSave=$(az functionapp function show -g $RGName --name $functionTollBoothEvents --function-name savePlateData -o tsv --query id)
eventFuncIdQueue=$(az functionapp function show -g $RGName --name $functionTollBoothEvents --function-name queuePlateForManualCheckup -o tsv --query id)
eventGridTopicId=$(az eventgrid topic show --name $eventGridTopicName --resource-group $RGName --query id -o tsv)
az eventgrid event-subscription create  --name saveplatedatasub --source-resource-id $eventGridTopicId --endpoint $eventFuncIdSave --endpoint-type azurefunction --included-event-types savePlateData
az eventgrid event-subscription create  --name queueplateFormanualcheckupsub --source-resource-id $eventGridTopicId --endpoint $eventFuncIdQueue --endpoint-type azurefunction --included-event-types queuePlateForManualCheckup

