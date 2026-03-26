#!/usr/bin/env bash
set -euo pipefail

# Ensure the MFlix .env file exists (from template).
# The actual MongoDB URI will be configured by deploy-target-db.sh after Azure resources are provisioned.
ENV_FILE="MFlix/.env"
ENV_EXAMPLE="MFlix/.env.example"

if [ ! -f "$ENV_FILE" ]; then
  if [ -f "$ENV_EXAMPLE" ]; then
    cp "$ENV_EXAMPLE" "$ENV_FILE"
    echo "Created $ENV_FILE from $ENV_EXAMPLE"
  else
    echo "Warning: Neither $ENV_FILE nor $ENV_EXAMPLE found."
  fi
fi

echo ""
echo "To deploy Azure resources (source MongoDB + target DocumentDB), run:"
echo "  cd infra && ./deploy-target-db.sh --administratorPassword <your-password>"
echo ""

