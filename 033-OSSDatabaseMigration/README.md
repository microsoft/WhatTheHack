# What The Hack - Intro To OSS DB Migration to Azure OSS DB
## Introduction
This intro level hackathon will help you get hands-on experience migrating databases from on-premises PostgreSQL, Oracle and/or MySQL to Azure DB for PostgreSQL and/or Azure DB for MySQL.

## Learning Objectives
In this hack you will solve a common challenge for companies migrating to the cloud: migrating databases such as PostgreSQL, Oracle and MySQL to Azure. The application using the database is a sample e-commerce [application](https://github.com/pzinsta/pizzeria) written in Java. It will be configured to use PostgreSQL, MySQL and/or Oracle. 

The participants will learn how to:

1. Perform a pre-migration assessment of the databases looking at size, database engine type, database version, etc.
1. Use offline tools to copy the databases to Azure OSS databases
1. Use the Azure Database Migration Service to perform an online migration (if applicable)
1. Do cutover and validation to ensure the application is working properly with the new configuration
1. Use a private endpoint for Azure OSS databases instead of a public IP address for the database
1. Configure a read replica for the Azure OSS databases

## Challenges
- Challenge 0: **[Pre-requisites - Setup Environment and Prerequisites!](Student/00-prereqs.md)**
   - Prepare your environment to run the sample application
- Challenge 1: **[Discovery and assessment](Student/01-discovery.md)**
   - Discover and assess the application's PostgreSQL/MySQL/Oracle databases
- Challenge 2: **[Offline migration](Student/02-offline-migration.md)**
   - Dump the "on-prem" databases (or use a tool like ora2pg), create databases for Azure DB for PostgreSQL/MySQL and restore them
- Challenge 3: **[Offline Cutover and Validation](Student/03-offline-cutover-validation.md)**
   - Reconfigure the application to use the appropriate connection string and validate that the application is working
- Challenge 4: **[Online Migration](Student/04-online-migration.md)**
   - Create new databases in Azure DB for PostgreSQL/MySQL and use the Azure Database Migration Service to replicate the data from the on-prem databases
- Challenge 5: **[Online Cutover and Validation](Student/05-online-cutover-validation.md)**
   - Reconfigure the application to use the appropriate connection string for Azure DB for PostgreSQL/MySQL
- Challenge 6: **[Private Endpoints](Student/06-private-endpoint.md)**
   - Reconfigure the application to use configure Azure DB for PostgreSQL/MySQL with a private endpoint so it can be used with a private IP address
- Challenge 7: **[Replication](Student/07-replication.md)**
   - Add an additional replica to the Azure DB for PostgreSQL/MySQL


## Prerequisites

- Access to an Azure subscription with Owner access
   - If you don't have one, [Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)
   - Familiarity with Azure Cloud Shell
- [**Visual Studio Code**](https://code.visualstudio.com/) (optional)

## Repository Contents
- `../Coach`
  - [Lecture presentation](Coach/OSS-DB-What-the-Hack-Lecture.pptx?raw=true) with short presentations to introduce each challenge
  - Example solutions and coach tips to the challenges (If you're a student, don't cheat yourself out of an education!)
- `../Student/Resources`
   - Pizzeria application environment setup

## Contributors
- Pete Rodriguez
- Israel Ekpo
- Mike Shelton
- Daniel Kondrasevich 
- Sumit Sengupta
- Peter Laudati
