# Challenge 02 - Migrating from MongoDB to Azure Document DB

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Prerequisites 

Make sure you have successfully completed Challenges 0 and 1 before starting this challenge. 

## Introduction

In this challenge you will use the Azure DocumentDB Migration extension in Visual Studio Code to migrate the data from source database to Azure DocumentDB. 

## Description
If you were able to successfully connect to your local MongoDB source database in Challenge 1, you should be ready to get started!

- Right click on your source database and select `Data migration`. For the data migration provider, select `Migration to Azure Document DB`
- Put in a Job Name of your choice. For Migration Mode, select `Offline` and for Connectivity, select `Public`
- For the target Azure DocumentDB account
    - Subscription: Use the default subscription
    - Resource Group: Select the resource group where you deployed Azure DocumentDB (default is rg-mflix-documentdb)
    - Account Name: Select the account name
    - Connection String: You will have to retrieve this from the Azure Portal. Open your Azure DocumentDB instance. It should be under Settings/Connection Strings. Replace the password with the password you chose when you ran the `deploy-target-db.sh` script. 
- Create the Database Migration Service. You can use the existing resource group for your Azure DocumentDB. 
- You may have to update firewall rules for Azure DocumentDB accordingly. 
- Select all of the collections in your `sample_flix` database.
- Start Migration

If the migration was successful, you will then need to update the connection string in your `.env` file to the one for Azure DocumentDB. Once you do that, you will need to stop the MFlix application (hint: `CTRL+C` in the terminal window where the app is running) and restart it (hint: `npm start`). Open the browser with `http://localhost:5001` to see if it's working. 

## Success Criteria

To complete this challenge successfully, you should be able to:
- Ensure that the data migration completed successfully 
- Update the app's database connection string to point to the new Azure DocumentDB 
- Verify that the application is working correctly with the new Azure DocumentDB

## Learning Resources


- [Migrate MongoDB to Azure DocumentDB online using Azure DocumentDB migration extension (public preview)](https://learn.microsoft.com/en-us/azure/documentdb/how-to-migrate-vs-code-extension)


