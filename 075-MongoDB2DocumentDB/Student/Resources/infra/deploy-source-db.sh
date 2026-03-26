#!/usr/bin/env bash
set -euo pipefail

source ./functions.sh

format_duration() {
  local seconds=$1
  printf "%dm %02ds" $((seconds / 60)) $((seconds % 60))
}

script_start=$SECONDS

declare -A variables=(
  [template]="source-db.bicep"
  [parameters]="source-db.bicepparam"
  [resourceGroupName]="rg-mflix-documentdb"
  [location]="eastus2"
  [administratorLogin]="mflixadmin"
  [administratorPassword]=""
  [validateTemplate]=0
  [useWhatIf]=0
)

parse_args variables "$@"

[[ -n "$administratorLogin" ]] || error_exit "Missing required argument: --administratorLogin"
[[ -n "$administratorPassword" ]] || error_exit "Missing required argument: --administratorPassword"

authenticate_to_azure

subscriptionName=$(az account show --query name --output tsv)

step_start=$SECONDS
echo "Checking if [$resourceGroupName] resource group exists in [$subscriptionName]..."
if ! az group show --name "$resourceGroupName" >/dev/null 2>&1; then
  echo "Creating [$resourceGroupName] in [$location]..."
  az group create --name "$resourceGroupName" --location "$location" >/dev/null
  echo "[$resourceGroupName] created."
else
  echo "[$resourceGroupName] already exists."
fi
echo "  (Resource group: $(format_duration $((SECONDS - step_start))))"

if [[ "$validateTemplate" == "1" ]]; then
  if [[ "$useWhatIf" == "1" ]]; then
    echo "Previewing deployment changes for [$template]..."
    az deployment group what-if \
      --resource-group "$resourceGroupName" \
      --template-file "$template" \
      --parameters "$parameters" \
      --parameters location="$location" \
      --parameters administratorLogin="$administratorLogin" administratorPassword="$administratorPassword"
  else
    echo "Validating [$template]..."
    az deployment group validate \
      --resource-group "$resourceGroupName" \
      --template-file "$template" \
      --parameters "$parameters" \
      --parameters location="$location" \
      --parameters administratorLogin="$administratorLogin" administratorPassword="$administratorPassword" >/dev/null
  fi
fi

step_start=$SECONDS
echo "Deploying source MongoDB (ACI) via [$template]..."
deployment_output=$(az deployment group create \
  --resource-group "$resourceGroupName" \
  --template-file "$template" \
  --parameters "$parameters" \
  --parameters location="$location" \
  --parameters administratorLogin="$administratorLogin" administratorPassword="$administratorPassword" \
  --query "properties.outputs.deploymentInfo.value" \
  --output json)

sourceMongoDbFqdn=$(echo "$deployment_output" | jq -r '.sourceMongoDbFqdn')

echo "Deployment completed. ($(format_duration $((SECONDS - step_start))))"
echo "  Source MongoDB FQDN: $sourceMongoDbFqdn"

# --- Wait for source MongoDB to be ready ---
step_start=$SECONDS
command -v mongosh >/dev/null 2>&1 || error_exit "mongosh is required for readiness checks but is not installed."

echo "Waiting for source MongoDB ($sourceMongoDbFqdn) to be ready..."
for i in $(seq 1 30); do
  if mongosh \
    --host "$sourceMongoDbFqdn" \
    --port 27017 \
    --username "$administratorLogin" \
    --password "$administratorPassword" \
    --authenticationDatabase "admin" \
    --quiet \
    --eval "db.adminCommand({ ping: 1 }).ok" 2>/dev/null | grep -q '^1$'; then
    echo "Source MongoDB responded to authenticated ping."
    break
  fi
  if [ "$i" -eq 30 ]; then
    echo "Warning: Timed out waiting for source MongoDB. You may need to load data manually." >&2
  fi
  echo "  Attempt $i/30 — waiting 10s..."
  sleep 10
done
echo "  (MongoDB readiness wait: $(format_duration $((SECONDS - step_start))))"

# Give MongoDB a few extra seconds after readiness checks
sleep 5

# --- Load sample data ---
step_start=$SECONDS
echo "Downloading sample data..."
curl -sL https://atlas-education.s3.amazonaws.com/sampledata.archive -o sampledata.archive

if command -v mongorestore >/dev/null 2>&1; then
  echo "Loading sample data into source MongoDB at $sourceMongoDbFqdn..."
  mongorestore \
    --host="${sourceMongoDbFqdn}:27017" \
    --username="${administratorLogin}" \
    --password="${administratorPassword}" \
    --authenticationDatabase="admin" \
    --archive=sampledata.archive \
    --nsInclude="sample_mflix.*" \
    --drop
  echo "Sample data loaded into source MongoDB."
else
  echo "Warning: mongorestore is not installed; skipping data load." >&2
  echo "Install MongoDB Database Tools and run manually:" >&2
  echo "  mongorestore --host=${sourceMongoDbFqdn}:27017 --username=${administratorLogin} --password=<password> --authenticationDatabase=admin --archive=sampledata.archive --nsInclude='sample_mflix.*' --drop" >&2
fi
echo "  (Data download + load: $(format_duration $((SECONDS - step_start))))"

rm -f sampledata.archive

# --- Update .env with source MongoDB connection string ---
sourceMongoUri="mongodb://${administratorLogin}:${administratorPassword}@${sourceMongoDbFqdn}:27017/?retryWrites=false&maxIdleTimeMS=120000&authSource=admin"

ENV_FILE="../MFlix/.env"
if [ -f "$ENV_FILE" ]; then
  # Update both MFLIX_DB_URI and SECRET_KEY
  escapedSourceMongoUri=$(printf '%s' "$sourceMongoUri" | sed 's/[&|\\]/\\&/g')
  sed -i "s|^MFLIX_DB_URI=.*|MFLIX_DB_URI=${escapedSourceMongoUri}|" "$ENV_FILE"
  SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_hex(16))")
  sed -i "s|^SECRET_KEY=.*|SECRET_KEY=${SECRET_KEY}|" "$ENV_FILE"
  echo "Updated $ENV_FILE with source MongoDB URI and generated SECRET_KEY."
else
  cat > "$ENV_FILE" <<EOF
SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_hex(16))")
MFLIX_DB_URI=${sourceMongoUri}
MFLIX_NS=sample_mflix
PORT=5001
EOF
  echo "Created $ENV_FILE with source MongoDB URI."
fi

echo ""
echo "===== Source MongoDB Deployment Summary ====="
echo "Source MongoDB (ACI):  mongodb://${administratorLogin}:<password>@${sourceMongoDbFqdn}:27017/?authSource=admin"
echo "============================================="
echo "Total deployment time: $(format_duration $((SECONDS - script_start)))"
