# What The Hack - Mongo DB to Azure Document DB Migration - Coach's Guide

## Introduction

In this hack, the students will learn how to move a MongoDB workload from MongoDB to Azure DocumentDB with minimal effort. They'll start by creating a MongoDB database from a sample and deploying a sample Node.js application. They will make sure it works as is. They will then perform a guided migration of that database to Azure using the Visual Studio Code extension for DocumentDB. Finally, they'll understand the core migration flow, validate data in the new environment, fix an issues they might encounter, and run the app against the migrated database.

## Learning Objectives

- Assess source database readiness and identify key migration considerations before moving data.
- Use the DocumentDB VS Code extension to execute and monitor a database migration.
- Compare source and target results to verify collection structure, document counts, and query behavior.
- Update application configuration and troubleshoot common connectivity or compatibility issues after cutover.

## Coach guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Solution-00.md)**
   - Deploy the source database and get the sample application up and running
- Challenge 01: **[Prepare and perform the migration to Azure DocumentDB](Solution-01.md)**
   - Use the Azure DocumentDB migration extension for Visual Studio Code to assess the source MongoDB workload and identify and fix any issues that will block migration.
- Challenge 02: **[Compare source and target databases and update the application configuration](Solution-02.md)**
   - Compare the source target databases and if everything is okay, you will modify the application configuration with the new Azure DocumentDB and re-run the application

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- The hack deploys MongoDB on Azure Container Instances for the source MongoDB. It also deploys Azure DocumentDB to the M20 Compute Tier. This is configurable. 
- The student should have contributor access to the Azure subscription. 

## Suggested Hack Agenda 

* Challenge 0 (Setup): 30-45 minutes
* Challenge 1 (Extension + DocumentDB deployment): 45-60 minutes
* Challenge 2 (Migration): 45-60 minutes
* Buffer time for troubleshooting: 30 minutes per challenge

This timing does not include any lecture content that you may wish to include 

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
