# Challenge 13 - Deploy an AKS Kubernetes Cluster

[< Previous Challenge](./Challenge-12.md) - [Home](../README.md)

## Introduction

The goals of this challenge include understanding:

- How to deploy an AKS cluster using Bicep
- How to leverage modules & deployment scripts to deploy code to the cluster

## Description

### Deploy an AKS Cluster

Your challenge is to:

- Create a Bicep file to deploy an AKS cluster into your subscription.

### Deploy an App on to the AKS Cluster

Now that your cluster is running, we want to deploy a sample app to the cluster.  We're going to use a tool called a _[deployment script](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-script-template)_ to do this. Fortunately, the heavy lifting has been done for you!

Remember when we covered modules back in Challenge 6?  We created our own modules.  But there are also _public modules_ you can use. For this challenge, we're going to use a module called `AKS Run Command Script`, which allows you to run a command on a Kubernetes cluster by calling a deployment script under the covers.  

You can find the module and how to use it here: [AKS Run Command Script](https://github.com/Azure/bicep-registry-modules/blob/main/modules/deployment-scripts/aks-run-command/README.md)

Thus, your challenge is to:

- Update your bicep file to leverage the "AKS Run Command Script" module, and have it run the following command which will deploy a sample application to the cluster:

  ```bash
  kubectl apply -f https://raw.githubusercontent.com/Azure-Samples/azure-voting-app-redis/master/azure-vote-all-in-one-redis.yaml
  ```

## Success Criteria

- Verify your AKS cluster is up and running
- Demonstrate that your app is running on your cluster

## Learning Resources

- [Quickstart: Deploy an Azure Kubernetes Service (AKS) cluster using Bicep](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-bicep)
- [AKS Run Command Script](https://github.com/Azure/bicep-registry-modules/blob/main/modules/deployment-scripts/aks-run-command/README.md)
- [Using Bicep modules](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules)
