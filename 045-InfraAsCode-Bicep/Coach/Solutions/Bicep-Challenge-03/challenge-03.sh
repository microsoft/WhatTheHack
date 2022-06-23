LOCATION='australiaeast'
RESOURCE_GROUP_NAME='challenge-02-rg'
DEPLOYMENT_NAME='challenge-03-deployment'
STORAGE_ACCOUNT_NAME='<name of existing storage account>'

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

az deployment group create \
	--name $DEPLOYMENT_NAME \
	--resource-group $RESOURCE_GROUP_NAME \
	--template-file ./challenge-03.bicep \
	--parameters storageAccountName="$STORAGE_ACCOUNT_NAME" \
	--parameters containers='("container2", "container3", "container4")'
