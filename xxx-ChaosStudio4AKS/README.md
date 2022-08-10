# What The Hack - xxx-ChaosStudio

## Introduction 

Azure Chaos Studio (Preview) is a managed service for improving resilience by injecting faults into your Azure applications. Running controlled fault
injection
experiments against your applications, a practice known as chaos engineering, helps you to measure, understand, and improve resilience against real-world
incidents, such as a region outages or application failures causing high CPU utilization on a VMs, ScaleSets, and Azure Kubernetes.


## Learning Objectives
This “What the Hack” WTH is designed to introduce you to Azure Chaos Studios (Preview) and guide you through a series of hands-on challenges to accomplish
the following:
  
1. Leverage the Azure Chaos Studio to inject failure into an application/workload
2. Provide hands-on understanding of Chaos Engineering 
3. Understand how resilientcy can be achieved with Azure 

In this WTH, you are the system owner of the Contoso Pizzeria Application (or you may bring your own application). Super Bowl Sunday is Contoso Pizza's busiest time of the year, the pizzeria
ordering application must be must be available during the Super Bowl. 

You have been tasked to test the resiliency of the pizzeria application (or your application). The pizzeria application is running on Azure and you will use Chaos Studio to
simulate various failures. 

## Challenges
1. Challenge 00: **[Ready Set Go](Student/Challenge-00.md)**
	 - Deploy the multi-region Kubernetes pizzeria application,
1. Challenge 01: **[Is your application ready for the Super Bowl?](Student/Challenge-01.md)**
	 - How does your application handle failure during large scale events?
1. Challenge 02: **[My AZ burned down, now what?](Student/Challenge-02.md)**
	 - Can your application survive an Azure outage of 1 or more Availability Zones?
1. Challenge 03: **[Godzilla takes out an Azure region!](Student/Challenge-03.md)**
	 - Can your application survive a region failure? 
1. Challenge 04: **[Injecting Chaos into your pipeline](Student/Challenge-04.md)**
	 - Optional challenge, using Chaos Studio experiments in your CI/CD pipeline

## Prerequisites
- Azure subscription with owner access
- Visual Studio Code terminal or Azure Shell (recommended)
- Latest Azure CLI (if not using Azure Shell) 
- Github or Azure DevOps to automate Chaos Testing
- Azure fundamentals, Vnets, NSGs, ScaleSets, Traffic Manager 
- Fundamentals of Chaos Engineering
- Basic understanding of Kubernetes (kubectl commands)

## Learning Resources 
* [What is Azure Chaos Studio](https://docs.microsoft.com/en-us/azure/chaos-studio/chaos-studio-overview)
* [What is Chaos Engineering](https://docs.microsoft.com/en-us/azure/architecture/framework/resiliency/chaos-engineering?toc=%2Fazure%2Fchaos-studio%2Ftoc.json&bc=%2Fazure%2Fchaos-studio%2Fbreadcrumb%2Ftoc.json)
* [How Netflix pioneered Chaos Engineering](https://techhq.com/2019/03/how-netflix-pioneered-chaos-engineering/)
* [Embrace the Chaos](https://medium.com/capital-one-tech/embrace-the-chaos-engineering-203fd6fc6ff7)
* [Why you should break more things on purpose --AWS, Azure, and LinkedIn case studies](https://www.contino.io/insights/chaos-engineering)

## Repository Contents
- `./Coach/Guides`
  - Coach's Guide and related files
- `./ContosoPizzaApp`
  - Image files and code for the pizza application
- `./Student/Guides`
  - Student's Challenge Guide

## Contributors
- Jerry Rhoads
- Kevin Gates
- Andy Huang
- Tommy Falgout 
