# What The Hack - DynatraceOnAzure - Coach Guide

## Introduction

Welcome to the coach's guide for the Dynatrace On Azure WhatTheHack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

This WhatTheHack provide you hands on experience on how to Monitor Azure workloads using Dynatrace.   It will show you how Dynatrace's AI-engine, Davis, performs automatic and intelligent root-cause analysis in hybrid cloud Azure environments. This hack was designed specifically for Cloud Ops Engineers, DevOps engineers, Developers, and Architects who want to expand their knowledge on Dynatrace & Azure.

The story goes that, you are new engineer that was hired to modernize a ecommerce website for company called "DTOrders".  "DTOrders" currently has this website deployed to Azure virtual machines but  wants to containerize this application to run on Kubernetes.  The engineer's job will first be deploy the application to Azure VM and then migrate it run on AKS Cluster.  Along the way, they'll use Dynatrace to  monitor the application on Azure VM and once migrated to AKS, compare the product functionality and how easy it is to monitor and manage your application with Dynatrace.


**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your environment to work with Azure and Dynatrace.
- Challenge 01: **[OneAgent Observability on Azure VM](./Solution-01.md)**
	 - Review the power on OneAgent.
- Challenge 02: **[Dynatrace Observability on AKS](./Solution-02.md)**
	 - Deploy Dynatrace Operator on AKS cluster with a sample application and review AKS observability with Dynatrace.
- Challenge 03: **[Automated Root Cause Analysis with Davis](./Solution-03.md)**
	 - Enable a problem in your sample application and walk through what Davis found.
- Challenge 04: **[Azure Monitor Metrics & Custom Dashboard](./Solution-04.md)**
  - In this challenge, you will create a custom dashboard to track Service Level Objects (SLO's)
- Challenge 05: **[Challenge 05 - Grail - Dashboards & Notebooks](./Solution-05.md)**
	 - In this challenge, you will query, visualize, and observe all your data stored in Grail via Dashboards and Notebooks.
- Challenge 06: **[Challenge 06 - Grail - SRE Guardian & Workflows](Solution-06.md)**
	* In this challenge you'll learn the benefits of Site  Reliability Guardian (SRG) and experience the power of Automation in dynatrace by creating workflows to automatically execute an SRG.
- Challenge 07: **[Cleanup](./Solution-05.md)**
	 - Description of challenge

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. 

Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

The folders are self contained challenges for the hack. You do not need to go to other resources to run the challenges. Attendee's will need a laptop, but only an Azure browser is required. All work will be done in the Azure  portal and the Azure Command Shell. If you think attendee's laptops may be locked down to the point that they can't access Azure, than having a laptop for loan will be a good idea. No special software needs to be installed though.

The original code base of the Challenges automation scripts & sample app are located below

- [Dynatrace Azure Workshop Scripts](https://github.com/dt-alliances-workshops/azure-modernization-dt-orders-setup/)
- [Sample App Codebase](https://github.com/dt-orders)
- [Docker Images](https://hub.docker.com/search?q=dtdemos)

### Student Resources

Students will download the scripts from a github repo via the Git clone in the Azure Cloud shell

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

>**Note** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

### Additional Coach Prerequisites (Optional)

- Coach must validate if the [Dynatrace Azure Workshop Github repo](https://github.com/dt-alliances-workshops/azure-modernization-dt-orders-setup/) is accessible. 

- If Github repo is inaccessible, please open up a issue within the WhatTheHack repo.  

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Attendees should have the “Azure account administrator” (or "Owner") role on the Azure subscription in order setup Azure Monitor metrics integration. 

- Each student will spin up the following resources in Azure:
    - 2 x 2 vCPUs VMs for the AKS cluster + 1 Public IPs
    - 1 x 1 vCPU VM for Dynatrace Active Gate
    - 1 x 2 vCPUs VMs for sample monolith application    
    - 1 PIP for the Dynatrace Orders website on Monolith
    - 1 PIP for Dynatrace Orders website on AKS    
    - Total: 7 vCPU + 3 Public IPs per student

>**Note**
> - Azure resources that will be consumed by a student implementing the hack's challenges
> - Azure permissions required by a student to complete the hack's challenges.

## Suggested Hack Agenda (Optional)

- Sample Hack Day  (~4 hours)
  - Challenge 0 (45 min)
  - Challenge 1 (1 hr)
  - Challenge 2 (45 mins)
  - Challenge 3 (30 mins)
  - Challenge 4 (30 mins)
  - Challenge 5 (15 mins)
  - Challenge 6 (15 mins)


## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide

