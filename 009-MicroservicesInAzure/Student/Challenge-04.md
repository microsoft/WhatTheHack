# Challenge 4: Deploying to ACI

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

For our microservices based architecture, we're going to use containers for our microservices and deploy them using Azure Container Instances as the quickest way to get containers up and running in Azure. In this challenge you will be tasked with doing this and in the process will learn how quick and easy it is.

## Description

- There are three different containers you are going to deploy as Azure Container Instances
- Data API:  `microservicesdiscovery/travel-data-service`
- Itinerary API:  `microservicesdiscovery/travel-itinerary-service`
- DataLoader utility (to setup and seed Cosmos DB):  `microservicesdiscovery/travel-dataloader`
- All of these containers will need 3 environment variables defined:
  - `DataAccountName`: Name of the Cosmos DB Account
  - `DataAccountPassword`: Primary Key of the Cosmos DB Account
  - `ApplicationInsights__InstrumentationKey`:  Instrumentation Key of the App Insights Resource
- The Data API and Itinerary API containers, both need to specify a DNS Name, so they are easily addressable by the Web Site.
  - After you get the Data API deployed, use the Azure CLI to query the deployed container for its full qualified domain name (FQDN) and store it in a variable called:  
    - `dataServiceUri`
  - After you get the Itinerary API deployed, use the Azure CLI to query the deployed container for the FQDN and store it in a variable called:  
    - `itineraryServiceUri`
- Verify the Data Service by browsing the URL:  
  - `http://$dataServiceUri/api/airport`
  - It should return a list of Airports
- Verify the Itinerary Service by browsing the URL:  
  - `http://$itineraryServiceUri/api/itinerary/AAA`
  - It should return a 204.
- **NOTE:** It should return a 404, but to get a positive test response, it returns a 204 (which represents “no content”) to verify the service is up and running.
- After you get the DataLoader deployed, you can see what it actually did by viewing its logs.
  - Use the Azure CLI to print out the logs for the Data Loader container.
  - Try this with the other containers as well just for fun.

## Success Criteria

1. You have deployed the 3 containers into Azure Container Instances.
1. You have verified the Data Service end point URL.
1. You have verified the Itinerary Service end point URL.
1. You have successfully using the CLI to query the container logs.

## Learning Resources

- [Overview of Azure Container Instances](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview)
