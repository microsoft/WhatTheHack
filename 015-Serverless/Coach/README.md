# What The Hack - Azure Serverless - Coach Guide

## Introduction

Welcome to the coach's guide for the Azure Serverless What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

These are intended to be helpful tips should you not know what the student may have done wrong.  Screenshots are only as accurate as the time of screen capture and are subject to change.

<!--
This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.
-->

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 01: **[Setup](./Solution-01.md)**
	 - Prepare your workstation to develop your Serverless Solution
- Challenge 02: **[Create a Hello World Function](./Solution-02.md)**
	 - Create your first "Hello World" Azure Function in Visual Studio Code
- Challenge 03: **[Create Resources](./Solution-03.md)**
	 - Provision the basic resources in Azure to prepare your deployment ground
- Challenge 04: **[Configuration](./Solution-04.md)**
	 - Configure application settings on the Microsoft Azure Portal and update the TollBooth application code
- Challenge 05: **[Deployment](./Solution-05.md)**
	 - Deploy the Tollbooth project to the "App" in the Azure Portal Function App and configure the Event Grid
- Challenge 06: **[Create Functions Using VS Code](./Solution-06.md)**
	 - Create the event triggered functions in VS Code to respond to Event Grid Topics
- Challenge 07: **[Monitoring](./Solution-07.md)**
	 - Configure application monitoring with Application Insights Resource on Azure Portal
- Challenge 08: **[Data Export Workflow](./Solution-08.md)**
	 - Deploy a Logic App to periodically export the license plate data and conditionally send an email

## Coach's Guides for Optional Challenges
- Challenge 07A: **[Scale the Cognitive Service](./Solution-07A.md)**
	 - Witness the dynamic scaling of the Function App demonstrating the true Serverless behaviour
- Challenge 07B: **[View Data in Cosmos DB](./Solution-07B.md)**
	 - Use the Azure Cosmos DB Data Explorer in the portal to view saved license plate data

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- A laptop: Windows, MacOS or Linux OR A development machine that you have **administrator rights** on.
- Active Azure Subscription with **contributor level access or equivalent** to create or modify resources.

## Suggested Hack Agenda

- Estimated duration is 12 hours depending on student skill level

## Repository Contents

- `../Coach`
  - Coach's Guide and related files
- `../Student/Resources`
  - Image files and code for TollBooth Application meant to be provided to students.
  (Must be packaged up by the coach and provided to students at start of event)
- `../images`
  - Generic image files needed
- `../Student`
  - Student's Challenge Guide
