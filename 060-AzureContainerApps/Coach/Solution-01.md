# Challenge 01 - Deploy A Simple Azure Container Application - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

This challenge requires the students to use the Azure CLI to create a simple Azure Container App (ACA) using an existing container image. It is suggested they use the following image: mcr.microsoft.com/azuredocs/containerapps-helloworld:latest

The solution does not require Docker Desktop or an Azure Container Registry and it will automatically provision a Log Analytics workspace.

## Solution

  ```bash
  # Set environment variables
  RESOURCE_GROUP="rg-container-apps"
  LOCATION="uksouth"
  CONTAINERAPPS_ENVIRONMENT="env-container-apps"

  # Create the resource group
  az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

  # Create the container app environment
  az containerapp env create \
  --name $CONTAINERAPPS_ENVIRONMENT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION

  # Create the container app
  az containerapp create \
  --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest \
  --name simple-container-app \
  --resource-group $RESOURCE_GROUP \
  --environment $CONTAINERAPPS_ENVIRONMENT \
  --target-port 443 \
  --ingress 'external' \
  --query properties.configuration.ingress.fqdn
  ```