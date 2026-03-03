#!/usr/bin/env bash
set -euo pipefail

source ./functions.sh

declare -A variables=(
  [template]="main.bicep"
  [parameters]="main.bicepparam"
  [resourceGroupName]="rg-mflix-documentdb"
  [location]="eastus"
  [validateTemplate]=0
  [useWhatIf]=0
  [updateEnv]=1
)

parse_args variables "$@"
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
      --parameters location="$location"
  else
    echo "Validating [$template]..."
    az deployment group validate \
      --resource-group "$resourceGroupName" \
      --template-file "$template" \
      --parameters "$parameters" \
      --parameters location="$location" >/dev/null
  fi
fi

echo "Deploying [$template]..."
deploymentOutputs=$(az deployment group create \
  --resource-group "$resourceGroupName" \
  --template-file "$template" \
  --parameters "$parameters" \
  --parameters location="$location" \
  --query 'properties.outputs' \
  -o json)

echo "Deployment completed."

if [[ "$updateEnv" == "1" ]]; then
  if ! command -v jq >/dev/null 2>&1; then
    error_exit "jq not found. Install it with: sudo apt-get install -y jq"
  fi

  environment_file="../MFlix/.env"
  environment_sample_file="../MFlix/.env.example"

  [[ -f "$environment_sample_file" ]] || error_exit "Missing $environment_sample_file"

  if [[ -f "$environment_file" ]]; then
    random_chars=$(LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 5)
    mv "$environment_file" "${environment_file}-${random_chars}.bak"
    echo "Existing .env backed up to ${environment_file}-${random_chars}.bak"
  fi

  source "$environment_sample_file"

  account_name=$(echo "$deploymentOutputs" | jq -r '.deploymentInfo.value.accountName')
  connection_string=$(az cosmosdb keys list \
    --name "$account_name" \
    --resource-group "$resourceGroupName" \
    --type connection-strings \
    --query 'connectionStrings[0].connectionString' \
    -o tsv)

  if [[ -z "$connection_string" || "$connection_string" == "null" ]]; then
    error_exit "Unable to retrieve MongoDB connection string for account [$account_name]."
  fi

  {
    echo "SECRET_KEY=\"${SECRET_KEY:-your_secret_key_here}\""
    echo "MFLIX_DB_URI=\"${connection_string}\""
    echo "MFLIX_NS=\"${MFLIX_NS:-sample_mflix}\""
    echo "PORT=\"${PORT:-5001}\""
  } > "$environment_file"

  echo "Updated [$environment_file] with Azure DocumentDB connection settings."
fi


