# Challenge 4: Offline Cutover and Validation

[< Previous Challenge](./03-offline-migration.md) - **[Home](../README.md)** - [Next Challenge >](./05-online-migration.md)

## Introduction
 Reconfigure the application to use the appropriate connection string and validate that the application is working 

## Description
You will reconfigure the application to use a connection string that points to the Azure DB for PostgreSQL/MySQL. You will need to update the ContosoPizza/values.yaml file with the updated values for dataSourceURL, dataSourceUser and dataSourcePassword using the appropriate Azure DB values for PostgreSQL/MySQL:
```yaml
appConfig:
  ...
  dataSourceURL: "jdbc url goes here" # your JDBC connection string goes here
  dataSourceUser: "user name goes here" # your database username goes here
  dataSourcePassword: "Pass word goes here!" # your database password goes here
  ...
```
Once you make your changes, you will need to run a helm upgrade command to see the changes reflected:
```shell

helm upgrade --install mysql-contosopizza ./ContosoPizza --set appConfig.databaseType=mysql --set infrastructure.namespace=contosoappmysql

```

To deploy the app backed by PostgreSQL, run the following command after you have edited the values file to match your desired database type

```shell

helm upgrade --install postgres-contosopizza ./ContosoPizza --set appConfig.databaseType=postgres --set infrastructure.namespace=contosoapppostgres

```

## Success Criteria

* You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working with the configuration change. You can do this by registering yourself as a user in the application. You would then connect to the Azure DB for PostgreSQL/MySQL and do a 'select * from users' to see if the new user is in the database(s) 
