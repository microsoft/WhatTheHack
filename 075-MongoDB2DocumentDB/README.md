# What The Hack - Mongo DB to Azure Document DB Migration

## Introduction

In this hack, you will learn how to move a MongoDB workload from MongoDB to Azure DocumentDB with minimal effort. You'll start by creating a MongoDB database from a sample and deploying a sample Node.js application. You will make sure it works as is. You will then perform a guided migration of that database to Azure using the Visual Studio Code extension for DocumentDB. Finally, you’ll understand the core migration flow, validate data in the new environment, fix an issues you might encounter, and run the app against the migrated database.



## Learning Objectives

- Assess source database readiness and identify key migration considerations before moving data.
- Use the DocumentDB VS Code extension to execute and monitor a database migration.
- Compare source and target results to verify collection structure, document counts, and query behavior.
- Update application configuration and troubleshoot common connectivity or compatibility issues after cutover.

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
	 - Deploy the source database and get the sample application up and running
- Challenge 01: **[Install the Azure DocumentDB migration extension for VS Code and Deploy Azure Document DB](Student/Challenge-01.md)**
	 - Install the Azure DocumentDB Migration extension in Visual Studio Code and deploy an instance of Azure DocumentDB in your Azure subscription.
- Challenge 02: **[Migrating from MongoDB to Azure Document DB](Student/Challenge-02.md)**
	 - Use the Azure DocumentDB Migration extension to migrate data from your source MongoDB to Azure DocumentDB, then update and test the application with the new connection.
	 - Compare the source target databases and if everything is okay, you will modify the application configuration with the new Azure DocumentDB and re-run the application

## Prerequisites

- Your own Azure subscription with Owner access
- Visual Studio Code
- Personal GitHub account

## Contributors

- [Pete Rodriguez](https://github.com/perktime)
- [Mike Shelton](https://github.com/mshelt)
- [Manish Sharma](https://github.com/manishmsfte)
