# Challenge 5: Online Cutover and Validation

[< Previous Challenge](./04-online-migration.md) - **[Home](../README.md)** - [Next Challenge >](./06-private-endpoint.md)


## Introduction
 Reconfigure the application to use the appropriate connection string and validate that the application is working

## Description
You will initiate a database cutover in Azure DMS
You will reconfigure the application to use a connection string that points to the Azure DB for PostgreSQL/MySQL. You will need to update the ContosoPizza/values-mysql.yaml or ContosoPizza/values-postgresql.yaml values file with the updated values for dataSourceURL, dataSourceUser and dataSourcePassword using the appropriate Azure DB values for PostgreSQL/MySQL:

```yaml
appConfig:
  dataSourceURL: "jdbc url goes here" # your JDBC connection string goes here
  dataSourceUser: "user name goes here" # your database username goes here
  dataSourcePassword: "Password goes here!" # your database password goes here
```
Once you make your changes, you will need to run helm upgrade command again to see them in the Pizzeria web application:

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

* You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working with the configuration change
* You can update the value of column  "name" in table "ingredient" for any row. Change the name from "Onion" to "Shallot" and on the app, click on 
start building any pizza, and on the next page, click "Veggies" and at the lower left corner, see that "Shallot" appears with the picture of the onion.

