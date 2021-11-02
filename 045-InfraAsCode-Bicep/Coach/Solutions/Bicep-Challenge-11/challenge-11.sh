LOCATION='eastus'
DEPLOYMENT_NAME='challenge-11-deployment'

az deployment sub create \
	--name $DEPLOYMENT_NAME \
    --template-file challenge-11.bicep \
	--parameters challenge-11.parameters.json \
