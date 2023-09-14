# What The Hack - Modern GitHub Dev - Coach Guide

## Introduction

Welcome to the coach's guide for the Modern Development and DevOps with GitHub What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Configure Your Development Environment](./Solution-01.md)**
	 - Setup your development environment in the cloud
- Challenge 02: **[Add A Feature To The Existing Application](./Solution-02.md)**
	 - Leverage GitHub Copilot to help you add features to your application
- Challenge 03: **[Setup Continuous Integration And Ensure Security](./Solution-03.md)**
	 - Setup continuous integration and integrate GitHub Advanced Security into your pipeline
- Challenge 04: **[Create A Deployment Environment](./Solution-04.md)**
	 - Use IaC to provision your cloud environment
- Challenge 05: **[Setup Continuous Deployment](./Solution-05.md)**
	 - Deploy your application to Azure with Continuous Delivery

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

- The sample application is hosted in the GitHub organization and is located [here](https://github.com/github/pets-workshop), there is no student resources directory like other hacks have.

- The [student resources folder](../Student/resources/) contains a copy of a possible solution for the React component for [Challenge 2 - Add a feature to the existing application](../Student/challenge02.md). Students are welcome to copy/paste this file if they don't feel comfortable coding.
  
Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.


## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Attendees should have the “Azure account administrator” (or "Owner") role on the Azure subscription in order to authenticate, create and configure the resource group and necessary resources including:
    - Serverless Cosmos DB with Mongo API
    - Azure Container App with supporting services


## Repository Contents


- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- The sample application is hosted in the GitHub organization and is located [here](https://github.com/github/pets-workshop)
