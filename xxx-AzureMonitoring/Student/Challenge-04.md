# Challenge 04 - Azure Monitor for Applications

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

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
	
- Create an Alert to get triggered once an execption happen.
  - Run the eShopOnWeb Web project locally (use Firefox) and check out the App Insights tooling in VS and the Azure Portal
  - To create an exception, try to change the user login password on the eShoponWeb web page. (use Firefox) 
  - Find the exception in App Insights
  - Create Alerts based on the URL availability and exceptions

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

- Use Firefox whenever possible. The eShoponWeb may not work on all browsers, we tested it on Firefox and it works fine. On other browsers it may work, but **you may not be able to login**. 

## Advanced Challenges

Too comfortable?  Eager to do more?  Try these additional challenges!

- Publish your code to your Virtual Machine Scale set and run the eShoponWeb from the internet.
- Create a Dashboard showing the Application availability, failed requests and response time.
- Can you hit the VMSS to cause an Auto Scale?
     - You may need to have a look on the sources\LoadScripts folder for that.
