# Challenge 3 - Do you know what’s going on in your application?

[< Previous Challenge](./challenge-02.md) - **[Home](../README.md)** - [Next Challenge>](./challenge-04.md)


## Introduction 

Now things are running on Azure, how can we keep an eye on what's going on? And what about the logs?

## Description

Create an App Service instance and deploy the app. Make sure that credentials are in a KeyVault and app settings don’t contain any credentials/keys in cleartext.

## Success Criteria

1. Verify functionality by creating a new owner, a new pet and a new visit through the new webapp
1. Verify that app insights is collecting metrics and logs
1. No file needs to be changed for this challenge


## Learning Resources

- https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview
- https://docs.microsoft.com/en-us/azure/azure-monitor/app/java-in-process-agent

[Next Challenge - Hello microservices!](./challenge-04.md)