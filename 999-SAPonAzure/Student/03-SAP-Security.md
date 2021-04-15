# Challenge 3: Introduction To Kubernetes

[< Previous Challenge](./02-acr.md) - **[Home](../README.md)** - [Next Challenge >](./04-k8sdeployment.md)

## Introduction

Now it is time to introduce the container orchestrator we all came for: Kubernetes!

## Description

In this challenge we will be provisioning our first Kubernetes cluster using the Azure Kubernetes Service (AKS). This will give us an opportunity to learn how to use the `kubectl` kubernetes command line tool, as well as using the Azure CLI to issue commands to AKS.

- Install the Kubernetes command line tool (`kubectl`).
	- **Hint:** This can be done easily with the Azure CLI.
- Create a new, multi-node AKS cluster.
	- Use the default Kubernetes version used by AKS.
	- The cluster will use basic networking and kubenet.  
	- The cluster will use a managed identity
	- The cluster will use Availability Zones for improved worker node reliability.
- Use kubectl to prove that the cluster is a multi-node cluster and is working.
- Use kubectl to examine which availability zone each node is in.  
- **Optional:** Bring up the Kubernetes dashboard in your browser
	- **Hint:** Again, the Azure CLI makes this very easy.
	- **NOTE:** This will not work if you are using an Ubuntu Server jump box to connect to your cluster.
	- **NOTE:** Since the cluster is using RBAC by default, you will need to look up how to enable the special permissions needed to access the dashboard.

## Success Criteria

1. The kubectl CLI is installed.
1. Show that a new, multi-node AKS kubernetes cluster exists.
1. Show that its nodes are running in multiple availability zones.
1. Show that it is using basic networking (kubenet)