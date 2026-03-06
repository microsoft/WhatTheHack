#!/bin/bash

source ./environment-azure.sh


print_lines() {
  echo ""
  echo ""
}

print_lines
echo "Checking Azure Storage Account Shared Key Access..."
SHARED_KEY_ACCESS=$(az storage account show -g ${AZURE_RESOURCE_GROUP} --name ${STORAGE_ACCOUNT} --query "allowSharedKeyAccess" --output tsv)
echo "Shared Key Access: ${SHARED_KEY_ACCESS}"
echo "This should be 'true'"

print_lines
echo "Checking Azure Storage Account Public Network Access..."
PUBLIC_NETWORK_ACCESS=$(az storage account show -g ${AZURE_RESOURCE_GROUP} --name ${STORAGE_ACCOUNT} --query "publicNetworkAccess" --output tsv)
echo "Public Network Access: ${PUBLIC_NETWORK_ACCESS}"
echo "This should be 'Enabled'"

print_lines
echo "Checking Azure Cosmos DB Account Local Auth Disabled..."
COSMOS_DB_DISABLE_LOCAL_AUTH=$(az cosmosdb show -g ${AZURE_RESOURCE_GROUP} --name ${COSMOS_DB_ACCOUNT} --query "disableLocalAuth" --output tsv)
echo "Cosmos DB Local Auth Disabled: ${COSMOS_DB_DISABLE_LOCAL_AUTH}"
echo "This should be 'false'"

print_lines
echo "Checking Azure Cosmos DB Account Public Network Access..."
COSMOS_DB_PUBLIC_NETWORK_ACCESS=$(az cosmosdb show -g ${AZURE_RESOURCE_GROUP} --name ${COSMOS_DB_ACCOUNT} --query "publicNetworkAccess" --output tsv)
echo "Cosmos DB Public Network Access: ${COSMOS_DB_PUBLIC_NETWORK_ACCESS}"
echo "This should be 'Enabled'"

echo ""
echo ""

printf "%-45s %-12s %-12s %-10s\n" "Service Setting/Configuration" "Expected" "Actual" "Result"

# Azure Blob Storage Network Access
if [ "${PUBLIC_NETWORK_ACCESS}" == "Enabled" ]; then
  result="Pass"
else
  result="Fail"
fi
printf "%-45s %-12s %-12s %-10s\n" "Azure Blob Storage Network Access Enabled" "Enabled" "${PUBLIC_NETWORK_ACCESS}" "${result}"

# Azure Blob Storage Shared Key
if [ "${SHARED_KEY_ACCESS}" == "true" ]; then
  result="Pass"
else
  result="Fail"
fi
printf "%-45s %-12s %-12s %-10s\n" "Azure Blob Storage Shared Key Allowed" "true" "${SHARED_KEY_ACCESS}" "${result}"

# Cosmos DB Public Network Access
if [ "${COSMOS_DB_PUBLIC_NETWORK_ACCESS}" == "Enabled" ]; then
  result="Pass"
else
  result="Fail"
fi
printf "%-45s %-12s %-12s %-10s\n" "Cosmos DB Public Network Access Enabled" "Enabled" "${COSMOS_DB_PUBLIC_NETWORK_ACCESS}" "${result}"

# Cosmos DB Local Auth Disabled
if [ "${COSMOS_DB_DISABLE_LOCAL_AUTH}" == "false" ]; then
  result="Pass"
else
  result="Fail"
fi
printf "%-45s %-12s %-12s %-10s\n" "Cosmos DB Local Auth Disabled" "false" "${COSMOS_DB_DISABLE_LOCAL_AUTH}" "${result}"

