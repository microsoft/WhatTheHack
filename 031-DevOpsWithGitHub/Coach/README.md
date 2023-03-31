# What The Hack - DevOps with GitHub - Coach Guide

## Introduction
Welcome to the coach's guide for the DevOps with GitHub What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.


**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides
- Challenge 00: **[Setup Azure & Tools](./Solution-00.md)**
	- Get your environment set up to hack
- Challenge 01: **[Setup Your Repository](./Solution-01.md)**
	- Establish version control by putting your code into a GitHub repository
- Challenge 02: **[Setup a Codespace](./Solution-02.md)**
	- Create a cloud based development environment with all of the prerequisite tools 
- Challenge 03: **[Track Your Work with GitHub Project Boards](./Solution-03.md)**
	 - How to track your projects/work leveraging GitHub Project Boards
- Challenge 04: **[First GitHub Actions Workflow](./Solution-04.md)**
	 - Write a simple GitHub Actions Workflow
- Challenge 05: **[Infrastructure as Code](./Solution-05.md)**
	 - Infrastructure as Code Automation with GitHub Actions
- Challenge 06: **[Continuous Integration](./Solution-06.md)**
	 - Continuous Integration with GitHub Actions
- Challenge 07: **[Build and Push Docker Image to Container Registry](./Solution-07.md)**
	 - Build and push Docker images to container registry(ACR)
- Challenge 08: **[Continuous Delivery](./Solution-08.md)**
	 - Deploying your application to Azure with Continuous Delivery
- Challenge 09: **[Branching & Policies](./Solution-09.md)**
	 - Protecting and creating processes for your repository with branching and branch policies
- Challenge 10: **[Security](./Solution-10.md)**
	 - Incorporating security into your projects leveraging native GitHub features
- Challenge 11: **[Monitoring: Application Insights](./Solution-11.md)**
	 - Monitoring your applications leveraging Application Insights

## Coach Prerequisites 

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The hosting guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

By default, What The Hack assumes all students bring their own Azure subscription to participate.  Most hacks are authored with this assumption.  However, you may come across the following situations:

- Some organizations may provide a single Azure subscription that students must share. 
- If you are running a hack with students from different organizations, it is easier to provide access to an individual or a shared Azure subscription(s) for the students.

	**NOTE:** The What The Hack project does not have the ability to provide access to Azure subscriptions.  It is the responsibility of the host to work with a stakeholder in the organization to arrange for access to Azure.

#### Provision Shared Azure & GitHub Student Resources

For scenarios where students will work from a shared Azure subscription, we have provided a set of scripts that will provision access to Azure and GitHub repositories for each student.  See the [Coach's Guide for Challenge 00 - Setup Azure & Tools](./Solution-00.md) for more information on how to use these scripts BEFORE hosting the hack. 

#### Provide Individual Student Resources

For non-shared scenarios, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the `Resources.zip` file to all students at the start of the hack. This package contains the sample application & ARM templates the students will use to complete the hack's challenges.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.  

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Azure resources that will be consumed by a student implementing the hack's challenges.
	- Azure Container Registry
	- Azure App Service
- Students will need access to a subscription or at minimum a resource group.  If the students only have permissions to the resource group, the group will need to ensure a student is either able to create a service principle or one will need to be generated in advance.

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Setup`
  - Optional automation for creation of Azure and GitHub resources to back face-to-face deliveries on shared Azure subscription
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
