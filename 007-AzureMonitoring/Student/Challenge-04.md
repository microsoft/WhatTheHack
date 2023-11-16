# Challenge 04 - Azure Monitor for Applications

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

To ensure performance requirements are met for eShopOnWeb, you will need to detect performance anomalies, diagnose issues, and understand what users are actually doing on the website. You will deploy and configure Application Insights to allow for continuous performance and usability monitoring.

Application Insights is an extension of Azure Monitor and provides application performance monitoring (APM) features. APM tools are useful to monitor applications from development, through test, and into production in the following ways:

- Proactively understand how an application is performing.
- Reactively review application execution data to determine the cause of an incident.

Application Insights is enabled by adding the Application Insights SDK or Azure Monitor OpenTelemetry Distro to your application code. Many languages are supported. The applications could be on Azure, on-premises, or hosted by another cloud. 

**NOTE:** As of September 2023, the Azure Monitor OpenTelemetry Distro is in preview. For this hack, we recommend using the Application Insights SDK for .NET. In the future, OpenTelemetry will be a fully supported option for monitoring applications in Azure Monitor.

## Description

An Application Insights resource has been pre-deployed in your eShopOnWeb Azure environment. It is named: `ai-wth-monitor-d-XX`

The source code for the eShopOnWeb application is located on the Visual Studio VM (`vmwthvsdXX`). You will connect to this VM via Azure Bastion and use Visual Studio to complete the tasks of this challenge. 

For this challenge, you will need to complete the following high level tasks:

- Create an Application Insights availability test
- Enable server-side telemetry for eShopOnWeb.
- Enable client-side telemetry for eShopOnWeb.
- Test eShopOnWeb on the Development Server.
- Publish the updated eShopOnWeb website to the "production" VM Scale Set.
- Observe telemetry for eShopOnWeb from the "production" VM Scale Set

### Create an Application Insights Availability Test

With Application Insights, you can set up recurring tests to monitor availability and responsiveness. Application Insights sends web requests to your application at regular intervals from points around the world. It can alert you if your application isn't responding or responds too slowly.

You can set up an availability test for any HTTP or HTTPS endpoint that is accessible from the public internet. You don't have to make any changes to the website you are testing. In fact, it doesn't even have to be a site that you own. You can test the availability of a REST API that your service depends on.

- Create a standard availability test for your eShopOnWeb homepage.

### Enable Application Insights Server-Side Telemetry for eShopOnWeb

- You can view and edit the source code in Visual Studio 2022 by opening the `eShopOnWeb.sln` solution file in the `"C:\eshoponweb\eShopOnWeb-main\"` folder.
- In Visual Studio:
  - Install the Application Insights SDK in the eShopOnWeb Web Project in the Solution
  - Install the Application Insights SDK NuGet package for ASP .NET Core. 
  - Add your Application Insights Key to the application's configuration settings

**HINT:** There are two ways to complete these tasks:
- Using the automated tools & wizard in Visual Studio.
- Manually editing the files in the solution.

**NOTE:** If you log into Azure with a work or school account that is NOT in the same Entra ID (formerly Azure Active Directory) tenant where your Azure subscription is located, you will not be able to use the automated tools & wizard in Visual Studio.

### Enable Application Insights Client-Side Telemetry for eShopOnWeb

If your application has client-side components, such as JavaScript, Application Insights can collect telemetry from them too.

This can be done simply by adding a JavaScript snippet that loads on all pages of your website.

- Inject the Application Insights .NET Core JavaScript snippet on the eShopOnWeb website.
  
  **HINT:** There is a standard file location in an ASP.NET Core Application where you should add the JavaScript snippet. Check the docs!

### Test eShopOnWeb on the Development Server

We have added an "Easter Egg" in the eShopOnWeb application that will trigger an exception.
  - Run the eShopOnWeb Web project in Visual Studio on the Visual Studio VM and check out the App Insights tooling in VS and the Azure Portal
  - To create an exception, try to change the user login password on the eShopOnWeb web page.
  - Find the exception in App Insights

### Create Alerts

Now that you have Application Insights configured and are able to view that the exceptions appear in the Azure Portal, you want to be able to respond to them.

  - Create an Alert based on the URL availability
  - Create an Alert to get triggered once an exception happens.

### Publish the Updated eShopOnWeb Website to the VM Scale Set

Once you have implemented Application Insights for the eShopOnWeb website in Visual Studio, you will need to get your changes published to the VM scale set hosting the website.

The VM scale set's automation script is configured to download the eShopOnWeb website from a fileshare on the Visual Studio VM.

In the `/Challenge-04` folder of your student resource package, you will find a PowerShell script named `BuildAndPublish-eShopOnWeb.ps1`. This script builds the solution and publishes its artifacts to the fileshare on the Visual Studio VM so that the VM scale set's automation script can download it.  

- Copy or upload this script to the Visual Studio VM and run it.
- After the `BuildAndPublish-eShopOnWeb.ps1` script has run, delete the VM instances of the VM scale set.  Azure will automatically create new VM instances to replace the ones you deleted.  These new VM instances should pick up the updated version of the eShopOnWeb website code with the Application Insights enabled.

### Observe Application Insights Telemetry from the VM Scale Set

- Navigate to the eShopOnWeb website hosted in the VM Scale Set.
- Re-create the exception by trying to change the user login password on the eShopOnWeb web page.
- Find the exception in Application Insights

## Success Criteria

- Verify you can observe the exception in the Azure Portal with App Insights and the Alert caused by it
- Verify that the client browser data is showing up in App Insights

## Learning Resources

- [Application Insights Overview](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
- [Application Insights for ASP. NET Core applications](https://learn.microsoft.com/en-us/azure/azure-monitor/app/asp-net-core?tabs=netcorenew%2Cnetcore6)
- [Application Insights Availability Tests](https://learn.microsoft.com/en-us/azure/azure-monitor/app/availability-overview)
- [Debug your applications with Azure Application Insights in Visual Studio](https://docs.microsoft.com/en-us/azure/azure-monitor/app/visual-studio)
- [Microsoft.ApplicationInsights.AspNetCore](https://www.nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore)
- [Disable SSL while debugging](https://codetolive.in/ide/how-to-disable-https-or-ssl-in-visual-studio-2019-for-web-project/)
- [Enable client-side telemetry for web applications](https://learn.microsoft.com/en-us/azure/azure-monitor/app/asp-net-core?tabs=netcorenew%2Cnetcore6#enable-client-side-telemetry-for-web-applications)
 
## Advanced Challenges

Too comfortable?  Eager to do more?  Try these additional challenges!

- Create a Dashboard showing the Application availability, failed requests and response time.
- Can you hit the VM Scale Set to cause an Auto Scale event?
  - Simulate a load on the eShopOnWeb website using the `UrlGenLoadwithCurl.sh` script in the `/Challenge-04` folder of the student resource package.
  - Modify the URL in the script file to point at either the Public IP address or DNS name of the `pip-wth-monitor-web-d-XX` resource in Azure.
  - This script is designed to be run from any bash shell, including the Azure Cloud Shell.
