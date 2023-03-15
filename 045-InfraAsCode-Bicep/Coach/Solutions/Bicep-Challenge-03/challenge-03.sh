# If self-deploying the challenges, recommend adding a prefix to Azure resources.
# For example, resourceGroupName = "<my initials>-challenge-01-rg"
#
# In challenge 3, new containers are added to the storage account created in Challenge 2.

LOCATION='eastus'
RESOURCE_GROUP_NAME='<me>-challenge-02-rg'
DEPLOYMENT_NAME='<me>-challenge-03-deployment'
STORAGE_ACCOUNT_NAME='<account name from challenge 2>'

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

az deployment group create \
	--name $DEPLOYMENT_NAME \
	--resource-group $RESOURCE_GROUP_NAME \
	--template-file ./challenge-03.bicep \
	--parameters storageAccountName="$STORAGE_ACCOUNT_NAME" \
	--parameters containers='("container2", "container3", "container4")'
