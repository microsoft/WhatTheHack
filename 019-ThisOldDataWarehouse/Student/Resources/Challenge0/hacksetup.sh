#!/bin/bash

#Prompt user for resource group name & Azure region location:
read -p "Enter a resource group name: " RGNAME
read -p "Enter an Azure region to deploy to (i.e. 'eastus', 'westus', 'northeurope'): " LOCATION

#az login
#az account set --subscription $subscription

echo "Creating resource group '$RGNAME' in Azure region '$LOCATION'..."
az group create --location $LOCATION --name $RGNAME

echo "Deploying Azure Container Instance with source LOB databases..."
az container create -g $RGNAME --name mdwhackdb --image whatthehackmsft/sqlserver2019_demo:1  --cpu 2 --memory 7 --ports 1433 --ip-address Public

echo "Deploying Azure Data Factory, Azure SQL Server Instance & SSIS Runtime..."
az deployment group create --name final --resource-group $RGNAME --template-file template.json --parameters parametersFile.json
