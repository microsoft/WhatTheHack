# Challenge 05 - Scaling and High Availability

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

Now that you have your application running there are a few things to consider. How do you make it responsive? How do you make it resilient? How do you control costs while mananging load? In this challenge, we'll find that out.

## Description

In this challenge we will cover scale and resiliency from multiple aspects. We'll make sure enough replicas of our container are running to handle load. We'll make sure that there are enough resources in our cluster to handle all the containers we want to run and we'll figure out how Kubernetes repairs itself.

* Scale the nodes for the node pool in the AKS cluster from 3 to 1.  Make sure you watch the pods after you perform the scale operation.  You can use an Azure CLI command like the following to do this:

  **`az aks nodepool scale --resource-group wth-rg01-poc --cluster-name wth-aks01-poc --name nodepool1 --node-count 1`**

* Next, scale the **Web** app to 2 instances
	- This should be done by modifying the YAML file for the Web app and re-deploying it 
*  Now, scale the **API** app to 4 instances using the same technique.  
* Watch events using kubectl with its special watch option.
   - You will find an error occurs because the cluster does not have enough resources to support that many instances.
   - There are two ways to fix this problem: 
     1. Increase the size of your cluster, either manually, or by enabling the cluster autoscaler.
     2. Decrease the resources needed by the deployments
  - For this exercise, we want you to adjust the resources used by your deployments.
* To fully deploy the application, you will need 4 instances of the API app running and 2 instances of the Web app. 
	- Hint: If you fixed the issue above correctly (look at pod resource request!), you should be able to do this with the resources of your original cluster.
* When your cluster is fully deployed, browse to the `/stats.html` page of the web application.
	- Keep refreshing to see the API app’s host name keep changing between the deployed instances.
* Scale the API app back down to 1, and immediately keep refreshing the `/stats.html` page.
	- You will notice that without any downtime it now directs traffic only to the single instance left.

## Success Criteria

1. Verify that you can scale your cluster down to 1 node.
1. Verify that you can run 2 replicas of content-web.
1. Verify that you can run 4 replicas of content-api.
1. Validate that you have fixed the resource issues.

## Learning Resources

* [How to watch Kubernetes events](https://stackoverflow.com/questions/45226732/what-kubectl-command-can-i-use-to-get-events-sorted-by-specific-fields-and-print)