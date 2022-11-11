# Challenge 01 - Monitoring Basics and Dashboards

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

After deploying your initial solution for eshoponweb, you want to make sure that the telemetry is collected from the VMs deployed and display the results on a dashboard for visualization and alerting purposes. To accomplish this, you will have to understand the concept of counters, how to collect them, how to configure Alerts, and display them in a Dashboard.  

Once you have configured the dashboard, alerts, and counters to be collected, you will use two tools to simulate a load on the eShopOnWeb resources:
- HammerDB - A benchmarking and load testing tool for the world's most popular databases, including SQL Server.
- A custom script that produces CPU load on the eShopOnWeb website.

## Description

In the eShopOnWeb Azure environment, there are three compute resources to be aware of:
- **`vmss-wth-monitor-d-XX`** - Virtual Machine Scale Set (VMSS) hosting the eShopOnWeb web site
- **`vmwthdbdXX`** - Virtual Machine running SQL Server 2019 hosting the eShopOnWeb database
- **`vmwthvsdXX`** - Virtual Machine running Windows Server 2022 + Visual Studio 2022 + SQL Management Studio to act as a "jumpbox" that you will login to for administrative tasks.

>**Note** The "XX" in each resource name will vary based on the Azure region the eShopOnWeb Azure environment has been deployed to.

Azure Bastion has been configured to enable you to securely login to any of these VMs with a Remote Desktop session through a web brower. 

To login to a VM via Azure Bastion, navigate to the blade for any of these VMs in the Azure portal, click the "Connect" button, and select "Bastion". Use the username and password provided in Challenge 0.
 
### Set up Counters, Alerts, and Dashboard

In this challenge you need to complete the following management tasks:

- Create an empty database called “tpcc” on the SQL Server VM
	>**Note** Use SQL Auth with the username being "sqladmin" and password being whatever you used during deployment in Challenge 0.
    - **HINT:** You can use SQL Management Studio on either the SQL Server VM or the Visual Studio VM to create the database.

- Using AZ CLI, Powershell or ARM template, send the below guest OS metric to Azure Monitor for the SQL Server
	- Add a Performance Counter Metric:
	- Object: SQLServer:Databases
	- Counter: Active Transactions
	- Instance:tpcc

- From Azure Monitor, create a graph for the SQL Server Active Transactions and Percent CPU and pin to your Azure Dashboard

- From Azure Monitor, create an Action group, to send email to your address

- Create an Alert if Active Transactions goes over 40 on the SQL Server tpcc database.

- Create an Alert Rule for CPU over 75% on the Virtual Scale Set that emails me when you go over the threshold.
	- Note: In the Student\Resources\Loadscripts folder you will find a CPU load script to use.

### Simulate Load on the eShopOnWeb Environment

Now that Azure Monitor is configured to monitor the eShopOnWeb resources, it is time to simulate load on the SQL Server database and the eShopOnWeb website:
- Use HammerDB to create a transaction load on the "tpcc" database on the SQL Server
    - Download and Install HammerDB tool on the Visual Studio VM 
    - See sample [Instructions for using HammerDB](./Resources/Challenge-02/UsingHammerDB.md) to generate load on the "tpcc" database.
- Simulate a CPU load on the VM Scale Set using the `cpuGenLoadwithPS.ps1` script located in the `/Challenge-01` folder of the student resource package.
    - This script is designed to be run directly on the VM instances in the VMSS.
    - **HINT:** You will need to upload this script to the VMs in order to run it on each instance.


### Reconcile From Hack 2
### Tasks to finish the Challenge
- Create an empty DB "tpcc" in the SQL server
- Enable the collection of the following counter:
	- \SQLServer:Databases(*)\Active Transactions
- Stress the "tpcc" DB using HammerDB. For detailed instructions, see section [HammerDB Configuration]() below.
- Simulate a CPU load on the VM Scale Set using the [cpuGenLoadwithPS.ps1](https://github.com/msghaleb/AzureMonitorHackathon/blob/master/sources/Loadscripts/cpuGenLoadwithPS.ps1)
- Pin the metric of the above SQL counter as well as the average VMSS CPU utilization to your Dashboard
- Create an Alert to be notified in case the SQL active transactions went above 40
- Create an Alert to get notified if the average CPU load on the VMSS is above 75%
- Suppress the Alerts over the weekends


### Definition of Done:
Show the dashboard with the metric in it, which should also show a spike representing before and after the DB stress

![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/ch1_metric_spike.jpg)

## Success Criteria

To complete this challenge successfully, you should be able to:

- Stress the SQL using HammerDB
- Verify that you can collect the DB and CPU counter of the VMSS after loading the CPU, and display them on a Dashboard.
- Verify the dashboard has the metric with a spike representing before and after the DB stress.

## Learning Resources

- [Install and configure Windows Azure diagnostics extension (WAD) using Azure CLI](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/diagnostics-extension-windows-install#azure-cli-deployment)
- [HammerDB](https://www.hammerdb.com)
- [Finding the counter](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/get-counter?view=powershell-5.1)
- [In case you will modify the code (keep in mind you need to convert to bicep and match the syntax)](https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/collect-custom-metrics-guestos-resource-manager-vm)
- [Converting to bicep and bicep playground](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/bicep-decompile?tabs=azure-cli)
