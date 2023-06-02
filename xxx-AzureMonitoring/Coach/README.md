# What The Hack - Azure Monitoring - Coach Guide

## Introduction

Welcome to the coach's guide for the Azure Monitoring What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx) that features short sections to introduce key topics associated with each challenge. It is recommended that the coach presents each short section before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your Azure environement and deploy your eShopOnWeb application.
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

### Additional Coach Prerequisites (Optional)

_Please list any additional pre-event setup steps a coach would be required to set up such as, creating or hosting a shared dataset, or deploying a lab environment._

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

_Please list Azure subscription requirements._

_For example:_

- Azure resources that will be consumed by a student implementing the hack's challenges
- Azure permissions required by a student to complete the hack's challenges.

## Suggested Hack Agenda (Optional)

### Note: For a "choose your own adventure" hack experience after completing challenge 02, you can complete any combination of challenges 03, 04 and 05 but must do a minimum of one of them in order to proceed to challenge 06

_This section is optional. You may wish to provide an estimate of how long each challenge should take for an average squad of students to complete and/or a proposal of how many challenges a coach should structure each session for a multi-session hack event. For example:_

Recommended maximum time spent on each challenge:
  - Challenge 0 (1 hour)
  - Challenge 1 (2 hour)
  - Challenge 2 (2 hour)
  - Challenge 3 (45 mins)
  - Challenge 4 ()
  - Challenge 5 ()
  - Challenge 6 ()
  - Challenge 7 ()

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
