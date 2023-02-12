# Challenge 03 - Monitor Virtual Machines with Azure Monitor Logs

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

In this challenge you will put together a comprehensive solution to monitor virtual machine operations. This will include installation of Azure Monitor Agent, exploration of VM Insights, Change Tracking and Inventory.

Azure Monitor Logs is a feature of Azure Monitor that collects and organizes log and performance data from monitored resources. Azure Monitor Logs stores the data that it collects in one or more Log Analytics workspaces. After you create a Log Analytics workspace, you must configure sources to send their data. No data is collected automatically.  

>**Note:** Azure Monitor Logs is one half of the data platform that supports Azure Monitor. The other is Azure Monitor Metrics (see Challenge-01), which stores lightweight numeric data in a time-series database. Azure Monitor Metrics can support near real time scenarios, so it's useful for alerting and fast detection of issues. Azure Monitor Metrics can only store numeric data in a particular structure, whereas Azure Monitor Logs can store a variety of data types that have their own structures. You can also perform complex analysis on Azure Monitor Logs data by using log queries, which can't be used for analysis of Azure Monitor Metrics data.

Azure Monitor Agent collects monitoring data from the guest operating system of Azure and hybrid virtual machines and delivers it to Azure Monitor Logs for use by features, insights, and other services. Azure Monitor Agent uses Data collection rules, where you define which data you want each agent to collect and to which Log analytics workspace it should be sent. Azure Monitor Agent (AMA) replaces several legacy monitoring agents, like Log Analytics Agent (MMA, OMS) and Telegraf agent.

>**Note:** The Log Analytics agent is on a deprecation path and won't be supported after August 31, 2024. If you use the Log Analytics agent to ingest data to Azure Monitor Logs, migrate to the new Azure Monitor Agent prior to that date.

Azure Monitor Agent is implemented as an Azure VM extension. You can install it by using any of these methods: as part of the Data collection rule (DCR) creation,  Bicep or ARM Template, PowerShell, Azure CLI, Azure Policy.

## Description

In this challenge you need to complete the following management tasks:
- Install Azure Monitor Agent on all your VMs and VM scale sets. You can use any of the deployment methods from the list above (DCR, Bicep, Azure CLI, etc.). 
>**Hint:** You can find a sample Bicep file, 'ama.bicep', in the '/Challenge-03' subfolder of the Resources folder. 
- Create a Data collection rule and configure it to send basic Windows Event Logs and Performance counters (CPU, Memory, Disk, Network) from your VMs and VM scale sets to the already existing Log Analytics workspace called **`law-wth-monitor-d-XX`**
- Verify that telemetry started to flow into the Log Analytics workspace.
>**Hint:** You can find sample KQL queries in the '/Challenge-03' subfolder of the Resources folder.
- Configure VM Insights for all VMs, pin Performance graphs from the VM Insights workbook to your Azure dashboard.
- Enable Change Tracking and Inventory for all VMs.

## Success Criteria

- Show your dashboard with VM Insights performance graphics.
- Show performance and event data in Azure Monitor Logs.
- Show Change Tracking and Inventory graphics.

## Learning Resources

- [Azure Monitor Logs Overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)
- [Azure Monitor Agent Overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/agents-overview)
- [Collect events and performance counters from virtual machines with Azure Monitor Agent](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/data-collection-rule-azure-monitor-agent?tabs=portal)
- [Install Azure Monitor Agent](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-manage?tabs=azure-portal)
- [Resource Manager template samples for agents in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/resource-manager-agent?tabs=bicep#diagnostic-extension)
- [Configure Log Analytics workspace for VM Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-configure-workspace?tabs=CLI#add-vminsights-solution-to-workspace)
- [Enable VM insights by using Azure Policy](https://docs.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-enable-policy)
- [Enable Change Tracking and Inventory using Azure Monitoring Agent](https://learn.microsoft.com/en-us/azure/automation/change-tracking/enable-vms-monitoring-agent?tabs=singlevm)

