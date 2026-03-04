#!/bin/bash

delete_topic_schemas() {
    local topic_name="$1" # The name of the topic to delete
    local topic_key_schema="${topic_name}-key" # The key schema subject
    local topic_value_schema="${topic_name}-value" # The value schema subject

    # Check if the topic name is provided
    if [ -z "$topic_name" ]; then
        echo "Error: No topic name provided."
        echo "Usage: delete_topic_schemas <topic_name>"
        exit 1
    fi

    confluent schema-registry schema delete --subject $topic_key_schema --version "all" --force 
    confluent schema-registry schema delete --subject $topic_value_schema --version "all" --force

    confluent schema-registry schema delete --subject $topic_key_schema --version "all" --force --permanent
    confluent schema-registry schema delete --subject $topic_value_schema --version "all" --force --permanent

}


# List Schema Registry
confluent schema-registry schema list


# Reference topics from Azure Blob Store
delete_topic_schemas "departments"
delete_topic_schemas "product_pricing"
delete_topic_schemas "product_skus"

# Transaction topics from Cosmos DB
delete_topic_schemas "purchases"
delete_topic_schemas "replenishments"
delete_topic_schemas "returns"

# Destination topics heading over to Azure AI Search
delete_topic_schemas "net_sales"
delete_topic_schemas "product_inventory"

confluent schema-registry schema list