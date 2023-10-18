# What The Hack - Entra ID B2B - Coach Guide

## Introduction

Welcome to the coach's guide for the Entra ID B2B What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.


## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
     - Create an Entra ID tenant
     - Entra ID single tenant setup
- Challenge 01: **[Register new application](./Solution-01.md)**
     - Register a new application in an Entra ID tenant
     - Understand the concepts of multi-tenant apps, service principals, authentication vs authorization, security tokens
- Challenge 02: **[Test the sign-in](./Solution-02.md)**
	 - Supported account types set to "Accounts in this organizational directory only (single-tenant)" with redirect link to authr.dev
     - Use an authr.dev link to test the sign in
- Challenge 03: **[Invite a guest user](./Solution-03.md)**
     - Complete B2B setup and invite a new guest user
     - Use an authr.dev link to test the sign in for the guest user and test sign in using the app setup
- Challenge 04: **[Integrate Entra ID authentication into an Azure App Service (EasyAuth)](./Solution-04.md)**
	 - Integrate Entra ID authentication into an Azure App Service (EasyAuth)
- Challenge 05: **[Integrate Entra ID authentication into an application](./Solution-05.md)**
	 - Integrate Entra ID authentication into an application
        - ASP.Net (Authorization Code Flow)
        - SPA (Angular) (PKCI)  
        - Desktop application (Client Credential Flow)
- Challenge 06: **[Deploy to Azure](./Solution-06.md)**
	 - Deploy to Azure
     - Publish the Web App to the web site and update its app registration redirect URIs to include the App Service URL(s)
     - Setup Managed identity

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.


## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.



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
