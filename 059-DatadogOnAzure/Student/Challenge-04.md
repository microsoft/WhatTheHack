# Challenge 04 - Datadog for Applications

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

To ensure performance requirements are met for eShopOnWeb, you will need to detect performance anomalies, diagnose issues, and understand what users are actually doing on the website. You will deploy configure Datadog Dotnet APM to allow for continuous performance and usability monitoring. 

## Success Criteria

To complete this challenge successfully, you should be able to:
- Show the Synthetics test results for Browser, ICMP and HTTP tests
- Show that the client browser data is showing up in RUM 

## Description

- Create a Browser, ICMP and HTTP test for your eShopWeb webpage using Datadog Synthetics. What are the differences? Which type of test will tell you what? 
- Enable server-side telemetry in the eShoOnWeb Web project 
    - For Datadog agent configuration: 
        - Add the environment variables to your host VM 
        - Configure the Datadog agent, ensuring APM is enabled 
        - Enable logging for IIS 
- Enable RUM (Real User Monitoring) for your eShoponWeb application. 
    - Inject RUM snippet into your code 

## Learning Resources

*Sample IoT resource links:*

- [Datadog Synthetics](https://docs.datadoghq.com/synthetics/)
- [Create a Datadog Synthetics test via API](https://docs.datadoghq.com/api/latest/synthetics/)
- [Datadog IIS Integration Docs](https://docs.datadoghq.com/integrations/iis/)
- [Monitoring IIS with Datadog Blog Post](https://www.datadoghq.com/blog/iis-monitoring-datadog/)
- [Key IIS Metrics](https://www.datadoghq.com/blog/iis-metrics/)
- [Datadog RUM](https://docs.datadoghq.com/real_user_monitoring/)
- [Create Datadog RUM Application Via API](https://docs.datadoghq.com/api/latest/rum/#create-a-new-rum-application)
