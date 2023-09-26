# What The Hack - Infrastructure As Code: Bicep - Coach's Guide

## Introduction
Welcome to the coach's guide for the "Infrastructure As Code: Bicep" What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

Also remember that this hack includes a optional [lecture presentation](WTH-IaC-Bicep-Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

Additionally, please review the [Stretch Thinking](Solution-Stretch-Thinking.md) guide for tips on extending the conversation with your participants.

**NOTE:** If you are a Hackathon participant, this is the answer guide.  Don't cheat yourself by looking at these during the hack!  Go learn something. :)

## Coach's Guides
- Challenge 00: **[Pre-requisites - Ready, Set, Go!](Solution-00.md)**
   - Get your workstation ready to work with Azure
- Challenge 01: **[Basic Bicep](Solution-01.md)**
   - Develop a simple Bicep file that takes inputs to create an Azure Storage Account and returns outputs
- Challenge 02: **[Bicep Expressions and Referencing Resources](Solution-02.md)**
   - Learn Bicep expressions and referencing resources
- Challenge 03: **[Advanced Resource Declarations](Solution-03.md)**
   - Advanced resource declarations
- Challenge 04: **[Secret Values with Azure Key Vault](Solution-04.md)**
   - Learn how to not lose your job
- Challenge 05: **[Deploy a Virtual Machine](Solution-05.md)**
   - Create a complex deployment with Bicep using modules
- Challenge 06: **[Bicep Modules](Solution-06.md)**
   - Learn how create resusable modules for granular resource management
- Challenge 07: **[Configure VM to Run a Web Server](Solution-07.md)** 
   - Learn about custom script extensions
- Challenge 08: **[Deploy a Virtual Machine Scale Set](Solution-08.md)**
   - Create complex deployment with Bicep using modules
- Challenge 09: **[Configure VM Scale Set to Run a Web Server](Solution-09.md)**
   - Learn about custom script extensions in a VM Scale Set
- Challenge 10: **[Configure VM Scale Set to Run a Web Server Using cloud-init](Solution-10.md)**
   - How cloud-init scripts can be run on a Virtual Machine Scale Set (VMSS)
- Challenge 11: **[Deploy Resources to Different Scopes](Solution-11.md)**
   - Learn how to deploy resources to different scopes
- Challenge 12: **[Deploy an Azure App Service](Solution-12.md)**
   - Learn how to an Azure App Service and deploy an app to it   
- Challenge 13: **[Deploy an AKS cluster](Solution-13.md)**
   - Learn how to deploy an AKS cluster and deploy an app to it 

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

### Additional Coach Prerequisites

Some organizations may block their users from installing software on their workstations, especially if it requires Administrator access. The Coach should share the [Challenge 00 pre-requisites](../Student/Challenge-00.md) with a stakeholder in the students' organization before hosting the hack. 

If the organization blocks the installation of all or some software, there are multiple options you can consider. For more details, see the [Coach's guide for Challenge 00](Solution-00.md).

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Students can complete all challenges except 11 with "Contributor" access to their subscription.
- Students must have "Owner" access on their subscription to complete challenge 11 to deploy at the "subscription" scope.
- Each student will spin up the following resources in Azure:
   - Storage Account
   - Virtual Network
   - Network Security Group
   - Virtual Machine
   - Virtual Machine Scale Set
   - Public IP Address
   - Azure App Service
   - Azure Kubernetes Service (AKS)

## Suggested Hack Agenda

This hack is designed to be run as a full 3-day event, for a total of approximately 18 hours to complete all challenges. There are multiple options that enable you run this hack for a shorter periods of time and still provide value to attendees depending on the organization's learning objectives. 

Different groups of students will complete the challenges at different paces based on their comfort level with Linux and/or using Command Line Interface (CLI) tools. This is okay, and students should be encouraged to participate in this intro-level hack no matter what their experience level is.

Learning about Infrastructure-as-Code is a fundamental skill in Azure. This hack is often delivered to folks who are just getting started with Azure. While coaches are covering Bicep, they should also mix in Azure basics to the discussions as needed.  For example, the [opening lecture](WTH-IaC-Bicep-Lectures.pptx?raw=true) starts off with "How Azure is organized", covering details of the Azure Resource Manager, Resource Providers, Subscriptions, Resources Groups, and Resources.

Here are some things to know about the challenges and options you have for running the hack:

### Challenge "Zero"

Challenge "Zero" is all about the tooling needed to manage Azure.  While this hack can be completed using the Azure Cloud Shell, it is highly recommended that students get the experience of installing all of the pre-requisite tools on their local workstation. This will better prepare them to continue working with Azure after the hack is over.

- It is common and OKAY if students spend 30-60 minutes getting all of the tools installed and configured properly.
- Coaches can share the pre-requisites with a stakeholder in the students' organization to see if there are opportunities for students to complete them before the hack event. However, it is rare that attendees will do this and thus, coaches should plan for this time as part of the event. 

### Challenges 1-6 - Bicep Fundamentals

Challenges 1 through 6 cover the core Bicep syntax features and concepts (secret management & modules). These challenges should be completed in order as they build upon each other. These challenges start off demonstrating Bicep syntax concepts by having the students deploy a simple Azure Storage Account. They add complexity with Challenge 5 culminating in the composition of several dependent resources to deploy an Azure Virtual Machine. Challenge 6 completes the core concepts by covering Bicep modules.

Completing these challenges will provide most organizations with the knowledge they need to use Bicep to implement Infrastructure-As-Code. Depending on the organization's learning objectives, you can choose to continue on with more advanced concepts & examples focused on Azure IaaS deployments, Azure PaaS deployments, or both. 

The rest of the challenges can be completed in any order based on the organization's learning objectives.

### Challenges 7-11 Bicep IaaS Deployments

Challenges 7 through 10 focus on more complex Azure IaaS deployments of VMs, Load Balancers, Virtual Machine Scale Sets, and using the Custom Script Extension to deploy or configure software on those VMs/VMSSs. 

Challenge 11 focuses on how Bicep can be used to deploy Azure resources at different scopes (tenant, management group, subscription or resource group). 

### Challenges 12-13 Bicep PaaS Deployments

Challenges 12 and 13 have the students learn how to use Bicep to deploy Azure PaaS services, including an Azure App Service and an Azure Kubernetes Service (AKS) Cluster.

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
