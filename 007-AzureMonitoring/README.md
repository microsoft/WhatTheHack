# Azure Monitoring

## Introduction

This challenge-based Azure Monitoring workshop is intended to teach you how to monitor Azure workloads. During this day you will be working Azure Monitor, Log Analytics and Application Insights.

## Learning Objectives

Understand Azure Monitor capabilities, facilitate an Azure Monitor customer conversation, and demo key features of Azure Monitor.

## Challenges

- Challenge 0: **[Getting Started](Student/00-Prerequisites.md)**
- Challenge 1: **[Monitoring and Alert Rule](Student/01-Monitoring-And-Alert-Rule.md)**
- Challenge 2: **[Monitoring and Alert Rule Automation](Student/02-Monitoring-And-Alert-Rule-Automation.md)**
- Challenge 3: **[Application Insights](Student/03-Application-Insights.md)**
- Challenge 4: **[Azure Monitor for Containers](Student/04-Azure-Monitor-For-Containers.md)**
- Challenge 5: **[Log Analytics Query](Student/05-Log-Analytics-Query.md)**
- Challenge 6: **[Optional Logs](Student/06-Optional-Logs.md)**
- Challenge 7: **[Dashboard and Analytics](Student/07-Dashboard-And-Analytics.md)**
- Challenge 8: **[Workbooks](Student/08-Workbooks.md)**

## Prerequisites

1. Please review the following docs before or during the event when necessary
    - [Send Guest OS metrics to the Azure Monitor metric store](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/collect-custom-metrics-guestos-resource-manager-vm)

    - [Get Started with Metrics Explorer](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-getting-started)

    - [View and Manage Alerts in Azure Portal](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-metric#view-and-manage-with-azure-portal)

    - [Create metric alerts with ARM templates](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-metric-create-templates)

    - [Create Action Rules](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-action-rules)

    - [Monitor your Kubernetes Cluster](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-analyze)

    - [View Kubernetes logs, events, and pod metrics in real-time](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-livedata-overview)

    - [Start Monitoring Your ASP.NET Core Web Application](https://docs.microsoft.com/en-us/azure/azure-monitor/learn/dotnetcore-quick-start)

    - [What does Application Insights Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview#what-does-application-insights-monitor)

    - [Grafana Integration](https://grafana.com/grafana/plugins/grafana-azure-monitor-datasource)

    - [Create interactive reports with workbooks](https://docs.microsoft.com/en-us/azure/azure-monitor/app/usage-workbooks)

2. Attendees have access to an Azure Subscription where they can each deploy the provided ARM template that will build a very detailed infrastructure to monitor.  This includes the Vnet, subnets, NSG(s), LB(s), NAT rules, scales set and a fully functional .NET Core Application (eShopOnWeb) to monitor.
3. Attendees should have a level 200-300 understanding of the Azure platform.  Understand concepts like PowerShell, Azure Cli, ARM, resource groups, RBAC, network, storage, compute, scale sets, virtual machines and security.  Previous experience working with ARM templates is recommended.
4. Access to a machine with Visual Studio Code and the Azure PowerShell Modules loaded or Azure CLI. VS Code ARM and PowerShell extensions should be configured.

![Hack Diagram](./Images/monitoringhackdiagram.png)
