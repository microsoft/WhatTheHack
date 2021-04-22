# Challenge 0: Pre-requisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./01-assessment.md)

## Introduction

It's time to set up what you will need in order to do these challenges for OSS DB migration

## Description

In this challenge you'll be setting up your environment so that you can complete your challenges.

- Install the recommended toolset:
    - To connect to PostgreSQL database, use [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio) or [pgAdmin](https://www.pgadmin.org/)
    - [MySQL Workbench](https://www.mysql.com/products/workbench/) (note: if you get an error about not having the Visual Studio C++ 2019 Redistributable on your machine when installing, refer to this [note](https://support.microsoft.com/en-us/topic/the-latest-supported-visual-c-downloads-2647da03-1eea-4433-9aff-95f26a218cc0)
    - Another option is to use a single tool for both MySQL and PostgreSQL - like [dbeaver](https://dbeaver.io/download/). 
    - Visual Studio Code (optional)

- Within Azure Cloud Shell, download the required resources for this hack. The location will be given to you by your coach. You should do this in Azure Cloud Shell or in an Mac/Linux/WSL environment which has the Azure CLI installed. Run this command to setup the environment:

```bash
cd ~/Resources/ARM-Templates/KubernetesCluster
chmod +x ./create-cluster.sh
./create-cluster.sh

```

#### NOTE: creating the cluster will take several minutes

- Now you will deploy the Pizzeria application and its associated PostgreSQL and MySQL databases

```bash
cd ~/Resources/HelmCharts/ContosoPizza
chmod +x ./*.sh
./deploy-pizza.sh

```
#### NOTE: deploying the Pizzeria application will take several minutes

- Optional but highly recommended - run the shell script in the files given to you for this hack at this path:
`HelmCharts/ContosoPizza/update_nsg_for_postgres_mysql.sh`
This will block public access to your on-premise databases. You should run this on your local machine (not Azure Cloud Shell). You will need the Azure CLI to do that. 
- Please refer to the [AKS cheatsheet](./K8s_cheetsheet.md) for a reference of running handy AKS commands to validate your environment. You will need this throughout the hack.


## Success Criteria

* You have a Unix shell at your disposal for setting up the Pizzeria application (e.g. Azure Cloud Shell, WSL2 bash, Mac zsh etc.)
* You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working
* You have database management tools installed and are able to connect to the Postgres and MySQL databases for the Pizzeria app

## References

* [pgAdmin](https://www.pgadmin.org)
* [MySQL Workbench](https://www.mysql.com/products/workbench/)
* [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15)
* [Visual Studio Code](https://code.visualstudio.com/) (optional)

