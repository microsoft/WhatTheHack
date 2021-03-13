# Challenge 2 - Azure App Services <3 Spring Boot

[< Previous Challenge](./challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./challenge-03.md)


## Introduction 

So far we've been running the Spring Boot app locally, now it's time to run it on Azure.

## Description

Create an App Service instance and deploy the app. Make sure that credentials are in a KeyVault and app settings don’t contain any credentials/keys in cleartext.

## Success Criteria

1. Verify functionality by creating a new owner, a new pet and a new visit through the new webapp
1. Verify that app settings don't include any sensitive values
1. Connect to the database through cloud shell 
1. Verify that the tables include the newly created entities (owner/pet/visit) 
1. No file needs to be changed for this challenge


## Learning Resources

- https://docs.microsoft.com/en-us/azure/app-service/
- https://docs.microsoft.com/en-us/azure/key-vault/general/overview

[Next Challenge - Do you know what’s going on in your application? >](./challenge-03.md)