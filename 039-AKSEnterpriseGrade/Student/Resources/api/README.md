# API Container

## Usage

Here you can find the source files to build this container. The container is a web API that returns JSON payload. It offers the following endpoints:

* `/api/healthcheck`: returns a basic JSON code to verify if the application is running, it can be used for liveliness probes
* `/api/sqlversion`: returns the results of a SQL query (`SELECT @@VERSION` for SQL Server or `SELECT VERSION();` for MySQL/Postgres) against a SQL database. You can override the value of the `SQL_SERVER_FQDN` via a query parameter
* `/api/sqlsrcip`: returns the results of a SQL query (`SELECT CONNECTIONPROPERTY("client_net_address")` for SQL Server, `SELECT host FROM information_schema.processlist WHERE ID=connection_id();` for MySQL or `SELECT inet_client_addr ();` for Postgres) against a SQL database. You can override the value of the `SQL_SERVER_FQDN`, `SQL_SERVER_USERNAME`, `SQL_SERVER_PASSWORD` and `SQL_SERVER_ENGINE` via a query parameter
* `/api/ip`: returns information about the IP configuration of the container, such as private IP address, egress public IP address, default gateway, DNS servers, etc
* `/api/dns`: returns the IP address resolved from the FQDN supplied in the parameter `fqdn`
* `/api/printenv`: returns the environment variables for the container
* `/api/curl`: returns the output of a curl request, you can specify the argument with the parameter `url`
* `/api/pi`: calculates the decimals of the number pi, you can specify how many decimals with the parameter `digits`. 1,000 digits should be quick, but as you keep increasing the number of digits, more CPU will be required. You can use this endpoint to force the container to consume more CPU
* `/api/sqlsrcipinit`: the previous endpoints do not modify the database. If you want to modify the database, you need first to create a table with this endpoint
* `/api/sqlsrciplog`: this endpoint will create a new record in the table created with the previous endpoint (`sqlsrcipinit`) with a timestamp and the source IP address as seen by the database.

The container requires these environment variables :

* `SQL_SERVER_FQDN`: FQDN of the SQL server
* `SQL_SERVER_DB` (optional): FQDN of the SQL server
* `SQL_SERVER_USERNAME`: username for the SQL server
* `SQL_SERVER_PASSWORD`: password for the SQL server
* `SQL_ENGINE`: can be either `sqlserver`, `mysql` or `postgres`
* `PORT` (optional): TCP port where the web server will be listening (8080 per default)
* `USE_SSL` (optional): Connect to the database using SSL. Can be either `yes` or `no`. Default `yes`.

Note that environment variables can also be injected as files in the `/secrets` directory.

## Build

You can build the image locally with:

```bash
docker build -t fasthack/sqlapi:1.0 .
```

or in a registry such as Azure Container Registry with:

```bash
az acr build -r <your_acr_registry> -g <your_azure_resource_group> -t sqlapi:1.0 .
```

## Deploy

### Test this against an Azure SQL Database

You can deploy an Azure SQL Database to test this image with the Azure CLI:

```bash
# Create Database for testing
rg=rg$RANDOM
location=westeurope
sql_server_name=sqlserver$RANDOM
sql_db_name=mydb
sql_username=azure
sql_password=your_super_secret_password
az group create -n $rg -l $location
az sql server create -n $sql_server_name -g $rg -l $location --admin-user "$sql_username" --admin-password "$sql_password"
az sql db create -n $sql_db_name -s $sql_server_name -g $rg -e Basic -c 5 --no-wait
sql_server_fqdn=$(az sql server show -n $sql_server_name -g $rg -o tsv --query fullyQualifiedDomainName) && echo $sql_server_fqdn
```

Delete the RG when you are done

```bash
# Delete resource group
az group delete -n $rg -y --no-wait
```

### Run this image locally

Replace the image and the variables with the relevant values for your environment. If you are using a private registry, make sure to provide authentication parameters:

```bash
# Deploy API on Docker
docker run -d -p 8080:8080 -e "SQL_SERVER_FQDN=yourdatabase.com" -e "SQL_SERVER_USERNAME=your_db_admin_user" -e "SQL_SERVER_PASSWORD=your_db_admin_password" --name api fasthacks/sqlapi:1.0
```

### Run this image in Azure Container Instances

Replace the image and the variables with the relevant values for your environment. If you are using a private registry, make sure to provide authentication parameters:

```bash
# Deploy API on ACI
rg=your_resource_group
sql_server_fqdn=your_db_fqdn
sql_username=your_db_admin_user
sql_password=your_db_admin_password
az container create -n api -g $rg \
    -e "SQL_SERVER_USERNAME=$sql_username" "SQL_SERVER_PASSWORD=$sql_password" "SQL_SERVER_FQDN=$sql_server_fqdn" \
    --image fasthacks/sqlapi:1.0 --ip-address public --ports 8080
```

### Run this image in Kubernetes

You can use the sample manifest to deploy this container, modifying the relevant environment variables and source image:

```yml
apiVersion: v1
kind: Secret
metadata:
  name: sqlpassword
type: Opaque
stringData:
  password: your_db_admin_password
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    run: api
  name: api
spec:
  replicas: 1
  selector:
    matchLabels:
      run: api
  template:
    metadata:
      labels:
        run: api
    spec:
      containers:
      - image: fasthacks/sqlapi:1.0
        name: api
        ports:
        - containerPort: 8080
          protocol: TCP
        env:
        - name: SQL_SERVER_USERNAME
          value: "your_db_admin_username"
        - name: SQL_SERVER_FQDN
          value: "your_db_server_fqdn"
        - name: SQL_SERVER_PASSWORD
          valueFrom:
            secretKeyRef:
              name: sqlpassword
              key: password
      restartPolicy: Always
---
apiVersion: v1
kind: Service
metadata:
  name: api
spec:
  type: LoadBalancer
  ports:
  - port: 8080
    targetPort: 8080
  selector:
    run: api
```

### Run this image on Azure App Services

This example Azure CLI code deploys the image on Azure Application Services (aka Web App):

```bash
# Run on Web App
rg=your_resource_group
sql_server_fqdn=your_db_fqdn
sql_username=your_db_admin_user
sql_password=your_db_admin_password
svcplan_name=webappplan
app_name_api=api-$RANDOM
az appservice plan create -n $svcplan_name -g $rg --sku B1 --is-linux
az webapp create -n $app_name_api -g $rg -p $svcplan_name --deployment-container-image-name fasthacks/sqlapi:1.0
az webapp config appsettings set -n $app_name_api -g $rg --settings "WEBSITES_PORT=8080" "SQL_SERVER_USERNAME=$sql_username" "SQL_SERVER_PASSWORD=$sql_password" "SQL_SERVER_FQDN=${sql_server_fqdn}"
az webapp restart -n $app_name_api -g $rg
app_url_api=$(az webapp show -n $app_name_api -g $rg --query defaultHostName -o tsv) && echo $app_url_api
```
