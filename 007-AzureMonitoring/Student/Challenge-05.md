# Challenge 05 - Azure Monitor for Containers

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

In this challenge we will learn more about Container Insights and how it works.

## Description

In the eShopOnWeb Azure environment, there is an Azure Kubernetes Service (AKS) cluster with a containerized version of eShopOnWeb deployed on it:
- **`aks-wth-monitor-d-XX`** 

In Challenge 4, you configured the eShopOnWeb application to report application-level metrics to Application Insights. The containerized version of the application has already been pre-configured to report to the same Application Insights instance:
- **`ai-wth-monitor-d-XX`** 

The containerized version of eShopOnWeb is configured to work with the same SQL Server as the version hosted in IIS from the previous challenges:
- **`vmwthdbdXX`** 

>**Note** The "XX" in each resource name will vary based on the Azure region the eShopOnWeb Azure environment has been deployed to.

### Open the eShopOnWeb Website Hosted on AKS

The eShopOnWeb application is exposed to the Internet with an external IP address via a Kubernetes service named `eShop-Web`. 

- Open the eShopOnWeb website in your browser by navigating to the external Public IP of the Kubernetes service.

**HINT:** You can find the external IP address of the `eShop-web` service using either the Azure portal, or the Kubernetes CLI, `kubectl`.

**HINT:** You can access `kubectl` from the Azure Cloud Shell.  
- Authenticate `kubectl` with the `aks-wth-monitor-d-XX` AKS cluster in your lab environment:
    - `az aks get-credentials -g <resourcegroupname> -n aks-wth-monitor-d-XX`
- Retrieve the public IP address of the `eshop-web` Kubernetes service from the AKS cluster:
    - `kubectl get services`

### Observe eShopOnWeb with Container Insights

- From Azure Monitor, view the CPU and memory usage of the containers running the eShopOnWeb application
- Generate and view an exception in the eShopOnWeb application.
    - **HINT:** Try to change your password within the application.

## Success Criteria
- Verify you are able to see the exception in Application Insights.
- Verify you can you see the container insights live logs.

## Learning Resources

- [Install the Kubernetes CLI, `kubectl`, using the Azure CLI](https://learn.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-install-cli)
- [Install the Kubernetes CLI, `kubectl`, using PowerShell](https://learn.microsoft.com/en-us/powershell/module/az.aks/install-azaksclitool?view=azps-10.2.0)
- [Azure Container Monitoring](https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview)
- [How to set up the Live Data feature](https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-livedata-setup)