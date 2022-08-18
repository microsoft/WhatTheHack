# Challenge 03 - Introduction To Kubernetes

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

Now it is time to introduce the container orchestrator we all came for: Kubernetes!

## Description

In this challenge we will be provisioning our first Kubernetes cluster using the Azure Kubernetes Service (AKS). This will give us an opportunity to learn how to use the `kubectl` kubernetes command line tool, as well as using the Azure CLI to issue commands to AKS.

- Install the Kubernetes command line tool (`kubectl`).
	- **Hint:** This can be done easily with the Azure CLI
- Use the Azure CLI to create a new, multi-node AKS cluster with the following specifications:
	- Use the default Kubernetes version used by AKS.
	- The cluster should use kubenet (ie: basic networking).  
	- The cluster should use a managed identity
	- The cluster should use the maximum number of Availability Zones for improved worker node reliability.
	- The cluster should attach to your ACR created in Challenge 2 (if you didn't do Challenge 2, you don't need to attach to anything).
      - **NOTE:** Attaching an ACR requires you to have "Owner" or "Azure account administrator" role on the Azure subscription. If this is not possible then someone who is an Owner can do the attach for you after you create the cluster.
    - **NOTE:** You will need to specify on the command line if you want ssh keys generated or no ssh keys used. Either option will work, but you should read the documentation and be familiar with the difference.

Once the cluster is running:
- Use kubectl to prove that the cluster is a multi-node cluster and is working properly.
- Use kubectl to examine which availability zone each node is in.  
- **Optional:** Bring up the AKS "Workloads" screen in the Azure portal.
	- **Hint:** Again, the Azure CLI makes this very easy with one command.
	- **NOTE:** This will not work if you are using a Linux jump box to connect to your cluster.

## Success Criteria

1. The kubectl CLI is installed.
1. Show that a new, multi-node AKS kubernetes cluster exists.
1. Show that its nodes are running in multiple availability zones.
1. Show that it is using basic networking (kubenet)

## Learning Resources

- [Azure Kubernetes Service (AKS) and availability zones](https://docs.microsoft.com/en-us/azure/aks/availability-zones)
