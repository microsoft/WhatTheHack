#!/usr/bin/env bash
set -euo pipefail

: "${WORKSHOP_ID:?Set WORKSHOP_ID}"
: "${AZURE_LOCATION:?Set an organizer-approved AZURE_LOCATION}"
: "${MODEL_NAME:?Set an available MODEL_NAME}"
: "${MODEL_VERSION:?Set the exact MODEL_VERSION}"
: "${PROJECT_ROLE_DEFINITION_ID:?Set the administrator-approved Foundry project role GUID}"
: "${CONFIRM_CREATE:?Set CONFIRM_CREATE to the workshop ID after reviewing costs}"
[[ "$WORKSHOP_ID" =~ ^[a-z][a-z0-9-]{3,23}$ ]] || { echo "Invalid WORKSHOP_ID" >&2; exit 1; }
[[ "$CONFIRM_CREATE" == "$WORKSHOP_ID" ]] || { echo "Confirmation does not match" >&2; exit 1; }

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
GROUP="rg-context-quest-$WORKSHOP_ID"
STATE="$(az account show --query state -o tsv --only-show-errors)"
[[ "$STATE" == "Enabled" ]] || { echo "Select an enabled Azure subscription" >&2; exit 1; }
az account show --query '{subscription:name,id:id}' -o table
echo "Draft provisioning: $GROUP in $AZURE_LOCATION. Model/inference charges may apply."

if [[ "$(az group exists --name "$GROUP" -o tsv)" == "true" ]]; then
  OWNER="$(az group show --name "$GROUP" --query tags.workshop -o tsv)"
  [[ "$OWNER" == "$WORKSHOP_ID" ]] || { echo "Refusing unowned resource group" >&2; exit 1; }
else
  az group create --name "$GROUP" --location "$AZURE_LOCATION" \
    --tags "workshop=$WORKSHOP_ID" --output none --only-show-errors
fi

USER_ID="$(az ad signed-in-user show --query id -o tsv --only-show-errors)"
az deployment group create --name "context-quest-$WORKSHOP_ID" \
  --resource-group "$GROUP" --template-file "$SCRIPT_DIR/main.bicep" \
  --parameters workshopId="$WORKSHOP_ID" location="$AZURE_LOCATION" \
    modelName="$MODEL_NAME" modelVersion="$MODEL_VERSION" \
    userObjectId="$USER_ID" projectRoleDefinitionId="$PROJECT_ROLE_DEFINITION_ID" \
  --query properties.outputs --output json --only-show-errors
echo "Copy projectEndpoint and modelDeploymentName outputs into .env; no keys are output."
