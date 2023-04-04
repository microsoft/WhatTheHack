# Challenge 03 - Azure Monitor for Virtual Machines

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

In this challenge you will explore additional features and solutions to monitor virtual machine operations: VM Insights, Change Tracking and Inventory.

VM insights monitors the performance and health of your virtual machines and virtual machine scale sets. It monitors their running processes and dependencies on other resources. VM insights can help deliver predictable performance and availability of vital applications by identifying performance bottlenecks and network issues. It can also help you understand whether an issue is related to other dependencies. VM insights stores its data in Azure Monitor Logs, which allows it to deliver powerful aggregation and filtering and to analyze data trends over time. You can view this data in a single VM from the virtual machine directly. Or, you can use Azure Monitor to deliver an aggregated view of multiple VMs.

Change Tracking and Inventory tracks changes in virtual machines to help you pinpoint operational and environmental issues with software managed by the Distribution Package Manager. Items that are tracked by Change Tracking and Inventory include:
- Windows software
- Linux software (packages)
- Windows and Linux files
- Windows registry keys
- Windows services
- Linux daemons

## Description

In this challenge you need to complete the following management tasks:
- Configure VM Insights for all VMs and VMSS. Verify that with the help of Azure Monitor aggregated view.
- Explore VM Insights workbooks, determine how much free disk space is left for the SQL Server VM.
- For the SQL Server VM pin the Available Memory chart from the VM Insights workbook to your Azure dashboard.
- Enable Change Tracking and Inventory for all VMs and explore what changes are detected by the feature.

## Success Criteria

- Demonstrate that VM Insights is enabled for all VMs and VMSS.
- Show your Azure dashboard with VM Insights performance chart.
- Show Change Tracking and Inventory dashboards.

## Learning Resources
- [VM Insights Overview](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-overview)
- [Enable VM insights](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-enable-overview)
- [Overview of Change Tracking and Inventory using Azure Monitoring Agent](https://learn.microsoft.com/en-us/azure/automation/change-tracking/overview-monitoring-agent)
- [Enable Change Tracking and Inventory using Azure Monitoring Agent](https://learn.microsoft.com/en-us/azure/automation/change-tracking/enable-vms-monitoring-agent?tabs=singlevm)

