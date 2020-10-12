# What The Hack - Azure Arc enabled Kubernetes Hack

## Challenge 2 – Deploy Kubernetes cluster locally
[Back](challenge01.md) - [Home](../readme.md) - [Next](challenge03.md)

### Introduction

In this challenge lets built another cluster that will act has a remote cluster that will be Arc enabled. The cluster is going to be deployed locally via minikube. 

Once this challenge is complete, we will have a 2nd cluster deployed and ready to be managed by Azure Arc enabled Kubernetes. With minikube cluster deployed, we will be able to manage the cluster centrally via the Azure portal.

 ![](../img/image4.png)

### Challenge

1. Deploy a minikube cluster locally 
    *  Run ```kubectl get nodes -o wide``` with the ```kubectl``` context being that of a newly minikube cluster to verify cluster is ready to be Arc enabled.
2. If minikube cluster is not able to be deployed:
    * Deploy an Azure Kubernetes Service (AKS) cluster as a **remote** cluster that will be Arc enabled.
    * Another alternative, is to deploy a Kubernetes cluster locally via Ranger K3s.

### Success Criteria

This challenge will be complete when a 2nd cluster is successfully deployed and ready to be enabled for Azure Arc enabled Kuberenetes.

[Back](challenge01.md) - [Home](../readme.md) - [Next](challenge03.md)
