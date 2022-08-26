# Challenge 02 - Monitoring Basics and Dashboards

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

After deploying your initial solution for eshoponweb, you want to make sure that the telemetry is collected from the VMs deployed and display the results on a dashboard for visualization and alerting purposes. To accomplish this, you will have to understand the concept of counters, how to collect them, how to configure Alerts and display them in a Dashboard.  

## Description

Using HammerDB to stress the SQL database, you will collect the database and CPU counters of the VMSS after loading the CPU and display the results on the dashboard.
 
In this challenge you need to complete the following management tasks:

- Create an empty database called “tpcc” on the SQL Server VM
	- Note: Use SQL Auth with the username being sqladmin and password being whatever you used during deployment

- Using AZ CLI, Powershell or ARM template, send the below guest OS metric to Azure Monitor for the SQL Server
	- Add a Performance Counter Metric:
	- Object: SQLServer:Databases
	- Counter: Active Transactions
	- Instance:tpcc

- Use HammerDB to create transaction load
	- Download and Install HammerDB tool on the Visual Studio VM (instructions are in your Student\Guides\Day-1 folder for setting up and using [HammerDB](www.hammerdb.com).

- From Azure Monitor, create a graph for the SQL Server Active Transactions and Percent CPU and pin to your Azure Dashboard

- From Azure Monitor, create an Action group, to send email to your address

- Create an Alert if Active Transactions goes over 40 on the SQL Server tpcc database.

- Create an Alert Rule for CPU over 75% on the Virtual Scale Set that emails me when you go over the threshold.
	- Note: In the Student\Resources\Loadscripts folder you will find a CPU load script to use.

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

### HammerDB Configuration

#### Stress the Database using HammerDB 
- From the Visual Studio Server, download and install the latest version of [HammerDB](http://www.hammerdb.com/)
  ![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image13.png)    
- Open HammerDB and double click on SQL Server to start configuring the transaction load. In the dialog that opens, click OK.
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image18.png)   

- Drill into SQL Server \\ TPC-C \\ Schema Build and double click on **Options**
- Modify the Build Options for the following:
	- SQL Server: Name of your SQL Server
	- SQL Server ODBC Driver: SQL Server
	- Authentication: SQL Server Authentication
	- SQL Server User ID: sqladmin
	- SQL Server User Password: \<password  you  used during the deployment\>
	- SQL Server Database: tpcc
	- Number of Warehouses: 50
	- Virtual Users to Build Schema: 50  
>**Note: **Setting the last two at 50 should generate enough load to trip a threshold and run long enough for you to graph to show a spike

  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image19.png)
  
- Double click on Build and Click Yes to kick of a load test.
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image20.png)
  
When the test is running it should look like the screenshot below:
>**TIP:** If you would like to run a second test you **must** first delete the database you created and recreate it. HammerDB will not run a test against a database that has data in it. When you run a test is fills the database with a bunch of sample data.
  

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image21.png) 


## Success Criteria

Stress the SQL using HammerDB, collect the DB and CPU counter of the VMSS after loading the CPU, and display them on a Dashboard. The dashboard should have the metric with a spike representing before and after the DB stress.

## Learning Resources

- [Install and configure Windows Azure diagnostics extension (WAD) using Azure CLI](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/diagnostics-extension-windows-install#azure-cli-deployment)
- [HammerDB](https://www.hammerdb.com)
- [Finding the counter](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/get-counter?view=powershell-5.1)
- [In case you will modify the code (keep in mind you need to convert to bicep and match the syntax)](https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/collect-custom-metrics-guestos-resource-manager-vm)
- [Converting to bicep and bicep playground](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/bicep-decompile?tabs=azure-cli)
