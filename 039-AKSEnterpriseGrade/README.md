# What The Hack - AKS Enterprise-Grade

## Introduction

The objective of this hack is to dive deeply into all aspects of integration between Kubernetes, the Azure Kubernetes Service (AKS), and various Azure services. We have included challenges for many components that are required to operate a Kubernetes cluster on Azure (eg: networking, storage, etc)

## Learning Objectives

In this hack you will start by deploying a 3-tier application to AKS with very specific networking requirements.

The complexity will quickly evolve towards security and storage, finishing with the last challenge focusing on Arc-enabled Kubernetes clusters and Arc-enabled data services.

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Containers](Student/Challenge-01.md)**
	 - Get familiar with the sample application for this hack, and roll it out locally or with Azure Container Instances
- Challenge 02: **[AKS Network Integration and Private Clusters](Student/Challenge-02.md)**
	 - Deploy the application in an AKS cluster with strict network requirements
- Challenge 03: **[AKS Monitoring](Student/Challenge-03.md)**
	 - Monitor the application, either using Prometheus or Azure Monitor
- Challenge 04: **[Secrets and Configuration Management](Student/Challenge-04.md)**
	 - Harden secret management with the help of Azure Key Vault
- Challenge 05: **[AKS Security](Student/Challenge-05.md)**
	 - Explore AKS security concepts such as Azure Policy for Kubernetes
- Challenge 06: **[Persistent Storage in AKS](Student/Challenge-06.md)**
	 - Evaluate different storage classes by deploying the database in AKS
- Challenge 07: **[Service Mesh](Student/Challenge-07.md)**
	 - Explore the usage of a Service Mesh to further protect the application
- Challenge 08: **[Arc-Enabled Kubernetes and Arc-Enabled Data Services](Student/Challenge-08.md)**
	 - Leverage Arc for Kubernetes to manage a non-AKS cluster, and Arc for data to deploy a managed database there

## Prerequisites

- Access to an Azure subscription (owner privilege is required in some exercises)
- Visual Studio Code
- Windows Subsystem for Linux (Windows-only)
- Azure CLI
- Docker Desktop (Optional)

## Contributors

- Adrian Joian
- Gitte Vermeiren
- Jose Moreno
- Victor Viriya-ampanond
- Peter Laudati
- Pete Rodriguez
