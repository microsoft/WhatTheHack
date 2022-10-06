# Challenge 03 - Monitoring Azure Virtual Machines

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

In this challenge you will put together a comprehensive solution to monitor virtual machine operations. This will include the 4 golden signals correlated with relevant platform metrics, linked by tags, and will serve as building blocks when you eventually scale out and/or add regions, shards, and promote your code to production through staging from development environments.  

## Description

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