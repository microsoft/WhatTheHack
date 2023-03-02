# What The Hack - Modern development and DevOps with GitHub

## Introduction

Welcome to the coach's guide for the Modern development and DevOps with GitHub What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

> **NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- [Challenge 0](./Coach/solution00.md) - Setup and Introduction
- [Challenge 1](./Coach/solution01.md) - Configure your development environment
- [Challenge 2](./Coach/solution02.md) - Add a feature to the existing application
- [Challenge 3](./Coach/solution03.md) - Setup continuous integration and ensure security
- [Challenge 4](./Coach/solution04.md) - Create a deployment environment
- [Challenge 5](./Coach/solution05.md) - Setup continuous deployment

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Coach notes

- DevOps is a large topic, one which students can explore many aspects. Feel free to have conversations with teams about different approaches. Allow them to explore as they like.

### Student Resources

- The [student resources folder](../Student/resources/) contains a copy of a possible solution for the React component for [Challenge 2 - Add a feature to the existing application](../Student/challenge02.md). Students are welcome to copy/paste this file if they don't feel comfortable coding.

> **NOTE:** Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide. Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Attendees should have the “Azure account administrator” (or "Owner") role on the Azure subscription in order to authenticate, create and configure the resource group and necessary resources including:
    - Serverless Cosmos DB with Mongo API
    - Azure Container App with supporting services

> **NOTE:** A [bicep file](../Student/resources/main.bicep) is provided to create the necessary Azure resources

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
