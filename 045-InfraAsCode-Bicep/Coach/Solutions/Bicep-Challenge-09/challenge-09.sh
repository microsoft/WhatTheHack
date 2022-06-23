LOCATION='australiaeast'
RESOURCE_GROUP_NAME='challenge-09-rg'
DEPLOYMENT_NAME='challenge-09-deployment'

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

SCRIPT=$(cat ../scripts/install-apache.sh)

az deployment group create \
	--name $DEPLOYMENT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --template-file ./challenge-09.bicep \
	--parameters ./challenge-09.parameters.json \
    --parameters customScript="$SCRIPT"
