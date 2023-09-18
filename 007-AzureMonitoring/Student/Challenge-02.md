# Challenge 02 - Setting up Monitoring via Automation

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

There are multiple ways to configure monitoring in Azure. You can configure monitoring manually in the Azure portal like you did in the previous challenge. This is a great way to learn how Azure Monitor works and what settings are available to choose from. However, this method does not scale when you need to configure monitoring across 10s, 100s, or even 1000s of resources in Azure. It is easier to configure monitoring at scale across many Azure resources if you use a declarative Infrastructure-as-Code tool such as ARM templates, Bicep, or Terraform. In addition to that, you can use Azure Policies to ensure that all newly created VMs in the defined scope get required agents installed and all cloud native resources send diagnostics to Azure Monitor (Azure Policies will be explored in the next Challenge).

For this challenge, you will deploy several Metric alerts for your VMs, but this time you will use Bicep templates instead of the Azure Portal. You will get familiar with a new type of alerts - Activity log alert. The Azure Monitor Activity log is a platform log in Azure that provides insight into subscription-level events. The activity log includes information like when a resource is modified or a virtual machine is started.

You will also be asked to install the Azure Monitor Agent on the Virtual Machine Scale Set (VMSS) and configure new Data Collection Rules (DCRs) by using an Infrastructure-as-Code approach.

## Description

You can find sample Bicep files, `alert.bicep`and `ama.bicep`, in the `Challenge-02` folder of the student resource package. To complete the challenge, navigate to the location of these files using your terminal client (WSL or Azure Cloud Shell).

In this challenge you need to complete the following management tasks:

- Explore and update the `alert.bicep` file by adding the Resource Id of the Action Group, that you've created in the previous Challenge. Deploy the alerts into the same Resource group where your VMs are located, using the following Azure CLI command: 
```bash
az deployment group create --name "alert-deployment" --resource-group "<your-resource-group-name>" --template-file alert.bicep
```
- Verify that you have 2 new Alert Rules in the Portal or from the command line. Stop one of your VMs and verify that the Activity Log alert has fired.
- Modify the `alert.bicep` file to include “Disk Write Operations/Sec” Metric alert rule and set a threshold of 20. Rerun your template and verify the new Metric Alert rule was created for all your VMs.

>**HINT:** Use the "Percentage CPU" Metric alert rule that you deployed earlier as an example.

- Explore the `ama.bicep` file that deploys the Azure Monitor Agent and Data Collection Rules. In the file, update the names of your Log Analytics workspace `law-wth-monitor-d-XX` and the Virtual Machine Scale Set `vmss-wth-monitor-d-XX`. Deploy this Bicep template into the same Resource group where your VMSS is located, using the following Azure CLI command: 
```bash
az deployment group create --name "ama-deployment" --resource-group "<your-resource-group-name>" --template-file ama.bicep
```

Bonus questions: 
- Will the Activity log alert get fired if the VM was turned off from the OS? Or if the VM was not available? Why?
- How many emails did you receive when the Activity Log alert fired? Why? How can you change this behaviour?


## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that you have 3 new Alert rules in the Azure Portal.
- Show the fired Activity Log alert and explain what you have done.
- Demonstrate the Azure Monitor Agent extension installed on the Virtual Machine Scale Set.
- Verify that you have two new Data Collection Rules that are sending Performance counters and Windows event logs from the VMSS to Azure Monitor Logs.

## Learning Resources

- [What is Bicep?](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep)
- [Supported metrics in Azure Monitor by resource type](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported#microsoftcomputevirtualmachines)
- [Bicep documentation for Metric alerts](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/metricalerts?pivots=deployment-language-bicep)
- [Create monitoring resources by using Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/scenarios-monitoring)
- [Resource Manager template samples for agents in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/resource-manager-agent?tabs=bicep)
- [Best practices: Alerts and Automated actions](https://learn.microsoft.com/en-us/azure/azure-monitor/best-practices-alerts)
- [Azure Monitor activity log](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/activity-log)
- [Activity log alerts](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types#activity-log-alerts)
- [Azure Policy built-in definitions for Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/policy-reference)
- [Create diagnostic settings at scale using Azure Policies](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings-policy)
