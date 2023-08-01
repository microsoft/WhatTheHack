# Challenge 05 - Add Application Monitoring - Coach's Guide

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance

### Create Application Insights Azure resource

1.  Run the following Azure CLI to create a Log Analytics workspace for the App Insights instance to use.

    ```shell
    az monitor log-analytics workspace create --resource-group <resource-group-name> --name <log-analytics-workspace-name>
    ```

1.  Run the following Azure CLI to create an Application Insights resource.

    ```shell
    az monitor app-insights component create --app <app-insights-name> --location <location> --resource-group <resource-group-name> --workspace <log-analytics-workspace-name>
    ```

    > Note:
    >
    > - You can also use the Azure Portal to create the Application Insights resource.
    > - You may be prompted to install the `application-insights` extension when running the Azure CLI. Choose `Yes`.

1.  Copy the `Connection String` GUID from the Application Insights resource. You can get this from the output of the previous Azure CLI command or from the Azure Portal.

### Review where to update the Application Insights configuration in the application

1.  Open the `RockPaperScissorsBoom.Server\appsettings.json` file and note the key that stores the Application Insights Connection String. This is the value we need to modify via environment variables in both the local & Azure deployment.

    ```json
    {
      ...
      "ApplicationInsights": {
        "ConnectionString": "<app-insights-connection-string>"
      },
      ...
    }
    ```

### Add Application Insights to the app running locally

1.  Open the `docker-compose.yaml` file.

1.  Modify the `docker-compose.yaml` file to include this new `ApplicationInsights__InstrumentationKey` environment variable, similar to below.

    ```yaml
    version: "3"
    services:
      rockpaperscissors-server:
        build:
          context: .
          dockerfile: Dockerfile-Server
        container_name: rockpaperscissors-server
        environment:
          "ApplicationInsights__ConnectionString": "<app-insights-connection-string>"
          "ConnectionStrings__DefaultConnection": "..."
        ports:
          - "80:80"
    ```

1.  Run the following command to start the app locally.

    ```shell
    docker compose up --build --remove-orphans
    ```

1.  Open the browser to http://localhost and play a game.

1.  Open the Azure portal and navigate to your new Application Insights resource.

1.  In the `Transaction search` blade, you should see a list of requests made to the app. Search for transactions from the last 24 hours. You will see transactions from the localhost.
    > Note: It may take a few minutes for the transactions to be processed in Application Insights.

### Add Application Insights to the app running in App Service

1.  Run the following Azure CLI to add a new value to the App Service App Settings. This will be surfaced to the application as a new environment variable that will override the value specified in the `appsettings.json` file (note the double underscores in the nested resource name).

    ```shell
    az webapp config appsettings set --resource-group <resource-group-name> --name <app-service-name> --settings ApplicationInsights__ConnectionString="<app-insights-connection-string>"
    ```

1.  Open the browser to https://\<app-service-name\>.azurewebsites.net and play a game.

1.  Open the Azure portal and navigate to your Application Insights resource.

1.  In the `Transaction search` blade, you should see a list of requests made to the app.
