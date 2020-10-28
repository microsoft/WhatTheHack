
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

## Deploying the Application

```shell

cd 027-OSS-Database-Migration/Coach/Resources/EnvironmentSetUp/HelmCharts

helm upgrade --install wth-contosopizza ./ContosoPizza


```