# Challenge 03 - Run the app on Azure - Coach's Guide

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

### Create the Azure Container Registry & push your local Docker image to it

1.  Run the following Azure CLI to create the Azure Container Registry.

    ```shell
    az acr create -g <resource-group-name> -n <acr-name> --sku Basic --admin-enabled true
    ```

1.  Run the following Azure CLI to get the login server for the Azure Container Registry.

    ```shell
    az acr login -n <acr-name>
    ```

1.  Run the following Docker CLI to tag your local Docker image with the Azure Container Registry login server. **Note** that you may have slightly different image names. Check the list of images names created locally with `docker images`.

    ```shell
    docker tag rpsb-rockpaperscissors-server <acr-name>.azurecr.io/rockpaperscissors-server:latest
    ```

1.  Run the following Docker CLI to push your local Docker image to the Azure Container Registry.

    ```shell
    docker push <acr-name>.azurecr.io/rockpaperscissors-server:latest
    ```

### Create the Azure App Service for Containers

1.  Run the following Azure CLI to create the App Service Plan.

    ```shell
    az appservice plan create -g <resource-group-name> -n <app-service-plan-name> --is-linux --sku B1
    ```

1.  Run the following Azure CLI to create the App Service for Containers.

    ```shell
    az webapp create -g <resource-group-name> -p <app-service-plan-name> -n <app-name> --deployment-container-image-name <acr-name>.azurecr.io/rockpaperscissors-server:latest
    ```

1.  Run the following Azure CLI to get the CI/CD webhook URL from App Service (so it can be notified on a push of a new image to the Azure Container Registry)

    ```shell
    az webapp deployment container config --enable-cd true --name <app-name> --resource-group <resource-group-name> --query CI_CD_URL --output tsv
    ```

1.  Run the following Azure CLI to setup the webhook notification from the ACR to App Service (update the ACR url & image name as needed).

    ```shell
    az acr webhook create --name appserviceCD --registry <container-registry-name> --uri <app-service-cicd-url> --actions push --scope <container-registry-name>.azurecr.io/rockpaperscissors-server:latest
    ```

### Modify the App Service to have the connection string for the database

1.  Run the following Azure CLI to get the connection string for the Azure SQL database.

    ```shell
    az sql db show-connection-string -s <sql-server-name> -n RockPaperScissorsBoom -c ado.net
    ```

1.  Run the following Azure CLI to set the connection string for the App Service.

    ```shell
    az webapp config connection-string set -g <resource-group-name> -n <app-name> -t SQLAzure --settings DefaultConnection="<connection-string>"
    ```

### Test your web app

1.  Navigate to your web app in a browser and play a game. You can get the url from the Azure portal (e.g., https://\<app-service-name\>.azurewebsites.net).

1.  Login to the database (using the Query editor in the Azure portal) to ensure you are getting new database records

    ```sql
    SELECT * FROM [dbo].[GameRecords]
    ```

### Troubleshooting

- If the application does not start correctly, make sure the database firewall is not restricting access. To check this, in the Azure Portal, navigate to the **Azure SQL** -> **Networking** page and check the box **"Allow Azure services and resources to access this server."**
