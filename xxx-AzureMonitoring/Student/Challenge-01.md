# Challenge 01 - Monitoring Basics: Metrics, Logs, Alerts and Dashboards

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

After deploying your initial solution for eShopOnWeb, you want to make sure that the telemetry is collected from the VMs deployed and display the results on a dashboard for visualization and alerting purposes. By default Azure Monitoring collects only host-level metrics - like CPU utilization, disk and network usage - for all virtual machines and virtual machine scale sets without any additional software. For more insight into your virtual machines, you can collect guest-level log and performance data using Azure Monitor Agent.

To accomplish this task, you will need to understand the concept of metrics and logs, how to collect them into Azure Monitor, how to configure different types of alerts, and display results in an Azure Dashboard.  

Once you have configured the dashboard, alerts, and diagnostics data to be collected, you will use two tools to simulate a load on the eShopOnWeb resources:
- HammerDB - A benchmarking and load testing tool for the world's most popular databases, including SQL Server.
- A custom script that produces CPU load on the eShopOnWeb website.

## Azure Monitor Overview

### Azure Monitor Metrics and Logs

Azure Monitor Logs is a feature of Azure Monitor that collects and organizes log and performance data from monitored resources into Log Analytics workspaces. Azure Monitor Logs is one half of the data platform that supports Azure Monitor. The other is Azure Monitor Metrics, which stores lightweight numeric data in a time-series database. Azure Monitor Metrics can support near real time scenarios, so it's useful for alerting and fast detection of issues. Azure Monitor Metrics can only store numeric data in a particular structure, whereas Azure Monitor Logs can store a variety of data types that have their own structures. You can also perform complex analysis on Azure Monitor Logs data by using KQL queries, which can't be used for analysis of Azure Monitor Metrics data. 

### Azure Monitor Agent

Azure Monitor Agent collects monitoring data from the guest operating system of Azure and hybrid virtual machines and delivers it to Azure Monitor for use by features, insights, and other services. Azure Monitor Agent uses Data collection rules, where you define which data you want each agent to collect and where to send. Azure Monitor Agent (AMA) replaces several legacy monitoring agents, like Log Analytics Agent (MMA, OMS), Diagnostics agent and Telegraf agent.

### Azure Monitor Alerts

You can create different types of alerts in Azure Monitor:
- A Metric alert rule monitors a resource by evaluating conditions on the resource metrics at regular intervals. Metric alerts are useful when you want to be alerted about data that requires little or no manipulation. 
- A Log alert rule monitors a resource by using a Log Analytics query to evaluate resource logs at a set frequency. You can use KQL queries to perform advanced logic operations in the condition of the alert rule.
- An Activity log alert rule monitors a resource by checking the Activity logs for a new activity log event that matches the defined conditions. For example, you might want to be notified when a production VM is deleted or a Service Health event occurs. 

## Description

In the eShopOnWeb Azure environment, there are three compute resources to be aware of:
- **`vmss-wth-monitor-d-XX`** - Virtual Machine Scale Set (VMSS) hosting the eShopOnWeb web site
- **`vmwthdbdXX`** - Virtual Machine running SQL Server 2019 hosting the eShopOnWeb database
- **`vmwthvsdXX`** - Virtual Machine running Windows Server 2022 + Visual Studio 2022 + SQL Management Studio to act as a "jumpbox" that you will login to for administrative tasks.

>**Note** The "XX" in each resource name will vary based on the Azure region the eShopOnWeb Azure environment has been deployed to.

Azure Bastion has been configured to enable you to securely login to any of these VMs with a Remote Desktop session through a web browser. To login to a VM via Azure Bastion, navigate to the blade for any of these VMs in the Azure portal, click the "Connect" button, and select "Bastion". Use the username and password provided in Challenge 0.
 
### Set up Counters, Alerts, and Dashboard

In this challenge you need to complete the following management tasks:
- Create an empty database called “tpcc” on the SQL Server VM. Use SQL Auth with the username being "sqladmin" and password being whatever you used during deployment in Challenge 0.

	**HINT:** You can use SQL Management Studio on either the SQL Server VM or the Visual Studio VM, or SQL Server Object Explorer view in Visual Studio to create the database.

- In Azure portal navigate to the blade of the SQL Server VM, click "Metrics" to open Azure Monitor Metrics explorer, and check what metrics are currently being collected.
- From Azure Monitor create a new Data Collection Rule for the SQL Server and configure it to send the below guest OS metrics to Azure Monitor Metrics:
	- Object: Memory
		- Counter: Available Bytes
		- Counter: Committed Bytes
		- Counter: % Committed Bytes in Use 
	- Object: SQLServer:Databases
		- Counter: Active Transactions
		- Instance: tpcc

>**Note** When you create a Data Collection Rule the Azure Monitor Agent will be automatically installed on virtual machine.
- Create another Data Collection Rule for the SQL Server and configure it to send basic Windows Event Logs to the already existing Log Analytics workspace called **`law-wth-monitor-d-XX`**. Use sample KQL queries in the '/Challenge-01' subfolder of the Resources folder to verify that the logs started to flow into the Log Analytics workspace. 
- Create graphs for the SQL Server Active Transactions and the Virtual Machine Scale Set CPU Utilisation (see the Metrics blades of the VM and VMSS) and pin both of them to your Azure Dashboard.
- From Azure Monitor, create an Action group to send email to your email address.
- Create a Metric Alert Rule to be notified via email if "Active Transactions" metric goes over 40 on the SQL Server "tpcc" database.
- Create a Meric Alert Rule to be notified via email if average CPU Utilisation goes over 75% on the Virtual Machine Scale Set.
- Suppress all alerts over the weekend (unless you are solving this challenge on the weekend).

### Simulate load on the eShopOnWeb Environment

Now that Azure Monitor is configured to monitor the eShopOnWeb resources, it is time to simulate load on the SQL Server database and the eShopOnWeb website:
- Use HammerDB to create a transaction load on the "tpcc" database on the SQL Server
    - Download and Install HammerDB tool on the Visual Studio VM 
    - See sample [Instructions for using HammerDB](./Resources/Challenge-01/UsingHammerDB.md) to generate load on the "tpcc" database.
- Simulate a CPU load on the VM Scale Set using the [cpuGenLoadwithPS.ps1](./Resources/Challenge-01/cpuGenLoadwithPS.ps1) script located in the `/Challenge-01` folder of the student resource package.
    - This script is designed to be run directly on the VM instances in the VMSS.
    - **HINT:** You will need to upload this script to the VMs in order to run it on each instance.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you can collect the DB and CPU counters after load simulation and display them on a Dashboard.
- Verify the dashboard has the metric with a spike representing before and after the simulation.
- Show two fired alerts in the Portal and the email notifications received.

![enter image description here](../Images/01-04-Sample-dashboard.png)

## Learning Resources

- [Azure Monitor Overview](https://learn.microsoft.com/en-us/azure/azure-monitor/overview)
- [Azure Monitor Metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-platform-metrics)
- [Azure Monitor Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)
- [Azure Monitor Alerts](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview)
- [Azure Monitor Agent](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/agents-overview)
- [Collect events and performance counters from virtual machines with Azure Monitor Agent](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/data-collection-rule-azure-monitor-agent?tabs=portal)
- [HammerDB](https://www.hammerdb.com)
- [Finding the counter](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/get-counter?view=powershell-5.1) 
- [Run scripts in your Windows VM by using action Run Commands](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/run-command)
