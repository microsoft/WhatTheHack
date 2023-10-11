# What The Hack - Intro To Azure Red Hat OpenShift

## Introduction

This intro level hack will help you get hands-on experience with Red Hat OpenShift on Microsoft Azure. 

## Learning Objectives

In this hack you learn how to use Azure Red Hat OpenShift (ARO). You will take a simple multi-tiered web app and deploy it to an ARO cluster. Once the application is in ARO, you will learn how to tweak all the knobs and levers to scale, manage and monitor it as well as integrate it with Azure.

1. Deploy an ARO cluster and deploy applications to it
2. Understand key ARO management areas: monitoring, storage, networking, scaling, and Azure service operators

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
	 - Prepare your workstation to work with Azure
- Challenge 01: **[ARO Cluster Deployment](Student/Challenge-01.md)**
	 - Deploy an ARO cluster and access it using CLI and the Redhat Portal
- Challenge 02: **[Application Deployment](Student/Challenge-02.md)**
	 - Deploy the frontend and backend of an application onto the ARO cluster
- Challenge 03: **[Logging and Metrics](Student/Challenge-03.md)**
	 - Integrate Azure Monitor and view the application logs to identify application errors
- Challenge 04: **[Storage](Student/Challenge-04.md)**
	 - Deploy a MongoDB database service to address application errors
- Challenge 05: **[Configuration](Student/Challenge-05.md)**
	 - Configure the frontend and backend applications
- Challenge 06: **[Networking](Student/Challenge-06.md)**
	 - Secure cluster traffic between pods using network policies
- Challenge 07: **[Scaling](Student/Challenge-07.md)**
	 - Scale the frontend and backend applications
- Challenge 08: **[Azure Active Directory Integration](Student/Challenge-08.md)**
	 - Provide authentication to your ARO Web Console
- Challenge 09: **[Azure Service Operator Connection](Student/Challenge-09.md)**
	 - Integrate Azure Service Operator

## Prerequisites
- Your own Azure subscription with Owner access
- Visual Studio Code
- Azure CLI
- Alternatively, you can use the [**Azure Cloud Shell**](https://shell.azure.com/)
- Challenge 0: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**

## Contributors

- [Daniel Kondrashevich](https://github.com/danielkon96)
- [Anahita Afshari](https://github.com/anahitaafsh)
- [Sowmyan Soman Chullikkattil](https://github.com/sowsan)
