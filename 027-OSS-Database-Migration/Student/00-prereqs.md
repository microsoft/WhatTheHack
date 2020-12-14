# Challenge 0: Pre-requisites - Ready, Set, GO! 

**[Home](../README.md)** - [Next Challenge >](./01-assessment.md)

## Introduction

It's time to set up what you will need in order to do these challenges for OSS DB migration 

## Description

In this challenge you'll be setting up your environment so that you can complete your challenges.

- Make sure that you have joined the Microsoft Teams group for this track. The first person on your team at your table should create a new channel in this Team with your team name.

- Install the recommended toolset:
    - Azure Data Studio
    - MySQL Workbench
    - pgAdmin
    - Visual Studio Code (optional)

- Within Azure Cloud Shell, clone the GIT repository at https://github.com/izzymsft/WhatTheHack-1 and run this command to setup the environment: 
    create-cluster.sh

    This will take several minutes

Go to this file to see the instructions to install PostgreSQL, MySQL and the ContosoPizza application: [README](../Coach/Resources/EnvironmentSetUp/HelmCharts/README.md) 

- Determine the external IP address for the Pizzeria application you installed and validate the applications are working properly by opening a web browser to http://<Your External IP Address>:8081/pizzeria/ and http://<Your External IP address>:8082/pizzeria/
    hint: figure out how to use kubectl to list the services on the AKS cluster

## Success Criteria

1. You have a bash shell at your disposal for setting up the Pizzeria application (Azure Cloud Shell)
1. Visual Studio Code is installed.
1. You have database management tools installed
1. You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working

## References

PostgreSQL Tools: https://www.pgadmin.org/
MySQL Workbench: https://www.mysql.com/products/workbench/
Azure Data Studio: https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15
Visual Studio Code: https://code.visualstudio.com/

