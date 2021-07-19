# Challenge 4: Azure Monitor for Applications

[Previous Challenge](./03-Azure-Monitor-For-Virtual-Machines.md) - **[Home](../README.md)** - [Next Challenge>](./05-Azure-Monitor-For-Containers.md)

## Introduction

In order to detect performance anomalies, diagnose issues, and understand what users are actually doing on the we for eshoponweb site w will automatically detect performance anomalies, and includes powerful analytics tools to help you diagnose issues and to understand what users actually do with your app. It's designed to help you continuously improve performance and usability.

## Description

- Create a URL ping availability test for your eShopWeb webpage

- Enable Application Insights server-side telemetry in teh eShoOnWeb Web project
  - In Visual Studio, install the Application Insights SDK in the eShopOnWeb Web Project in the Solution
	- Install the Application Insights SDK NuGet package for ASP .NET Core. 
	- Add you Application Insights Key to your code
	- Make sure if you use the web shop locally (try Firefox) that it write data to Application Insights in Azure
	- Generate an exception (can you change your password?)
	- Create an Alert to be triggered once this exception happened
	
- Enable client-side telemetry collection for your eShoponWeb application.
	- Inject the App Insights .NET Core JavaScript snippet
	
- Run the eShopOnWeb  Web project locally and check out the App Insights tooling in VS and the Azure Portal
  - Trip the exception that has been added and setup an alert for it.
  - Find the exception in App Insights (Hint: Try to change your password)
  - Create Alerts based on availability and exceptions

*Bonus task:
*- Can you hit the VMSS to cause an Auto Scale?
*- Can you publish your code to your VMSS?

## Success Criteria

- Show the exception Azure Portal App Insights and the Alert cause by it
- Show that the client browser data is showing up in App Insights 

## Learning Resources

- [Application Insights Overview](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
- [Application Insights for ASP. NET Core applications](https://docs.microsoft.com/en-us/azure/azure-monitor/app/asp-net-core#enable-application-insights-server-side-telemetry-no-visual-studio)
- [Monitor the availability of any website](https://docs.microsoft.com/en-us/azure/azure-monitor/app/monitor-web-app-availability)
- [Debug your applications with Azure Application Insights in Visual Studio](https://docs.microsoft.com/en-us/azure/azure-monitor/app/visual-studio)
- [Microsoft.ApplicationInsights.AspNetCore](https://www.nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore)
- [Disable SSL while debugging](https://codetolive.in/ide/how-to-disable-https-or-ssl-in-visual-studio-2019-for-web-project/)
- [Enable client-side telemetry for web applications](https://docs.microsoft.com/en-us/azure/azure-monitor/app/asp-net-core#enable-client-side-telemetry-for-web-applications)  
