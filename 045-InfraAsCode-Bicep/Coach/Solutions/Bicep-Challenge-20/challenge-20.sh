LOCATION='eastus'
DEPLOYMENT_NAME='<me>-challenge-20-deployment'
RG='<me>-challenge-20-rg'

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

az deployment group create `
	--name $deploymentName  `
	--resource-group $resourceGroupName `
    --template-file challenge-20.bicep `
	--parameters challenge-20.parameters.json 