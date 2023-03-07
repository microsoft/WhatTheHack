# What The Hack - Azure Monitoring

## Introduction

The Azure Monitoring v2.0 What the Hack (WTH) provides hands on experience on how to monitor Azure workloads using Azure Monitor, Log Analytics, Insights, Workbooks and Grafana. This hack was designed specifically for Infrastructure engineers, DevOps engineers, administrators and IT architects who want to build their knowledge on Azure Monitor. However, anyone with a passion around Monitoring is welcome!  

![Hack Intro](./Images/header.png) 

## Learning Objectives

In this hack, you will be getting hands on experience with monitoring resources (VMs, applications, containers) using Azure Monitoring capabilities such as log analytics, dashboards, and KQL. Additionally, Grafana has been introduced to add additional visualization tools.

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Monitoring Basics: Metrics, Logs, Alerts and Dashboards](Student/Challenge-01.md)**
	 - Description of challenge
- Challenge 02: **[Metric and Activity Log alerts via Automation](Student/Challenge-02.md)**
	 - Description of challenge
- Challenge 03: **[Azure Monitor for Virtual Machines](Student/Challenge-03.md)**
	 - Description of challenge
- Challenge 04: **[Azure Monitor for Applications](Student/Challenge-04.md)**
	 - Description of challenge
- Challenge 05: **[Azure Monitor for Containers](Student/Challenge-05.md)**
	 - Description of challenge
- Challenge 06: **[Log Queries with KQL and Grafana](Student/Challenge-06.md)**
	 - Description of challenge
- Challenge 07: **[Visualizations](Student/Challenge-07.md)**
	 - Description of challenge

## Prerequisites

1. Please review the following docs before or during the event when necessary

    - [View and Manage Alerts in Azure Portal](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-metric#view-and-manage-with-azure-portal)
    - [Create metric alerts with ARM templates](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-metric-create-templates)
    - [Send Guest OS metrics to the Azure Monitor metric store](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/collect-custom-metrics-guestos-resource-manager-vm)
    - [Get Started with Metrics Explorer](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-getting-started)
    - [Create Action Rules](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-action-rules)
    - [Monitor your Kubernetes Cluster](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-analyze)
    - [View Kubernetes logs, events, and pod metrics in real-time](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-livedata-overview)
    - [Start Monitoring Your ASP.NET Core Web Application](https://docs.microsoft.com/en-us/azure/azure-monitor/learn/dotnetcore-quick-start)
    - [What does Application Insights Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview#what-does-application-insights-monitor)
    - [Grafana Integration](https://grafana.com/grafana/plugins/grafana-azure-monitor-datasource)
    - [Create interactive reports with workbooks](https://docs.microsoft.com/en-us/azure/azure-monitor/app/usage-workbooks)

1. Attendees have access to an Azure Subscription where they can each deploy the provided ARM template that will build a very detailed infrastructure to monitor.  This includes the Vnet, subnets, NSG(s), LB(s), NAT rules, scales set and a fully functional .NET Core Application (eShopOnWeb) to monitor.
1. Attendees should have a level 200-300 understanding of the Azure platform.  Understand concepts like PowerShell, Azure Cli, ARM, resource groups, RBAC, network, storage, compute, scale sets, virtual machines and security.  Previous experience working with ARM templates is recommended.
1. Access to a machine with Visual Studio Code and the Azure PowerShell Modules loaded or Azure CLI. VS Code ARM and PowerShell extensions should be configured.

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
