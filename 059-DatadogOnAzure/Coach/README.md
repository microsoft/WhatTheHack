# What The Hack - Datadog On Azure - Coach Guide

## Introduction

Welcome to the coach's guide for the Datadog On Azure What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx?raw=true) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Alerts, Activity Logs, and Service Health](./Solution-01.md)**
	 - Create a monitor for one of your VMs using Terraform
- Challenge 02: **[Monitoring Basics and Dashboards](./Solution-02.md)**
	 - Using the SQL server that is deployed, we will cover the basics of monitoring and Dashboards.
- Challenge 03: **[Monitoring Azure Virtual Machines](./Solution-03.md)**
	 - Datadog agent manual and scalable installations on Windows and VM scale sets.
- Challenge 04: **[Datadog for Applications](./Solution-04.md)**
	 - Monitoring applications deployed to Azure using Datadog. 


## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Attendees should have the “Azure account administrator” (or "Owner") role on the Azure subscription in order to authenticate their AKS clusters against Azure Container Registries.  For more info: [Authenticate with Azure Container Registry from Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration)
- Each student will spin up the following resources in Azure:
	- 1 x 2 vCPUs VMs for the AKS cluster + 2 Public IPs
  - 2 x 4 vCPUs VMs for SQL Server & Visual Studio
  - 4 x 4 vCPUs VMSS for IIS (initial deployment is 2 x 4 vCPU, but students will scale it up to 4 during the hack)
  - 1 PIP for the eShopOnWeb website
  - 1 PIP for Azure Bastion
  - 2 Azure Storage accounts (blob storage)
  - Total: 26 vCPU + 4 Public IPs per studente

>**Note** The VM SKUs are configurable in the Bicep templates. Smaller VM SKU sizes can be used if cost is a concern for the hack.  

>**Note** Always remind students to stop all VMs, VM Scale Sets, and AKS clusters at the end of each hack day to conserve costs during a multi-day hack.

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
