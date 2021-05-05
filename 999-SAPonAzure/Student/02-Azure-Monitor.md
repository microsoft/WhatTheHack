# Challenge 2: Azure Monitor SAP Workload On Azure. 

[< Previous Challenge](./01-SAP-Auto-Deployment.md) - **[Home](../README.md)** - [Next Challenge >](./03-SAP-Security.md)

## Introduction

With your SAP Landscape deployed, now you need to deploy Azure native monitoring services.  In this challenge, you'll configure and capture critical monitoring metrics for SAP solutions on Azure.

## Description

Configure Azure Monitor for SAP application that can fetch critical metrics for Virtual Machine, SAP Application and HANA database.

![SAP ON Azure Monitoring](Images/Challenge2_Azure_Monitor_SAP_Architecture.png)

In this challenge, we will Azure Monitoring to unlock the monitoring capabilities of Azure native monitoring services. We will configure monitoring data collection and ingestion of data into log analytics workspace for trend insights and custom dashboard.

- Enable VM Insights on the Virtual Machines hosting SAP Workload.

**VM Insights can be enabled from the Virtual Machine pane on Azure Portal, consider creating a Log Analytics workspace as a pre-requisites**

- Deploy Azure Monitor for SAP resource from Azure Portal.
	- This should be done by searching "Azure Monitor for SAP" as a service under the search option on Azure Portal.
- Create provider for SAP Netweaver  
- Create & configure OS, SAP HANA, & Netweaver providers (the docs are your friend!).
 
- Review availability of Monitoring stats in the Log Analytics workspace.
	- Hint: Select the Log Workspace that was used while enabling VM Insights and attach it to Azure Monitor for SAP.
- When monitoring data is ingested into Log workspace.
	- Execute standard kusto query to visualize the monitoring data.
- Create a custom dashboard.
	- Modify the standard query to create custom dashboard as required.
	- Hint:- Example custom queries are available for HoneyComb Dashboard.

## Success Criteria

1. Connect SAP to native Azure Monitoring services.
2. Check that monitoring data is flowing into your workspace.
3. Build a custom dashboard with the data

## Learning Resources

[Deploy Azure Monitor for SAP Solutions with Azure portal](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/sap/azure-monitor-sap-quickstart)

[AMS Netweaver Provider Portal Link (in preview)](https://ms.portal.azure.com/?feature.nwflag=true#home)

[Log Analytics Workspace] (https://docs.microsoft.com/en-us/azure/azure-monitor/logs/quick-create-workspace)

[VM Insights] (https://docs.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-enable-overview)
