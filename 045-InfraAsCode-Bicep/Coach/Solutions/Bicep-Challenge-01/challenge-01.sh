# If self-deploying the challenges, recommend adding a prefix to Azure resources.
# For example, resourceGroupName = "<my initials>-challenge-01-rg"

LOCATION='eastus'
RESOURCE_GROUP_NAME='<me>-challenge-01-rg'
DEPLOYMENT_NAME='<me>-challenge-01-deployment'
STORAGE_ACCOUNT_NAME='<me>ch01'

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

az deployment group create \
	--name $DEPLOYMENT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --template-file ./challenge-01.bicep \
	--parameters location=${LOCATION} storageAccountName=${STORAGE_ACCOUNT_NAME}
