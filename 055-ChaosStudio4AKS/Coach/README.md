# What The Hack - ChaosStudio4AKS - Coach Guide

## Introduction

Welcome to the coach's guide for the ChaosStudio4AKS What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Is your Application ready for the Super Bowl?](./Solution-01.md)**
	 - How does your application handle failure during large scale events?
- Challenge 02: **[My AZ burned down, now what?](./Solution-02.md)**
	 - Can your application survive an Azure outage of 1 or more Availability Zones?
- Challenge 03: **[Godzilla takes out an Azure region!](./Solution-03.md)**
	 - Can your application survive a region failure?
- Challenge 04: **[Injecting Chaos into your pipeline](./Solution-04.md)**
	 - Optional challenge, using Chaos Studio experiments in your CI/CD pipeline

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

### Additional Coach Prerequisites (Optional)

None are required for this hack

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Azure subscription with contributor access
- Visual Studio Code terminal or Azure Shell
- Latest Azure CLI (if not using Azure Shell)
- Chaos Studio, Azure Kubernetes Service (AKS) and Traffic Manager services will be used in this hack


## Suggested Hack Agenda

- Day 1
  - Challenge 0 (1.5 hours)
  - Challenge 1 (2 hours)
  - Challenge 2 (1 hours)
  - Challenge 3 (1 hours)

- Day 2
  - Challenge 4 (4 hours)

## Repository Contents

_The default files & folders are listed below. You may add to this if you want to specify what is in additional sub-folders you may add._

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
