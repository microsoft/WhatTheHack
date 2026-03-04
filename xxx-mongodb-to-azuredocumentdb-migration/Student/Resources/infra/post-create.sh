#!/usr/bin/env bash
set -euo pipefail

TOOLS_DEB_URL="https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-arm64-100.14.1.deb"
TOOLS_DEB_PATH="/tmp/mongodb-database-tools.deb"
MONGO_KEYRING_PATH="/usr/share/keyrings/mongodb-server-8.0.gpg"
MONGO_APT_LIST="/etc/apt/sources.list.d/mongodb-org-8.0.list"

install_mongodb_tools() {
  sudo rm -f "${MONGO_KEYRING_PATH}"
  curl -fsSL https://pgp.mongodb.com/server-8.0.asc \
    | sudo gpg --batch --yes --dearmor -o "${MONGO_KEYRING_PATH}"

  echo "deb [ signed-by=${MONGO_KEYRING_PATH} ] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/8.0 main" \
    | sudo tee "${MONGO_APT_LIST}" >/dev/null

  sudo apt-get update
  sudo apt-get install -y mongodb-mongosh

  if sudo apt-get install -y mongodb-database-tools; then
    return
  fi

  if [ "$(dpkg --print-architecture)" != "arm64" ]; then
    echo "Error: mongodb-database-tools is unavailable via apt on this architecture." >&2
    exit 1
  fi

  echo "Falling back to MongoDB Database Tools .deb for arm64..."
  curl -fsSL "${TOOLS_DEB_URL}" -o "${TOOLS_DEB_PATH}"
  sudo apt-get install -y "${TOOLS_DEB_PATH}"
  rm -f "${TOOLS_DEB_PATH}"
}

main() {
  cd MFlix
  npm install

  install_mongodb_tools

  sudo npm uninstall -g mongosh || true
}

main "$@"
