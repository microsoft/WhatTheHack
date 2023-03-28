# What The Hack - DynatraceOnAzure - Coach Guide

## Introduction

Welcome to the coach's guide for the DynatraceOnAzure What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

This WhatTheHack provide you hands on experience on how to Monitor Azure workloads using Dynatrace.   It will show you how Dynatrace's AI-engine, Davis, performs automatic and intelligent root-cause analysis in hybrid cloud Azure environments. This hack was designed specifically for Cloud Ops Engineers, DevOps engineers, Developers, and Architects who want to expand their knowledge on Dynatrace & Azure.

The story goes that, you are new engineer that was hired to modernize a ecommerce website for company called "DTOrders".  "DTOrders" currently has this website deployed to Azure virtual machines but  wants to containerize this application to run on Kubernetes.  The engineer's job will first be deploy the application to Azure VM and then migrate it run on AKS Cluster.  Along the way, they'll use Dynatrace to  monitor the application on Azure VM and once migrated to AKS, compare the product functionality and how easy it is to monitor and manage your application with Dynatrace.


**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Title of Challenge](./Solution-01.md)**
	 - Description of challenge
- Challenge 02: **[Title of Challenge](./Solution-02.md)**
	 - Description of challenge
- Challenge 03: **[Title of Challenge](./Solution-03.md)**
	 - Description of challenge
- Challenge 04: **[Title of Challenge](./Solution-04.md)**
	 - Description of challenge
- Challenge 05: **[Title of Challenge](./Solution-05.md)**
	 - Description of challenge

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

The folders are self contained challenges for the hack. You do not need to go to other resources to run the challenges. Attendee's will need a laptop, but only an Azure browser is required. All work will be done in the portal and the Azure Command Shell. If you think attendee's laptops may be locked down to the point that they can't access Azure, than having a laptop for loan will be a good idea. No special software needs to be installed though.

The original code base of the lab automation scripts & sample app are located below

- [Dynatrace Azure Workshop Scripts](https://github.com/dt-alliances-workshops/azure-modernization-dt-orders-setup/)
- [Sample App Codebase](https://github.com/dt-orders)
- [Docker Images](https://hub.docker.com/search?q=dtdemos)

### Student Resources

Students will download the scripts from a github repo via the Git clone in the Azure Cloud shell

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

### Additional Coach Prerequisites (Optional)

Coach must validate if the [Dynatrace Azure Workshop Github repo](https://github.com/dt-alliances-workshops/azure-modernization-dt-orders-setup/) is accessible. 

If Github repo is inaccessible, please open up a issue in the WhatTheHack repo.  

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Attendees should have the “Azure account administrator” (or "Owner") role on the Azure subscription in order to authenticate their AKS clusters against Azure Container Registries. For more info: 

- Each student will spin up the following resources in Azure:
    - 2 x 2 vCPUs VMs for the AKS cluster + 1 Public IPs
    - 1 x 1 vCPU VM for Dynatrace Active Gate
    - 1 x 2 vCPUs VMs for sample monolith application    
    - 1 PIP for the Dynatrace Orders website on Monolith
    - 1 PIP for Dynatrace Orders website on AKS    
    - Total: 7 vCPU + 3 Public IPs per student

***NOTE:***
- Azure resources that will be consumed by a student implementing the hack's challenges
- Azure permissions required by a student to complete the hack's challenges.

## Suggested Hack Agenda (Optional)

_This section is optional. You may wish to provide an estimate of how long each challenge should take for an average squad of students to complete and/or a proposal of how many challenges a coach should structure each session for a multi-session hack event. For example:_

- Sample Day 1
  - Challenge 1 (1 hour)
  - Challenge 2 (30 mins)
  - Challenge 3 (2 hours)
- Sample Day 2
  - Challenge 4 (45 mins)
  - Challenge 5 (1 hour)
  - Challenge 6 (45 mins)

## Repository Contents

_The default files & folders are listed below. You may add to this if you want to specify what is in additional sub-folders you may add._

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
