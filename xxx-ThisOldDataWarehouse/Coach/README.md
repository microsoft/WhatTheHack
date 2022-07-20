# What The Hack - ThisOldDataWarehouse - Coach Guide

## Introduction

This workshop is intended to give Data Engineers a level 400 understanding of the Modern Data Warehouse architecture and development skills to build it with Azure Synapse Analytics.  First, data engineers will learn how to migrate their SQL Server on-premise workloads to Azure Synapse analytics.  Likewise, the workshop will provide the skills and best practices to integrate a Data Lake into the existing data warehouse platform.  This will require the existing ETL (SSIS package) be refactored into Azure Data Factory pipelines.  Additionally, Modern Data Warehouse platforms are starting to integrate real-time data pipelines into the data lake.  Lastly, the students will be able to build out a Power BI Data model and tune it and the Synapse platform for optmial performance.  This will showcase Synapse Analytics performance with Dashboards.

The format we're following for this is similar to other initiatives like OpenHack and What the Hack. The material is intended to be light on presentations and heavy on hands on experience. The participants will spend the majority of their time working on challenges. The challenges are not designed to be hands on labs, but rather a business problem with success criteria. The focus here is encouraging the participants to think about what they're doing and not just blindly following steps in a lab.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Setup](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Data Warehouse Migration](./Solution-01.md)**
	 - Description of challenge
- Challenge 02: **[Data Lake Integration](./Solution-02.md)**
	 - Description of challenge
- Challenge 03: **[Data pipeline Migration](./Solution-03.md)**
	 - Description of challenge
- Challenge 04: **[Real-time Data Pipeline](./Solution-04.md)**
	 - Description of challenge
- Challenge 05: **[Analytics Migration](./Solution-05.md)**
	 - Description of challenge
- Challenge 06: **[Title of Challenge](./Solution-06.md)**
	 - Description of challenge
- Challenge 07: **[Title of Challenge](./Solution-07.md)**
	 - Description of challenge
- Challenge 08: **[Title of Challenge](./Solution-08.md)**
	 - Description of challenge
- Challenge 09: **[Title of Challenge](./Solution-09.md)**
	 - Description of challenge
- Challenge 10: **[Title of Challenge](./Solution-10.md)**
	 - Description of challenge
- Challenge 11: **[Title of Challenge](./Solution-11.md)**
	 - Description of challenge
- Challenge 12: **[Title of Challenge](./Solution-12.md)**
	 - Description of challenge
- Challenge 13: **[Title of Challenge](./Solution-13.md)**
	 - Description of challenge
- Challenge 14: **[Title of Challenge](./Solution-14.md)**
	 - Description of challenge
- Challenge 15: **[Title of Challenge](./Solution-15.md)**
	 - Description of challenge

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

_Please list Azure subscription requirements._

_For example:_

- Azure resources that will be consumed by a student implementing the hack's challenges
- Azure permissions required by a student to complete the hack's challenges.

## Suggested Hack Agenda (Optional)

The following is expected timing for a standard delivery.

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
