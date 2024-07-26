# What The Hack - Data Science In Microsoft Fabric

## Introduction

Welcome to the coach's guide for the Data Science In Microsoft Fabric What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Configure your Fabric workspace and gather your data
- Challenge 01: **[Bring your data to the OneLake](./Solution-01.md)**
	 - Creating a shortcut to the available data
- Challenge 02: **[Prepare your data for ML](./Solution-02.md)**
	 - Clean and transform the data into a useful format while leveraging Data Wrangler
- Challenge 03: **[Train and register the model](./Solution-03.md)**
	 - Train a machine learning model with ML Flow with the help of Copilot
- Challenge 04: **[Generate batch predictions](./Solution-04.md)**
	 - Score a static dataset with the model
- Challenge 05: **[Visualize predictions with a PowerBI report ](./Solution-05.md)**
	 - Visualize generated predictions by using a PowerBI report
- Challenge 06: **[Deploy the model to an AzureML real-time endpoint](./Solution-06.md)**
	 - Deploy the trained model to an AzureML inferencing endpoint

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download the "StudentResources.zip" file. The coach should then provide a copy of the file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.


## Azure and M365 Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

Required resources during this hack:
- Azure storage account to upload training data
- Fabric capacity if not using the trial

Each student will need a PowerBI Pro or Premium per user license for Challenge 06, build a PowerBI Report, unless they are using the Fabric Trial or a capacity sized larger than F64. 

## Suggested Hack Agenda 

You may schedule this hack in any format, as long as the challenges are completed sequentially.

Time estimate for each challenge:
- Challenge 00: 15 minutes
- Challenge 01: 30 minutes
- Challenge 02: 30 minutes
- Challenge 03: 45 minutes
- Challenge 04: 30 minutes
- Challenge 05: 30 minutes
- Challenge 06: 45 minutes

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Notebooks`
  - Solution files with completed example answers to challenges
- `./Coach/CoachResources.zip`
  - Coach resources ready to be downloaded as a zip file
- `./Student`
  - Student's Challenge Guide
- `./Student/StudentResources.zip`
  - Student resources ready to be downloaded as a zip file
- `./Student/Resources`
  - Unpackaged version of StudentResources.zip
