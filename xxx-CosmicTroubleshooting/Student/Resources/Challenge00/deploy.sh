#!/bin/bash

RG_NAME=${1:-rg-wth-azurecosmosdb}
SEED_DATABASE=1


# Read the bicep parameters
parametersfilename='./WTHAzureCosmosDB.IaC/main.parameters.json'

echo "Deploying infrastructure"

location=`jq -r ".parameters.location.value" $parametersfilename`

# Deploy our infrastructure
output=$(az deployment sub create \
  --location $location \
  --template-file "WTHAzureCosmosDB.IaC/main.bicep" \
  --parameters @$parametersfilename)


originDir=$PWD

echo "Building and publishing solution"
# Build and publish the solution
dotnet publish "WTHAzureCosmosDB.sln" -c "Release" -clp:ErrorsOnly
cd "./WTHAzureCosmosDB.Web/bin/Release/net6.0/publish/"
zip -r deploy.zip *

# Publish the web app to azure and clean up
webAppName=`echo $output | jq -r '.properties.outputs.webAppName.value'`
suppressOutput=$(az webapp deployment source config-zip -g $RG_NAME -n $webAppName --src "./deploy.zip")
rm "./deploy.zip"
cd $originDir


cd  "./WTHAzureCosmosDB.Console"

# Seed the database
if [ $SEED_DATABASE == 1 ]; then
        echo "Seeding the Azure Cosmos DB database with data"
        dotnet run /seedProducts /connString `echo $output | jq -r '.properties.outputs.cosmosDbConnectionString.value'` -clp:ErrorsOnly
    fi

bicepDeploymentOutputs=`echo $output | jq -r '.properties.outputs'`

cd ..