# Challenge 7: Private Endpoint

[< Previous Challenge](./06-online-cutover-validation.md) - **[Home](../README.md)**  - [Next Challenge >](./08-replication.md)


## Introduction
Up to this point you have been using a public IP address for Azure DB for PostgreSQL/MySQL for your Pizzeria application. From a security perspective a preferred approach would be to use a private endpoint which will expose Azure DB for PostgreSQL/MySQL using a private IP address from within the application's virtual network.

## Description
You will add a private endpoint for Azure DB for PostgreSQL/MySQL
You will reconfigure the application to use a connection string that points to the private IP address for Azure DB for PostgreSQL/MySQL. You will need to update the ContosoPizza/values-mysql.yaml or ContosoPizza/values-postgresql.yaml values file with the updated values for dataSourceURL, dataSourceUser and dataSourcePassword using the appropriate Azure DB values for PostgreSQL/MySQL:

```yaml
appConfig:
  dataSourceURL: "jdbc url goes here" # your JDBC connection string goes here
```
Once you make your changes, you will need to run a helm upgrade command to see the changes reflected:

```bash

helm upgrade --install mysql-contosopizza ./ContosoPizza -f ./ContosoPizza/values.yaml -f ./ContosoPizza/values-mysql.yaml

```

To deploy the app backed by PostgreSQL, run the following command after you have edited the values file to match your desired database type

```bash

helm upgrade --install postgres-contosopizza ./ContosoPizza -f ./ContosoPizza/values.yaml -f ./ContosoPizza/values-postgresql.yaml

```

## Success Criteria

* You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working with the configuration change for the private endpoint.

## References
* [Private Link for Azure Database for PostgreSQL-Single server](https://docs.microsoft.com/en-us/azure/postgresql/concepts-data-access-and-security-private-link)
* [Private Link for Azure Database for MySQL using Portal](https://docs.microsoft.com/en-us/azure/mysql/howto-configure-privatelink-portal)

