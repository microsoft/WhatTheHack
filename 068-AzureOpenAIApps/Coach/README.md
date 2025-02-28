# What The Hack - Building AI Apps with OpenAI and the Azure Ecosystem - Coach's Guide

## Introduction

Welcome to the coach's guide for the Building AI Apps with OpenAI and the Azure Ecosystem What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Pre-requisites - Ready, Set, GO!](Solution-00.md)**
	 - Prepare your workstation and environment to work with Azure. Deploy the dependencies to Azure.
- Challenge 01: **[Auto-Vectorization: Automatic Processing of Document Embeddings from Data Sources](Solution-01.md)**
	- Design and implement a pipeline that tracks changes to the document sources (object stores, relational databases, NoSQL databases) and automatically processes the embeddings for these documents (if necessary). 
    - The pipeline also stores these dense vectors in the appropriate vector databases for usage in vector, sparse and hybrid search.
- Challenge 02: **[Contoso Travel Assistant](Solution-02.md)**
	 - Design and implement a virtual assistant that responds to frequently asked questions about the economy, climate and government based on static data from the Contoso Islands documents stored in blob storage.
	 - Design and implement a virtual assistant that provides near real-time answers to Contoso Islands tourists that are looking to make a reservation for a Yacht tour for a specific date.
- Challenge 03: **[The Teacher's Assistant — Batch & Near Realtime Essay Grading](Solution-03.md)**
	 - Design and implement a pipeline that reads, analyzes and grades essays submitted in various file and image formats (PDF, JPEG/JPG, PNG, BMP, and TIFF) loaded from Azure Blob Storage.
- Challenge 04: **[Quota Monitoring and Enforcement](Solution-04.md)**
	 - Design and implement a solution to monitor the usage of OpenAI resources as well as the enforcement of quotas allocated to multiple users within an organization.
- Challenge 05: **[Performance and Cost and Optimizations](Solution-05.md)**
     - Design and implement a solution that optimizes the application performance and minimizes the operational costs of the OpenAI solutions.

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

Because of capacity issues, a coach should run a deployment themselves BEFORE the start of the hack to make sure that the deployment in Challenge 0 will work. 

### Student Resources

The coach should provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

Students need to have "contributor" access to an Azure subscription.

- [Azure subscription](https://azure.microsoft.com/en-us/free/)

Students that choose to use Github Codespaces should not require any other additional software on their computer other than a standard web browser like Edge or Chrome. 

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be provided to students at start of event although it will be included with the GitHub Codespace by default)
