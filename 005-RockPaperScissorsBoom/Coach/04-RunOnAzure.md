
# Challenge 4 - Run the app on Azure

[< Previous Challenge](03-MoveToAzureSql.md) - **[Home](README.md)** - [Next Challenge >](05-RunTheGameContinuously.md)

## Prerequisites

1. [Challenge 3](03-MoveToAzureSql.md)

## Prepare the environment

```bash
appPlan="<PLAN-NAME>-$randomId"
appName="<APP-NAME>-$randomId"
appSku="S1"

# If using GitHub container registry, obtain Personal Access Token (PAT) from GitHub
githubPat="<PAT>"

# Registry and container resources
registryUrl="<REGISTRY-URL>"
registryUserName="<ANY-NAME>"
registryPassword="$GITHUB_PAT"

# Azure SQL connection string
sqlConnectionString="<SQL-CONNECTION-STRING>"
```

## Using Github Container Registry

1. Use GitHub packages or container registry by [Enable improved container support](https://docs.github.com/en/packages/guides/enabling-improved-container-support)

2. Configure Docker to use your private registry

   ```bash
   # Using GitHub container registry
   echo $GITHUB_PAT | docker login ghcr.io -u USERNAME --password-stdin
   ```

3. Build and push the container image

    ```bash
    # Don't forget the path arg in the docker command, in this case it's "."
    docker build \
        -f Dockerfile-Server \
        -t $registryUrl/$imageName:$imageTag .

    # Publish the image to your container registry
    docker push $registryUrl/$imageName:$imageTag
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
