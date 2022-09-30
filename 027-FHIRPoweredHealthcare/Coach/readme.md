# What The Hack - FHIR Powered Healthcare - Coach Guide

## Introduction

Welcome to the coach's guide for the FHIR Powered Healthcare What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

**These challenges must be completed in order:**
- Challenge 0: **[Pre-requisites - Ready, Set, GO!](Student/Challenge00.md)**
  - 
- Challenge 1: **[Extract and load FHIR synthetic Electronic Health Record (EHR) data](Student/Challenge01.md)**
    - Deploy FHIR service in Azure Health Data Services platform
    - Generate and load synthetic Electronic Health Record (EHR) data into FHIR Service.
**These challenges can be completed in any order:**
- Challenge 2: **[Extract, transform and load HL7v2 and C-CDA EHR data](Student/Challenge02.md)**
    - Convert and Load HL7v2 and C-CDA clinical data into FHIR Service.
- Challenge 3: **[Create a new Single Page App (SPA) for patient search](Student/Challenge03.md)**
    - Develop React Single Page App (SPA) to search and view FHIR patient data.
- Challenge 4: **[Analyze and Visualize FHIR data](Student/Challenge04.md)**
    - Transform and explore FHIR data for secondary use analytics.
- Challenge 5: **[Bulk export, anonymize and store FHIR data into Data Lake storage](Student/Challenge05.md)**
    - Export and anonymize FHIR data for secondary use.
- Challenge 6: **[Stream IoMT Device data into FHIR using MedTech service](Student/Challenge06.md)**
    - Ingest, transform and load medical IoT device data into FHIR using MedTech service.
- Challenge 7: **[ Ingest, search & retrieve DICOM imaging data](Student/Challenge07.md)**
    - Ingest, search and retrieve imaging data persisted in the DICOM service.

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the \`/Student/Resources\` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

### Additional Coach Prerequisites (Optional)

### Pre-Select Your Path For Container Content
Coaches, be sure to read the [Coach Guidance for Challenge 1](./Solution-01.md). You will need to select a proper path based on the learning objectives of the organization (to be decided PRIOR TO the hack!).  Select the proper path after consulting with the organization's stakeholder(s) for the hack.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

This hack will deploy the following Azure resources and OSS components to implement the hack's challenges:
- Azure Health Data Services workspace (managed PaaS)
- FHIR service	(managed FHIR server)
- FHIR Loader (OSS) Function App (for ingesting FHIR data in Challenge 1)
- App Service Plan (Shared by FHIR Loader function apps)
- Storage account (Blob storage for FHIR service $export operation in Challenge 5)
- Storage account (Storage account for FHIR Loader)
- Key Vault (Stores secrets and configuration settings)
- Log Analytics Workspace (Logs the activity of deployed components)
- Application Insights (Monitors FHIR Loader application)
- Event Grid System Topic (Triggers processing of FHIR bundles placed in the FHIR Loader storage account)

## Suggested Hack Agenda (Optional)

_This section is optional. You may wish to provide an estimate of how long each challenge should take for an average squad of students to complete and/or a proposal of how many challenges a coach should structure each session for a multi-session hack event. For example:_

- Sample Day 1
  - Challenge 1 (1 hour)
  - Challenge 2 (30 mins)
  - Challenge 3 (2 hours)
- Sample Day 2
  - Challenge 4 (45 mins)
  - Challenge 5 (1 hour)
  - Challenge 6 (45 mins)

## Repository Contents

_The default files & folders are listed below. You may add to this if you want to specify what is in additional sub-folders you may add._

- \`./Coach\`
  - Coach's Guide and related files
- \`./Coach/Solutions\`
  - Solution files with completed example answers to a challenge
- \`./Student\`
  - Student's Challenge Guide
- \`./Student/Resources\`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
