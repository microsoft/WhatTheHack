# What The Hack - Azure Monitoring

## Introduction

The Azure Monitoring v2.0 What the Hack (WTH) provides hands on experience on how to monitor Azure workloads using Azure Monitor, Log Analytics, Application Insights, and Azure Monitor Workbooks. This hack was designed specifically for infrastructure engineers, DevOps engineers, administrators and IT architects who want to build their knowledge on Azure Monitor. However, anyone with a passion for Monitoring is welcome!  

![Hack Intro](./Images/header.png) 

## Learning Objectives

In this hack, you will be getting hands on experience with monitoring resources (VMs, applications and containers) using Azure Monitor capabilities such as log analytics, dashboards and Kusto Query Language (KQL).

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
	 - Prepare your Azure environement and deploy your eShopOnWeb application.
- Challenge 01: **[Monitoring Basics: Metrics, Logs, Alerts and Dashboards](Student/Challenge-01.md)**
	 - Configure basic monitoring and alerting
- Challenge 02: **[Setting up Monitoring via Automation](Student/Challenge-02.md)**
	 - Automate deployment of Azure Monitor at scale
- Challenge 03: **[Azure Monitor for Virtual Machines](Student/Challenge-03.md)**
	 - Configure VM Insights and monitoring of virtual machine performance
- Challenge 04: **[Azure Monitor for Applications](Student/Challenge-04.md)**
	 - Monitoring applications for issues
- Challenge 05: **[Azure Monitor for Containers](Student/Challenge-05.md)**
	 - Monitoring containers performance and exceptions
- Challenge 06: **[Log Queries with Kusto Query Language (KQL)](Student/Challenge-06.md)**
	 - Use the Kusto Query Language (KQL) to write and save queries
- Challenge 07: **[Visualizations](Student/Challenge-07.md)**
	 - Create visualizations to build insights from the data collected in the previous challenges

## Prerequisites

1. Please review the following docs before or during the event when necessary

    - [View and Manage Alerts in Azure Portal](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/alerts-metric#view-and-manage-with-azure-portal)
    - [Create metric alerts with ARM templates](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/alerts-metric-create-templates)
    - [Send Guest OS metrics to the Azure Monitor metric store](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/collect-custom-metrics-guestos-resource-manager-vm)
    - [Get Started with Metrics Explorer](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/metrics-getting-started)
    - [Create Action Rules](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/alerts-action-rules)
    - [Monitor your Kubernetes Cluster](https://learn.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-analyze)
    - [View Kubernetes logs, events, and pod metrics in real-time](https://learn.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-livedata-overview)
    - [Start Monitoring Your ASP.NET Core Web Application](https://learn.microsoft.com/en-us/azure/azure-monitor/learn/dotnetcore-quick-start)
    - [What does Application Insights Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview#what-does-application-insights-monitor)
    - [Create interactive reports with workbooks](https://learn.microsoft.com/en-us/azure/azure-monitor/app/usage-workbooks)

2. Attendees have access to an Azure Subscription where they can each deploy the provided ARM template that will build a very detailed infrastructure to monitor.  This includes the Vnet, subnets, NSG(s), LB(s), NAT rules, scales set and a fully functional .NET Core Application (eShopOnWeb) to monitor.
3. Attendees should have a level 200-300 understanding of the Azure platform.  Understand concepts like PowerShell, Azure CLI, ARM, resource groups, RBAC, network, storage, compute, scale sets, virtual machines and security.  Previous experience working with ARM templates is recommended.
4. Access to a machine with Visual Studio Code and the Azure PowerShell Modules loaded or Azure CLI. VS Code ARM and PowerShell extensions should be configured.

## Contributors

- [Robert Kuehfus](https://github.com/rkuehfus)
- [Kayode Prince](kayodeprinceMS)
- [Mohamed Ghaleb](https://github.com/msghaleb)
- [Jason Masten](https://github.com/jamasten)
- [Vanessa Bruwer](https://github.com/vanessabruwer)
- [Martina Lang](https://github.com/martinalang)
- [Sherri Babylon](https://github.com/shbabylo)
- [Peter Laudati](https://github.com/jrzyshr)
- [Maria Botova](https://github.com/MariaBTV)
- [Warren Kahn](https://github.com/WKahnZA)

