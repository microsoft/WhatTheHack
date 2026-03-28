#!/bin/bash

# Function to upload files to Cosmos DB
upload_to_cosmos_db() {

  COSMOS_DB_ACCOUNT_NAME="${AZURE_COSMOS_DB_ACCOUNT_NAME}"
  COSMOS_DB_DATABASE_NAME="${AZURE_COSMOS_DB_DATABASE_NAME}"

  TARGET_FOLDER=$1
  CONTAINER_NAME="${TARGET_FOLDER//_/-}"

  echo "Uploading Files from ${TARGET_FOLDER} to Cosmos DB container ${CONTAINER_NAME} ..."

  echo "Changing directory to ${TARGET_FOLDER}"
  cd ${TARGET_FOLDER}

  echo "Uploading JSON files to Cosmos DB Account ${COSMOS_DB_ACCOUNT_NAME}/${COSMOS_DB_DATABASE_NAME}/${CONTAINER_NAME} ..."

  # Loop through all JSON files in the current directory
  for file in *.json; do
    if [ -f "$file" ]; then
      echo "Uploading $file to Cosmos DB container ${CONTAINER_NAME}..."
      
      # Use az cosmosdb sql container item create to upload the document
      az cosmosdb sql container item create \
        --account-name "${COSMOS_DB_ACCOUNT_NAME}" \
        --database-name "${COSMOS_DB_DATABASE_NAME}" \
        --container-name "${CONTAINER_NAME}" \
        --item "@${file}" \
        --output none
      
      if [ $? -eq 0 ]; then
        echo "✅ Successfully uploaded $file"
      else
        echo "❌ Failed to upload $file"
      fi
    fi
  done

  echo "Upload completed for ${CONTAINER_NAME}."

  cd ..

}

upload_to_cosmos_db "departments"
upload_to_cosmos_db "product_pricing"
upload_to_cosmos_db "product_skus"

echo "All uploads completed."
