# What The Hack - Logic Apps Enterprise Integration - Coach Guide

## Introduction

Welcome to the coach's guide for the Logic Apps Enterprise Integration What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Process JSON input data & write to Storage](./Solution-01.md)**
	 - Create a Logic App workflow to process JSON input data & write it to Blob Storage
- Challenge 02: **[Write to SQL](./Solution-02.md)**
	 - Add the ability to write data to SQL
- Challenge 03: **[Modularize & integrate with Service Bus](./Solution-03.md)**
	 - Break up the Logic App into smaller pieces & integrate with Service Bus
- Challenge 04: **[Monitor end-to-end workflow](./Solution-04.md)**
	 - Use correlation ID & Application Insights to monitor the end-to-end workflow
- Challenge 05: **[Validation & custom response](./Solution-05.md)**
	 - Add validation & custom responses to the Logic App
- Challenge 06: **[Parameterize with app settings](./Solution-06.md)**
	 - Parameterize the Logic App with app settings instead of hard-coding values
- Challenge 07: **[Authenticate with AzureAD when calling custom API](./Solution-07.md)**
	 - Call a custom API protected via OAuth2 & AzureAD
- Challenge 08: **[Visual Studio Code authoring](./Solution-08.md)**
	 - Author Logic Apps in Visual Studio Code

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

## Suggested Hack Agenda

- Day 1
  - Challenge 1 (1 hour)
  - Challenge 2 (30 mins)
  - Challenge 3 (1 hour)
  - Challenge 4 (1 hour)
	- Challenge 5 (30 min)
	- Challenge 6 (30 min)
	- Challenge 7 (1 hour)
	- Challenge 8 (30 min)

## Repository Contents

_The default files & folders are listed below. You may add to this if you want to specify what is in additional sub-folders you may add._

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Content`
	- Student's Challenge Guide source files
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
