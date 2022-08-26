# Challenge 05 - Azure Monitor for Containers

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

In this challenge we will learn more about Container Monitoring and how it works

## Description

- Deploy the eShoponWeb application to a local container and make sure it is running
- Deploy the eShoponWeb application to an AKS cluster and make sure it is running

From your Visual Studio Server, deploy the eShoponWeb application to AKS
- Update DB connection strings to use IP addresses instead of hostnames
- Add Docker Support to your app in VS (requires Docker Desktop to be installed)
- Create an Azure Container Registry
- Publish eshop on web app to your Container Registry
- Update DB dependencies using connection strings
- Update App Insights dependency using instrumentation key
- Update and use the provided deployment and service YAML files to deploy app to AKS
- From Azure Monitor, view the CPU and memory usage of the containers running the eShoponWeb application
- Generate and view an exception in the eShoponWeb application (Hint: Try to change your password)

## Success Criteria
- Generate an exception and show it in the container logs
- Are you also able to see the exception in Application Insights?
- Can you see the container insights live logs?

## Learning Resources
- [Download and install Docker](https://docs.docker.com/desktop/#download-and-install) 
- [Azure Container Monitoring](https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview)
- [How to set up the Live Data feature](https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-livedata-setup)