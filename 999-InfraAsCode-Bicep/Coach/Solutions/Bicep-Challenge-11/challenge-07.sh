LOCATION='eastus'
DEPLOYMENT_NAME='challenge-07-deployment'

az deployment sub create \
	--name $DEPLOYMENT_NAME \
    --template-file challenge-07.bicep \
	--parameters challenge-07.parameters.json \
