# Challenge 8: Azure Arc for Kubernetes and for Data Services

[< Previous Challenge](./07-aks_mesh.md) - **[Home](../README.md)**

## Introduction

This challenge will cover the basics of Azure Arc for Kubernetes, as well as Azure Arc for Data Services.

## Description

You need to fulfill these requirements to complete this challenge:

- Deploy a non-AKS Kubernetes cluster somewhere (it could be on Azure or anywhere else) and connect it with Azure so that it appears as an ARM resource in the portal.
> **Note**: It is recommended using VM sizes for the worker nodes with at least 4 cores and premium disk support, since Arc for data is quite demanding in terms of resources
- Configure an Azure Policy to prevent privileged containers from running in the cluster.
- Use Gitops to deploy an application to the cluster. You can take the application we have been using in this FastHack (the [web](./web/README.md)/[api](./api/README.md) container images) or any other container image
- Deploy a database in the new cluster over Arc for Data
> **Note**: make sure the policy previously deployed does not interfere with the Arc data controller, in case it needs to run privileged containers

## Success Criteria

- A non-AKS cluster is represented in Azure via Arc for Kubernetes
- An application has been deployed with Gitops
- Participants can demonstrate how Azure Policies prevent the usage of privileged containers
- A managed database is deployed in the cluster through Arc for Data Services

## Optional Objectives

- Connect your AKS cluster from previous challenges to the same Gitops repo, and make sure that changes to the application are propagated to both clusters

## Related Documentation

These docs might help you achieving these objectives:

- [Deploy a Kubernetes cluster with aks-engine](https://github.com/Azure/aks-engine/blob/master/docs/tutorials/quickstart.md)
- [Azure Arc for Kubernetes](https://docs.microsoft.com/azure/azure-arc/kubernetes/overview)
- [Azure Policy for Kubernetes](https://docs.microsoft.com/azure/governance/policy/concepts/policy-for-kubernetes)
- [Azure Arc for data](https://docs.microsoft.com/azure/azure-arc/data/overview)
