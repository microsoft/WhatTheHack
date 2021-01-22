# Challenge 2 - Run the app

Easiest way it's run docker-compose to build the images and run the containers:

## Running the app in Azure Cloud Shell

Launch Azure Cloud Shell by following the steps on [Browser-based shell experience](https://docs.microsoft.com/azure/cloud-shell/overview#browser-based-shell-experience)

## Running the app in a local environment

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
2. Run the following docker commands

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
