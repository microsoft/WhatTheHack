# Challenge 02 - Monitor platform events with Activity Log

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

The Azure Monitor activity log is a platform log in Azure that provides insight into subscription-level events. The activity log includes information like when a resource is modified or a virtual machine is started.

For this challenge, your goal is to understand Azure platform logs, configure an Activity log alert to get notified if a VM has been turned off, view the Service Health and set up a Service Health alert.

There are multiple ways to configure monitoring in Azure. You can configure monitoring manually in the Azure portal like you did in the previous challenge. This is a great way to learn how Azure Monitor works and what settings are available to choose from. 

However, this method does not scale when you need to configure monitoring across 10s, 100s, or even 1000s of resources in Azure. It is easier to configure monitoring at scale across many Azure resources if you use a declarative infrastructure-as-code tool such as ARM templates, Bicep, or Terraform.

## Description

For this challenge, you will use Bicep to deploy an Activity log alert. You can find the sample Bicep file, `alert.bicep`, in the `/Challenge-02` folder of the `Resources.zip` file provided by your coach. To complete the challenge, navigate to the location of this file using your terminal client (WSL or Azure Cloud Shell).


### Understand Activity Logs, configure an alert to get notified if a VM has been turned off, and a Service Health alert.

- Update the 'alert.bicep' file adding the id of the Action Group, that you've created in the previous Challenge.
- Deploy the alert using the following Azure CLI command: 
```bash
az deployment group create --name alert-deployment --resource-group <your-resource-group-name> --template-file alert.bicep
```
- Verify that you have a new Alert Rule in the Portal or from the command line.
- Stop one of your VMs and verify that the alert has fired.
- Review the Service Health dashboard in Azure Monitor. Create a Service Health alert in the Portal. Bonus task: If you'd like to challenge yourself even more, try to do this by updating and re-deploying the 'alert.bicep' file.

Questions:
- Will the Alert get fired if the VM was turned off from the OS? Or if the VM was not available? Why?
- What is the scope of the Actiity Log alert? How is the scope defined in the Bicep file?
- How many emails did you receive when the alert got fired? Why?
- What is the difference between Service Heatlh alerts and Resource Health alerts?

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that you have two new Activity log alerts in the Azure Portal.
- Show the alert which got fired and explain what you have done.
- Answer the questions.

## Learning Resources

- [Azure Monitor activity log](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/activity-log)
- [Activity log alerts](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types#activity-log-alerts)
- [Create activity log alerts on service notifications using the Azure portal](https://learn.microsoft.com/en-us/azure/service-health/alerts-activity-log-service-notifications-portal)
- [Quickstart: Create activity log alerts on service notifications using a Bicep file](https://learn.microsoft.com/en-us/azure/service-health/alerts-activity-log-service-notifications-bicep?tabs=CLI)
- [Create monitoring resources by using Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/scenarios-monitoring)
