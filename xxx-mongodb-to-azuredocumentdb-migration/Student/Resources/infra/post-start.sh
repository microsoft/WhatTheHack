#!/usr/bin/env bash
set -euo pipefail

container_name="mongodb-source"
network_name="mflix-network"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker CLI not found; skipping ${container_name} startup." >&2
  exit 0
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker daemon is unavailable; skipping ${container_name} startup." >&2
  exit 0
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
    -e MONGO_INITDB_DATABASE=sample_mflix \
    mongo:7; then
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

# Generate a random SECRET_KEY for JWT tokens
echo "Generating random SECRET_KEY for JWT authentication..."
SECRET_KEY=$(openssl rand -base64 32)
ENV_FILE="MFlix/.env"
ENV_EXAMPLE="MFlix/.env.example"

if [ ! -f "$ENV_FILE" ]; then
  if [ -f "$ENV_EXAMPLE" ]; then
    # Copy .env.example to .env
    cp "$ENV_EXAMPLE" "$ENV_FILE"
    echo "Created $ENV_FILE from $ENV_EXAMPLE"
  else
    echo "Warning: Neither $ENV_FILE nor $ENV_EXAMPLE found."
    exit 0
  fi
fi

# Update the SECRET_KEY in the .env file
sed -i "s|SECRET_KEY=.*|SECRET_KEY=$SECRET_KEY|" "$ENV_FILE"
echo "Updated SECRET_KEY in $ENV_FILE"

echo "Downloading sample data for MongoDB..."
curl  https://atlas-education.s3.amazonaws.com/sampledata.archive -o sampledata.archive
echo "Loading sample data into the local MongoDB instance..."
mongorestore --host="mongodb-source:27017" --archive=sampledata.archive --nsInclude="sample_mflix.*" --drop
echo "Sample data loaded into local MongoDB instance."

