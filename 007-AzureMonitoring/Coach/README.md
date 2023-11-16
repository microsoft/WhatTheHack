# What The Hack - Azure Monitoring - Coach Guide

## Introduction

Welcome to the coach's guide for the Azure Monitoring What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx) that features short sections to introduce key topics associated with each challenge. It is recommended that the coach presents each short section before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your Azure environment and deploy your eShopOnWeb application.
- Challenge 01: **[Monitoring Basics: Metrics, Logs, Alerts and Dashboards](./Solution-01.md)**
	 - Configure basic monitoring and alerting
- Challenge 02: **[Setting up Monitoring via Automation](./Solution-02.md)**
	 - Automate deployment of Azure Monitor at scale
- Challenge 03: **[Azure Monitor for Virtual Machines](./Solution-03.md)**
	 - Configure VM Insights and monitoring of virtual machine performance
- Challenge 04: **[Azure Monitor for Applications](./Solution-04.md)**
	 - Monitoring applications for issues
- Challenge 05: **[Azure Monitor for Containers](./Solution-05.md)**
	 - Monitoring containers performance and exceptions
- Challenge 06: **[Log Queries with Kusto Query Language (KQL)](./Solution-06.md)**
	 - Use the Kusto Query Language (KQL) to write and save queries
- Challenge 07: **[Visualizations](./Solution-07.md)**
	 - Create visualizations to build insights from the data collected in the previous challenges

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Students should have the Azure "contributor" role on their Azure subscription

In Challenge 00, students will deploy a provided Bicep template that deploys multiple Azure resources for the eShopOnWeb sample application. The students will work to configure Azure Monitor to monitor those resources during the hack.

The Bicep template requires the `Microsoft.OperationsManagement` resource provider to be registered in the student's Azure subscription in order to run. Details on this are included in Challenge 00.

The Bicep template deploys the following resources:
- 2 x 2 vCPUs VMs for the Visual Studio & SQL Server VMs
- 2 x 2 vCPUs VM Scale Set for the web server
- 1 x 2 vCPUs VM for the AKS cluster
- Azure Bastion
- Log Analytics
- Application Insights
- Azure Storage Account

**NOTE:** These resources may consume more than the monthly allowance in a trial Azure Subscription if left running for the typical 3-day duration of a hack.  It is important for coaches to remind students to shut down all VMs, the VM Scale Set, and AKS cluster at the end of each hack day to conserve resources.

## Suggested Hack Agenda

This hack is designed to be run as a full 3-day event, for a total of approximately 18 hours to complete all challenges. There are multiple variations of this hack that enable you run it for a shorter period of time and still provide value to attendees. Different groups of students will complete the challenges at different paces based on their comfort level with Azure and/or using Command Line Interface (CLI) tools. This is okay, and students should be encouraged to participate in this intro-level hack no matter what their experience level is.

While the challenges are designed to build the students' knowledge iteratively, you can shorten the hack based on the organization's learning objectives. 

Challenges 00, 01, and 02 must be completed in order.

For a "choose your own adventure" hack experience after completing challenge 02, you can complete any combination of challenges 03, 04, and/or 05 but must do a minimum of one of them in order to proceed to challenge 06.

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc.. meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
