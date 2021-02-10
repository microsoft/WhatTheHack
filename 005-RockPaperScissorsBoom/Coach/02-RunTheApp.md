# Challenge 2 - Run the app

[< Previous Challenge]() - **[Home](README.md)** - [Next Challenge >](03-MoveToAzureSql.md)

Easiest way it's run docker-compose to build the images and run the containers:

## Running the app in Azure as a local environment

1. Launch Azure Cloud Shell by following the steps on [Browser-based shell experience](https://docs.microsoft.com/azure/cloud-shell/overview#browser-based-shell-experience), alternatively, you can use the Azure CLI or Window Terminal Cloud Shell.

2. Create and push the container image in the cloud

   ```bash
   # Build your server container image
   az acr build \
        -t $acrRepoName/$imageName:$imageTag
        -r $registryName
        -f Dockerfile-server
   ```

3. Test the app in Azure Container Instance

    ```bash
    # Create and deploy the application
    az container create \
        -g resourceGroupName \
        -f deploy-aci.yaml .
    
    # Obtain the FQDN to test your app using the browser
    az container show \
        -g $resourceGroupName
        -n $aciName
    ```

## Running the app in a local environment

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
2. Use the following docker commands within the application context to run the app locally

    ```bash
    docker-compose up -d    # Builds and runs the services defined
    docker images           # Lists the images in the local environment - should show 4-5 imges in this case
    docker ps               # Shows the running containers and their images
    docker-compose down     # Stops all services and containers defined in the compose file
    ```

### Validate the application is working

1. Launch your browser and navigate to `http://localhost`. The app should load up. Run a few games to validate
2. Examine container logs

    ```bash
    docker ps                       # List containers and their IDs
    docker ps -a                    # List containers that are no longer running. ex crashed
    docker logs <container-id>      # Displays the logs for the container
    ```
