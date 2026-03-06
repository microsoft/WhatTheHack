#!/bin/bash

connector_config_populate_secrets()
{


    # Path to the input and output files
    FILE_PREFIX="$1"
    DIRECTORY_PREFIX="./connector-configurations"
    INPUT_FILE="${DIRECTORY_PREFIX}/${FILE_PREFIX}.example.json"
    OUTPUT_FILE="${DIRECTORY_PREFIX}/${FILE_PREFIX}.final.json"

    echo ""
    echo ""
    echo "Preparing Connector Configuration File ${FILE_PREFIX} ..."
    # Replace placeholders and output to a new file 
    sed \
        -e "s|\[AZURE_RESOURCE_GROUP\]|${AZURE_RESOURCE_GROUP}|g" \
        -e "s|\[KAFKA_API_KEY\]|${KAFKA_API_KEY}|g" \
        -e "s|\[KAFKA_API_SECRET\]|${KAFKA_API_SECRET}|g" \
        -e "s|\[AZURE_SEARCH_SERVICE_NAME\]|${AZURE_SEARCH_SERVICE_NAME}|g" \
        -e "s|\[AZURE_SEARCH_API_KEY\]|${AZURE_SEARCH_API_KEY}|g" \
        -e "s|\[AZURE_STORAGE_ACCOUNT_NAME\]|${AZURE_STORAGE_ACCOUNT_NAME}|g" \
        -e "s|\[AZURE_STORAGE_ACCOUNT_KEY\]|${AZURE_STORAGE_ACCOUNT_KEY}|g" \
        -e "s|\[AZURE_COSMOS_DB_ACCOUNT_NAME\]|${AZURE_COSMOS_DB_ACCOUNT_NAME}|g" \
        -e "s|\[AZURE_COSMOS_DB_ACCOUNT_KEY\]|${AZURE_COSMOS_DB_ACCOUNT_KEY}|g" \
        -e "s|\[AZURE_COSMOS_DB_DATABASE_NAME\]|${AZURE_COSMOS_DB_DATABASE_NAME}|g" \
        -e "s|\[ARM_CLIENT_ID\]|${ARM_CLIENT_ID}|g" \
        -e "s|\[ARM_CLIENT_SECRET\]|${ARM_CLIENT_SECRET}|g" \
        -e "s|\[ARM_TENANT_ID\]|${ARM_TENANT_ID}|g" \
        -e "s|\[ARM_SUBSCRIPTION_ID\]|${ARM_SUBSCRIPTION_ID}|g" \
        "$INPUT_FILE" > "$OUTPUT_FILE"

    echo "Replacement complete. Modified file saved as $OUTPUT_FILE." 
}

connector_config_populate_secrets "ai_search_product_inventory"
connector_config_populate_secrets "ai_search_net_sales"
connector_config_populate_secrets "ai_search_departments_flat"

connector_config_populate_secrets "azure_blob_departments"
connector_config_populate_secrets "azure_blob_product_skus"
connector_config_populate_secrets "azure_blob_product_pricing"

connector_config_populate_secrets "cosmos_db_purchases"
connector_config_populate_secrets "cosmos_db_returns"
connector_config_populate_secrets "cosmos_db_replenishments"