#!/bin/bash

# Include functions
source ./functions.sh

authenticate_to_azure
# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --resource-group-name) RESOURCE_GROUP_NAME="$2"; shift ;; 
        *) error_exit "Unknown parameter passed: $1" ;;
    esac
    shift 
done

# Validate mandatory parameters
if [[ -z "$RESOURCE_GROUP_NAME" ]]; then
    error_exit "Resource Group Name is mandatory."
fi
# Try a command that requires login, suppress its output
if az account show > /dev/null 2>&1; then
  echo "Azure CLI is already logged in."
else
  echo "Need to run 'az login'."  
  az login
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    error_exit "jq is not installed. Please install it to proceed."
fi

# Check if the resource group exists
echo "Checking if resource group '$RESOURCE_GROUP_NAME' exists..."
if [[ "$(az group exists --name "$RESOURCE_GROUP_NAME")" == "false" ]]; then
    error_exit "Resource group '$RESOURCE_GROUP_NAME' not found. You may need to run deploy.sh instead."
fi
echo "Resource group '$RESOURCE_GROUP_NAME' found."

# Extract outputs
outputs=$(az deployment group show \
  --resource-group $RESOURCE_GROUP_NAME \
  --name "main" \
  --query properties.outputs)
#echo $outputs

generate_local_settings_file