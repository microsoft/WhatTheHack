# Challenge 04 - Datadog for Applications

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** 

## Introduction

To ensure performance requirements are met for eShopOnWeb, you will need to detect performance anomalies, diagnose issues, and understand what users are actually doing on the website. You will deploy and configure Datadog Dotnet APM to allow for continuous performance and usability monitoring. 

## Description

For this challenge, you will need to complete the following tasks:

- Create a Browser, ICMP and HTTP test for your eShopWeb webpage using Datadog Synthetics. What are the differences? Which type of test will tell you what? 
- Enable server-side telemetry in the eShopOnWeb Web project 
    - For Datadog agent configuration: 
        - Add the environment variables to your host VM 
        - Configure the Datadog agent, ensuring APM is enabled 
        - Enable logging for IIS 
- Enable RUM (Real User Monitoring) for your eShoponWeb application. 
    - Inject the RUM snippet into the homepage of the eShopOnWeb website 

### Edit the eShopOnWeb Website

The source code for the eShopOnWeb application is located on the Visual Studio VM (`vmwthvsdXX`). 
- You can edit the source code in Visual Studio 2022 by opening the `eShopOnWeb.sln` solution file in the `"C:\eshoponweb\eShopOnWeb-main\"` folder.
- The website homepage, `Index.cshtml` is located in the `\src\Web\Pages\` folder of the eShopOnWeb solution.

### Publish the Updated eShopOnWeb Webite to the VM Scale Set

Once you have saved your changes to the `Index.cshtml` file in Visual Studio, you will need to get your changes published to the VM scale set hosting the website.

The VM scale set's automation script is configured to download the eShopOnWeb website from a fileshare on the Visual Studio VM.

In the `/Challenge-04` folder of your student resource package, you will find a PowerShell script named `BuildAndPublish-eShopOnWeb.ps1`. This script builds the solution and publishes its artifacts to a fileshare on the Visual Studio VM so that the VM scale set's automation script can download it.  

- Copy or upload this script to the Visual Studio VM and run it.
- After the `BuildAndPublish-eShopOnWeb.ps1` script has run, delete the VM instances of the VM scale set.  Azure will automatically create new VM instances to replace the ones you deleted.  These new VM instances should pick up the updated version of the eShopOnWeb website code with the Datadog RUM snippet.

### Observe RUM Telemetry in the Datadog Dashboard

Once the website has been instrumented with Datadog RUM, it may take a few minutes for data to appear in the Datadog dashboard.

- Simulate a load on the eShopOnWeb website using the `UrlGenLoadwithCurl.sh` script in the `/Challenge-04` folder of the student resource package.
    - Modify the URL in the script file to point at either the Public IP address or DNS name of the `pip-wth-monitor-web-d-XX` resource in Azure.
    - This script is designed to be run from any bash shell, including the Azure Cloud Shell.

## Success Criteria

To complete this challenge successfully, you should be able to:
- Show the Synthetics test results for Browser, ICMP and HTTP tests
- Show that the client browser data is showing up in RUM
- Verify that activity appears in RUM when running a loadtest against the eShopOnWeb website 

## Learning Resources

- [Datadog Synthetics](https://docs.datadoghq.com/synthetics/)
- [Create a Datadog Synthetics test via API](https://docs.datadoghq.com/api/latest/synthetics/)
- [Datadog IIS Integration Docs](https://docs.datadoghq.com/integrations/iis/)
- [Monitoring IIS with Datadog Blog Post](https://www.datadoghq.com/blog/iis-monitoring-datadog/)
- [Key IIS Metrics](https://www.datadoghq.com/blog/iis-metrics/)
- [Datadog RUM](https://docs.datadoghq.com/real_user_monitoring/)
- [Create Datadog RUM Application Via API](https://docs.datadoghq.com/api/latest/rum/#create-a-new-rum-application)
