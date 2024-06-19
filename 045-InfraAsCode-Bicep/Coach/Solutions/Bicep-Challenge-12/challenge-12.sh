LOCATION='eastus'
DEPLOYMENT_NAME='<me>-challenge-12-deployment'
RG='<me>-challenge-20-rg'

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

az deployment group create `
	--name $deploymentName  `
	--resource-group $resourceGroupName `
    --template-file challenge-12.bicep `
	--parameters challenge-12.parameters.json 