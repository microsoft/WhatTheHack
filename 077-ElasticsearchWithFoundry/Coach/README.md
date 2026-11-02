# What The Hack - Context Quest: Optimizing AI Agents with Microsoft Foundry and Elastic Context Engine - Coach Guide

**[Hack Home](../README.md)**

## Introduction

Welcome to the coach's guide for the Intro To Kubernetes What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an [optional lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

Coach students toward evidence, not a predetermined token-saving result. This workshop uses a fictional customer-support scenario to connect Microsoft Foundry with Elastic MCP, generate reusable context using native Context Engine, and evaluate prompt-injection resistance.


**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Ready, Set, Connect](./Solution-00.md)**
  - Prepare your own environments and launch the supplied notebook workspace.
- Challenge 01: **[Connect Foundry Agent to Elastic](./Solution-01.md)**
  - Build a Foundry agent with Elastic MCP and collect a discovery baseline.
- Challenge 02: **[Build the Context Engine](./Solution-02.md)**
  - Create an AI Index and Knowledge Indicators, and retrieve the Context Engine MCP endpoint.
- Challenge 03: **[Rise of Agent Optimus](./Solution-03.md)**
  - Build a Foundry agent on the Context Engine and compare it with Agent Mole.

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event.

### Student Resources

This hack uses GitHub Codespaces for all student resources. Students should use their personal GitHub accounts to access Codespaces which will provide a configured VS Code developer environment for them that runs in a browser, hosted in the cloud.

Alternatively, students may download the Student Resources package: [Resources.zip](https://aka.ms/wth/elasticwithfoundry/resources) and use the DevContainer in it to load the pre-configured developer environment on their local workstation.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

Students should have permissions to create the following resources:
- Microsoft Foundry project
- Deploy OpenAI models

The hack also requires access to an Elastic Serverless environment. Elastic can be provisioned through the Microsoft Marketplace with a 7-day free trial. 

If the student Azure accounts are blocked from Marketplace deployments, they can provision the trial from [Elastic's website](https://elastic.co).

## Suggested Hack Agenda

This hack was designed to be run as a 3 hour event. It was authored with more "step-by-step" guidance than the typical What The Hack to ensure the majority of students can complete the three challenges in the given time.

Use these coach-only facilitation budgets after accounts are ready. Adjust from pilot evidence; do not expose speed-based success criteria to students.

| Activity | Compact session | Extended session |
|---|---|---|
| Intro and learning goals | 10 minutes | 10 minutes |
| Challenge 00 | 15 minutes | 20 minutes |
| Challenge 01 | 20 minutes | 30 minutes |
| Challenge 02 | 20 minutes | 30 minutes |
| Challenge 03 | 20 minutes | 30 minutes |
| Challenge 04 | 30 minutes | 45 minutes |
| Evidence demos and optional extensions | 10 minutes | 20 minutes |
| Cleanup | 5 minutes | 10 minutes |
| Total | 120 minutes | 180 minutes |



## Repository Contents

- `./Coach`
  - Coach's Guide and related files
  - [Lecture presentation](Lectures.pptx?raw=true) with short presentations to introduce each challenge.
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc. meant to be accessed by students via GitHub Codespaces or a local DevContainer
