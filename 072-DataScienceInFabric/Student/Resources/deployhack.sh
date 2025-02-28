#!/bin/bash

read -p "Enter a prefix for your resource group and resources: " RESOURCEPREFIX
response=$(az storage account check-name --name $RESOURCEPREFIX)
available=$(jq -n --argjson data "$response" '$data.nameAvailable')

until [[ $available == "true" ]]
do
    echo "'$RESOURCEPREFIX' is not available as a storage account name. Please try a different name"
    read -p "Enter a prefix for your resource group and resources: " RESOURCEPREFIX
    response=$(az storage account check-name --name $RESOURCEPREFIX)
    available=$(jq -n --argjson data "$response" '$data.nameAvailable')
    
done

RGNAME="$RESOURCEPREFIX-rg"
deploymentName="$RESOURCEPREFIX-deployment"

read -p "Enter an Azure region to deploy to (i.e. 'eastus', 'westus', 'northeurope'): " LOCATION

echo "Creating resource group '$RGNAME' in Azure region '$LOCATION'..."
az group create --location $LOCATION --name $RGNAME

echo "Deploying Azure Storage Account where your training data will be located..."
az storage account create --name $RESOURCEPREFIX --resource-group $RGNAME --sku Standard_LRS

echo "Validating storage account for ADLS Gen 2 migration... "
az storage account hns-migration start --request-type validation --name $RESOURCEPREFIX

echo "Upgrading the Azure Storage Account to ADLS gen 2 to enable the creation of shortcuts..."
az storage account hns-migration start --request-type upgrade --name $RESOURCEPREFIX

echo "Downloading the required data from the GitHub repo..."
wget https://aka.ms/csvfabricwth

echo "Creating a container to store the directory where the data will be uploaded..."
fsresponse=$(az storage fs create -n file-system --account-name $RESOURCEPREFIX)
until [[ $fsresponse != "" ]]
do
    echo -e "\n\nAction failed. Trying again in 10 seconds..."
    sleep 10
    fsresponse=$(az storage fs create -n file-system --account-name $RESOURCEPREFIX)
done


echo "Creating a file system in the previously created container..."
az storage fs directory create -n files -f file-system --account-name $RESOURCEPREFIX

echo "Adding files to file system..."
az storage fs file upload -s "heartdata.csv" -p files/heart.csv  -f file-system --account-name $RESOURCEPREFIX

read -p "Would you like to proceed setting up the Azure Machine Learning workspace for Challenge 6 (Optional) (y/n) " CONTINUE

if [[ $CONTINUE == "y" ]]
then
az ml workspace create -n $RESOURCEPREFIX -g $RGNAME
fi
