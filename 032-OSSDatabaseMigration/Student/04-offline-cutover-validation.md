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
Once you make your changes, you will need to run helm uninstall and helm upgrade commands to see the changes reflected:

```bash

# Use this to uninstall, if you are using MySQL as the database
helm uninstall mysql-contosopizza

helm upgrade --install mysql-contosopizza ./ContosoPizza -f ./ContosoPizza/values.yaml -f ./ContosoPizza/values-mysql.yaml

```

To deploy the app backed by PostgreSQL, run the following command after you have edited the values file to match your desired database type:

```bash

# Use this to uninstall, if you are using PostgreSQL as the database
helm uninstall postgres-contosopizza

helm upgrade --install postgres-contosopizza ./ContosoPizza -f ./ContosoPizza/values.yaml -f ./ContosoPizza/values-postgresql.yaml

```

## Success Criteria

* You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working with the configuration change. You can do this by registering yourself as a user in the application. You would then connect to the Azure DB for PostgreSQL/MySQL and do a 'select * from users' to see if the new user is in the database(s)
