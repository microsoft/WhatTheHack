#!/bin/bash

# Generate a local env.sh file from terraform output

# Exit immediately if a command exits with a non-zero status
set -e

# Where to output the env file
ENV_FILE="./azure_environment_variables.sh"

# Generate the env.sh file
echo "#!/bin/bash" > "$ENV_FILE"
echo "" >> "$ENV_FILE"

# Read outputs and write them as export statements

echo "# Azure Resource Group for Resources" >> "$ENV_FILE"
terraform output -raw resource_group_name | awk '{print "export AZURE_RESOURCE_GROUP=\"" $0 "\""}' >> "$ENV_FILE"
echo "" >> "$ENV_FILE"

echo "# Azure Cosmos DB Credentials" >> "$ENV_FILE"
terraform output -raw cosmosdb_account_name | awk '{print "export AZURE_COSMOS_DB_ACCOUNT_NAME=\"" $0 "\""}' >> "$ENV_FILE"
terraform output -raw cosmosdb_primary_key | awk '{print "export AZURE_COSMOS_DB_ACCOUNT_KEY=\"" $0 "\""}' >> "$ENV_FILE"
terraform output -raw cosmosdb_database_name | awk '{print "export AZURE_COSMOS_DB_DATABASE_NAME=\"" $0 "\""}' >> "$ENV_FILE"
echo "" >> "$ENV_FILE"

echo "# Azure AI Search Credentials" >> "$ENV_FILE"
terraform output -raw search_service_name | awk '{print "export AZURE_SEARCH_SERVICE_NAME=\"" $0 "\""}' >> "$ENV_FILE"
terraform output -raw azure_search_admin_key | awk '{print "export AZURE_SEARCH_API_KEY=\"" $0 "\""}' >> "$ENV_FILE"
echo "" >> "$ENV_FILE"

echo "# Azure Storage Account Credentials" >> "$ENV_FILE"
terraform output -raw storage_account_name | awk '{print "export AZURE_STORAGE_ACCOUNT_NAME=\"" $0 "\""}' >> "$ENV_FILE"
terraform output -raw storage_account_primary_access_key | awk '{print "export AZURE_STORAGE_ACCOUNT_KEY=\"" $0 "\""}' >> "$ENV_FILE"
echo "" >> "$ENV_FILE"

#echo "# Azure Redis Cache Credentials" >> "$ENV_FILE"
#terraform output -raw redis_hostname | awk '{print "export REDIS_HOSTNAME=\"" $0 "\""}' >> "$ENV_FILE"
#terraform output -raw redis_primary_access_key | awk '{print "export REDIS_PRIMARY_ACCESS_KEY=\"" $0 "\""}' >> "$ENV_FILE"
#echo "" >> "$ENV_FILE"

echo "✅ Environment file generated: $ENV_FILE"
