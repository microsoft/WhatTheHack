# Challenge 07 - Visualizations

[< Previous Challenge](./Challenge-06.md) - **[Home](../README.md)**

## Introduction

### What is an Azure Monitor Workbook?
An Azure Monitor workbook is a customizable dashboard in the Azure portal that helps you visualize, analyze, and correlate data from multiple sources, including Azure resources, third-party services, and custom data sources. With Azure Monitor workbooks, you can create rich visualizations, such as tables, charts, and graphs, that provide insights into your application and infrastructure performance, health, and security.

Workbooks allow you to aggregate data from multiple sources and display it in a single dashboard. This makes it easier to analyze and troubleshoot issues across different services and environments. Workbooks also enable you to create custom queries and metrics, set up alerts and notifications, and share your dashboards with other users in your organization. 

Some common scenarios where Azure Monitor workbooks can be useful include:

* Monitoring and troubleshooting application performance and availability
* Analyzing infrastructure and resource utilization
* Identifying and responding to security threats and anomalies
* Creating custom reports and visualizations for different stakeholders and audiences

## Description
In this challenge you need to create an Azure Monitor Workbook that will allow you to see the following information from any of your VMs on a single page. You must be able to change the time range and switch between the various VMs without editing your KQL code.

* CPU %
* Available Memory
* Free Disk Space

## Success Criteria
You have successfully created a new workbook showing the performance characteristics of the virtual machines in your environment.


# Bonus Challenge (requires completion of all previous challenges)
Your company's eShopOnWeb website is going to launch soon and as one of the application owners you are responsible for ensuring that the site is performing well, available, and overall provides a good user experience. Together with your team you have decided to use Azure Workbooks to visualize the most important metrics of your application, as Workbooks are a flexible canvas and seem to provide all the functionality you need. 

## Description
In this challenge, you will therefore create a workbook that combines browser, web server and infrastructure performance data for your eShopOnWeb application on the AKS cluster.  
More specifically, you are going to visualize the following data:
* Web page performance as observed from the client-side browser using Page View records.
    * Visualizations: Time Selector, Table with columns for Page Titles, Page Views with Bar underneath, Average Page Time with Thresholds and Maximum Page time with Bar underneath.
* Request failures reported by the web server using Request records.
    * Visualization: Table with columns for Request Name, HTTP Return Code, Failure Count with Heatmap and Page Time with Heatmap.
* Server response time as observed from the server-side using Request metrics.
    * Visualization: Line Chart of Average and Max Server Response Time.
* Infrastructure performance as observed from the nodes in the AKS cluster on which the application is deployed using Average and Maximum CPU usage metrics.
    * Visualization: Line Chart of Average CPU usage percentage by AKS cluster node.
* Infrastructure performance from AKS nodes showing disk used percentage based on Log Analytics records.
    * Visualization: Line Chart of Average Disk used percentage by AKS cluster node.
* Health status/availability of components
    * Visualization: Threshold-based tiles/grid view presenting the heartbeat status of each server

## Success Criteria
You have successfully created a new workbook showing the relevant metrics and now have better insights into your application's performance, availability, health, and user experience. 

## Learning Resources
* [Azure Monitor Workbooks](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview)
* [Workbook Parameters](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-parameters)
