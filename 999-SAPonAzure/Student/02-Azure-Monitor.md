# Challenge 2: Azure Monitor SAP Workload On Azure. 

[< Previous Challenge](./04-k8sdeployment.md) - **[Home](../README.md)** - [Next Challenge >](./03-SAP-Security.md)

## Introduction

Mango Inc has migrated SAP landscape on Microsoft Cloud Azure. Now Mango Inc wants to enable Azure native monitoring services to monitor SAP Solution on Azure. It is critical for Mango Inc to monitor and review resource usage trend for last 30 days. How to configure & capture critical monitoring metrics for SAP Solution on Azure? In this challenge, we'll find that out.

## Description

Configure Azure Monitor for SAP application that can  fetch critical metrics for Virtual Machine, SAP Application and HANA database.Application should also allow user to select material from the list and display complete details for that material upon selection. High level architecture for this application may look like as shown below. 





In this challenge we will cover scale and resiliency from multiple aspects. We'll make sure enough replicas of our container are running to handle load. We'll make sure that there are enough resources in our cluster to handle all the containers we want to run and we'll figure out how Kubernetes repairs itself.

- Scale the nodes in the AKS cluster from 3 to 1.  Make sure you watch the pods after you perform the scale operation.  You can use an Azure CLI command like the following to do this:

**`az aks nodepool scale --resource-group wth-rg01-poc --cluster-name wth-aks01-poc --name nodepool1 --node-count 1`**

- Scale the **Web** app to 2 instances
	- This should be done by modifying the YAML file for the Web app and re-deploying it 
- Scale the **API** app to 4 instances using the same technique as above.  
- Watch events using kubectl with its special watch option (the docs are your friend!).
	- You will find an error occurs because the cluster does not have enough resources to support that many instances.
	- There are three ways to fix this: increase the size of your cluster, decrease the resources needed by the deployments or deploy the cluster autoscaler to your cluster.  
- To fully deploy the application, you will need 4 instances of the API app running and 2 instances of the Web app. 
	- Hint: If you fixed the issue above correctly (look at pod resource request!), you should be able to do this with the resources of your original cluster.
- When your cluster is fully deployed, browse to the “/stats.html” page of the web application.
	- Keep refreshing to see the API app’s host name keep changing between the deployed instances.
- Scale the API app back down to 1, and immediately keep refreshing the `/stats.html` page.
	- You will notice that without any downtime it now directs traffic only to the single instance left.

## Success Criteria

Task1: Create a Log Analytics Workspace.
Task2: Deploy Azure Monitor for SAP.
Task3: Enable VM Insights on Virtual Machines running SAP Workloads and connect to log analytics workspace created as part of Task1.
Task4: Configure OS, SAP NetWeaver providers.
Task5: Check for Monitoring data in Log Analytics Workspace.
Task6: Use Kusto query to create custom dashboard and setup alerts.
