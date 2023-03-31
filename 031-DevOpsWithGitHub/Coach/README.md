# What The Hack - DevOps with GitHub - Coach Guide

## Introduction
Welcome to the coach's guide for the DevOps with GitHub What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.


**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides
- Challenge 00: **[Setup Azure & Tools](./Solution-00.md)**
	- Get your environment set up to hack
- Challenge 01: **[Setup Your Repository](./Solution-01.md)**
	- Establish version control by putting your code into a GitHub repository
- Challenge 02: **[Setup a Codespace](./Solution-02.md)**
	- Create a cloud based development environment with all of the prerequisite tools 
- Challenge 03: **[Track Your Work with GitHub Project Boards](./Solution-03.md)**
	 - How to track your projects/work leveraging GitHub Project Boards
- Challenge 04: **[First GitHub Actions Workflow](./Solution-04.md)**
	 - Write a simple GitHub Actions Workflow
- Challenge 05: **[Infrastructure as Code](./Solution-05.md)**
	 - Infrastructure as Code Automation with GitHub Actions
- Challenge 06: **[Continuous Integration](./Solution-06.md)**
	 - Continuous Integration with GitHub Actions
- Challenge 07: **[Build and Push Docker Image to Container Registry](./Solution-07.md)**
	 - Build and push Docker images to container registry(ACR)
- Challenge 08: **[Continuous Delivery](./Solution-08.md)**
	 - Deploying your application to Azure with Continuous Delivery
- Challenge 09: **[Branching & Policies](./Solution-09.md)**
	 - Protecting and creating processes for your repository with branching and branch policies
- Challenge 10: **[Security](./Solution-10.md)**
	 - Incorporating security into your projects leveraging native GitHub features
- Challenge 11: **[Monitoring: Application Insights](./Solution-11.md)**
	 - Monitoring your applications leveraging Application Insights

## Coach Prerequisites 

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the \`/Student/Resources\` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.  

### Additional Coach Prerequisites

If you are running this hack with a group, here are some options for providing access to Azure:
- Each person/team uses their own subscription
- Use a single subscription with each person/team using a different resource group
- Use a single subscription and resource group, with each person/team creating resources within the single resource group (less ideal)

Regardless of the option you choose, you'll have to consider:
- [Azure default quotas and resource limits](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits) (for example, # of VMs allowed per region or subscription)
- Unique naming of resources - many services may require a globally unique name, for example, App service, container registry.


## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Azure resources that will be consumed by a student implementing the hack's challenges.
	- Azure Container Registry
	- Azure App Service
- Students will need access to a subscription or at minimum a resource group.  If the students only have permissions to the resource group, the group will need to ensure a student is either able to create a service principle or one will need to be generated in advance.

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Setup`
  - Optional automation for creation of Azure and GitHub resources to back face-to-face deliveries on shared Azure subscription
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
