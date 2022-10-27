# Challenge 02 - Monitoring Basics and Dashboards

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

After deploying your initial solution for eShopOnWeb, you want to make sure that the telemetry is collected from the VMs deployed and display the results on a dashboard for visualization and alerting purposes. To accomplish this, you will have to understand the concept of counters, how to collect them, and how to display them on a dashboard using Datadog.

Once you have configured the counters to be collected, you will use two tools to simulate a load on the eShopOnWeb resources:
- HammerDB - A benchmarking and load testing tool for the world's most popular databases, including SQL Server.
- A custom script that produces CPU load on the eShopOnWeb website.

Feel free to achieve these objectives using the Azure portal, Datadog portal, Azure CLI, or Terraform.

## Description

In the eShopOnWeb Azure environment, there are three compute resources to be aware of:
- **`vmss-wth-monitor-d-XX`** - Virtual Machine Scale Set (VMSS) hosting the eShopOnWeb web site
- **`vmwthdbdXX`** - Virtual Machine running SQL Server 2019 hosting the eShopOnWeb database
- **`vmwthvsdXX`** - Virtual Machine running Windows Server 2022 + Visual Studio 2022 + SQL Management Studio to act as a "jumpbox" that you will login to for administrative tasks.

>**Note** The "XX" in each resource name will vary based on the Azure region the eShopOnWeb Azure environment has been deployed to.

Azure Bastion has been configured to enable you to securely login to any of these VMs with a Remote Desktop session through a web brower. 

To login to a VM via Azure Bastion, navigate to the blade for any of these VMs in the Azure portal, click the "Connect" button, and select "Bastion". Use the username and password provided in Challenge 0.

In this challenge you need to complete the following management tasks:
- Create an empty database called “tpcc” on the eShopOnWeb SQL Server
    >**Note** Use SQL Auth with the username being "sqladmin" and password being whatever you used during deployment in Challenge 0.
    - **HINT:** You can use SQL Management Studio on either the SQL Server VM or the Visual Studio VM to create the database.
- On the SQL Server VM:
    - Update the sample SQL Server check in order to connect to the DB
    - Run the Datadog agent's `status` subcommand and look for `sqlserver` in the Checks section  
    - Find `sqlserver.queries.count` in Metrics Explorer
- From Datadog, create a graph for the SQL Server Queries and Percent CPU, then add both to a Dashboard
- From Datadog, create an Alert to send an email for the following:
    - Create an Alert to be notified if Queries goes over 40 on the SQL Server tpcc database.
    - Create an Alert to be notified for CPU over 75% on the Virtual Machine Scale Set that sends an email when you go over the threshold.

Now that Datadog is configured to monitor the eShopOnWeb resources, it is time to simulate load on the SQL Server database and the eShopOnWeb website:
- Use HammerDB to create a transaction load on the "tpcc" database on the SQL Server
    - Download and Install HammerDB tool on the Visual Studio VM 
    - See sample [Instructions for using HammerDB](./Resources/Challenge-02/UsingHammerDB.md) to generate load on the "tpcc" database.
- Simulate a CPU load on the VM Scale Set using the `cpuGenLoadwithPS.ps1` script located in the `/Challenge-02` folder of the student resource package.
    - This script is designed to be run directly on the VM instances in the VMSS.
    - **HINT:** You will need to upload this script to the VMs in order to run it on each instance.

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that the Datadog is collecting the metrics.
- Show the Datadog dashboard with the database metric in it, which should show a spike representing before and after the database stress test.
- Show the Datadog dashboard with the CPU metric in it, which should show a spoke representing before and after the CPU load test.

## Learning Resources

- [SQL Server Integration Tile](https://us3.datadoghq.com/integrations/sql-server)
- [Datadog SQL Server DBM Docs](https://docs.datadoghq.com/database_monitoring/setup_sql_server/selfhosted/?tab=sqlserver2014)
- [Datadog Windows Agent Guide (CLI)](https://docs.datadoghq.com/agent/basic_agent_usage/windows/?tab=commandline)
