
# Challenge 4 - Run the app on Azure

[< Previous Challenge](03-MoveToAzureSql.md) - **[Home](README.md)** - [Next Challenge >](05-RunTheGameContinuously.md)

## Prepare the environment

If using the same terminal session, you may skip this step

```bash
# Set the resource group name and location for your server
resourceGroupName=WTH-RockPaper
location=eastus

# Random Identifier for deploying resources
randomIdentifier=$RANDOM
appPlan=<plan-name>-$randomIdentifier
appName=<unique-app-name>-$randomIdentifier
appSku=S1

# If using GitHub container registry, obtain Personal Access Token (PAT) from GitHub
githubPat=<your-pat>

# Registry and container resources
registryUrl=<registry-url>
registryUserName=<github-repo-username>
registryPassword=$githubPat
imageName=<my-app-image>
imageTag=<my-app-image-tag>

# Azure SQL connection string
sqlConnectionString=<azure-sql-db-conn-string>
```

## Create a private container registry

1. Create an ACR instance using the [az acr create](https://docs.microsoft.com/cli/azure/acr#az-acr-create) command

    ```bash
    # If using the same terminal session, you can recall the previously defined variables $resourceGroupName and $randomIdentifier

    # Azure Container Registry
    az acr create \ 
        -g $resourceGroupName \
        -n myContainerRegistry-$randomIdentifier \
        --sku Basic

    # If using GitHub:
    # 
    ```

    Or

2. Use GitHub packages or container registry by [Enable improved container support](https://docs.github.com/en/packages/guides/enabling-improved-container-support)

3. Configure Docker to you the private registry

   ```bash
   # Using Azure Container Registry
   az acr login -n mycontainerregistry

   # Using GitHub container registry
   echo $GITHUB_PAT | docker login ghcr.io -u USERNAME --password-stdin
   ```

## Build the app image

```bash
# Don't forget the path arg in the docker command, in this case it's "."
docker build \
    -f Dockerfile-Server \
    -t <container-registry>/<image-name>:<image-tag> .

# Publish the image to your container registry
docker push <container-registry>/<image-name>:<image-tag>
```

## Deploy the app to Azure AppService

1. Create ApprService plan with: [az appservice plan create](https://docs.microsoft.com/cli/azure/appservice/plan?view=azure-cli-latest#az_appservice_plan_create)

   ```bash
   az appservice plan create \
        -g $resourceGroupName \
        -n $appPlan \
        -l $location \
        --is-linux \
        --sku $appSku
   ```

2. Create a Web App and deploy container with: [az webapp create](https://docs.microsoft.com/cli/azure/webapp?view=azure-cli-latest#az_webapp_create)

    ```bash
    # Create a Web App and set container registry and image to use
    az webapp create \
        -g $resourceGroupName \
        -n $appName \
        -p $appPlan \
        -i $registryUrl/$imageName:$imageTag \
        -s $registryUserName \
        -w $registryPassword
   ```

3. Provide Azure SQL connection string as an environment variable

    ```bash
    az webapp config connection-string set \
        -n $appName \
        -g $resourceGroupName \
        -t SQLAzure \
        --settings DefaultConnection=$sqlConnectionString
    ```
