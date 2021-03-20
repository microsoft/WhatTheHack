# Challenge 0: Pre-requisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./01-assessment.md)

## Introduction

It's time to set up what you will need in order to do these challenges for OSS DB migration

## Description

In this challenge you'll be setting up your environment so that you can complete your challenges.

- Make sure that you have joined the Microsoft Teams group for this track. The first person on your team at your table should create a new channel in this Team with your team name.

- Install the recommended toolset:
    - To connect to Postgres database, [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio) or [pgAdmin](https://www.pgadmin.org/)
    - [MySQL Workbench](https://www.mysql.com/products/workbench/) (note: if you get an error about not having the Visual Studio C++ 2019 Redistributable on your machine when installing, refer to this [note](https://support.microsoft.com/en-us/topic/the-latest-supported-visual-c-downloads-2647da03-1eea-4433-9aff-95f26a218cc0)
    - Another option is to use a single tool for both mysql and postgres - like [dbeaver](https://dbeaver.io/download/). 
    - Visual Studio Code (optional)

- Within Azure Cloud Shell, download the required resources for this hack. The location will be given to you by your coach. You should do this in Azure Cloud Shell or in an Mac/Linux/WSL environment which has the Azure CLI installed. Run this command to setup the environment:

```bash
cd Resources/ARM-Templates/KubernetesCluster
chmod +x ./create-cluster.sh
sh ./create-cluster.sh

```

*Note: creating the cluster will take several minutes*

- Next, go to this file to see the [instructions](Resources/HelmCharts/README.md) to **install PostgreSQL, MySQL and the ContosoPizza on-premise application on Azure AKS**
- Optional but highly recommended - run this [shell script](./Update_nsg_for_postgres_mysql.sh) to block public access to your on-premise databases.
- Please refer to the [AKS cheatsheet](./K8s_cheetsheet.md) for reference of running handy aks commands to validate your environment. You may need this throughout the hack.


## Success Criteria

* You have a bash shell at your disposal for setting up the Pizzeria application (e.g. Azure Cloud Shell, WSL2, etc.)
* You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working
* You have database management tools installed and are able to connect to the Postgres and MySQL databases for the Pizzeria app
* You can update the value of column  "name" in table "ingredients" for any row with your favorite pizza flavor and it shows up on the webapp. 

## References

* pgAdmin: https://www.pgadmin.org/
* MySQL Workbench: https://www.mysql.com/products/workbench/
* Azure Data Studio: https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15
* Visual Studio Code: https://code.visualstudio.com/

