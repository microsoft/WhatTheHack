#!/usr/bin/env bash
set -euo pipefail

container_name="mongodb-source"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker CLI not found; skipping ${container_name} startup." >&2
  exit 0
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker daemon is unavailable; skipping ${container_name} startup." >&2
  exit 0
fi

if ! docker ps -a --format '{{.Names}}' | grep -q '^mongodb-source$'; then
  if ! docker run -d \
    --name "${container_name}" \
    -p 27017:27017 \
    -e MONGO_INITDB_DATABASE=sample_mflix \
    mongo:7; then
    echo "Warning: failed to create ${container_name}. Continuing without startup failure." >&2
    echo "Hint: check for port conflicts on 27017 or existing container name conflicts." >&2
    exit 0
  fi
else
  if ! docker start "${container_name}" >/dev/null 2>&1; then
    echo "Warning: failed to start ${container_name}. Continuing without startup failure." >&2
    exit 0
  fi
fi