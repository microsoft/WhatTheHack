# Challenge-01 - Deploy A Simple Azure Container Application

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Pre-requisites

You should have completed Challenge-00.

## Introduction

Azure has a number of Azure container options each offering different features and levels of complexity. At one end, there is Azure Container Instances (ACI) which provide single pods on demand but lack capabilities such as load balancing and scaling. At the other end, there is Azure Kubernetes Service (AKS) which provides a fully managed Kubernetes experience on Azure.

Azure Container Apps (ACA) sits between ACI and AKS. It is ideal for those organisations that want to build microservices, API endpoints and long running processes on a serverless platform without needing access to the Kubernetes API or Control Plane. Some of the key features offered by ACA are:

- Code can be written using the language, framework or SDK chosen by the developer
- Provides autoscaling based on HTTP traffic and can scale to 0 which reduces usage charges
- Supports container app versioning using revisions which enables blue/green deployments
- Provides Distributed Application Runtime (Dapr) integration to reduce the complexity of developing distributed systems
- Supports Kubernetes-based Event Driven Autoscaler (KEDA) triggers to scale as required

## ACA Key Concepts

Container Apps - Support any linux-based x86-64 container image
Container Apps Environment - Acts as a secure boundary around groups of container apps
Container Apps Containers - Can use any runtime, programming language or development stack
Revisions - Enable container app versioning

## Description

Use the Azure CLI to create a simple ACA using an existing container image. The following image can be used: mcr.microsoft.com/azuredocs/containerapps-helloworld:latest.

## Tips
To enable the container app to be accessed publicly via its fully qualified domain name (FQDN), and to return the FQDN when the container is created, set the following parameters:

 ```bash
--target-port
--ingress
--query
```

## Success Criteria
 
If the ACA has been deployed successfully, entering the fully qualified domain name of the ACA in a browser will result in the following page being displayed:

![screenshot](../Images/Challenge-01Screenshot-01.png)

## Learning Resources

- [Azure Container Apps Documentation](https://learn.microsoft.com/en-us/azure/container-apps/)
