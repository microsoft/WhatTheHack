# Challenge 4: Offline Cutover and Validation

[< Previous Challenge](./03-offline-migration.md) - **[Home](../README.md)** - [Next Challenge >](./05-online-migration.md)

## Introduction
 Reconfigure the application to use the appropriate connection string and validate that the application is working

## Description
You will reconfigure the application to use a connection string that points to the Azure DB for PostgreSQL/MySQL. You will need to update the ContosoPizza/values-mysql.yaml or ContosoPizza/values-postgresql.yaml values file with the updated values for dataSourceURL, dataSourceUser and dataSourcePassword using the appropriate Azure DB values for PostgreSQL/MySQL:

```yaml
appConfig:
  dataSourceURL: "jdbc url goes here" # your JDBC connection string goes here
  dataSourceUser: "user name goes here" # your database username goes here
  dataSourcePassword: "Password goes here!" # your database password goes here
```
Once you make your changes, you will need to run helm upgrade command to see the changes reflected:

```bash

helm upgrade --install mysql-contosopizza ./ContosoPizza -f ./ContosoPizza/values.yaml -f ./ContosoPizza/values-mysql.yaml

```

To deploy the app backed by PostgreSQL, run the following command after you have edited the values file to match your desired database type:

```bash

helm upgrade --install postgres-contosopizza ./ContosoPizza -f ./ContosoPizza/values.yaml -f ./ContosoPizza/values-postgresql.yaml

```

## Success Criteria

* You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working with the configuration change
* You can update the value of column  "name" in table "ingredients" for any row. e.g. Change the name from "Onion" to your name and on the app, click on 
start building any pizza, and on the next page, click "Veggies" and at the lower left corner, see that your name appears with the picture of oni


