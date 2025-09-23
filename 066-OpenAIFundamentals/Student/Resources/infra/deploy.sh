#!/bin/bash

# Include functions
source ./functions.sh

# Variables
declare -A variables=(
  [template]="main.bicep"
  [parameters]="main.bicepparam"
  [resourceGroupName]="rg-ai-foundry-secure"
  [location]="eastus"
  [validateTemplate]=0
  [useWhatIf]=0
)

authenticate_to_azure

subscriptionName=$(az account show --query name --output tsv)
userObjectId=$(az ad signed-in-user show --query id --output tsv)

parse_args variables $@

# Validates if the resource group exists in the subscription, if not, it creates it
echo "Checking if [$resourceGroupName] resource group exists in the [$subscriptionName] subscription..."
az group show --name $resourceGroupName &>/dev/null

if [[ $? != 0 ]]; then
  echo "No [$resourceGroupName] resource group exists in the [$subscriptionName] subscription"
  echo "Creating [$resourceGroupName] resource group in the [$subscriptionName] subscription..."

  # Create the resource group
  az group create --name $resourceGroupName --location $location 1>/dev/null

  if [[ $? == 0 ]]; then
    echo "[$resourceGroupName] resource group successfully created in the [$subscriptionName] subscription"
  else
    echo "Failed to create [$resourceGroupName] resource group in the [$subscriptionName] subscription"
    exit
  fi
else
  echo "[$resourceGroupName] resource group already exists in the [$subscriptionName] subscription"
fi

# Validates the Bicep template
if [[ $validateTemplate == 1 ]]; then
  if [[ $useWhatIf == 1 ]]; then
    # Execute a deployment What-If operation at resource group scope.
    echo "Previewing changes deployed by [$template] Bicep template..."
    az deployment group what-if \
      --resource-group $resourceGroupName \
      --template-file $template \
      --parameters $parameters \
      --parameters \
      location=$location \
      userObjectId=$userObjectId 

    if [[ $? == 0 ]]; then
      echo "[$template] Bicep template validation succeeded"
    else
      echo "Failed to validate [$template] Bicep template"
      exit
    fi
  else
    # Validate the Bicep template
    echo "Validating [$template] Bicep template..."
    output=$(az deployment group validate \
      --resource-group $resourceGroupName \
      --template-file $template \
      --parameters $parameters \
      --parameters \
      location=$location\
      userObjectId=$userObjectId)

    if [[ $? == 0 ]]; then
      echo "[$template] Bicep template validation succeeded"
    else
      echo "Failed to validate [$template] Bicep template"
      echo $output
      exit
    fi
  fi
fi

# Deploy the Bicep template
echo "Deploying [$template] Bicep template..."
deploymentOutputs=$(az deployment group create \
  --resource-group $resourceGroupName \
  --only-show-errors \
  --template-file $template \
  --parameters $parameters \
  --parameters location=$location \
  --parameters userObjectId=$userObjectId \
  --query 'properties.outputs' -o json)

  #echo $deploymentOutputs
  if [[ $? == 0 ]]; then
    echo "[$template] Bicep template deployment succeeded"
  else
    echo "Failed to deploy [$template] Bicep template"
    exit
  fi

json=$deploymentOutputs
# Check if jq is installed
if ! command -v jq &> /dev/null; then
    error_exit "jq not found. Install it using 'sudo apt-get install jq'."
fi

# Create the .env file
echo -e "\n- Creating the .env file:"
environment_file="../.env"
environment_sample_file="../.env.sample"

# check if the .env file already exists and back it up if it does
    if [[ -f "$environment_file" ]]; then
        random_chars=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 5)
        mv "$environment_file" "${environment_file}-${random_chars}.bak"
        echo -e "\e[33mWarning: Existing .env file found. Backed up to ${environment_file}-${random_chars}.bak\e[0m"
    else
        touch $environment_file
    fi
  if [[ ! -f "$environment_sample_file" ]]; then
      error_exit "Example .env.sample file not found at $environment_sample_file."
  fi
# Load existing values from .env.sample file
source $environment_sample_file

# Extract values from JSON and write to .env file with double quotes around values
echo "Populating .env file..."
echo "OPENAI_API_KEY=\"$(echo "$json" | jq -r '.deploymentInfo.value.aiServicesKey')\"" >> $environment_file
echo "OPENAI_API_BASE=\"$(echo "$json" | jq -r '.deploymentInfo.value.aiServicesOpenAiEndpoint')\"" >> $environment_file
echo "AZURE_AI_SEARCH_KEY=\"$(echo "$json" | jq -r '.deploymentInfo.value.searchKey')\"" >> $environment_file
echo "AZURE_AI_SEARCH_ENDPOINT=\"$(echo "$json" | jq -r '.deploymentInfo.value.searchEndpoint')\"" >> $environment_file
echo "DOCUMENT_INTELLIGENCE_ENDPOINT=\"$(echo "$json" | jq -r '.deploymentInfo.value.documentEndpoint')\"" >> $environment_file
echo "DOCUMENT_INTELLIGENCE_KEY=\"$(echo "$json" | jq -r '.deploymentInfo.value.documentKey')\"" >> $environment_file
echo "AZURE_BLOB_STORAGE_ACCOUNT_NAME=\"$(echo "$json" | jq -r '.deploymentInfo.value.storageAccountName')\"" >> $environment_file
echo "AZURE_BLOB_STORAGE_KEY=\"$(echo "$json" | jq -r '.deploymentInfo.value.storageAccountKey')\"" >> $environment_file
echo "AZURE_BLOB_STORAGE_CONNECTION_STRING=\"$(echo "$json" | jq -r '.deploymentInfo.value.storageAccountConnectionString')\"" >> $environment_file
# Warning: this assumes the first deployed model is the chat model used by the Jupyter notebooks
echo "CHAT_MODEL_NAME=\"$(echo "$json" | jq -r '.deploymentInfo.value.deployedModels[0].name')\"" >> $environment_file

# Add values from the existing .env.sample file
echo "OPENAI_API_TYPE=\"$OPENAI_API_TYPE\"" >> $environment_file
echo "OPENAI_API_VERSION=\"$OPENAI_API_VERSION\"" >> $environment_file
echo "EMBEDDING_MODEL_NAME=\"$EMBEDDING_MODEL_NAME\"" >> $environment_file

echo "Done!"
