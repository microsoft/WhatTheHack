# Challenge 2 - Azure App Services :heart: Spring Boot

[< Previous Challenge](./challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./challenge-03.md)

## Introduction

So far we've been running the Spring Boot app locally, now it's time to run it on Azure.

## Description

Create an App Service instance and deploy the app.

## Success Criteria

1. Verify the application is working by creating a new owner, a new pet and a new visit through the new webapp
1. Connect to the database through a `mysql` client
1. Verify that the tables include the newly created entities (owner/pet/visit)
1. No files should be modified for this challenge

## Learning Resources

- [Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/)

## Tips

It's possible to deploy a jar file to App Service through [Maven](https://docs.microsoft.com/en-us/azure/app-service/quickstart-java?tabs=javase&pivots=platform-linux#configure-the-maven-plugin), but that would require you to change the pom file. An alternative is the [ZIP deployment](https://docs.microsoft.com/en-us/azure/app-service/deploy-zip).

[Next Challenge - Do you know what’s going on in your application? >](./challenge-03.md)
