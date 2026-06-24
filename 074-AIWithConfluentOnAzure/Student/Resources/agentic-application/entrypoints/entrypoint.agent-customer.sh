#!/bin/bash

# This is needed to create (or update) the virtual environment.
# Resolve and install all dependencies listed in pyproject.toml and uv.lock.
# Ensure the environment is in sync with your project metadata.
uv sync

# Activate the Virtual Environment
source .venv/bin/activate

# This is needed for Azure AI Search. For some reason, the SSL certs are not working on Macs
# pip install --upgrade certifi
# or
# uv add certifi
PY_CERT=$(python -c "import certifi; print(certifi.where())")

# make TLS stacks use it
export SSL_CERT_FILE="$PY_CERT"
export REQUESTS_CA_BUNDLE="$PY_CERT"   # requests uses this
export AZURE_CA_BUNDLE="$PY_CERT"      # Azure SDK honors this

# Run the application after all of the above are completed successfully
sleep 48h