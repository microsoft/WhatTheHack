# Challenge 08 - Leverage SignalR - Coach's Guide

[< Previous Solution](./Solution-07.md) - **[Home](./README.md)** - [Next Solution >](./Solution-09.md)

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
    docker compose up
    ```

1.  Open a browser to http://localhost:8080/api/default to ensure the app is up & running.

1.  Open another tab and navigate to https://localhost.

1.  Click on the `Competitors` tab, then the `Create new` link

1.  Give the bot a name (such as `ExampleBot`), select the `ExampleBot` type as `SignalRBot`, set the url to `http://localhost:8080/decision` and click the `Create` button.

1.  Click on the `Run the Game` tab, then `Run the Game Again`.

1.  You should see the `ExampleBot` in the list of competitors.

### Build & push the ExampleBot Docker image

1.  Build & push the ExampleBot Docker image:

    ```shell
    docker build -f Dockerfile-ExampleBot -t rockpaperscissors-examplebot .

    docker tag rockpaperscissors-examplebot <acr-name>.azurecr.io/rockpaperscissors-examplebot:latest

    docker push <acr-name>.azurecr.io/rockpaperscissors-examplebot:latest
    ```
