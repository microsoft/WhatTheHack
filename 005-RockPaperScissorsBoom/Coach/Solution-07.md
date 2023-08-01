# Challenge 07 - Leverage SignalR - Coach's Guide

[< Previous Solution](./Solution-06.md) - **[Home](./README.md)** - [Next Solution >](./Solution-08.md)

## Notes & Guidance

### Run locally with Docker Compose

1.  Modify the `docker-compose.yaml` file to include a new `ExampleBot` service

    ```yaml
    rockpaperscissors-examplebot:
      build:
        context: .
        dockerfile: Dockerfile-ExampleBot
      container_name: rockpaperscissors-examplebot
      ports:
        - "8080:80"
    ```

1.  Run the following command to start the app:

    ```shell
    docker compose up --build
    ```

1.  Open a browser to http://localhost:8080/api/default to ensure the app is up & running.

1.  Open another tab and navigate to https://localhost.

1.  Click on the `Competitors` tab, then the `Create new` link

1.  Give the bot a name (such as `ExampleBot`), select the `ExampleBot` type as `SignalRBot`, set the url to `http://localhost:8080/decision` and click the `Create` button.

1.  Click on the `Run the Game` tab, then `Run the Game Again`.

1.  You should see the `ExampleBot` in the list of competitors.

### Build, push & start the `ExampleBot` Docker image

1.  Build & push the `ExampleBot` Docker image:

    ```shell
    docker compose build

    docker tag rpsb-rockpaperscissors-examplebot <acr-name>.azurecr.io/rockpaperscissors-examplebot:latest

    docker push <acr-name>.azurecr.io/rockpaperscissors-examplebot:latest
    ```

1.  Run the following Azure CLI to create the App Service for Containers for your new `ExampleBot` using your existing App Service Plan.

    ```shell
    az webapp create -g <resource-group-name> -p <app-service-plan-name> -n <app-name> --deployment-container-image-name <acr-name>.azurecr.io/rockpaperscissors-examplebot:latest
    ```

1.  Run the following Azure CLI to get the CI/CD webhook URL from App Service (so it can be notified on a push of a new image to the Azure Container Registry).

    ```shell
    az webapp deployment container config --enable-cd true --name <app-name> --resource-group <resource-group-name> --query CI_CD_URL --output tsv
    ```

1.  Run the following Azure CLI to setup the webhook notification from the ACR to App Service (update the ACR url & image name as needed).

    ```shell
    az acr webhook create --name appserviceCD --registry <container-registry-name> --uri <app-service-cicd-url> --actions push --scope <container-registry-name>.azurecr.io/rockpaperscissors-examplebot:latest
    ```

1.  Navigate to the `ExampleBot` web app URL to ensure the `ExampleBot` app is running: https://<web-app-name>.azurewebsites.net/api/default

### Run the `RockPaperScissorsBoom` app and include your new `ExampleBot`

1.  Navigate to your `RockPaperScissorsBoom` web app that is hosted in Azure.

1.  Click on the `Competitors` tab, then the `Create new` link

1.  Give the bot a name (such as `ExampleBot`), select the `ExampleBot` type as `SignalRBot`, set the url to `https://<web-app-name>.azurewebsites.net/decision` and click the `Create` button.

1.  Click on the `Run the Game` tab, then `Run the Game Again`.

1.  You should see the `ExampleBot` in the list of competitors.
