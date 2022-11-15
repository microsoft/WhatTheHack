# What The Hack - Cosmic Troubleshooting - Coach Guide

## Introduction

Welcome to the coach's guide for the Cosmic Troubleshooting What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[What is Going On?](./Solution-01.md)**
	 - Troubleshoot the performance issues
- Challenge 02: **[Time to Fix Things](./Solution-02.md)**
	 - Implement planned changes
- Challenge 03: **[Automate Order Processing](./Solution-03.md)**
	 - Automate processing of submitted orders
- Challenge 04: **[Time to Analyze Data](./Solution-04.md)**
	 - Integrate clickstream data and plan for analyzing
- Challenge 05: **[Going Global](./Solution-05.md)**
	 - Multi-region deployment of the application/database
- Challenge 06: **[Securing the Data](./Solution-06.md)**
	 - Let's make sure we prevent bad things from happening

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

- Your own Azure subscription with Owner access
- Visual Studio Code
- Azure CLI
- Each student will spin up the following resources in Azure (when they run the provided scripts in the student resources folder):
  - 1x S1 Azure App Service Plan for the web app
  - 1x Consumption App Service Plan for supporting Function apps
  - 1x App Service
  - 2x Azure Application Insights instances
  - 1x Azure Cosmos DB Account with 3 containers (total of 1800 RU/s)
  - 1x Azure Load Testing Service
  - 2x Managed Identities
  - 1x Azure Function App
  - 1x Azure Key Vault
  - 1x Azure Storage Account
  
  Depending on how the students will elect to solve the challenges, more Azure Services will need to be deployed, such as:

  - Additional Azure Cosmos DB containers (with cross-region multi-master support)
  - Additional Azure Function Apps
  - Azure Traffic Manager
  - Azure Synapse Analytics with an Apache Spark Pool
  - Additional Azure Storage Accounts

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
