## Setting up Kubernetes

First we need to navigate to the ARM templates folder in the Coaches Resource folder to provision the AKS cluster

The steps to deploy the AKS cluster, scale it up and scale it down are available in the README files for that section

## PostgreSQL Setup on Kubernetes

These instructions provide guidance on how to setup PostgreSQL 11 on AKS

This requires Helm3 and the latest version of Azure CLI to be installed

## Installing the PostgreSQL Database

```shell

# Clone the Git Repository
#git clone WhatTheHackGitURL

# Get into the WhatTheHack repo
#cd WhatTheHack

# Navigate to the Helm Charts
#cd 027-OSS-Database-Migration/Coach/Resources/EnvironmentSetUp/HelmCharts

# Install the Kubernetes Resources
helm upgrade --install wth-postgresql ./PostgreSQL116 --set infrastructure.password=OCPHack8

```

## Checking the Service IP Addresses and Ports

```shell

kubectl -n postgresql get svc

```
**Important: you will need to copy the postgres-internal Cluster-IP value to use for the dataSourceURL later in these steps**

## Checking the Pod for Postgres

```shell

kubectl -n postgresql get pods

```

## Getting into the Container

```shell

# Use this to connect to the database server
kubectl -n postgresql exec deploy/postgres -it -- bash

# Use this to login to the service

psql -U postgres
```
Run the following commands to check the Postgres Version and create the WTH database (warning: application deployment will fail if you don't do this)

```sql

--Check the DB Version
SELECT version();

--Create the wth database
CREATE DATABASE wth;

--List databases. notice that there is a database called wth
\l

-- Set default database to wth
\c wth

```

## Uninstalling the PostgreSQL from Kubernetes (only if you need to cleanup and try the helm deployment again)

Use this to uninstall the PostgreSQL 11 instance from Kubernetes cluster

```shell

# Uninstall to the database server. To install again, run helm upgrade
helm uninstall wth-postgresql

```



## Installing MySQL

```shell

# Install the Kubernetes Resources
helm upgrade --install wth-mysql ./MySQL57 --set infrastructure.password=OCPHack8

```

## Checking the Service IP Addresses and Ports

```shell

kubectl -n mysqlwth get svc

```
**Important: you will need to copy the mysql-internal Cluster-IP value to use for the dataSourceURL later in these steps**

## Checking the Pod for MySQL

```shell

kubectl -n mysqlwth get pods

```

## Getting into the Container

```shell

# Use this to connect to the database server
kubectl -n mysqlwth exec deploy/mysql -it -- bash

# Use this to login to the service
mysql -u root -pOCPHack8
```
Run the following commands to check the MySQL Version and create the WTH database (warning: application deployment will fail if you don't do this)
```sql

-- Check the mysql DB Version
SELECT version();

-- List databases
SHOW DATABASES;

--Create wth database
CREATE DATABASE wth;

-- Set default database to wth
USE wth

-- Show tables in wth database

SHOW TABLES;

```

## Uninstalling the MySQL from Kubernetes (only if you need to cleanup and try the helm deployment again)

Use this to uninstall the MySQL instance from Kubernetes cluster

```shell

# Uninstall to the database server. To install again, run helm upgrade command previously executed
helm uninstall wth-mysql

```

## Deploying the Web Application

First we navigate to the Helm charts directory

```shell

cd 027-OSS-Database-Migration/Coach/Resources/EnvironmentSetUp/HelmCharts


```

We can deploy in two ways

* Backed by MySQL Database
* Backed by PostgreSQL Database

For the MySQL database setup, the developer/operator can make changes to the values-mysql.yaml file.

For the PostgreSQL database setup, the developer/operator can make changes to the values-postgresql.yaml file.

In the yaml files we can specify the database Type (appConfig.databaseType) as "mysql" or postgres" and then we can set the JDBC URL, username and password under the appConfig objects.

In the globalConfig object we can change the merchant id, public keys and other values as needed but you generally can leave those alone as they apply to both MySQL and PostgreSL deployment options

```yaml
appConfig:
  databaseType: "databaseType goes here" # mysql or postgres
  dataSourceURL: "jdbc url goes here" # your JDBC connection string goes here
  dataSourceUser: "user name goes here" # your database username goes here
  dataSourcePassword: "Pass word goes here!" # your database password goes here
  webPort: 8081 # the port the app listens on
  webContext: "pizzeria" # the application context http://hostname:port/webContext
```

The developer or operator can specify the '--values'/'-f' flag multiple times.
When more than one values file is specified, priority will be given to the last (right-most) file specified in the sequence.
For example, if both values.yaml and override.yaml contained a key called 'namespace', the value set in override.yaml would take precedence.

The commands below allows us to use settings from the values file and then override certain values in the database specific values file.

```shell

helm upgrade --install release-name ./HelmChartFolder -f values.yaml -f override.yaml

```

To deploy the app backed by MySQL, run the following command after you have edited the values file to match your desired database type

```shell

helm upgrade --install mysql-contosopizza ./ContosoPizza -f values.yaml -f values-mysql.yaml

```

To deploy the app backed by PostgreSQL, run the following command after you have edited the values file to match your desired database type

```shell

helm upgrade --install postgres-contosopizza ./ContosoPizza -f values.yaml -f values-postgresql.yaml

```

If you wish to uninstall the app, you can use one of the following commands:

```shell

# Use this to uninstall, if you are using MySQL as the database
helm uninstall mysql-contosopizza

# Use this to uninstall, if you are using PostgreSQL as the database
helm uninstall postgres-contosopizza

```


After the apps have booted up, you can find out their service addresses and ports as well as their status as follows

```shell

# get service ports and IP addresses
kubectl -n {infrastructure.namespace goes here} get svc

# get service pods running the app
kubectl -n {infrastructure.namespace goes here} get pods

# view the first 5k lines of the application logs
kubectl -n {infrastructure.namespace goes here} logs deploy/contosopizza --tail=5000

# example for ports and services
kubectl -n {infrastructure.namespace goes here} get svc

```

Verify that contoso pizza application is running on AKS

```shell

# Insert the external IP address of the command <kubectl -n contosoappmysql or contosoapppostgres get svc below>

http://{external_ip_contoso_app}:8081/pizzeria/
```
