#!/bin/bash

source ./environment-azure.sh


print_lines() {
  echo ""
  echo ""
}

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

