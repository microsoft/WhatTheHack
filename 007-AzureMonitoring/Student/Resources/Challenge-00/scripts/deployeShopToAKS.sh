#!/bin/bash

# This script is designed to be run in an ACI container via Bicep Deployment script

# Input Params expected as Environment Variable:

# RESOURCE_GROUP
# AKS_CLUSTER_NAME
# APP_INSIGHTS_NAME
# SQLSERVER_NAME
# SQL_USERNAME
# SQL_PASSWORD

# Install the Azure CLI application-insights extension
az extension add --name application-insights

# Construct the two database connection strings from the environment variables:
catalogConnection="Server=$SQLSERVER_NAME;Integrated Security=false;User ID=$SQL_USERNAME;Password=$SQL_PASSWORD;Initial Catalog=Microsoft.eShopOnWeb.CatalogDb;TrustServerCertificate=True"
identityConnection="Server=$SQLSERVER_NAME;Integrated Security=false;User ID=$SQL_USERNAME;Password=$SQL_PASSWORD;Initial Catalog=Microsoft.eShopOnWeb.Identity;TrustServerCertificate=True"

# Get the App Insights connection string
appInsightsConnection=$(az monitor app-insights component show --app $APP_INSIGHTS_NAME --resource-group $RESOURCE_GROUP --query connectionString -o json)

# Escape the JSON string using jq
escapedAppInsightsConnection=$(echo $appInsightsConnection | jq -r @sh)

# install kubectl
az aks install-cli
# authenticate kubectl against the AKS cluster
az aks get-credentials -n $AKS_CLUSTER_NAME -g $RESOURCE_GROUP

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Add the official stable repository
helm repo add stable https://charts.helm.sh/stable

# Update Helm repositories
helm repo update

# Install eShop on AKS with Helm from the What The Hack Docker Hub account
helm install eshopaks oci://registry-1.docker.io/whatthehackmsft/eshopaks \
    --version '0.1.0' \
    --set connectionStrings.catalogConnection=\""$catalogConnection\"" \
    --set connectionStrings.identityConnection=\""$identityConnection\"" \
    --set connectionStrings.appInsightsConnection=$escapedAppInsightsConnection

