# Challenge 02 - Monitoring Basics and Dashboards

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

After deploying your initial solution for eShopOnWeb, you want to make sure that the telemetry is collected from the VMs deployed and display the results on a dashboard for visualization and alerting purposes. To accomplish this, you will have to understand the concept of counters, how to collect them, and how to display them on a Dashboard.

## Description

In the eShopOnWeb Azure environment, there are three compute resources to be aware of:
- **`vmss-wth-monitor-d-eu`** - Virtual Machine Scale Set (VMSS) hosting the eShopOnWeb web site
- **`vmwthdbdeu`** - Virtual Machine running SQL Server 2019 hosting the eShopOnWeb database
- **`vmwthvsdeu`** - Virtual Machine running Windows Server 2022 + Visual Studio 2022 to act as a "jumpbox" that you will login to for administrative tasks.

Azure Bastion has been configured to enable you to securely login to any of these VMs with a Remote Desktop session through a web brower. 

To login to a VM via Azure Bastion, navigate to the blade for any of these VMs in the Azure portal, click the "Connect" button, and select "Bastion". Use the username and password provided in Challenge 0.

Using HammerDB to stress the SQL database, you will collect the database and CPU counters of the VMSS using Datadog and display the results on the dashboard.

In this challenge you need to complete the following management tasks:
- Create an empty database called “tpcc” on the SQL Server VM
    **NOTE:** Use SQL Auth with the username being sqladmin and password being whatever you used during deployment
- On the SQL Server VM, complete the Datadog install and configure database monitoring
    - Configure Datadog agent's API key
    - Update the sample SQL Server check in order to connect to the DB
    - Run the Datadog agent's `status` subcommand and look for `sqlserver` in the Checks section  
    - Find sqlserver.queries.count in Metrics Explorer
- Use HammerDB to create transaction load
    - Download and Install HammerDB tool on the Visual Studio VM 
    - Instructions for setting up and using HammerDB are in the `/Challenge-02` folder from the student `Resources.zip` file.
- From Datadog, create a graph for the SQL Server Queries and Percent CPU, then add both to a Dashboard
- From Datadog, create an Alert to send an email for the following:
- Create an Alert if Queries goes over 40 on the SQL Server tpcc database.
- Create an Alert for CPU over 75% on the Virtual Machine Scale Set that emails me when you go over the threshold.
    **NOTE:** In the `\Challenge-02` folder you will find a CPU load script to use.


## Success Criteria

*Success criteria goes here. The success criteria should be a list of checks so a student knows they have completed the challenge successfully. These should be things that can be demonstrated to a coach.* 

*The success criteria should not be a list of instructions.*

*Success criteria should always start with language like: "Validate XXX..." or "Verify YYY..." or "Show ZZZ..." or "Demonstrate you understand VVV..."*

*Sample success criteria for the IoT sample challenge:*

To complete this challenge successfully, you should be able to:
- Verify that the IoT device boots properly after its thingamajig is configured.
- Verify that the thingamajig can connect to the mothership.
- Demonstrate that the thingamajic will not connect to the IoTProxyShip

## Learning Resources

- [SQL Server Integration Tile](https://us3.datadoghq.com/integrations/sql-server)
- [Datadog SQL Server DBM Docs](https://docs.datadoghq.com/database_monitoring/setup_sql_server/selfhosted/?tab=sqlserver2014)
- [Datadog Windows Agent Guide (CLI)](https://docs.datadoghq.com/agent/basic_agent_usage/windows/?tab=commandline)
