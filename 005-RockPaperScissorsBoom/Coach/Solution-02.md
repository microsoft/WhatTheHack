# Challenge 02 - Move to Azure SQL Database - Coach's Guide

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

### Create Azure SQL Server & Database

1.  Create an Azure SQL Server via the Azure CLI (substituting your own values).

    ```shell
    az sql server create -g <resource-group-name> -n <sql-server-name> -u <admin-username> -p <admin-password>
    ```

1.  Optional: Add an IP firewall rule to restrict access to just your local IP & Azure (PowerShell)

    ```powershell
    $myIP = $(Invoke-WebRequest -Uri "https://api.ipify.org").Content

    az sql server firewall-rule create -g <resource-group-name> -s <sql-server-name> -n AllowMyIP --start-ip-address $myIP --end-ip-address $myIP

    az sql server firewall-rule create -g <resource-group-name> -s <sql-server-name> -n AllowAzure --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0
    ```

1.  Create an Azure SQL Database via the Azure CLI.

    ```shell
    az sql db create -g <resource-group-name> -s <sql-server-name> -n RockPaperScissorsBoom
    ```

1.  Run the following Azure CLI command to get the connection string for the Azure SQL database.

    ```shell
    az sql db show-connection-string -s <sql-server-name> -n RockPaperScissorsBoom -c ado.net
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
        "ConnectionStrings__DefaultConnection": "Server=tcp:<sql-server-name>.database.windows.net,1433;Initial Catalog=RockPaperScissorsBoom;Persist Security Info=False;User ID=<username>;Password=<password>;MultipleActiveResultSets=False;Encrypt=true;TrustServerCertificate=False;Connection Timeout=30;"
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
    docker compose up --build --remove-orphans
    ```

1.  Navigate to the locally running application in the browser (http://localhost) & play the game

### Check for records in the database

1.  Open the Azure portal (https://portal.azure.com).

1.  Navigate to the **Azure SQL Server** & **SQL Database**.

1.  Open the **Query Editor** & login with the credentials you specified earlier.

1.  Run the following query to see the records in the `GameRecords` table.

    ```sql
    SELECT * FROM [dbo].[GameRecords]
    ```

### Troubleshooting

- If the Docker image does not start correctly, it may be because it cannot access the database. Verify that connections can be made to the server. By default, the server will restrict access to the database. Add a firewall rule.
