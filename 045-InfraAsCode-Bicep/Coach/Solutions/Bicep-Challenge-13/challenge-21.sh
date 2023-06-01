LOCATION='eastus'
DEPLOYMENT_NAME='<me>-challenge-13-deployment'
RG='<me>-challenge-13-rg'

# generate ssh key; save in aks and aks.pub
ssh-keygen -f aks

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

az deployment group create \
	--name $DEPLOYMENT_NAME \
	--resource-group $RG
    --template-file challenge-13.bicep \
	--parameters challenge-13.parameters.json 

