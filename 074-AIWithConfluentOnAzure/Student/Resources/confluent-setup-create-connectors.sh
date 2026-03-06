
# This script sets up a Confluent Connect cluster with the specified configuration file.


# Sets up a Confluent Connector using the provided configuration file.
setup_confluent_connector()
{
    local CONNECTOR_NAME="$1"
    local CONNECTOR_CONFIG_DIRECTORY="./connector-configurations"
    local CONNECTOR_CONFIG_FILE="${CONNECTOR_CONFIG_DIRECTORY}/${CONNECTOR_NAME}.final.json"
    # Check if the connector configuration file exists
    if [ ! -f "$CONNECTOR_CONFIG_FILE" ]; then
        echo "Error: Connector configuration file $CONNECTOR_CONFIG_FILE does not exist."
        exit 1
    fi

    # Create the connector using the provided configuration file
    echo ""
    echo ""
    echo "Creating connector $CONNECTOR_NAME using configuration file $CONNECTOR_CONFIG_FILE..."
    
    # Create the Kafka Connector
    confluent connect cluster create --config-file ${CONNECTOR_CONFIG_FILE} 
}


# Create the Kafka Source Connectors for Azure Blob Storage
setup_confluent_connector "azure_blob_departments"
setup_confluent_connector "azure_blob_product_pricing"
setup_confluent_connector "azure_blob_product_skus"


# Set up the Kafka Sink Connectors for Azure Cosmos DB
setup_confluent_connector "cosmos_db_purchases"
setup_confluent_connector "cosmos_db_returns"
setup_confluent_connector "cosmos_db_replenishments"

# Set up the Kafka Sink Connectors for Azure AI Search
setup_confluent_connector "ai_search_product_inventory"
setup_confluent_connector "ai_search_net_sales"
setup_confluent_connector "ai_search_departments_flat"

# List all connectors in the cluster
confluent connect cluster list
