# What The Hack - Azure Load Testing - Coach Guide

## Introduction
Welcome to the coach's guide for the Azure Load Testing What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.  

NOTE: If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides
- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Develop a Load Testing Strategy](./Solution-01.md)**
	 - How to develop a load testing strategy for your application
- Challenge 02: **[Create a Load Testing Script](./Solution-02.md)**
	 - Deploy a sample application and create JMeter scripts to support your load testing strategy
- Challenge 03: **[Create Azure Load Testing Service and Establish Baselines](./Solution-03.md)**
	 - Create Azure Load Testing Service and learn techniques on how to establish baselines for your application
- Challenge 04: **[Enable Automated Load Testing (CI/CD)](./Solution-04.md)**
	 - Incorporate load testing into your CI/CD Pipeline
- Challenge 05: **[Identify & Remediate Bottlenecks](./Solution-05.md)**
	 - Review load test results and identify bottlenecks
- Challenge 06: **[Stress Testing](./Solution-06.md)**
	 - How to perform stress tests and observing your application behavior
- Challenge 07: **[Load Testing With Chaos Experiment (Resilience Testing)](./Solution-07.md)**
	 - Incorporate load testing and chaos experiments together

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file as this contains the sample application they will need for this hack. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription/resource group where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

Requirements:

- Contributor permissions to a subscription or resource group
- Resources - The following resources will be created during the hack
	- Azure Load Testing
	- Azure App Service
	- Azure Cosmos DB
	- Azure Application Insights

## Suggested Hack Agenda
This hack is estimated to take 3 days with 4 hours each day.
## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Sample app code, ARM Template, and deployment script is located here for students to deploy the sample app used in the challenges  (Must be packaged up by the coach and provided to students at start of event)