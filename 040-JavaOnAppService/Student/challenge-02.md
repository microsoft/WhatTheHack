# Challenge 2: Azure App Services &#10084;&#65039; Spring Boot

[< Previous Challenge](./challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./challenge-03.md)

## Introduction

So far we've been running the Spring Boot app locally, now it's time to run it on Azure.

## Description

Create a Web App running on an App Service instance and deploy the app. Choose a tier that allows autoscaling (will be introduced later).

## Success Criteria

1. Verify the application is working by creating a new owner, a new pet and a new visit through the new webapp
1. Connect to the database through a `mysql` client
1. Verify that the tables include the newly created entities (owner/pet/visit)
1. No files should be modified for this challenge

## Tips

It's possible to deploy a jar file to App Service through [Maven](https://docs.microsoft.com/en-us/azure/app-service/quickstart-java?tabs=javase&pivots=platform-linux#configure-the-maven-plugin), but that would require you to change the pom file. An alternative is the [ZIP deployment](https://docs.microsoft.com/en-us/azure/app-service/deploy-zip).

## Learning Resources

- [Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/)
- [Azure CLI for web apps](https://docs.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest)
- [Azure App Service ZIP deployment](https://docs.microsoft.com/en-us/azure/app-service/deploy-zip)
- [Azure App Service Maven deployment](https://docs.microsoft.com/en-us/azure/app-service/quickstart-java?tabs=javase&pivots=platform-linux#configure-the-maven-plugin)

[Next Challenge - Keep your secrets safe >](./challenge-03.md)
