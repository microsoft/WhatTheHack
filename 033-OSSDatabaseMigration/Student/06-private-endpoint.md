# Challenge 6: Private Endpoint

[< Previous Challenge](./05-online-cutover-validation.md) - **[Home](../README.md)**  - [Next Challenge >](./07-replication.md)


## Introduction
Up to this point you have been using a public IP address for Azure DB for PostgreSQL/MySQL for your Pizzeria application. From a security perspective a preferred approach would be to use a private endpoint which will expose Azure DB for PostgreSQL/MySQL using a private IP address from within the application's virtual network. This is available for Azure DB for PostgreSQL/MySQL Single Server only. Azure DB for PostgreSQL/MySQL Flexible Server supports VNET integration instead; you can only specify VNET integration for Flexible Server at deployment time. 

## Description
You will add a private endpoint for Azure DB for PostgreSQL/MySQL Single Server
You will reconfigure the application to use a connection string that points to the private IP address for Azure DB for PostgreSQL/MySQL Single Server. You will need to update the `ContosoPizza/values-mysql.yaml` or `ContosoPizza/values-postgresql.yaml` values file with the updated values for dataSourceURL, dataSourceUser and dataSourcePassword using the appropriate Azure DB values for PostgreSQL/MySQL:

```yaml
appConfig:
  dataSourceURL: "jdbc url goes here" # your JDBC connection string goes here
```
Once you make your changes, you will need to run a helm upgrade command to see the changes reflected:

* For MySQL:

```bash

helm upgrade --install mysql-contosopizza ./ContosoPizza -f ./ContosoPizza/values.yaml -f ./ContosoPizza/values-mysql.yaml
kubectl -n contosoappmysql rollout restart deployment contosopizza
```

Wait for a minute or two until the status field for the kubectl command below is  "Running" and "READY" state is "1/1".

Status field changes from "Terminating" to "ContainerCreating" and then to "Running".

```bash

 kubectl -n contosoappmysql get pods

```

* PostgreSQL:

```bash

helm upgrade --install postgres-contosopizza ./ContosoPizza -f ./ContosoPizza/values.yaml -f ./ContosoPizza/values-postgresql.yaml
kubectl -n contosoapppostgres rollout restart deployment contosopizza
```


Wait for a minute or two until the status field for the command of kubectl is  "Running" and "READY" state is "1/1".

Status field changes from "Terminating" to "ContainerCreating" and then to "Running".

```bash

 kubectl -n contosoapppostgres get pods

```

## Success Criteria

* You have validated that the Pizzeria application (PostgreSQL/MySQL) are working with the configuration change for the private endpoint.

## References
* [Private Link for Azure Database for PostgreSQL-Single server](https://docs.microsoft.com/en-us/azure/postgresql/concepts-data-access-and-security-private-link)
* [Private Link for Azure Database for MySQL using Portal](https://docs.microsoft.com/en-us/azure/mysql/howto-configure-privatelink-portal)

