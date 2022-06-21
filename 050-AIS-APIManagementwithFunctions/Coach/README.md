# What The Hack - AIS - API Management with Function Apps - Coach Guide

## Introduction

Welcome to the coach's guide for the Azure Integration Services - API Management with Function Apps Hack. Here you will find links to specific guidance for coaches for each of the challenges.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides
-  Challenge 0: **[Prepare your Development Environment](Solution-00.md)**
   - Get yourself ready to build your integration solution
-  Challenge 1: **[Provision an Integration Environment](Solution-01.md)**
   - Create a bicep template that will provision a baseline integration environment.
-  Challenge 2: **[Deploy your Integration Environment](Solution-02.md)**
   - Create a CI/CD pipeline to do automated deployment of your integration environment.
-  Challenge 3: **[Create Backend APIs](Solution-03.md)**
   - Create backend APIs
-  Challenge 4: **[Secure Backend APIs](Solution-04.md)**
   - Securing backend APIs by configuring them in the VNET or by using OAuth 2.0 authorization

## Coach Prerequisites 

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a `Resources.zip` file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.  

### Additional Coach Prerequisites 
- Visual Studio Code 1.63 or higher with Bicep extension
- Azure CLI 2.20.0 or higher
- Azure DevOps project or GitHub project

## Azure Requirements

These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

This hack requires students to use an account that have Owner access to an Azure subscription so they can create and consume Azure resources such as: 

- API Management Service
- Azure Function Apps
- Virtual Networks 
- Private Endpoints

Moreover, check that the account the students will use have the right permissions to be able to create new AAD application registrations (service principals).  If the student accounts do not have this permission, then ask if your AAD Global Administrator can allow it, or create app-registrations (service principals) on the student's behalf for the hack.  Steps on how do this can be found [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal#permissions-required-for-registering-an-app).


## Suggested Hack Agenda 
- Day 1
	- Challenge 0 (1 hour)
	- Challenge 1 (2 hours)
	- Challenge 2 (1 hour)
- Day 2
	- Challenge 2 (1 hour)
 	- Challenge 3 (1 hour)
 	- Challenge 4 (1 hour)

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)





