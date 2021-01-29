# Challenge 0: Pre-requisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./01-assessment.md)

## Introduction

It's time to set up what you will need in order to do these challenges for OSS DB migration

## Description

In this challenge you'll be setting up your environment so that you can complete your challenges.

- Make sure that you have joined the Microsoft Teams group for this track. The first person on your team at your table should create a new channel in this Team with your team name.

- Install the recommended toolset:
    - Azure Data Studio or pgAdmin
    - MySQL Workbench
    - Visual Studio Code (optional)

- Within Azure Cloud Shell, download the required resources for this hack. The location will be given to you by your coach. You should do this in Azure Cloud Shell or in an Mac/Linux/WSL environment which has the Azure CLI installed. Run this command to setup the environment:

```bash
cd Resources/EnvironmentSetUp/ARM-Templates/KubernetesCluster

./create-cluster.sh

```

*Note: this will take several minutes*

Go to this file to see the instructions to install PostgreSQL, MySQL and the ContosoPizza application: [README](Resources/EnvironmentSetUp/HelmCharts/README.md)


## Success Criteria

1. You have a bash shell at your disposal for setting up the Pizzeria application (e.g. Azure Cloud Shell, WSL2, etc.)
1. Visual Studio Code is installed.
1. You have database management tools installed
1. You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working

## References

* pgAdmin: https://www.pgadmin.org/
* MySQL Workbench: https://www.mysql.com/products/workbench/
* Azure Data Studio: https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15
* Visual Studio Code: https://code.visualstudio.com/

