# What The Hack - Build & Modernize AI Applications - Coach Guide

## Introduction

Welcome to the coach's guide for the Build & Modernize AI Applications What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[The Landing Before the Launch](./Solution-01.md)**
	 - Deploy the solution cloud services in preparation for the launch of the POC.
- Challenge 02: **[Now We're Flying](./Solution-02.md)**
	 - Experiment with system prompts.
- Challenge 03: **[What's Your Vector, Victor?](./Solution-03.md)**
	 - Load new data and observe automatic vectorization.
- Challenge 04: **[It's All About the Payload, The Sequel](./Solution-04.md)**
	 - Extend the solution to handle any type of JSON data.
- Challenge 05: **[The Colonel Needs a Promotion](./Solution-05.md)**
	 - Add new capability by creating Semantic Kernel plugins.
- Challenge 06: **[Getting Into the Flow](./Solution-06.md)**
	 - Use ML Prompt Flow to replace portions of the chat service.

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Attendees should have the “Azure account administrator” (or "Owner") role on the Azure subscription in order to authenticate, create and configure the resource group and necessary resources including:
    - Azure Cosmos DB with NoSQL API
    - Azure Container App with supporting services _or_ Azure Kubernetes Service (AKS)
	- Azure OpenAI
	- Azure AI Search

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
  - `./Student/Resources`
    - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
