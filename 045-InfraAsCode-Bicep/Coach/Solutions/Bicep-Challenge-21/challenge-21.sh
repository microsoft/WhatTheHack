LOCATION='eastus'
DEPLOYMENT_NAME='<me>-challenge-21-deployment'
RG='<me>-challenge-21-rg'

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

az deployment group create \
	--name $DEPLOYMENT_NAME \
	--resource-group $RG
    --template-file challenge-21.bicep \
	--parameters challenge-21.parameters.json 

