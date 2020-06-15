# What The Hack - Intro To Kubernetes
## Introduction
This intro level hack will help you get hands-on experience with Docker, Kubernetes and the Azure Kubernetes Service (AKS) on Microsoft Azure. Kubernetes has quickly gone from being the shiny new kid on the block to the defacto way to deploy and orchestrate containerized applications.

This hack starts off by covering containers, what problems they solve, and why Kubernetes is needed to help orchestrate them.  You will learn all of the Kubernetes jargon (pods, services, and deployments, oh my!).  By the end, you should have a good understanding of what Kubernetes is and be familiar with how to run it on Azure.

This hack includes a optional [lecture presentation](Coach/Guides/Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

## Learning Objectives
In this hack you will solve a common challenge for companies migrating to the cloud. You will take a simple multi-tiered web app, containerize it, and deploy it to an AKS cluster. Once the application is in AKS, you will learn how to tweak all the knobs and levers to scale, manage and monitor it.

1. Containerize an application
1. Deploy a Kubernetes cluster in Azure and deploy applications to it.
1. Understand key Kubernetes management areas: scalability, upgrades and rollbacks, storage, networking, package management and monitoring

## Challenges
0. "Challenge 0" Pre-requisites - Ready, Set, GO!
   - Prepare your workstation to work with Azure, Docker containers, and AKS
1. Got Containers?
   - Package the "FabMedical" app into a Docker container and run it locally.
1. Azure Container Registry
   - Deploy an Azure Container Registry, secure it and publish your container.
1. Introduction to Kubernetes
   - Install the Kubernetes CLI tool, deploy an AKS cluster in Azure, and verify it is running.
1. Your first deployment
   - Pods, Services, Deployments: Getting your YAML on! Deploy the "FabMedical" app to your AKS cluster. 
1. Scale and High Availability
   - Flex Kubernetes' muscles by scaling pods, and then nodes. Observe how Kubernetes responds to resource limits.
1. Deploy MongoDB to AKS
   - Deploy MongoDB to AKS from a public container registry.
1. Updates and Rollbacks
   - Deploy v2 of FabMedical to AKS via rolling updates, roll it back, then deploy it again using the blue/green deployment methodology.
1. Storage
   - Delete the MongoDB you created earlier and observe what happens when you don't have persistent storage. Fix it!
1. Helm
   - Install Helm tools, customize a sample Helm package to deploy FabMedical, publish the Helm package to Azure Container Registry and use the Helm package to redeploy FabMedical to AKS.
1. Networking
   - Explore different ways of routing traffic to FabMedical by configuring an Ingress Controller with the HTTP Application Routing feature in AKS.
1. Operations and Monitoring
   - Explore the logs provided by Kubernetes using the Kubernetes CLI, configure Azure Monitor and build a dashboard that monitors your AKS cluster
   
## Prerequisites

- Access to an Azure subscription with Owner access
   - If you don't have one, [Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)
- [**Windows Subsystem for Linux (Windows 10-only)**](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [**Azure CLI**](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   - (Windows-only) Install Azure CLI on Windows Subsystem for Linux
   - Update to the latest
   - Must be at least version 2.7.x
- Alternatively, you can use the [**Azure Cloud Shell**](https://shell.azure.com/)
- [**Visual Studio Code**](https://code.visualstudio.com/)

## Repository Contents
- `../Coach/Guides`
  - [Lecture presentation](Coach/Guides/Lectures.pptx) with short presentations to introduce each challenge.
- `../Coach/Solutions`
   - Example solutions to the challenges (If you're a student, don't cheat yourself out of an education!)
- `../Student/Resources`
   - FabMedial app code and sample templates to aid with challenges

## Contributors
- Peter Laudati
- Gino Filicetti
- Israel Ekpo
- Sowmyan Soman Chullikkattil