# Advanced Kubernetes

## Introduction

This hack will guide you through advanced Kubernetes topics for both Operators and Developers.  These challenges are taken from what we are seeing in the field.

## Learning Objectives

In this hack, you will be working on a set of "Day 2" operational best practices for Kubernetes cluster management.  You will learn:

1. Create and use Helm charts
1. Using Git as the Source of Truth for your cluster
1. Build resiliency into your pods
1. Learn about the features of a Service Mesh

## Assumptions

Before starting this hack you should have hands-on experience with the following:

- AKS
- Kubernetes Ingress
- Github (Repo, Cloning)
- Docker Hub

## Challenges

1. [Setup](./Student/01-setup.md)
1. [Helm](./Student/02-helm.md)
   1. Create a new Helm chart
   1. Install Helm chart on AKS cluster
   1. Install Kubernetes Ingress using Helm
   1. Update Helm release to use Ingress
   1. Delete Kubernetes Ingress Helm Release
1. [GitOps](./Student/03-gitops.md)
   1. Install flux
   1. Setup Flux Pipeline
   1. Simulate CI to verify changes pushed to AKS cluster 
   1. Update Github to deploy Ingress Controller via Flux
1. [Resiliency](./Student/04-resiliency.md)
   1. Define Readiness Probe
   1. Define Liveness Probe
   1. Define Init container
   1. Define Limit
   1. Define Requests
1. [Service Mesh](./Student/05-service-mesh.md)
   1. Install a Service Mesh
   1. Apply a virtual service
   1. Apply weight-based routing
   1. Apply distributed tracing with Jaeger

## Prerequisites

- An Azure Subscription which can deploy an AKS cluster
- Access to a Bash Shell (Cloud Shell, WSL, etc.)

## Contributors
- Tommy Falgout
- Kevin M. Gates

