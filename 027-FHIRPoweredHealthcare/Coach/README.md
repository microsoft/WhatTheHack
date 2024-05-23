# What The Hack - FHIR Powered Healthcare - Coach Guide

## Introduction

Welcome to the coach's guide for the FHIR Powered Healthcare What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx?raw=true) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

**These challenges must be completed in order:**
- Challenge 0: **[Pre-requisites - Ready, Set, GO!](./Solution00.md)**
    - Required tools needed to implement the hack challenges
- Challenge 1: **[Extract and Load FHIR EHR Data](./Solution01.md)**
    - Deploy FHIR service in Azure Health Data Services platform
    - Generate and load synthetic Electronic Health Record (EHR) data into FHIR Service.

**These challenges can be completed in any order:**
- Challenge 2: **[Extract and Load `HL7v2` and `C-CDA` EHR Data](./Solution02.md)**
    - Convert and Load `HL7v2` and `C-CDA` clinical data into FHIR Service.
- Challenge 3: **[Search FHIR EHR Data](./Solution03.md)**
    - Develop Single Page App (SPA) to search and view FHIR EHR data.
- Challenge 4: **[Explore and Analyze FHIR EHR Data](./Solution04.md)**
    - Transform and explore FHIR data for secondary use analytics.
- Challenge 5: **[Export and Anonymize FHIR EHR Data](./Solution05.md)**
    - Export, anonymize and store FHIR EHR data in data lake for secondary use.
- Challenge 6: **[Ingest and Persist IoT Medical Device Data](./Solution06.md)**
    - Ingest, transform and load medical IoT device data into FHIR using MedTech service.
- Challenge 7: **[Load DICOM Imaging Data](./Solution07.md)**
    - Ingest, search and retrieve imaging data persisted in the DICOM service.
- Challenge 8: **[OMOP Analytics](Student/Challenge08.md)**
    - Transform FHIR data to OMOP open standards for downstream analytics using Healthcare Data Solutions.

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

This hack will deploy the following Azure resources and OSS components to implement the hack's challenges:
- Azure Health Data Services workspace (managed PaaS in various challenges)
- FHIR service	(managed FHIR server in challenge 1)
- DICOM service (managed DICOM server in challenge 7)
- MedTech service (managed PaaS to ingest and convert IoT medical device data into FHIR in challenge 6)
- FHIR Loader (OSS) Function App based event-driven pipeline (for ingesting FHIR data in Challenge 1)
- Azure Function (managed Serverless solution to host FHIR Loader app in challenge 1)
- FHIR Analytics Pipeline - FHIR to Synapse sync agent (OSS pipeline to move FHIR data in FHIR service to Azure Data Lake for analytics with Synapse in challenge 4)
- Tool for Health Data Anonymization pipeline (ADF pipeline to export and anonymize FHIR data in challenge 5)
- Serverless SQL pool in Azure Synapse Analytics (Query service over the data in your data lake in challenge 4)
- Azure Data Factory (Cloud ETL pipeline used in challenge 5)
- Azure Batch (Perform the de-identification in Tools for Health Data Anonymization in challenge 4)
- App Service Plan (Shared by FHIR Loader function apps)
- Storage account (Data Lake/Blob storage for various challenges)
- Key Vault (Stores secrets and configuration settings in various challenges)
- Log Analytics Workspace (Logs the activity of deployed components in various challenges)
- Application Insights (Monitors FHIR Loader application in various challenges)
- Event Grid System Topic (Triggers processing of FHIR bundles placed in the FHIR Loader storage account)
- Azure Data Factory (Export/Anonymize pipeline in challenge 5)
- Event Hub (managed event ingesting service in challenge 6)
- Healthcare Data Solutions (Pre-built pipelines to convert FHIR data to OMOP open standards within Microsoft Fabric Lakehouse in challenge 8)
- Microsoft Fabric (Pre-built Lakehouses and Notebooks in challenge 8)

## Repository Contents

- `.Coach`
  - Coach's Guide and related files
- `.Student`
  - Student's Challenge Guide
- `.Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
