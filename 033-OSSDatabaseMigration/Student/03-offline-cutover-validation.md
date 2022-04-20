# Challenge 3: Offline Cutover and Validation

[< Previous Challenge](./02-offline-migration.md) - **[Home](../README.md)** - [Next Challenge >](./04-online-migration.md)

## Introduction
 Reconfigure the application to use the appropriate connection string that uses Azure DB and validate that the application is working. You have to do this by redeploying the Pizzeria container application(s). 

## Description
You will reconfigure the application to use a connection string that points to the Azure DB for PostgreSQL/MySQL. You will need to update the `ContosoPizza/values-mysql.yaml`, `ContosoPizza/values-postgresql.yaml` and/or `ContosoPizza/values-oracle.yaml` values file(s) with the updated values for dataSourceURL, dataSourceUser and dataSourcePassword using the appropriate values for Azure DB for PostgreSQL/MySQL:

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

* Oracle:

You will need to change the database type in the `values-oracle.yaml` file from "oracle" to "postgres" before you run these steps. 

```bash

helm upgrade --install oracle-contosopizza ./ContosoPizza -f ./ContosoPizza/values.yaml -f ./ContosoPizza/values-oracle.yaml
kubectl -n contosoapporacle rollout restart deployment contosopizza
```

Wait for a minute or two until the status field for the command of kubectl is  "Running" and "READY" state is "1/1".

Status field changes from "Terminating" to "ContainerCreating" and then to "Running".

```bash

 kubectl -n contosoapporacle get pods

```
## Success Criteria

* You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working with the configuration change
* You can update the value of column  "name" in table "ingredient" for any row. Change the name from "Onion" to "Shallot" and on the app, click on 
start building any pizza, and on the next page, click "Veggies" and at the lower left corner, see that "Shallot" appears with the picture of the onion.

## Hints
* If your application is not working, you may need to check the pod deployment and logs to see what is happening:

```bash

 kubectl -n contosoapporacle get pods

```

If you see a CrashLoopBackoff, you can then do this to get more information:

```bash

 kubectl -n contosoapporacle describe pod <name of the pod>

```

and also

```bash

 kubectl -n contosoapporacle logs <name of the pod>

```
You may find it helpful to send the output of the above logs command to a file so you can grep it or use an editor to search it. Your problem may be identified by "Error" or "Exception".

* If you find an error in the JDBC connection string, you will have to repeat the steps to do a helm upgrade/kubectl rollout restart steps above for the application. 

## References

* [How to connect applications to Azure Database for MySQL](https://docs.microsoft.com/en-us/azure/mysql/howto-connection-string)
