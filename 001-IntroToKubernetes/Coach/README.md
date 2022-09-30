# What The Hack - Intro To Kubernetes - Coach Guide

## Introduction

Welcome to the coach's guide for the Intro To Kubernetes What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx?raw=true) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your workstation to work with Azure, Docker containers, and AKS.
- Challenge 01: **[Got Containers?](./Solution-01.md)**
	 - Package the "FabMedical" app into a Docker container and run it locally.
- Challenge 02: **[The Azure Container Registry](./Solution-02.md)**
	 - Deploy an Azure Container Registry, secure it and publish your container.
- Challenge 03: **[Introduction To Kubernetes](./Solution-03.md)**
	 - Install the Kubernetes CLI tool, deploy an AKS cluster in Azure, and verify it is running.
- Challenge 04: **[Your First Deployment](./Solution-04.md)**
	 - Pods, Services, Deployments: Getting your YAML on! Deploy the "FabMedical" app to your AKS cluster.
- Challenge 05: **[Scaling and High Availability](./Solution-05.md)**
	 - Flex Kubernetes' muscles by scaling pods, and then nodes. Observe how Kubernetes responds to resource limits.
- Challenge 06: **[Deploy MongoDB to AKS](./Solution-06.md)**
	 - Deploy MongoDB to AKS from a public container registry.
- Challenge 07: **[Updates and Rollbacks](./Solution-07.md)**
	 - Deploy v2 of FabMedical to AKS via rolling updates, roll it back, then deploy it again using the blue/green deployment methodology.
- Challenge 08: **[Storage](./Solution-08.md)**
	 - Delete the MongoDB you created earlier and observe what happens when you don't have persistent storage. Fix it!
- Challenge 09: **[Helm](./Solution-09.md)**
	 - Install Helm tools, customize a sample Helm package to deploy FabMedical, publish the Helm package to Azure Container Registry and use the Helm package to redeploy FabMedical to AKS.
- Challenge 10: **[Networking and Ingress](./Solution-10.md)**
	 - Explore different ways of routing traffic to FabMedical by configuring an Ingress Controller with the HTTP Application Routing feature in AKS.
- Challenge 11: **[Operations and Monitoring](./Solution-11.md)**
	 - Explore the logs provided by Kubernetes using the Kubernetes CLI, configure Azure Monitor and build a dashboard that monitors your AKS cluster

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

### Pre-Select Your Path For Container Content
Coaches, be sure to read the [Coach Guidance for Challenge 1](./Solution-01.md). You will need to select a proper path based on the learning objectives of the organization (to be decided PRIOR TO the hack!).  Select the proper path after consulting with the organization's stakeholder(s) for the hack.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Attendees should have the “Azure account administrator” (or "Owner") role on the Azure subscription in order to authenticate their AKS clusters against their Azure Container Registries.  For more info: <https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration>
- Each student will spin up the following resources in Azure:
	- 3 x 2 vCPUs VMs for the AKS cluster + 2 Public IPs (1 for AKS cluster, 1 for content-web)
	- 1 x 2 vCPUs VM for the Docker Build machine + one Public IP
	- Total: 8 vCPUs + 3 Public IPs per attendee

If attendees will be using a shared Azure subscription, see the [Coach Guidance for Challenge 0](./Solution-00.md) for additional information on how to configure the subscription.

## Suggested Hack Agenda

This hack is designed to be run as a full 3-day event, for a total of approximately 18 hours to complete all challenges. There are multiple variations of this hack that enable you run it for a shorter periods of time and still provide value to attendees. Different groups of students will complete the challenges at different paces based on their comfort level with Linux and/or using Command Line Interface (CLI) tools.  This is okay, and students should be encouraged to participate in this intro-level hack no matter what their experience level is.

### Challenges 1-3: Four Paths to Choose From

Challenge 1 has attendees start by taking the FabMedical sample application's source code, learn how to containerize it, and then run the application in Docker. We have found that this challenge often takes a significant amount of time (3+ hours) for attendees.

For organizations who are not focused on how to build container images, we have provided pre-built container images for the FabMedical sample application hosted in Dockerhub. This means you may choose to start the hack with either Challenge 2 or Challenge 3.

We have found it is common that some organizations do not allow their users to have the "Owner" role assigned to them in their Azure subscription. This means the attendees will not be able to configure the Azure Container Registry for use with their AKS cluster. 

You can workaround this either by skipping Challenge 2 altogether, or completing Challenge 2 to understand how ACR works, but then using the pre-built container images in Dockerhub for deployment in Challenge 4.

For more information on the various paths for Challenges 1 through 3, see the [Coach Guidance for Challenge 1](./Solution-01.md).

### Challenges 9-11: Choose Your Own Adventure

Challenges 9, 10, and 11 do not build on each other. You may "chooose your own adventure" once Challenge 8 is completed and focus on only the Challenges that are a priority for your organization.

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
  - [Lecture presentation](Lectures.pptx?raw=true) with short presentations to introduce each challenge.
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc. meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
