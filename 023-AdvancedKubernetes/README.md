# Advanced Kubernetes

## Introduction

This hack will guide you through advanced Kubernetes topics for both Operators and Developers.  These challenges are taken from what we are seeing in the field.

Unlike other WhatTheHack's, each of the challenges here are independent (e.g. You can do GitOps challenges without having done the Scaling challenges).  This is by design as different teams can prioritize specific features of Kubernetes.

## Learning Objectives

In this hack, you will be working on a set of "Day 2" operational best practices for Kubernetes cluster management.  You will learn:

1. Create and use Helm charts
1. Build resiliency into your pods
1. Scale your cluster
1. Using Git as the Source of Truth for your cluster
1. Learn about the features of a Service Mesh

## Assumptions

Before starting this hack you should have hands-on experience with the following:

- AKS
- Kubernetes Ingress
- Github (Repo, Cloning)
- Docker Hub
- If you are doing [Data Volumes](Coach/Solutions/07-data-volumes.md) challenges, make sure your cluster is in the [supported regions for Azure Files using NFS](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-compare-protocols#regional-availability) and [register the feature in your subscription](https://github.com/kubernetes-sigs/azurefile-csi-driver/tree/master/deploy/example/nfs).

## Challenges

1. [Setup](./Student/01-setup.md)
1. [Helm](./Student/02-helm.md)
   1. Create a new Helm chart
   1. Install Helm chart on AKS cluster
   1. Install Kubernetes Ingress using Helm
   1. Update Helm release to use Ingress
   1. Delete Kubernetes Ingress Helm Release
1. [Resiliency](./Student/03-resiliency.md)
   1. Define Readiness Probe
   1. Define Liveness Probe
1. [Scaling](./Student/04-scaling.md)
   1. Set up cluster autoscaling
   1. Set up pod autoscaling
   1. Define resource requests and limits
1. [GitOps](./Student/05-gitops.md)
   1. Install flux
   1. Setup Flux Pipeline
   1. Simulate CI to verify changes pushed to AKS cluster 
   1. Update Github to deploy Ingress Controller via Flux
1. [Service Mesh](./Student/06-service-mesh.md)
   1. Install a Service Mesh
   1. Apply a virtual service
   1. Apply weight-based routing
   1. Apply distributed tracing with Jaeger
1. [Data Volumes](./Student/07-data-volumes.md)
   1. Static provisioning with Azure Disks
   1. Dynamic provisioning with Azure Disks
   1. Scaling persistent applications with Azure Disks
   1. Scaling persistent applications with Azure Files

## Prerequisites

- An Azure Subscription which can deploy an AKS cluster
- Access to a Bash Shell (Cloud Shell, WSL, etc.)

## Contributors

- Tommy Falgout
- Kevin M. Gates
- Michelle Yang

## Quotes

`The factory of the future will have only two employees, a man and a dog. The man will be there to feed the dog. The dog will be there to keep the man from touching the equipment. --Warren Bennis`
