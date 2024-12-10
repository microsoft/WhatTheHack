# What The Hack - Build Your Own Copilot - Coach Guide

## Introduction

Welcome to the coach's guide for the Build Your Own Copilot What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - The landing before the launch](./Solution-00.md)**
	 - Prepare your workstation to work with Azure and deploy the required services.
- Challenge 01: **[Finding the kernel of truth](./Solution-01.md)**
	 - Learn about the basics of Semantic Kernel, a Large Language Model (LLM) orchestrator that powers the solution accelerator.
- Challenge 02: **[It has no filter](./Solution-02.md)**
	 - Learn about intercepting and using key assets from Semantic Kernel's inner workings - prompt and function calling data.
- Challenge 03: **[Always prompt, never tardy](./Solution-03.md)**
	 - Learn how prompts are used in the solution accelerator and experiment with changes to the prompts.
- Challenge 04: **[Cache it away for a rainy day](./Solution-04.md)**
	 - Learn about the inner workings and applications of semantic caching in the solution accelerator.
- Challenge 05: **[Do as the Colonel commands](./Solution-05.md)**
	 - Learn about implementing system commands based on user input in the solution accelerator.

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources & GitHub Codespaces

Before the hack, it is the Coach's responsibility to provide the student resources in the `/Student/Resources` folder of this hack to the students.  There are two options for doing this:

- Create a `Resources.zip` Package
- Setup a GitHub Codespace

#### Create a `Resources.zip` Package

To run the hack from a local workstation, students must have the contents of the `/Student/Resources` folder available on that workstation. 

Coach's should download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

#### Setup a GitHub Codespace

In many organizations, students may not be allowed to install software on their local workstations. This hack was designed to support using GitHub Codespaces to provide students with a developer environment in the cloud.  A GitHub Codespace is a development environment that is hosted in a container in the cloud that you access via a browser. All of the pre-requisite developer tools are pre-installed and available in the codespace.

It is the Coach's responsibility to create a GitHub repo to host the Codespace. To do this:
- Download the contents of the `/Student/Resources` folder of this hack.
- Create a new GitHub repo in your (the Coach's) GitHub account.  (We recommend naming it `<HackName>-Codespace`.)
- Commit the downloaded contents of the `/Student/Resources` to the root of the new repo.
- Provide a link to the new repo to the students.

> [!NOTE]
> Challenge 0 of the student guide contains instructions for the students on how to use GitHub Codespaces when provided a link to the repo you (the Coach) create.

> [!NOTE]
> The `/.devcontainer` folder in the `/Student/Resources` folder MUST be at the root of the new repo you create for the Codespace to work.

### Use the What The Hack Website

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

> [!NOTE]
> Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Attendees should have the “Azure account administrator” (or "Owner") role on the Azure subscription in order to authenticate, create and configure the resource group and necessary resources including:
    - Azure Cosmos DB for NoSQL API (with RBAC policies)
    - Azure Container App with supporting services _or_ Azure Kubernetes Service (AKS)
	- Azure OpenAI
	- Azure Managed Identity

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
  - `./Student/Resources`
    - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
