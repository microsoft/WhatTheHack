LOCATION='australiaeast'
RESOURCE_GROUP_NAME='challenge-02-rg'
DEPLOYMENT_NAME='challenge-02-deployment'

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

az deployment group create \
	--name $DEPLOYMENT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --template-file ./challenge-02.bicep \
	--parameters containerName='container1' globalRedundancy='true'
