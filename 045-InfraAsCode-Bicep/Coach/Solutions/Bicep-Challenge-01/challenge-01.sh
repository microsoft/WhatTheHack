LOCATION='australiaeast'
RESOURCE_GROUP_NAME='challenge-01-rg'
DEPLOYMENT_NAME='challenge-01-deployment'
STORAGE_ACCOUNT_NAME='add random chars to create a unique storage account name >=3 chars && <= 24 chars'

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

az deployment group create \
	--name $DEPLOYMENT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --template-file ./challenge-01.bicep \
	--parameters location=${LOCATION} storageAccountName=${STORAGE_ACCOUNT_NAME}
