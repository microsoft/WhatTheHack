# Challenge 02 - Move to Azure SQL Database - Coach's Guide

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

### Create Azure SQL Server & Database

1.  Create a Azure SQL Server via the Azure CLI (substituting your own values).

    ```shell
    az sql server create -g <resource-group-name> -n <sql-server-name> -u <admin-username> -p <admin-password>
    ```

1.  Optional: Add a IP firewall rule to restrict access to just your local IP & Azure

    ```powershell
    $myIP = $(Invoke-WebRequest -Uri "https://api.ipify.org").Content

    az sql server firewall-rule create -g <resource-group-name> -s <sql-server-name> -n AllowMyIP --start-ip-address $myIP --end-ip-address $myIP

    az sql server firewall-rule create -g <resource-group-name> -s <sql-server-name> -n AllowAzure --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0
    ```

1.  Create a Azure SQL Database via the Azure CLI.

    ```shell
    az sql db create -g <resource-group-name> -s <sql-server-name> -n RockPaperScissorsBoom
    ```

### Modify the `docker-compose.yaml` file to point to the new Azure SQL database

1.  Open the `docker-compose.yaml` file in a text editor.

1.  Comment out the `rockpaperscissors-sql` service since the application will use an Azure SQL database.

1.  Modify the `rockpaperscissors-server` service to use the Azure SQL database (notice that you modify the connection string & remove the dependency on the `rockpaperscissors-sql` service). Get the server FQDN & database name from the Azure portal.

    ```yaml
    rockpaperscissors-server:
      build:
        context: .
        dockerfile: Dockerfile-Server
      container_name: rockpaperscissors-server
      environment:
        "ConnectionStrings__DefaultConnection": "Server=<azure-sql-server-fqdn>,1433;Database=<azure-sql-db-name>;User Id=<admin-username>;Password=<admin-password>;Encrypt=False;Persist Security Info=False;trusted_connection=False"
      ports:
        - "80:80"
    ```

### Build & run the application

1.  Shut down the previous version of the application (to stop the local database).

    ```shell
    docker compose down
    ```

1.  Run the following command to build & run the application.

    ```shell
    docker compose up --build -d
    ```

1.  Navigate to the locally running application in the browser (http://localhost) & play the game

### Check for records in the database

1.  Open the Azure portal (https://portal.azure.com).

1.  Navigate to the Azure SQL Server & Database.

1.  Open the Query Editor & login with the credentials you specified earlier.

1.  Run the following query to see the records in the `Game` table.

    ```sql
    SELECT * FROM [dbo].[GameRecords]
    ```
