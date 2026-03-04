#!/bin/bash

connector_config_reset()
{


    # Path to the input and output files
    FILE_PREFIX="$1"
    DIRECTORY_PREFIX="./connector-configurations"
    INPUT_FILE="${DIRECTORY_PREFIX}/${FILE_PREFIX}.example.json"
    OUTPUT_FILE="${DIRECTORY_PREFIX}/${FILE_PREFIX}.final.json"

    echo ""
    echo "Removing existing output file ${OUTPUT_FILE} if it exists..."
    echo "Leaving Input file ${INPUT_FILE} intact..."
    rm -v -f "$OUTPUT_FILE"
    echo ""

}

connector_config_reset "ai_search_product_inventory"
connector_config_reset "ai_search_net_sales"
connector_config_reset "ai_search_departments_flat"

connector_config_reset "azure_blob_departments"
connector_config_reset "azure_blob_product_skus"
connector_config_reset "azure_blob_product_pricing"

connector_config_reset "cosmos_db_purchases"
connector_config_reset "cosmos_db_returns"
connector_config_reset "cosmos_db_replenishments"