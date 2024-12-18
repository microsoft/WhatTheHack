# What The Hack - Data Science In Microsoft Fabric

## Introduction

Welcome to the coach's guide for the Data Science In Microsoft Fabric What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Configure your Fabric workspace and gather your data
- Challenge 01: **[Bring your data to the OneLake](./Solution-01.md)**
	 - Creating a shortcut to the available data
- Challenge 02: **[Data preparation with Data Wrangler](./Solution-02.md)**
	 - Clean and transform the data into a useful format while leveraging Data Wrangler
- Challenge 03: **[Train and register the model](./Solution-03.md)**
	 - Train a machine learning model with ML Flow with the help of Copilot
- Challenge 04: **[Generate batch predictions](./Solution-04.md)**
	 - Score a static dataset with the model
- Challenge 05: **[Visualize predictions with a PowerBI report](./Solution-05.md)**
	 - Visualize generated predictions by using a PowerBI report
- Challenge 06: **[(Optional) Deploy the model to an AzureML real-time endpoint](./Solution-06.md)**
	 - Deploy the trained model to an AzureML endpoint for inference

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.


## Azure and Fabric Requirements

This hack requires students to have access to Azure and Fabric. These requirements should be shared with a stakeholder in the organization that will be providing the licenses that will be used by the students.

### Fabric and PowerBI licensing requirements:

Each student will need access to Microsoft Fabric and be licensed to create PowerBI reports for this hack. The following are the options to complete these licensing requirements:

1. **Recommended if available**: Individual [Fabric free trials](https://learn.microsoft.com/en-us/fabric/get-started/fabric-trial#start-the-fabric-capacity-trial). This will grant users access to creating the required Fabric items as well as the PowerBI report. **If previously used, the Fabric free trial may be unavailable**
2. Fabric Capacity and PowerBI Pro/Premium per user license. Each user would need their own PowerBI license but capacities could be shared and scaled up according to their needs. If running the hack on an individual basis, an F4 capacity would be adequate, and an F8 capacity would have generous compute power margin.  **Alternatively, users can activate a [PowerBI Free Trial](https://learn.microsoft.com/en-us/power-bi/fundamentals/service-self-service-signup-for-power-bi) if available.** The PowerBI trial could be available even if the Fabric one is not.


### Azure licensing requirements

There are 2 challenges that require access to Azure:

- Challenge 1: Students are required to navigate an Azure ADLS Gen 2 account through the Azure Portal to learn how to set up a Fabric shortcut to an existing file. This challenge requires each student to have contributor permissions to the resource, but 1 single storage account/directory/file could be shared among all students, given that they will not modify it but rather just access and connect to it.

- Challenge 6: Students are required to have Azure AI Developer access to an Azure Machine Learning resource. Each student will need to register their own model and create their own real-time endpoint, which is why it is **recommended to individually deploy an Azure ML workspace per student**.

Given these requirements, each student could have their own Azure subscription, or they could share access to a single subscription.

These Azure resources can be deployed on an individual per-student basis using the `deployhack.sh` script included in the student resources folder.

## Suggested Hack Agenda 

You may schedule this hack in any format, as long as the challenges are completed sequentially.

Time estimates for each challenge:
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
- `./Coach/Solutions`
  - Solution files with completed example answers to challenges
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Student resource files, also available as a download link on Student Challenge 0
