# Challenge 02 - Alerts, Activity Logs, and Service Health via Automation

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

Activity Logs show everything that is happening to your resources at the API level. The Activity log is a platform log in Azure that provides insights into subscription-level events. This includes information such as when a resource is modified or when a virtual machine is started.

For this challenge, your goal is to understand Azure platform logs, configure a monitor to get notified if a VM has been turned off, and view the service health.

There are multiple ways to configure monitoring in Azure.  You can configure monitoring manually in the Azure portal like you did in the previous challenge.  This is a great way to learn how Azure Monitor works and what settings are available to choose from. 

However, this method does not scale when you need to configure monitoring across 10s, 100s, or even 1000s of resources in Azure. It is easier to configure monitoring at scale across many Azure resources if you use a declarative infrastructure-as-code tool such as ARM templates, Bicep, or Terraform.

## Description

For this challenge, you will use Bicep to deploy the ??????? monitor. We have provided you with a sample Bicep file that can be used to configure monitoring in Datadog. 

You can find the sample Bicep file, `XXXXXXX.bicep`, in the `/Challenge-02` folder of the `Resources.zip` file provided by your coach. To complete the challenge, navigate to the location of this file using your terminal client (WSL or Azure Cloud Shell).


Understand Activity Logs, configure an Alert to get notified if a VM has been turned off, and view the service health.

- Update the parameters file and deployment script for the GenerateAlertRules.json template located in the AlertTemplates folder
    - Add the names of your VMs and ResouceId for your Action Group
- Deploy the GenerateAlertRules.json template using the sample PowerShell script (deployAlertRulesTemplate.ps1) or create a Bash script (look at the example from the initial deployment)
- Verify you have new Monitor Alert Rules in the Portal or from the command line (sample command is in the PowerShell deployment script using new Az Monitor cmdlets)
- Modify the GenerateAlertsRules.json to include “Disk Write Operations/Sec” and set a threshold of 20
- Rerun your template and verify your new Alert Rules are created for each of your VMs
- Create a new Action Rule that suppress alerts from the scale set and virtual machines

Bonus question/task:
- Will the Alert get fired if the VM was turned off from the OS? Or if the VM was not available? Why?

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that you have the new Monitor Alert Rules in the Azure Portal
- Show the Alert which got fired and explain what you have done.

## Learning Resources

- [Alerts on activity log](https://docs.microsoft.com/en-us/azure/azure-monitor/alerts/activity-log-alerts)
- [Azure Update Management overview](https://docs.microsoft.com/en-us/azure/automation/update-management/overview)
- [Create a new Automation Account](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-account)
- [How to use Azure Update Management to install a specific patch version](https://www.linkedin.com/pulse/how-use-azure-update-management-install-specific-patch-mohamed-ghaleb/)