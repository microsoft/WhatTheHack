# What The Hack - Intro To Kubernetes
## Introduction
This intro level hack will help you get hands-on experience with Kubernetes & the Azure Kubernetes Service (AKS) on Microsoft Azure. Kubernetes has quickly gone from being a "shiny buzzword" technology to the defacto way to deploy and orchestrate containerized applications in the cloud.

The hack starts off by covering containers, what problems they solve, and why Kubernetes is needed to help orchestrate them.  You will learn all of the Kubernetes jargon (pods, services, and deployments, oh my!).  By the end, you should have a good understanding of what Kubernetes is and be familiar with how to run it on Azure!

This hack includes a optional [lecture presentation](Host/Guides/Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off the respective challenge.

## Learning Objectives
In this hack you will solve a common challenge for companies migrating to the cloud. You will take a simple multi-tiered website, containerize it, and deploy it into AKS. Once the application is in AKS, you will learn how to flex all the knobs and levers to scale it, manage it, and monitor it.

1. Containerize an application
2. Deploy a Kubernetes cluster in Azure
3. Understand key Kubernetes management areas: scalability, upgrades & rollbacks, storage, networking, and monitoring

## Challenges
0. "Challenge 0" Pre-requisites - Ready, Set, GO!
   - Prepare your workstation to work with Azure, Docker containers, and AKS
1. Got Containers?
   - Package the "FabMedical" app into a Docker container and run it locally.
2. Azure Container Registry
   - Deploy an Azure Container Registry, secure it, publish your container.
3. Introduction to Kubernetes
   - Install the Kubernetes CLI tool, deploy an AKS cluster in Azure, and verify it is running.
4. Your first deployment
   - Pods, Services, Deployments, and get your YAML on! Deploy the "FabMedical" app to your AKS cluster. 
5. Scale and High Availability
   - Flex Kubernetes' muscles by scaling pods, and then nodes. Observe how Kubernetes responds to resource limits.
6. Deploy MongoDB to AKS
   - Deploy MongoDB to AKS from a public container registry. (You deserve an easy break after the last challenge!)
7. Updates and Rollbacks
   - Deploy "V2" of FabMedical to AKS via rolling updates, roll it back, then deploy it again using the blue/green deployment methodology.
8. Storage
   - Whack the MongoDB you created earlier and observe what happens when you don't have persistent storage. Fix it!
9. Helm
   - Install Helm tools, customize a sample Helm package to deploy FabMedical, publish the Helm package to ACR, and use the Helm package to redeploy FabMedical to AKS.
1. Networking
   - Explore different ways of routing traffic to FabMedical by configuring an Ingress Controller with the HTTP Application Routing feature in AKS.
1. Operations and Monitoring
   - Explore the logs provided by Kubernetes using the Kubernetes CLI, configure Azure Monitor and build a dashboard that monitors your AKS cluster
   
You can find the student challenge guide here:
[Challenge Guide](Student/Challenge-Guide.pdf)

## Prerequisites

- Access to an Azure subscription with Owner access
   - If you don't have one, [Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)
- [**Windows Subsystem for Linux (Windows 10-only)**](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [**Azure CLI**](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   - (Windows-only) Install Azure CLI on Windows Subsystem for Linux
   - Update to the latest
   - Must be at least version 2.0.42
- Alternatively, you can use the [**Azure Cloud Shell**](https://shell.azure.com/)
- [**Visual Studio Code**](https://code.visualstudio.com/)

## Repository Contents
- `../Host/Guides`
  - [Lecture presentation](Host/Guides/Lectures.pptx) with short presentations to introduce each challenge 
  - Coach's Guide
- `../Host/Solutions`
   - Example solutions to the challenges (Don't cheat yourself!)
- `../Student`
  - Student's Challenge Guide
- `../Student/Resources`
   - FabMedial app code and sample templates to aid with challenges

## Contributors
- Peter Laudati
- Gino Filicetti
- Israel Ekpo
- Sowmyan Soman Chullikkattil