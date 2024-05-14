# What The Hack - RockPaperScissorsBoom - Coach Guide

## Introduction

Welcome to the coach's guide for the RockPaperScissorsBoom What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Solution-00.md)**
  - Prepare your workstation to work with Azure.
- Challenge 01: **[Run the app](Solution-01.md)**
  - Get the app running locally
- Challenge 02: **[Move to Azure SQL Database](Solution-02.md)**
  - Modify the locally running app to use an Azure SQL database
- Challenge 03: **[Run the app on Azure](Solution-03.md)**
  - Deploy the containerized app to Azure
- Challenge 04: **[Run the Game Continuously](Solution-04.md)**
  - Set up automation to run the game continuously
- Challenge 05: **[Add Application Monitoring](Solution-05.md)**
  - Add Application Monitoring to the app
- Challenge 06: **[Implement AAD B2C](Solution-06.md)**
  - Implement authentication for the application
- Challenge 07: **[Leverage SignalR](Solution-07.md)**
  - Set up a bot to play the game & communicate with SignalR
- Challenge 08: **[Leverage CDN](Solution-08.md)**
  - Set up a CDN to serve static content
- Challenge 09: **[Send a Winner Notification](Solution-09.md)**
  - Send a notification when a game is won
- Challenge 10: **[Run a Load Test](Solution-10.md)**
  - Run a load test against the app
- Challenge 11: **[Tournament Instructions](Solution-11.md)**
  - Build a bot and compete in a tournament

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

### Additional Coach Prerequisites (Optional)

_Please list any additional pre-event setup steps a coach would be required to set up such as, creating or hosting a shared dataset, or deploying a lab environment._

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Azure subscription with **Contributor** or **Owner** access
- Ability to create/use a resource group
- Ability to create the following Azure services
  - App Service
  - Azure SQL
  - Application Insights
  - Azure Container Registry
  - Event Hub
  - Event Grid
  - Azure Front Door
  - Logic Apps
  - Load Testing

## Suggested Hack Agenda (Optional)

_This section is optional. You may wish to provide an estimate of how long each challenge should take for an average squad of students to complete and/or a proposal of how many challenges a coach should structure each session for a multi-session hack event. For example:_

- Sample Day 1
  - Challenge 1 (1 hour)
  - Challenge 2 (1 hour)
  - Challenge 3 (1 hour)
  - Challenge 4 (1 hour)
  - Challenge 5 (1 hour)
- Sample Day 2
  - Challenge 6 (2 hour)
  - Challenge 7 (1 hour)
  - Challenge 8 (1 hour)
  - Challenge 9 (1 hour)
- Sample Day 3
  - Challenge 10 (1 hour)
  - Challenge 11 (1 hour)

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
