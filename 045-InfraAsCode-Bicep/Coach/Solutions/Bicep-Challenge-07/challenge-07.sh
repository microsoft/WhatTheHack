LOCATION='australiaeast'
RESOURCE_GROUP_NAME='challenge-07-rg'
DEPLOYMENT_NAME='challenge-07-deployment'

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

SCRIPT=$(cat ../scripts/install-apache.sh)

az deployment group create \
	--name $DEPLOYMENT_NAME \
	--resource-group $RESOURCE_GROUP_NAME \
	--template-file ./challenge-07.bicep \
	--parameters ./challenge-07.parameters.json \
    --parameters customScript="$SCRIPT"