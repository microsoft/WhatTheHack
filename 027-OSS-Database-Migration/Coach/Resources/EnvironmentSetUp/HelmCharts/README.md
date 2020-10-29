## Setting up Kubernetes

First we need to navigate to the ARM templates folder in the Coaches Resource folder to provision the AKS cluster

The steps to deploy the AKS cluster, scale it up and scale it down are available in the README files for that section

## PostgreSQL Setup on Kubernetes

These instructions provide guidance on how to setup PostgreSQL 11 on AKS

This requires Helm3 and the latest version of Azure CLI to be installed

## Installing the PostgreSQL Database

```shell

# Clone the Git Repository
git clone WhatTheHackGitURL

# Get into the WhatTheHack repo
cd WhatTheHack

# Navigate to the Helm Charts
cd 027-OSS-Database-Migration/Coach/Resources/EnvironmentSetUp/HelmCharts

# Install the Kubernetes Resources
helm upgrade --install wth-postgresql ./PostgreSQL116 --set infrastructure.password=OCPHack8

```

## Checking the Service IP Addresses and Ports

```shell

kubectl -n postgresql get svc

```

## Checking the Pod for Postgresl

```shell

kubectl -n postgresql get pods

```

## Getting into the Container

```shell

# Use this to connect to the database server
kubectl -n postgresql exec deploy/postgres -it -- bash

# Use this to login to the service
psql -U postgres

# Check the DB Version
SELECT version();

# Show databases
\l

# Set default database
\c databasename

# Show tables in database
\dt

```

## Uninstalling the PostgreSQL from Kubernetes

Use this to uninstall the PostgreSQL 11 instance from Kubernetes cluster

```shell

# Use this to connect to the database server
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

## Checking the Pod for Postgresl

```shell

kubectl -n mysqlwth get pods

```

## Getting into the Container

```shell

# Use this to connect to the database server
kubectl -n mysqlwth exec deploy/mysql -it -- bash

# Use this to login to the service
mysql -u root -pOCPHack8

# Check the DB Version
SELECT version();

# Show databases
SHOW DATABASES;

# Set default database
USE ocpwth

# Show tables in database

SHOW TABLES;

```

## Deploying the Web Application

First we navigate to the Helm charts directory

```shell

cd 027-OSS-Database-Migration/Coach/Resources/EnvironmentSetUp/HelmCharts


```

We can deploy in two ways

* Backed by MySQL Database
* Backed by PostgreSQL Database

In the ContosoPizza/values.yaml file we can specify the database Type (appConfig.databaseType) as "mysql" or postgres" and then we can set the JDBC URL, username and password under the appConfig object

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

After the apps have booted up, you can find out their service addresses and ports as well as their status as follows

```shell

# get service ports and IP addresses
kubectl -n {infrastructure.namespace goes here} get svc

# get service pods running the app
kubectl -n {infrastructure.namespace goes here} get pods

# view the first 5k lines of the application logs
kubectl -n {infrastructure.namespace goes here} logs deploy/contosopizza --tail=5000

# example for ports and services
kubectl -n contosoappmysql get svc

```

To deploy the app backed by MySQL, run the following command after you have edited the values file to match your desired database type

```shell

helm upgrade --install mysql-contosopizza ./ContosoPizza --set appConfig.databaseType=mysql --set infrastructure.namespace=contosoappmysql

```

To deploy the app backed by PostgreSQL, run the following command after you have edited the values file to match your desired database type

```shell

helm upgrade --install postgres-contosopizza ./ContosoPizza --set appConfig.databaseType=postgres --set infrastructure.namespace=contosoapppostgres

```