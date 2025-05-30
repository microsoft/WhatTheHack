#Workaround for FDPO MSFT internal subscriptions. 
# Include functions
source ./functions.sh

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

AZURE_AI_SEARCH=$(echo "$outputs" | jq -r '.searchName.value')

storageConnectionString=$(echo "$outputs" | jq -r '.storageConnectionString.value')
STORAGE_ACCOUNT=$(echo "$storageConnectionString" | sed -n 's/.*AccountName=\([^;]*\).*/\1/p')

webjobsConnectionString=$(echo "$outputs" | jq -r '.webjobsConnectionString.value')
WEBJOBS_STORAGE_ACCOUNT=$(echo "$webjobsConnectionString" | sed -n 's/.*AccountName=\([^;]*\).*/\1/p')

COSMOS_DB_ACCOUNT=$(echo "$outputs" | jq -r '.cosmosDBAccount.value')

az storage account update -g $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT  --allow-shared-key-access true
 

az storage account update \
  --name ${STORAGE_ACCOUNT} \
  --resource-group $RESOURCE_GROUP_NAME \
  --public-network-access Enabled \
  --default-action Allow

az storage account update -g $RESOURCE_GROUP_NAME --name $WEBJOBS_STORAGE_ACCOUNT  --allow-shared-key-access true
 
az storage account update \
  --name ${WEBJOBS_STORAGE_ACCOUNT} \
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
