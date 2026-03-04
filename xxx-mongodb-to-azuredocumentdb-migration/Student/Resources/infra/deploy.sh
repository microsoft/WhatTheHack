#!/usr/bin/env bash
set -euo pipefail

source ./functions.sh

declare -A variables=(
  [template]="main.bicep"
  [parameters]="main.bicepparam"
  [resourceGroupName]="rg-mflix-documentdb"
  [location]="eastus2"
  [administratorLogin]="mflixadmin"
  [administratorPassword]=""
  [validateTemplate]=0
  [useWhatIf]=0
  [updateEnv]=0
)

parse_args variables "$@"

[[ -n "$administratorLogin" ]] || error_exit "Missing required argument: --administratorLogin"
[[ -n "$administratorPassword" ]] || error_exit "Missing required argument: --administratorPassword"

authenticate_to_azure

subscriptionName=$(az account show --query name --output tsv)

echo "Checking if [$resourceGroupName] resource group exists in [$subscriptionName]..."
if ! az group show --name "$resourceGroupName" >/dev/null 2>&1; then
  echo "Creating [$resourceGroupName] in [$location]..."
  az group create --name "$resourceGroupName" --location "$location" >/dev/null
  echo "[$resourceGroupName] created."
else
  echo "[$resourceGroupName] already exists."
fi

if [[ "$validateTemplate" == "1" ]]; then
  if [[ "$useWhatIf" == "1" ]]; then
    echo "Previewing deployment changes for [$template]..."
    az deployment group what-if \
      --resource-group "$resourceGroupName" \
      --template-file "$template" \
      --parameters "$parameters" \
      --parameters location="$location" \
      --parameters administratorLogin="$administratorLogin" administratorPassword="$administratorPassword"
  else
    echo "Validating [$template]..."
    az deployment group validate \
      --resource-group "$resourceGroupName" \
      --template-file "$template" \
      --parameters "$parameters" \
      --parameters location="$location" \
      --parameters administratorLogin="$administratorLogin" administratorPassword="$administratorPassword" >/dev/null
  fi
fi

echo "Deploying [$template]..."
az deployment group create \
  --resource-group "$resourceGroupName" \
  --template-file "$template" \
  --parameters "$parameters" \
  --parameters location="$location" \
  --parameters administratorLogin="$administratorLogin" administratorPassword="$administratorPassword" \
  >/dev/null

echo "Deployment completed."

if [[ "$updateEnv" == "1" ]]; then
  echo "Skipping .env updates by design. Configure application connection settings manually."
fi


