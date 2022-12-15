#!/bin/bash

#Prompt user for resource group name & Azure region location:
read -p "Enter a resource group name where the hack's resources will be deployed. \n (If using a shared Azure subscription, include your initials in the resource group name): " RGNAME

read -p "Enter an Azure region to deploy to (ie. 'eastus', 'westus', 'northeurope'): " LOCATION

echo $RGNAME
echo $LOCATION

#az login
#az account set --subscription $subscription
#az group create --location $location --name $rgname
#az container create -g $rgname --name mdwhackdb --image whatthehackmsft/sqlserver2019_demo:1  --cpu 2 --memory 7 --ports 1433 --ip-address Public
#az deployment group create --name final --resource-group $rgname --template-file template.json --parameters parametersFile.json
