# Challenge 03 - Monitoring Azure Virtual Machines

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

In this challenge you will put together a comprehensive solution to monitor virtual machine operations. This will include the 4 golden signals correlated with relevant platform metrics, linked by tags, and will serve as building blocks when you eventually scale out and/or add regions, shards, and promote your code to production through staging from development environments.

### Understanding Azure VM Scale Sets

Before you get to the challenge, you should understand a little more about how Azure VM scale sets work. Azure VM scale sets let you create and manage a group of like-minded load balanced VMs. With scale sets, all VM instances are created from the same base OS image and configuration. This is because as scale sets scale up, new VM instances must be alike.

For more info on Azure VM Scale Sets, see: [What are Virtual Machine Scale Sets?](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview)

A common practice with VM scale sets is to have an automation script configured to run when VM instances are created to configure the server and deploy software on it. This is how the eShopOnWeb website is deployed on the VM instances of the scale set.

>**IMPORTANT:** While you can login to any VM instance of an Azure VM scale set, any changes you make (software installs or config updates) to a VM instance are ephemeral. When new VM instances are added to the scale set, they will be created from the base OS image and automation script.  These new instances will not have any changes you made while logged in to an existing VM instance.

## Description

In this challenge you need to:
- Update the Datadog configuration on the SQL Server VM
- Install and configure the Datadog agent on the VM scale set
- Create a dashboard in Datadog to visualize the data collected from the SQL Server VM and the VM scale set.

### Update Datadog Configuration on the SQL Server VM

Manually update the configuration on the SQL Server VM from Challenge 2 in order to add Datadog monitoring of the following: 
- Logs
- Live Process Monitoring
- Network Monitoring

### Install and Configure Datadog agent on the VM Scale Set

You will need to install the Datadog agent on the Azure VM scale set which runs the eShopOnWeb website and also configure it to add Datadog monitoring of the following:
- Logs
- Live Process Monitoring
- Network Monitoring

As noted above, the installation and configuration of software on a VM scale set needs to be done via an automation script. Normally, the Datadog installation and configuration would have been included in that automation BEFORE the VM scale set is deployed. However for this hack, we want you to learn how to perform this configuration.

To make this possible, we have provided you a way to hook into the automation process for the VM scale set. 
- The VM scale set is configured to look for a PowerShell script named `SetupDatadogOnWebServers.ps1` in an Azure Blob Storage container in the eShopOnWeb Azure environment.  
- The container name is `/scripts` and the storage account is named with a prefix of `bootstrap` followed by a random set of characters. (For example `bootstrapXXXXXXXXXX`)

In the `/Challenge-03` folder of your student resource package, you will find a sample PowerShell script named `SetupDatadogOnWebServers.ps1`. This script has the commands needed to install the Datadog agent and a sample configuration block that configures Logs, Live Process Monitoring, and Network Monitoring.  

You will need to edit this script and add the following:
- Your Datadog API key

Once your script is ready:
- Upload the completed script to the `/scripts` container of the storage account named with the prefix `bootstrap` in the eShopOnWeb Azure environment. 
- After the updated `SetupDatadogOnWebServers.ps1` script has been uploaded, delete the VM instances of the VM scale set.  Azure will automatically create new VM instances to replace the ones you deleted.  These new VM instances should run your updated script.

### Create a Dashboard in Datadog

Create a new dashboard that will contain the graphs typically included for an infrastructure host, but add a graph for logs, live processes and network monitoring. 

Update the dashboard to handle a drop-down via template variables for:
- Environment
- Host
- Region

## Success Criteria

To complete this challenge successfully, you should be able to:
- Show your dashboard with VM metrics, logs, process monitoring, Azure Automation and networking with a drop-down selector for hosts.

## Learning Resources

- [NPM for Windows](https://docs.datadoghq.com/network_monitoring/performance/setup/?tab=agentwindows) 
- [Template Variables for Dashboards](https://docs.datadoghq.com/dashboards/template_variables/)
- [Live Process monitoring configuration](https://docs.datadoghq.com/infrastructure/process/?tab=linuxwindows) 
- [Dashboard docs](https://docs.datadoghq.com/dashboards) 
- [Dashboard copy and paste](https://www.datadoghq.com/blog/copy-paste-widget/)
- [Dashboard widgets](https://docs.datadoghq.com/dashboards/widgets/)
- [Dashboard Powerpacks](https://www.datadoghq.com/blog/standardize-dashboards-powerpacks-datadog/)
