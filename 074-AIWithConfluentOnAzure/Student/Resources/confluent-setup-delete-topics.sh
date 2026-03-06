

# This script deletes all topics in the Confluent Cloud environment.
# It assumes that the Confluent CLI is installed, configured, and the user is authenticated.
# It also assumes that the user has the necessary permissions to delete topics.

# Function to delete a Kafka topic and its associated schemas
# Example usage
# delete_kafka_topic "sales_transactions"     
delete_kafka_topic_and_schemas() {
    # Check if the topic name is provided
    if [ -z "$1" ]; then
        echo "Error: No topic name provided."
        echo "Usage: delete_kafka_topic_and_schemas <topic_name>"
        exit 1
    fi

    local topic_name="$1" # The name of the topic to delete
    local topic_key_schema="${topic_name}-key" # The key schema subject
    local topic_value_schema="${topic_name}-value" # The value schema subject

    # Delete the schemas associated with the topic
    confluent schema-registry schema delete --subject $topic_key_schema --version "all" --force 
    confluent schema-registry schema delete --subject $topic_value_schema --version "all" --force

    # Permanently delete the schemas
    confluent schema-registry schema delete --subject $topic_key_schema --version "all" --force --permanent
    confluent schema-registry schema delete --subject $topic_value_schema --version "all" --force --permanent

    # Delete the Kafka topic
    confluent kafka topic delete "$topic_name" --force
    echo "Topic $topic_name and its schemas have been deleted."
}

# Reference topics from Azure Blob Store
delete_kafka_topic_and_schemas "departments"
delete_kafka_topic_and_schemas "product_pricing"
delete_kafka_topic_and_schemas "product_skus"

# Transaction topics from Cosmos DB
delete_kafka_topic_and_schemas "purchases"
delete_kafka_topic_and_schemas "replenishments"
delete_kafka_topic_and_schemas "returns"

# Destination topics heading over to Azure AI Search
delete_kafka_topic_and_schemas "net_sales"
delete_kafka_topic_and_schemas "product_inventory"


