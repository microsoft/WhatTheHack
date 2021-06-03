# What The Hack - AKS Enterprise-Grade

## Introduction

The objective of this hack is to dive deeply into all aspects of integration between AKS and various Azure services. We have included challenges for many components that are required to operate a Kubernetes cluster on Azure (eg: networking, storage, etc) as well as some optional ones (eg: monitoring).

## Learning Objectives

In this hack you will start by deploying a 3-tier application to AKS with very specific networking requirements.

The complexity will quickly evolve towards security and storage, finishing with the last challenge focusing on Arc-enabled Kubernetes clusters and Arc-enabled data services.

## Challenges

- Challenge 1: **[Containers](Student/01-containers.md)**
   - Get familiar with the application for this hack, and roll it out locally or with Azure Container Instances
- Challenge 2: **[AKS Network Integration and Private Clusters](Student/02-aks_private.md)**
   - Deploy the application in an AKS cluster with strict network requirements
- Challenge 3: **[AKS Monitoring](Student/03-aks_monitoring.md)**
   - Monitor the application, either using Prometheus or Azure Monitor
- Challenge 4: **[Secrets and Configuration Management](Student/04-aks_secrets.md)**
   - Harden secret management with the help of Azure Key Vault
- Challenge 5: **[AKS Security](Student/05-aks_security.md)**
   - Explore AKS security concepts such as Azure Policy for Kubernetes
- Challenge 6: **[Persistent Storage in AKS](Student/06-aks_storage.md)**
   - Evaluate different storage classes by deploying the database in AKS
- Challenge 7: **[Service Mesh](Student/07-aks_mesh.md)**
   - Explore the usage of a Service Mesh to further protect the application
- Challenge 8: **[Arc-Enabled Kubernetes and Arc-Enabled Data Services](Student/08-arc.md)**
   - Leverage Arc for Kubernetes to manage a non-AKS cluster, and Arc for data to deploy a managed database there

You can find the source code and documentation in the resources files provided to you for the hack.

## Prerequisites

- Access to an Azure subscription (owner privilege is required in some exercises)

## Contributors

- Adrian Joian
- Gitte Vermeiren
- Jose Moreno
- Victor Viriya-ampanond
