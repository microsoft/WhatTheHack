# Challenge 2: Azure Monitor SAP Workload On Azure. 

[< Previous Challenge](./01-SAP-Auto-Deployment.md) - **[Home](../README.md)** - [Next Challenge >](./03-SAP-Security.md)

## Introduction

Mango Inc has migrated the SAP landscape on Microsoft Cloud Azure. Now Mango Inc wants to enable Azure native monitoring services to monitor SAP Solution on Azure. It is critical for Mango Inc to monitor and review resource usage trend for the last 30 days. How to configure & capture critical monitoring metrics for SAP Solution on Azure? In this challenge, we'll find that out.

## Description

Configure Azure Monitor for SAP application that can fetch critical metrics for Virtual Machine, SAP Application and HANA database. The application should also allow users to select material from the list and display complete details for that material upon selection. High-level architecture for this application may look like as shown below.


![SAP ON Azure Monitoring](Images/Challenge2_Azure_Monitor_SAP_Architecture.png)


In this challenge, we will Azure Monitoring to unlock the monitoring capabilities of Azure native monitoring services. We will configure monitoring data collection and ingestion of data into log analytics workspace for trend insights and custom dashboard.

- Enable VM Insights on the Virtual Machines hosting SAP Workload.

**VM Insights can be enabled from the Virtual Machine pane on Azure Portal, consider creating a Log Analytics workspace as a pre-requisites**

- Deploy Azure Monitor for SAP resource from Azure Portal.
	- This should be done by searching "Azure Monitor for SAP" as a service under the search option on Azure Portal.
- Create provider for SAP Netweaver  
- Create & configure SAP HANA & Netweaver providers (the docs are your friend!).
	- You will find an error occurs because the cluster does not have enough resources to support that many instances.
	- There are three ways to fix this: increase the size of your cluster, decrease the resources needed by the deployments or deploy the cluster autoscaler to your cluster.  
- Review availability of Monitoring stats in the Log Analytics workspace.
	- Hint: Select the Log Workspace that was used while enabling VM Insights and attach it to Azure Monitor for SAP.
- When monitoring data is ingested into Log workspace.
	- Execute standard kusto query to visualize the monitoring data.
- Create a custom dashboard.
	- Modify the standard query to create custom dashboard as required.
	- Hint:- Example custom queries are available for HoneyComb Dashboard.

## Success Criteria

- Task1: Create a Log Analytics Workspace.
- Task2: Deploy Azure Monitor for SAP.
- Task3: Enable VM Insights on Virtual Machines running SAP Workloads and connect to log analytics workspace created as part of Task1.
- Task4: Configure OS, SAP NetWeaver providers.
- Task5: Check for Monitoring data in Log Analytics Workspace.
- Task6: Use Kusto query to create custom dashboard and setup alerts.
