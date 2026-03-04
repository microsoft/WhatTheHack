#!/usr/bin/env bash
set -euo pipefail

container_name="mongodb-source"
network_name="mflix-network"
mongo_root_username="mflixadmin"
mongo_creds_file="MFlix/.mongodb-source-credentials"

generate_password() {
  python3 - <<'PY'
import secrets
import string

alphabet = string.ascii_letters + string.digits
print(''.join(secrets.choice(alphabet) for _ in range(8)))
PY
}

if [ -f "${mongo_creds_file}" ]; then
  mongo_root_password=$(grep '^MONGO_SOURCE_PASSWORD=' "${mongo_creds_file}" | cut -d'=' -f2-)
fi

if [ -z "${mongo_root_password:-}" ]; then
  mongo_root_password="$(generate_password)"
  cat > "${mongo_creds_file}" <<EOF
MONGO_SOURCE_USERNAME=${mongo_root_username}
MONGO_SOURCE_PASSWORD=${mongo_root_password}
EOF
  chmod 600 "${mongo_creds_file}" || true
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker CLI not found; skipping ${container_name} startup." >&2
  exit 0
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker daemon is unavailable; skipping ${container_name} startup." >&2
  exit 0
fi

ENV_FILE="MFlix/.env"
ENV_EXAMPLE="MFlix/.env.example"

if [ ! -f "$ENV_FILE" ]; then
  if [ -f "$ENV_EXAMPLE" ]; then
    cp "$ENV_EXAMPLE" "$ENV_FILE"
    echo "Created $ENV_FILE from $ENV_EXAMPLE"
  else
    echo "Warning: Neither $ENV_FILE nor $ENV_EXAMPLE found."
    exit 0
  fi
fi

# Create custom network for hostname resolution if it doesn't exist
if ! docker network ls --format '{{.Name}}' | grep -q "^${network_name}$"; then
  echo "Creating Docker network: ${network_name}"
  docker network create "${network_name}" >/dev/null 2>&1 || true
fi

# Connect current dev container to the network if not already connected
current_container=$(hostname)
if ! docker network inspect "${network_name}" --format '{{range .Containers}}{{.Name}}{{end}}' | grep -q "${current_container}"; then
  echo "Connecting current dev container to network ${network_name}"
  docker network connect "${network_name}" "${current_container}" >/dev/null 2>&1 || true
fi

if ! docker ps -a --format '{{.Names}}' | grep -q '^mongodb-source$'; then
  if ! docker run -d \
    --name "${container_name}" \
    --network "${network_name}" \
    -p 27017:27017 \
    -e MONGO_INITDB_ROOT_USERNAME="${mongo_root_username}" \
    -e MONGO_INITDB_ROOT_PASSWORD="${mongo_root_password}" \
    -e MONGO_INITDB_DATABASE=sample_mflix \
    mongo:7 --auth; then
    echo "Warning: failed to create ${container_name}. Continuing without startup failure." >&2
    echo "Hint: check for port conflicts on 27017 or existing container name conflicts." >&2
    exit 0
  fi
else
  # If container exists, make sure it's on the correct network
  if ! docker network inspect "${network_name}" --format '{{range .Containers}}{{.Name}}{{end}}' | grep -q "${container_name}"; then
    echo "Connecting ${container_name} to network ${network_name}"
    docker network connect "${network_name}" "${container_name}" >/dev/null 2>&1 || true
  fi
  
  if ! docker start "${container_name}" >/dev/null 2>&1; then
    echo "Warning: failed to start ${container_name}. Continuing without startup failure." >&2
    exit 0
  fi
fi

echo "Downloading sample data for MongoDB..."
curl  https://atlas-education.s3.amazonaws.com/sampledata.archive -o sampledata.archive

if ! command -v mongorestore >/dev/null 2>&1; then
  echo "Warning: mongorestore is not installed in this container; skipping sample data restore." >&2
  echo "Hint: rebuild the dev container so postCreate installs MongoDB Database Tools." >&2
  echo "MongoDB source credentials:"
  echo "  Username: ${mongo_root_username}"
  echo "  Password: ${mongo_root_password}"
  exit 0
fi

echo "Loading sample data into the local MongoDB instance..."
if ! mongorestore \
  --host="mongodb-source:27017" \
  --username="${mongo_root_username}" \
  --password="${mongo_root_password}" \
  --authenticationDatabase="admin" \
  --archive=sampledata.archive \
  --nsInclude="sample_mflix.*" \
  --drop; then
  echo "Authenticated restore failed. Retrying without authentication for existing non-auth container..."
  mongorestore --host="mongodb-source:27017" --archive=sampledata.archive --nsInclude="sample_mflix.*" --drop
fi
echo "Sample data loaded into local MongoDB instance."
echo "MongoDB source credentials:"
echo "  Username: ${mongo_root_username}"
echo "  Password: ${mongo_root_password}"

