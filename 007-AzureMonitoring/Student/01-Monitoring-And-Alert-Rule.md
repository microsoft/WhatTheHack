# Challenge 1: Monitoring and Alert Rule

[Previous Challenge](./00-Prerequisites.md) - **[Home](../README.md)** - [Next Challenge>](./02-Monitoring-And-Alert-Rule-Automation.md)

## Introduction

## Description

In this challenge you need to complete the following management tasks:

Create an empty database called “tpcc” on the SQL Server VM
Note: Use SQL Auth with the username being sqladmin and password being whatever you used during deployment
Using AZ CLI, Powershell or ARM template, send the below guest OS metric to Azure Monitor for the SQL Server
Add a Performance Counter Metric:
Object: SQLServer:Databases
Counter: Active Transactions
Instance:tpcc

Download and Install HammerDB tool on the Visual Studio VM (instructions are in your Student\Guides\Day-1 folder for setting up and using [HammerDB](www.hammerdb.com).

Use HammerDB to create transaction load
From Azure Monitor, create a graph for the SQL Server Active Transactions and Percent CPU and pin to your Azure Dashboard
From Azure Monitor, create an Action group, to send email to your address
Create an Alert if Active Transactions goes over 40 on the SQL Server tpcc database.
Create an Alert Rule for CPU over 75% on the Virtual Scale Set that emails me when you go over the threshold.Note: In the Student\Resources\Loadscripts folder you will find a CPU load script to use.

## Success Criteria

## Learning Resources

[Install and configure Windows Azure diagnostics extension (WAD) using Azure CLI](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/diagnostics-extension-windows-install#azure-cli-deployment)
