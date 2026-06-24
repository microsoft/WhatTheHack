#!/bin/bash

# This script creates the necessary indices in Azure AI Search
# It assumes that the CURL CLI is installed, configured, and the user is authenticated.
# It also assumes that the user has the necessary permissions (ADMIN API KEY) to create indices.

AI_SEARCH_API_VERSION="2025-03-01-Preview"

create_ai_search_index()
{
    # Get the index name from the first argument
    INDEX_NAME="$1"
    # Get the index schema from the second argument
    INDEX_SCHEMA="./ai-search-schemas/${INDEX_NAME}.json"
    # Get the search service name from the third argument
    SEARCH_SERVICE_NAME="${AZURE_SEARCH_SERVICE_NAME}"
    # Get the resource group name from the fourth argument
    RESOURCE_GROUP="$4"

    # Create the index using the REST API endpoint
    echo ""
    echo "Creating index ${INDEX_NAME} in Azure AI Search service ${SEARCH_SERVICE_NAME}..."
    # Use curl to send a PUT request to create the index
    # Ensure the index schema file exists
    if [ ! -f "${INDEX_SCHEMA}" ]; then
        echo "Error: Index schema file ${INDEX_SCHEMA} does not exist."
        exit 1
    fi

    # Use curl to send a PUT request to create the index   
    curl -X PUT \
        "https://${SEARCH_SERVICE_NAME}.search.windows.net/indexes/${INDEX_NAME}?api-version=${AI_SEARCH_API_VERSION}" \
        -H "Content-Type: application/json" \
        -H "api-key: ${AZURE_SEARCH_API_KEY}" \
        -d "@${INDEX_SCHEMA}"
    
    # Check if the index creation was successful
    if [ $? -eq 0 ]; then
        echo "Index ${INDEX_NAME} created successfully."
    else
        echo "Failed to create index ${INDEX_NAME}."
    fi 

    echo ""
    echo "Done creating index ${INDEX_NAME} in Azure AI Search service ${SEARCH_SERVICE_NAME}..."
    echo ""
    echo "----------------------------------------------"
    echo ""
}

# List AI Search indices
# This will show all indices before creation
list_ai_search_indices() {
    echo ""
    echo "Listing all indices in Azure AI Search service ${AZURE_SEARCH_SERVICE_NAME}..."

    # Use curl to send a GET request and pipe output to jq for pretty-printing
    response=$(curl -s -X GET \
        "https://${AZURE_SEARCH_SERVICE_NAME}.search.windows.net/indexes?api-version=${AI_SEARCH_API_VERSION}" \
        -H "Content-Type: application/json" \
        -H "api-key: ${AZURE_SEARCH_API_KEY}")

    # Check if curl executed successfully
    if [ $? -eq 0 ]; then
        echo "Listed all indices successfully."
        echo "$response" | jq .
    else
        echo "Failed to list indices."
    fi

    echo ""
    echo "Done listing all indices in Azure AI Search service ${AZURE_SEARCH_SERVICE_NAME}..."
    echo ""
    echo "----------------------------------------------"
    echo ""
}


# List all indices in the Azure AI Search service
list_ai_search_indices

# Create the indices in Azure AI Search
create_ai_search_index "net_sales"
create_ai_search_index "product_inventory"

# List all indices in the Azure AI Search service again
list_ai_search_indices

