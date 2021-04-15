# Challenge 5: Build Mobile Application around SAP. 

[< Previous Challenge](./04-k8sdeployment.md) - **[Home](../README.md)** - [Next Challenge >](./06-deploymongo.md)

## Introduction

Mango Inc has established SAP landscape for several years. Now Mango Inc wants to enable users with simplified mobile user interface that requires data from multiple sources and one of the data source is S/4 Hana system. Assume that production workers on site want to know material information on their mobile devices. How do you build mobile application using No/Low code platform that can interact with SAP system seemlessly? In this challenge, we'll find that out.

## Description

Build a simple power application for Tablet that can  fetch available materials from the user sales organization and plant. Application should also allow user to select material from the list and display complete details for that material upon selection. High level architecture for this application may look like as shown below. 

[[/images/Challenge5-SampleArchiteture.png|ALT TEXT]]

![image](../images/Challenge5-SampleArchiteture.png)




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

1. You can scale your cluster down to 1 node.
1. Run 2 replicas of content-web.
1. Run 4 replicas of content-api.
1. Fix the resource issues.
