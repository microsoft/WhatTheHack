#!/bin/bash

# Function to upload files to blob store
upload_to_blob_storage() {

  STORAGE_ACCOUNT_NAME="${AZURE_STORAGE_ACCOUNT_NAME}"

  TARGET_FOLDER=$1

  DESTINATION_CONTAINER="${TARGET_FOLDER//_/-}"

  echo "Uploading Files from ${TARGET_FOLDER} to ${STORAGE_ACCOUNT_NAME} ..."

  echo "Changing directory to ${TARGET_FOLDER}"
  cd ${TARGET_FOLDER}

  echo "Uploading JSON files to Azure Blob Storage Account ${STORAGE_ACCOUNT_NAME}/${DESTINATION_CONTAINER}/topics ..."

  az storage blob upload-batch \
    --account-name "${STORAGE_ACCOUNT_NAME}" \
    --account-key "${AZURE_STORAGE_ACCOUNT_KEY}" \
    --destination "${DESTINATION_CONTAINER}/topics" \
    --source . \
    --overwrite \
    --pattern "*.json"
    

  echo "Upload completed."

  cd ..

}

upload_to_blob_storage "departments"
upload_to_blob_storage "product_pricing"
upload_to_blob_storage "product_skus"

echo "All uploads completed."
