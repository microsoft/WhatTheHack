# Challenge 1 - Setup

**[Home](README.md)** - [Next Challenge >](02-RunTheApp.md)

## Setup using Azure Cloud Shell

1. Run Cloud Shell in your Azure Subscription, see [Azure Cloud Shell](https://docs.microsoft.com/azure/cloud-shell/overview)
2. If this is the first time, you will need to [create storage](https://docs.microsoft.com/azure/cloud-shell/persisting-shell-storage) during the first run
3. Download the resources

   ```bash
   # MY_WTH_NAME.zip = any name you wish for your download
   # WTH_ASSET_RELEASE_URL = https://github.com/microsoft/WhatTheHack/releases choose the release and under assets, copy the link for the WTH
   curl -LJ0 <MY_WTH_NAME.zip> https://<WTH_ASSET_RELEASE_URL>

   # Unzip
   unzip MY_WTH_NAME.zip
   ```

4. Unzip files `unzip MY_WTH_NAME.zip`
5. Validate environment

    ```bash
    ls -al
    az --version
    code .
    ```

## Setup using Azure CLI in a local environment

1. [Install Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
2. Download the resources

    ```bash
    # MY_WTH_NAME.zip = any name you wish for your download
    # WTH_ASSET_RELEASE_URL = https://github.com/microsoft/WhatTheHack/releases choose the release and under assets, copy the link for the WTH
    curl -LJ0 <MY_WTH_NAME.zip> https://<WTH_ASSET_RELEASE_URL>

    # Unzip - use your favorite utility to unzip the archive 
    unzip MY_WTH_NAME.zip

    # Alternatively clone the repository
    git clone <REPO>
    ```

3. Validate the environment

    ```bash
    ls -al
    az --version
    code .
    ```
