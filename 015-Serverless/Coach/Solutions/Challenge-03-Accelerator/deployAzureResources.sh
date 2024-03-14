#!/bin/bash -x
# Variables
RGName="wth-serverless-rg"
location="eastus"

# Register Resource Providers
az provider register -n 'Microsoft.DocumentDB'
az provider register -n 'Microsoft.EventGrid'
az provider register -n 'Microsoft.KeyVault'
az provider register -n 'Microsoft.Web'
az provider register -n 'Microsoft.CognitiveServices' --accept-terms

# Create a resource group
az group create --name $RGName --location $location

# Deploy bicep template
az deployment group create -f main.bicep -g $RGName -n wth-serverless-rg
