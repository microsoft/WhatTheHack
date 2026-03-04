#!/bin/bash

# This script deletes specified connectors from a Confluent Kafka Connect cluster.
# It assumes that the Confluent CLI is installed, configured, and the user is authenticated.
# It also assumes that the user has the necessary permissions to delete connectors.
# Function to get connector IDs from their names

# Example usage:
# get_connector_ids "azure_blob_product_pricing_source_connector,azure_cosmos_db_purchases_source,azure_cosmos_db_returns_source"
get_connector_ids() {
  local connector_names_csv="$1"
  local connector_names_array
  
  IFS=',' read -r -a connector_names_array <<< "$connector_names_csv"

  # Get current connectors JSON
  local connectors_json
  connectors_json=$(confluent connect cluster list -o json)

  # Initialize result
  local connector_ids=()

  for name in "${connector_names_array[@]}"; do
    id=$(echo "$connectors_json" | jq -r --arg NAME "$name" '.[] | select(.name == $NAME) | .id')
    if [[ -n "$id" ]]; then
      connector_ids+=("$id")
    fi
  done

  # Output space-delimited list
  echo "${connector_ids[@]}"
}

# List all connectors in the cluster  
echo "Listing all connectors in the cluster before deletion:"
# This will show all connectors before deletion 

confluent connect cluster list

echo "----------------------------------------------"
echo "Deleting specified connectors from the cluster:"


# These are the connector names to delete
connectors="ai_search_departments_sink,ai_search_net_sales_sink,ai_search_departments_flat_sink,ai_search_product_inventory_sink,azure_blob_product_pricing_source_connector,azure_cosmos_db_purchases_source,azure_blob_product_skus_source_connector,azure_cosmos_db_returns_source,azure_cosmos_db_replenishments_source,azure_blob_departments_source_connector"

# Call the function
ids=$(get_connector_ids "$connectors")

echo "Connector IDs: $ids"

# Delete the connectors using their IDs
for id in $ids; do
  echo "Deleting connector with ID: $id"
  confluent connect cluster delete "$id"  --force
  # Check if the deletion was successful
  # The exit status of the last command is stored in $?
  # If the exit status is 0, the command was successful
  # If the exit status is not 0, the command failed
  if [ $? -eq 0 ]; then
    echo "Connector with ID $id deleted successfully."
  else
    echo "Failed to delete connector with ID $id."
  fi
done
echo "All specified connectors have been deleted."

# List all connectors in the cluster   
confluent connect cluster list
echo "All connectors in the cluster have been listed."
echo "----------------------------------------------"
echo "Confluent Connectors deletion complete."

