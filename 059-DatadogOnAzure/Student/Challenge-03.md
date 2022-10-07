# Challenge 03 - Monitoring Azure Virtual Machines

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

In this challenge you will put together a comprehensive solution to monitor virtual machine operations. This will include the 4 golden signals correlated with relevant platform metrics, linked by tags, and will serve as building blocks when you eventually scale out and/or add regions, shards, and promote your code to production through staging from development environments.

### Understanding Azure VM Scale Sets

Before you get to the challenge, you should understand a little more about how Azure VM scale sets work. Azure VM scale sets let you create and manage a group of like-minded load balanced VMs. With scale sets, all VM instances are created from the same base OS image and configuration. This is because as scale sets scale up, new VM instances must be alike.

For more info on Azure VM Scale Sets, see: [What are Virtual Machine Scale Sets?](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview)

A common practice with VM scale sets is to have an automation script configured to run when VM instances are created to configure the server and deploy software on it. This is how the eShopOnWeb website is deployed on the VM instances of the scale set.

## Description

For this challenge, you will need to install and configure the Datadog agent on the Azure VM scale set which runs the eShopOnWeb website. Normally, the configuration of Datadog on a VM scale set's VM instances would be included as part of the automation before the deployment of the scale set itself. However for this hack, we want you to learn how to perform this configuration. 

To make this possible, we have provided you a way to hook into the automation process for the VM scale set. 
- The VM scale set is configured to look for a PowerShell script named `SetupDatadogOnWebServers.ps1` in an Azure Blob Storage container in the eShopOnWeb Azure environment.  
- The container name is `/scripts` and the storage account is named with a prefix of `bootstrap` followed by a random set of characters. (For example `bootstrapXXXXXXXXXX`)
- In the `/Challenge-03` folder of your student resource package, you will find a PowerShell script named `SetupDatadogOnWebServers.ps1`.  This script is empty and you will need to figure out what to put in it to configure Datadog on the web servers.
- Upload the completed script to the `/scripts` container of the storage account named with the prefix `bootstrap` in the eShopOnWeb Azure environment. 
- After the updated `SetupDatadogOnWebServers.ps1` script has been uploaded, delete the VM instances of the VM scale set.  Azure will automatically create new VM instances to replace the ones you deleted.  These new VM instances should run your updated script.


In this challenge you need to complete the following management tasks:

Manually update the configuration on the SQL, IIS and Visual Studio VMs in order to add Datadog monitoring of the following: 
- Logs
- Live Process Monitoring
- Network Monitoring

Create a new dashboard that will contain the graphs typically included for an infrastructure host, but add a graph for logs, live processes and network monitoring. 

Update the dashboard to handle a drop-down via template variables for:
- Environment
- Host
- Region

Use Azure Policy to enable Configuration Management resources to monitor VM operations and performance.
- Configure Update Management for all virtual machines
- Enable VM Update Management solution
- Enable Automatic OS image upgrades for VM Scaleset
- Add a metric for Total Update Deployment Runs to dashboard

## Success Criteria

To complete this challenge successfully, you should be able to:
- Show your dashboard with VM metrics, logs, process monitoring, Azure Automation and networking with a drop-down selector for hosts.

## Learning Resources

- [NPM for Windows](https://docs.datadoghq.com/network_monitoring/performance/setup/?tab=agentwindows) 
- [Template Variables for Dashboards](https://docs.datadoghq.com/dashboards/template_variables/)
- [Live Process monitoring configuration](https://docs.datadoghq.com/infrastructure/process/?tab=linuxwindows) 
- [Dashboard docs](https://docs.datadoghq.com/dashboards) 
- [Dashboard copy and paste](https://www.datadoghq.com/blog/copy-paste-widget/)