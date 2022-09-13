# Challenge 5: Deploy the Website

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)**

## Introduction

In this challenge, we are deploying our web front end container into Azure App Services. This is an alternate method for running single containers that brings with it the ability for more robust features and deployment options.

## Description

- Using the Azure CLI, create a Standard Linux App Service Plan
- Using the Azure CLI, create a Web App and set the `microservicesdiscovery/travel-web` as the container image for the Web App
- The following Application Settings need to be added:
  - `DataAccountName`: Name of the Cosmos DB Account
  - `DataAccountPassword`: Primary Key of the Cosmos DB Account
  - `ApplicationInsights__InstrumentationKey`:  Instrumentation Key of the App Insights Resource
  - `DataServiceUrl`: The URL to the Data Service, only over HTTP
  - `ItineraryServiceUrl`: The URL to the Itinerary Service, only over HTTP
- Verify that you can browse to the URL of the App Service and get the website to display.

## Success Criteria

1. You have deployed the web front end container into a Linux App Service Web App.
1. You have verified that the web app's URL loads and shows our app.

## Learning Resources

- [App Services](https://docs.microsoft.com/en-us/azure/app-service/)
- [App Service Plans](https://docs.microsoft.com/en-us/azure/app-service/overview-hosting-plans)
- [Running a custom container in a Linux App Service Web App](https://docs.microsoft.com/en-us/azure/app-service/containers/quickstart-docker)
