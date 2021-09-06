# Challenge 4: Azure Monitor for Applications

[Previous Challenge](./03-Azure-Monitor-For-Virtual-Machines.md) - **[Home](../README.md)** - [Next Challenge>](./05-Azure-Monitor-For-Containers.md)

## Introduction

To ensure performance requirements are met for eshoponweb, you will need to detect performance anomalies, diagnose issues, and understand what users are actually doing on the website. You deside to deploy Application Insights to allow continuously performance and usability monitoring.

## Description

- Create a URL ping availability test for your eShopWeb webpage

- Enable Application Insights server-side telemetry in the eShoOnWeb Web project
  - In Visual Studio, install the Application Insights SDK in the eShopOnWeb Web Project in the Solution
	- Install the Application Insights SDK NuGet package for ASP .NET Core. 
	- Add you Application Insights Key to your code
	
- Enable client-side telemetry collection for your eShoponWeb application.
	- Inject the App Insights .NET Core JavaScript snippet
	
- Run the eShopOnWeb Web project locally (try Firefox), and check out the App Insights tooling in VS and the Azure Portal
  - Find the exception in App Insights (Hint: Try to change your password)
  - Create Alerts based on availability and exceptions

Bonus task:
- Can you hit the VMSS to cause an Auto Scale?
- Can you publish your code to your VMSS?

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

## Tips

- Use Firefox whenever possible. The eShoponWeb may not work on all browsers, we tested it on Firfox and it works fine. On other browsers it may work, but **you may not be able to login**. 
