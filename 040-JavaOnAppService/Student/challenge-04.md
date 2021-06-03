# Challenge 4: Do you know what’s going on in your application?

[< Previous Challenge](./challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./challenge-05.md)

## Introduction

Now things are running on Azure, how can we keep an eye on what's going on? And what about the logs?

## Description

Create an Application Insights instance and connect the application running on the App Service to use that instance. Make sure that credentials are in a KeyVault and app settings don’t contain any credentials/keys in cleartext.

## Success Criteria

1. Verify the application is working by creating a new owner, a new pet and a new visit through the new webapp
1. Verify that Application Insights is collecting metrics and logs
1. The Application Map in Application Insights contains the App Service instance and the MySQL database
1. No files should be modified for this challenge

## Tips

App Service doesn't contain the Azure Application Insights agent jar, you'll need to include it when you deploy your application.

## Learning Resources

- [Azure Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
- [Application Insights Agent](https://docs.microsoft.com/en-us/azure/azure-monitor/app/java-in-process-agent)

[Next Challenge - Operational dashboards >](./challenge-05.md)
