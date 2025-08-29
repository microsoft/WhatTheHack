#!/bin/bash

# Include functions
source ./functions.sh
# Default values
LOCATION="East US 2"
DOCUMENT_INTELLIGENCE_LOCATION="East US"
OPENAI_LOCATION="East US 2"
RESOURCE_GROUP_NAME="openai-apps-wth"
MODEL_NAME="gpt-4o"
MODEL_VERSION="2024-11-20"
EMBEDDING_MODEL="text-embedding-ada-002"
EMBEDDING_MODEL_VERSION="2"
# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --subscription-id) SUBSCRIPTION_ID="$2"; shift ;;
        --resource-group-name) RESOURCE_GROUP_NAME="$2"; shift ;;
        --location) LOCATION="$2"; shift ;;
        --tenant-id) TENANT_ID="$2"; shift ;;
        --use-service-principal) USE_SERVICE_PRINCIPAL=true ;;
        --service-principal-id) SERVICE_PRINCIPAL_ID="$2"; shift ;;
        --service-principal-password) SERVICE_PRINCIPAL_PASSWORD="$2"; shift ;;
        --openai-location) OPENAI_LOCATION="$2"; shift ;;
        --document-intelligence-location) DOCUMENT_INTELLIGENCE_LOCATION="$2"; shift ;;
        --skip-local-settings-file) SKIP_LOCAL_SETTINGS_FILE=true; shift ;;
        --silent-install) SILENT_INSTALL=true; shift ;;
        --model-name) MODEL_NAME="$2"; shift ;;
        --model-version) MODEL_VERSION="$2"; shift ;;
        --embedding-model) EMBEDDING_MODEL="$2"; shift ;;
        --embedding-model-version) EMBEDDING_MODEL_VERSION="$2"; shift ;;
        *) error_exit "Unknown parameter passed: $1" ;;
    esac
    shift
done

# Check if Bicep CLI is installed
# if ! command -v bicep &> /dev/null; then
#     error_exit "Bicep CLI not found. Install it using 'az bicep install'."
# fi

echo -e "\n\t\t\e[32mWHAT THE HACK - AZURE OPENAI APPS\e[0m"
echo -e "\tcreated with love by the Americas GPS Tech Team!\n"

if [[ "$SILENT_INSTALL" == false ]]; then
    # Validate mandatory parameters, if required
    if [[ -z "$SUBSCRIPTION_ID" || -z "$RESOURCE_GROUP_NAME" ]]; then
        error_exit "Subscription ID and Resource Group Name are mandatory."
    fi
    authenticate_to_azure

    # Set the subscription
    az account set --subscription "$SUBSCRIPTION_ID" || error_exit "Failed to set subscription."

    # Display deployment parameters
    echo -e "The resources will be provisioned using the following parameters:"
    echo -e "\t          TenantId: \e[33m$TENANT_ID\e[0m"
    echo -e "\t    SubscriptionId: \e[33m$SUBSCRIPTION_ID\e[0m"
    echo -e "\t    Resource Group: \e[33m$RESOURCE_GROUP_NAME\e[0m"
    echo -e "\t            Region: \e[33m$LOCATION\e[0m"
    echo -e "\t   OpenAI Location: \e[33m$OPENAI_LOCATION\e[0m"
    echo -e "\t Azure DI Location: \e[33m$DOCUMENT_INTELLIGENCE_LOCATION\e[0m"
    echo -e "\t   Model Name: \e[33m$MODEL_NAME\e[0m"
    echo -e "\tModel Version: \e[33m$MODEL_VERSION\e[0m"
    echo -e "\tEmbedding Model: \e[33m$EMBEDDING_MODEL\e[0m"
    echo -e "\tEmbedding Model Version: \e[33m$EMBEDDING_MODEL_VERSION\e[0m"
    echo -e "\e[31mIf any parameter is incorrect, abort this script, correct, and try again.\e[0m"
    echo -e "It will take around \e[32m15 minutes\e[0m to deploy all resources. You can monitor the progress from the deployments page in the resource group in Azure Portal.\n"

    read -p "Press Y to proceed to deploy the resources using these parameters: " proceed
    if [[ "$proceed" != "Y" && "$proceed" != "y" ]]; then
        echo -e "\e[31mAborting deployment script.\e[0m"
        exit 1
    fi
fi
start=$(date +%s)

# Create resource group
echo -e "\n- Creating resource group: "
az group create --name "$RESOURCE_GROUP_NAME" --location "$LOCATION" || error_exit "Failed to create resource group."

# Deploy resources
echo -e "\n- Deploying resources: "
result=$(az deployment group create --resource-group "$RESOURCE_GROUP_NAME" --template-file ./main.bicep \
    --parameters openAILocation="$OPENAI_LOCATION" documentIntelligenceLocation="$DOCUMENT_INTELLIGENCE_LOCATION" modelName="$MODEL_NAME" modelVersion="$MODEL_VERSION" embeddingModel="$EMBEDDING_MODEL" embeddingModelVersion="$EMBEDDING_MODEL_VERSION") || error_exit "Azure deployment failed."

# Extract outputs
outputs=$(echo "$result" | jq -r '.properties.outputs')
#echo $outputs
if [[ "$SKIP_LOCAL_SETTINGS_FILE" == true ]]; then
    echo -e "\n- Skipping local settings file generation."
else
    # Generate local settings file
    echo -e "\n- Generating local settings file:"
    generate_local_settings_file
fi



# Copy files to Azure Storage
echo -e "\n- Copying files:"
storage_connection=$(echo "$outputs" | jq -r '.storageConnectionString.value')
COSMOS_DB_ACCOUNT=$(echo "$outputs" | jq -r '.cosmosDBAccount.value')
STORAGE_ACCOUNT=$(echo "$outputs" | jq -r '.name.value')
AZURE_AI_SEARCH=$(echo "$outputs" | jq -r '.searchName.value')

#Workaround for FDPO MSFT internal subscriptions. 

az storage account update -g $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT  --allow-shared-key-access true
 
az storage account update \
  --name ${STORAGE_ACCOUNT} \
  --resource-group $RESOURCE_GROUP_NAME \
  --public-network-access Enabled \
  --default-action Allow

  # Enable Public Network Access
az cosmosdb update -g $RESOURCE_GROUP_NAME --name $COSMOS_DB_ACCOUNT --public-network-access Enabled 

# Enable Local Authentication with Keys
az resource update -g $RESOURCE_GROUP_NAME --name $COSMOS_DB_ACCOUNT --resource-type "Microsoft.DocumentDB/databaseAccounts" --set properties.disableLocalAuth=false

az search service update --name $AZURE_AI_SEARCH --resource-group $RESOURCE_GROUP_NAME --public-access enabled --disable-local-auth false
cosmosdb=$(az cosmosdb show --name $COSMOS_DB_ACCOUNT --resource-group $RESOURCE_GROUP_NAME | jq -r '.id')
az resource update --ids $cosmosdb --set properties.disableLocalAuth=false --latest-include-preview

#End workaround


# Declare an associative array
declare -A hashtable

# Add key-value pairs to the hashtable
hashtable["../data/contoso-education/F01-Civics-Geography and Climate/"]="f01-geography-climate"
hashtable["../data/contoso-education/F02-Civics-Tourism and Economy/"]="f02-tour-economy"
hashtable["../data/contoso-education/F03-Civics-Government and Politics/"]="f03-government-politics"
hashtable["../data/contoso-education/F04-Activity-Preferences/"]="f04-activity-preferences"

# Iterate over the hashtable
for sourceDir in "${!hashtable[@]}"; do
    az storage blob upload-batch --overwrite --source "$sourceDir" --destination "classifications" --connection-string "$storage_connection" || error_exit "Failed to upload files."
    az storage blob upload-batch --overwrite --source "$sourceDir" --destination "${hashtable[$sourceDir]}" --connection-string "$storage_connection" || error_exit "Failed to upload files."
done



end=$(date +%s)
echo -e "\nThe deployment took: $((end - start)) seconds."
