# What The Hack - Azure DevOps - Coach Guide

## Introduction

Welcome to the coach's guide for the Azure DevOps What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Setup](./Solution-00.md)**
	 - Prepare your workstation to be a devops master!
- Challenge 01: **[Azure Boards: Agile Project Management](./Solution-01.md)**
	 - Learn how to work with Azure Boards
- Challenge 02: **[Azure Repos: Introduction](./Solution-02.md)**
	 - Setup an Azure Repo and learn how to integrate it with Azure Board task items
- Challenge 03: **[Azure Pipelines: Infrastructure as Code](./Solution-03.md)**
	 - Deploy an ARM template via an Azure Pipelines job
- Challenge 04: **[Azure Pipelines: Continuous Integration](./Solution-04.md)**
	 - Learn how to automate a build process for a sample app
- Challenge 05: **[Azure Pipelines: Build and Push Docker Images to a Container Registry](./Solution-05.md)**
	 - Build and push Docker images to a container registry(ACR)
- Challenge 06: **[Azure Pipelines: Continuous Delivery](./Solution-06.md)**
	 - Automate the deployment of an application into Azure
- Challenge 07: **[Azure Repos: Branching & Policies](./Solution-07.md)**
	 - Learn about Git branching and configure policies to ensure developers follow the rules
- Challenge 08: **[Azure Monitoring: Application Insights](./Solution-08.md)**
	 - Configure Application Insights to create work items in Azure Boards
- Challenge 09: **[Azure Pipelines: OSS Scanning with Mend Bolt](./Solution-09.md)**
	 - Get a taste of DevSecOps by configuring a code scanning tool in your CI Pipeline

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
