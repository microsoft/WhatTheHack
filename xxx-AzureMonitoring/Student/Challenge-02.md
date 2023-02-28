# Challenge 02 - Metric and Activity Log alerts via Automation

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

There are multiple ways to configure monitoring in Azure. You can configure monitoring manually in the Azure portal like you did in the previous challenge. This is a great way to learn how Azure Monitor works and what settings are available to choose from. 

However, this method does not scale when you need to configure monitoring across 10s, 100s, or even 1000s of resources in Azure. It is easier to configure monitoring at scale across many Azure resources if you use a declarative infrastructure-as-code tool such as ARM templates, Bicep, or Terraform.

## Description

For this challenge, you will deploy several Metric alerts for your VMs, but this time you will use Bicep templates instead of the Azure Portal. You will also create a new type of alert - Activity log alert. 

> The Azure Monitor activity log is a platform log in Azure that provides insight into subscription-level events. The activity log includes information like when a resource is modified or a virtual machine is started.

You can find the sample Bicep file, `alert.bicep`, in the `/Challenge-02` folder of the `Resources.zip` file provided by your coach. To complete the challenge, navigate to the location of this file using your terminal client (WSL or Azure Cloud Shell).

- Update the 'alert.bicep' file adding the id of the Action Group, that you've created in the previous Challenge, and the region where you've deployed your VMs.
- Deploy the alerts using the following Azure CLI command: 
```bash
az deployment group create --name "alert-deployment" --resource-group "<your-resource-group-name>" --template-file alert.bicep
```
- Verify that you have three new Alert Rules in the Portal or from the command line.
- Stop one of your VMs and verify that the Activity Log alert has fired.
- Review the Service Health dashboard in Azure Monitor. Create a Service Health alert (a flavour of Activity log alerts) to get notified about the service incidents affecting your subscription by updating and re-deploying the 'alert.bicep' file.
- Modify the 'alert.bicep' to include “Disk Write Operations/Sec” and set a threshold of 20.
- Rerun your template and verify the new Metric Alert rule was created for all your VMs.

Bonus questions: 
- Will the Activity log alert get fired if the VM was turned off from the OS? Or if the VM was not available? Why?
- How many emails did you receive when the alert got fired? Why?

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that you have five new Alert rules in the Azure Portal.
- Show the alert which got fired and explain what you have done.

## Learning Resources

- [Azure Monitor activity log](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/activity-log)
- [Activity log alerts](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types#activity-log-alerts)
- [Quickstart: Create activity log alerts on service notifications using a Bicep file](https://learn.microsoft.com/en-us/azure/service-health/alerts-activity-log-service-notifications-bicep?tabs=CLI)
- [Create monitoring resources by using Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/scenarios-monitoring)
- [Bicep documentation for Activity log alerts](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/activitylogalerts?pivots=deployment-language-bicep)
- [Bicep documentation for Metric alerts](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/metricalerts?pivots=deployment-language-bicep)
