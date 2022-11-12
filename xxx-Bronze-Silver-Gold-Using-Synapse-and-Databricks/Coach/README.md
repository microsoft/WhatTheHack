# What The Hack - Bronze-Silver-Gold-Using-Synapse-and-Databricks - Coach Guide

## Introduction

Welcome to the coach's guide for the Bronze-Silver-Gold-Using-Synapse-and-Databricks What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx?raw=true) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Building Out the Bronze](./Solution-01.md)**
	 - Description of challenge
- Challenge 02: **[Standardizing on Silver](./Solution-02.md)**
	 - Description of challenge
- Challenge 03: **[Go for the Gold](./Solution-03.md)**
	 - Description of challenge
- Challenge 04: **[Visualize the Results](./Solution-04.md)**
	 - Description of challenge

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Additional Coach Prerequisites

The purpose of this hackathon is for the particpants to utilize the three-tier data lake architecture to combine different data sources into one Delta Lake architecture that can be utilized.  

For Challenge 0, they will need to import data from both the AdventureWork and WideWorldImporters databases into the Bronze layer.  Thus, for the hackathon you must setup these databases in an Azure SQL environment so that the users can connect to these are a source.  We want the users to focus on Databricks and Synapse technologies and not be responsible for setting up these databases.

These databases can be obtained at the following sites:

- [AdventureWorks sample databases](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms)

- [World-Wide-Importers sample databases](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/wide-world-importers)

Also, make sure to create a database reader account that the users can utilize to read the various tables.  The _CREATE LOGIN HackathonUser.sql_ script is located in the [Solutions](./Solutions) folder.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.


## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

Each team/squad will collaborate in one Student's Azure subscription.  The subscription chosen must have the ability to add all users to that subscription and give them contributor access within the Resource Group created for this hackathon. 


## Session Guidance 

This What the Hack was cdesigned and executed for a remote/virtual audience.

We initially conducted this hackathon in three - 4 hour sessions for a total of 12 hours. It was done over a three week period with each session being conducted on a Friday.

- Day 1
  - Challenge 1 - Building Out the Bronze
  - Challenge 2 - Standardizing on Silver
 
- Day 2
  - Challenge 2 - Standardizing on Silver
  - Challenge 3 - Go for the Gold

- Day 3
  - Challenge 3 - Go for the Gold
  - Challenge 4 - Visualize the Results

We also had the attendees fill out a survey during registration to guage their expertise and we made sure that each team was balanced with experts and beginners using the following questions:

- Experience Level with ADF/ Synapse Pipelines (100=Newbie -> 400=SME)
- Experience Level with ADF/Synapse Data Flows
- Experience Level with Azure Databricks
- Experience Level with Power BI
Answers were single select options of 100/200/300/400

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
