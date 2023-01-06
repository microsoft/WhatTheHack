# What The Hack - This Old Data Warehouse - Coach Guide

## Introduction

Welcome to the coach's guide for the This Old Data Warehouse What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](./MDWWTHIntro.pptx?raw=true) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Setup](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Data Warehouse Migration](./Solution-01.md)**
	 - Migrate EDW from SQL Server to Azure Synapse Analytics.  Lift & Shift ETL code to SSIS Runtime
- Challenge 02: **[Data Lake Integration](./Solution-02.md)**
	 - Build out Staging tier in Azure Data Lake.  Architect Lake for different refinement layers (staging, cleansed and presentation tiers) with POSIX setup
- Challenge 03: **[Data Pipeline Migration](./Solution-03.md)**
	 - Rewrite SSIS jobs from ETL data flow  to ADF as a ELT data flow.
- Challenge 04: **[Real-time Data Pipeline](./Solution-04.md)**
	 - Real-time data with Kafka and Databricks
- Challenge 05: **[Analytics Migration](./Solution-05.md)**
	 - Migrate reporting into Azure
- Challenge 06: **[Enterprise Security](./Solution-06.md)**
	 - Enterprise Security into Synapse Analytics
- Challenge 07: **[Unified Data Governance](./Solution-07.md)**
	 - Data Governance integration into Synapse

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Azure resources that will be provisioned by a student implementing the hack's challenges
	- Azure Data Factory
	- Azure Synapse Workspace
	- Azure Synapse Dedicated SQL Pool
	- Azure Storage Account
	- Azure Databricks Service
	- Azure Container Instance (Running SQL Server & Data Generator)
	- Azure Event Hubs
	- Azure SQL Database

- Azure permissions required by a student to complete the hack's challenges.
	- Access to an Azure Subscription 
	- Minimum access rights is Contributor for the resource group you are provisioning these services.

- These will the the Resource Providers that need to be registered in the subscription
	- Microsoft.Synapse
	- Microsoft.Databricks
	- Microsoft.StreamAnalytics
	- Microsoft.Storage
	- Microsoft.KeyVault
	- Microsoft.Datafactory
	- Microsoft.Sql
	- Microsoft.EventHub
	- Microsoft.ContainerInstance

## Suggested Hack Agenda

The Modern Data Warehouse What the Hack takes approximately 3 days from Challenges 1 to Challenge 5.  The first three challenges are in sequential order, and you must complete the previous challenges before going onto the next one.  Challenge 4 to 7 have no dependencies, and we typically have the attendees choose their own adventure.  Based on the students interest, they might like to learn more on several of these challenges, so we ask them to pick two of the four challenges to keep their work in the three-day timeframe.  Here are suggested times for the challenges to serve as guidance, but times might vary depending on your student's proficiency with data warehousing.

|                                            |                                                                                                                                                       |
| ------------------------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------: |
| **Topic** |  **Duration**  |
| Presentation 0:  [Welcome and Introduction](./MDWWTHIntro.pptx)  | 5 mins |
| Challenge 0: Environment Setup | 30 mins|
| Presentation 1: [Intro to Modern Data Warehouse](./MDWWTHIntro.pptx) | 30 mins|
| Challenge 1: Data Warehouse Migration | 240 mins |
| Challenge 2: Data Lake Integration | 120 mins |
| Challenge 3: Data pipeline Migration | 240 mins |
| Challenge 4: Realtime Data Pipelines | 120 mins |
| Challenge 5: Analytics Migration | 120 mins |
| Challenge 6: Enterprise Security | 120 mins |
| Challenge 7: Unified Data Governance | 120 mins |

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
