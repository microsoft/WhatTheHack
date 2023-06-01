# If self-deploying the challenges, recommend adding a prefix to Azure resources.
# For example, resourceGroupName = "<my initials>-challenge-01-rg"
#
# From PSH terminal in the directory for these files, run ".\challenge-04.ps1"

LOCATION='eastus'
RESOURCE_GROUP_NAME='<me>-challenge-05-rg'
DEPLOYMENT_NAME='<me>-challenge-05-deployment'

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

az deployment group create \
	--name $DEPLOYMENT_NAME \
	--resource-group $RESOURCE_GROUP_NAME \
	--template-file ./challenge-05.bicep \
	--parameters ./challenge-05.parameters.json
