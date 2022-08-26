# Challenge 07 - Visualizations

[< Previous Challenge](./Challenge-06.md) - **[Home](../README.md)** ]

## Introduction
Your company's eShopOnWeb website is going to launch soon and as one of the application owners you are responsible for ensuring that the site is performant, available, and overall provides a good user experience. Together with your team you have decided to use Azure Workbooks to visualize the most important metrics of your application, as Workbooks are a flexible canvas and seem to provide all the functionality you need. 

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
You have successfully created a new workbook showing the relevant metrics and now have better insights into your application's performance, availability, health, and user exprerience. 

## Learning Resources
* [Azure Monitor Workbooks](https://docs.microsoft.com/en-us/azure/azure-monitor/app/usage-workbooks)
