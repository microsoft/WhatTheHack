# Challenge 05 - Azure Monitor for Containers

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

In this challenge we will learn more about Container Monitoring and how it works.

## Description

We have published a container that runs the eShopOnWeb website to Docker Hub. You can find that container here: `whatthehackmsft/eshoponweb-k8s`

We have provided you with a Kubernetes manifest YAML file that can deploy the eShopOnWeb container from Docker Hub to the AKS (Azure Kubernetes Service) cluster in your environment. You can find the `eshoponweb-kubernetes.yaml` in the `/Challenge-05` folder of the student `Resources.zip` file.

The containerized version of the eShopOnWeb application looks for the following secret values from environment variables:
- `ConnectionStrings__CatalogConnection`
- `ConnectionStrings__IdentityConnection`
- `ApplicationInsights__ConnectionString`

You will need to provide these secret values to the AKS cluster for the application to work.

### Deploy eShopOnWeb to Azure Kubernetes Service

The following steps will require the use of the Kubernetes CLI, `kubectl`, and the Azure CLI. If you do not have the Kubernetes CLI installed on your workstation, you can complete this challenge using the Azure Cloud Shell.

- Edit the `eshoponweb-kubernetes.yaml` file to provide the connection string values needed by the application.  

**HINT:** You can find the connection string values in the `appsettings.json` file in the `src/Web` folder of the eShopOnWeb project on the Visual Studio jumpbox (`vmwthvsdXX`).

**NOTE:** The `XX` in the Azure resource names will vary based on the Azure region you deployed the hack environment to in Challenge 0.

- Authenticate `kubectl` with the `aks-wth-monitor-d-XX` AKS cluster in your lab environment:
    - `az aks get-credentials -g <resourcegroupname> -n aks-wth-monitor-d-XX`
- Deploy the application to AKS:
    - `kubectl apply -f eshoponweb-kubernetes.yaml`
- Retrieve the public IP address of the `eshop-web` Kubernetes service from the AKS cluster:
    - `kubectl get services`
- Open the eShopOnWeb website in your browser by navigating to the Public IP of the Kubernetes service.

### Observe eShopOnWeb with Container Insights

- From Azure Monitor, view the CPU and memory usage of the containers running the eShoponWeb application
- Generate and view an exception in the eShoponWeb application.
    - **HINT:** Try to change your password within the application.

## Success Criteria
- Verify you are able to see the exception in Application Insights.
- Verify you can you see the container insights live logs.

## Learning Resources

- [Azure Container Monitoring](https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview)
- [How to set up the Live Data feature](https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-livedata-setup)