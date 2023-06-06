# Challenge 03 - Azure Monitor for Virtual Machines

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

In this challenge you will explore additional features and solutions to monitor virtual machine operations: VM Insights, Change Tracking and Inventory.

VM insights monitors the performance and health of your virtual machines and virtual machine scale sets. It monitors their running processes and dependencies on other resources. VM insights can help deliver predictable performance and availability of vital applications by identifying performance bottlenecks and network issues. It can also help you understand whether an issue is related to other dependencies. VM insights stores its data in Azure Monitor Logs, which allows it to deliver powerful aggregation and filtering and to analyze data trends over time. You can view this data in a single VM from the virtual machine directly. Or, you can use Azure Monitor to deliver an aggregated view of multiple VMs.

Different installation methods are available for enabling VM insights on supported machines: Azure Portal, ARM/Bicep Templates, Azure Policy, PowerShell/Azure CLI. Azure Policy lets you set and enforce requirements for all new resources you create and resources you modify. VM insights policy initiatives, which are predefined sets of policies created for VM insights, install the agents required for VM insights and enable monitoring on all new virtual machines in your Azure environment. In this challenge you will also explore how to enable VM insights manually in Azure Portal and by using predefined VM insights policy initiates.

## Description

In this challenge you need to complete the following management tasks:
- Configure VM Insights for the SQL Server VM manually in Azure Portal. 
>**Note** Make sure you select **Azure Monitor agent** here and NOT Log Analytics agent. 
- Set up Azure Policy to automatically enable VM Insights on VMs and VMSSs in the main hackathon Resource Group `xxx-rg-wth-monitor-d-xx`. 
>**Note** Azure Policy lets you set and enforce requirements for all new resources you create and resources you modify. To remediate already existing resources, you need to run a remediation task after resource compliance status is available (this can take time, there's no pre-defined expectation of when the compliance evaluation cycle completes).
- Explore VM Insights workbooks, determine how much free disk space is left for the SQL Server VM.
- For the SQL Server VM pin the Available Memory chart from the VM Insights workbook to your Azure dashboard.


## Success Criteria

- Demonstrate that VM Insights is enabled for all VMs and VMSS.
- Show your Azure dashboard with VM Insights performance chart.

## Learning Resources
- [VM Insights Overview](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-overview)
- [Enable VM insights in the Azure portal](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-enable-portal)
- [Enable VM insights by using Azure Policy](https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-enable-policy)
- [Remediate non-compliant resources with Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources?tabs=azure-portal)
- [Get compliance data of Azure resources](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data)

