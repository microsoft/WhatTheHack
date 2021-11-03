LOCATION='australiaeast'
RESOURCE_GROUP_NAME='challenge-02-rg'
DEPLOYMENT_NAME='challenge-04-deployment'

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

az deployment group create \
	--name $DEPLOYMENT_NAME \
	--resource-group $RESOURCE_GROUP_NAME \
	--template-file ./challenge-04.bicep \
	--parameters ./challenge-04.parameters.json
