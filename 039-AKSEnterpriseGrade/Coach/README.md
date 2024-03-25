# What The Hack - AKS Enterprise-Grade - Coach Guide

## Introduction

Welcome to the coach's guide for the AKS Enterprise-Grade What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack assumes attendees have a base level of knowledge of Kubernetes, including understanding core concepts & features such as:
- Pods
- Deployments
- Services
- Ingress
- Helm
- YAML configuration files
- Kubernetes CLI => `kubectl`

The focus of this hack is how Kubernetes and the Azure Kubernetes Service (AKS) interact with the rest of the Azure platform.  If your organization is not familiar with the basics of Kubernetes, we recommend they complete the [Introduction To Kubernetes](../../001-IntroToKubernetes/) hack first.

This hack includes an optional [lecture presentation](Lectures.pptx?raw=true) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Containers](./Solution-01.md)**
	 - Get familiar with the application for this hack, and roll it out locally or with Azure Container Instances
- Challenge 02: **[AKS Network Integration and Private Clusters](./Solution-02.md)**
	 - Deploy the application in an AKS cluster with strict network requirements
- Challenge 03: **[AKS Monitoring](./Solution-03.md)**
	 - Monitor the application, either using Prometheus or Azure Monitor
- Challenge 04: **[Secrets and Configuration Management](./Solution-04.md)**
	 - Harden secret management with the help of Azure Key Vault
- Challenge 05: **[AKS Security](./Solution-05.md)**
	 - Explore AKS security concepts such as Azure Policy for Kubernetes
- Challenge 06: **[Persistent Storage in AKS](./Solution-06.md)**
	 - Evaluate different storage classes by deploying the database in AKS
- Challenge 07: **[Service Mesh](./Solution-07.md)**
	 - Explore the usage of a Service Mesh to further protect the application
- Challenge 08: **[Arc-Enabled Kubernetes and Arc-Enabled Data Services](./Solution-08.md)**
	 - Leverage Arc for Kubernetes to manage a non-AKS cluster, and Arc for data to deploy a managed database there

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Coach Guidance

* Let participants find their own solutions, even if they are wrong. Let them hit walls and learn from their mistakes, unless you see them investing too much time and effort. Give them hints that put them on the right track, but not solutions
* Most challenges can be solved in multiple ways, all of them correct solutions
* If there is any concept not clear for everybody, try to make participants explain to each other. Intervene only when no participant has the knowledge
* **Make sure no one is left behind**
* Make sure participants have a way to share code, ideally git-based
* Most challenges involve some level of subscription ownership to create identities or service principals, or for the AAD integration challenge.
* Let participants try options even if you know it is not going to work, let them explore on themselves. Stop them only if they consume too much time
* For each challenge, you can ask the least participative members to describe what has been done and why

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Attendees should have the “Azure account administrator” (or "Owner") role on the Azure subscription in order to authenticate their AKS clusters against their Azure Container Registries.  For more info: <https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration>
- Each student will spin up the following resources in Azure:
	- 1 Azure Container Registry
	- 3 Azure Container Instances (if not deploying Docker containers locally)
	- 3 x 2 vCPUs VMs for the AKS cluster
	- 3 Public IPs (1 for AKS cluster, 1 for sample web app, 1 for ingress controller)

## Suggested Hack Agenda

This hack is designed to be run as a 3 day event, for a total of approximately 18 hours to complete all challenges. 

There are multiple variations of this hack that enable you run it for a shorter periods of time and still provide value to attendees. Different groups of students will complete the challenges at different paces based on their comfort level with Linux and/or using Command Line Interface (CLI) tools. 

### Challenges 1-2: Multiple Paths to Choose From

Challenge 1 has attendees start by taking the sample application's source code, learn how to containerize it, run the application in Docker, then publish the container images to the Azure Container Registry.

Challenge 2 has the students deploy an AKS cluster and get the sample application deployed to it.

Students are given two options to deploy the AKS cluster:
- A regular AKS cluster with public IP addresses, or 
- A private AKS cluster with no public IP addresses

Deploying a private AKS cluster is more complex and will take students more time to figure out how to do it. Using a private cluster will also result in variations of how to solve the other challenges.

If students choose to deploy a private cluster, the coach should be prepared to explain key networking concepts and how a private AKS cluster works differently from a non-private AKS cluster.

### Challenge 1 & 2 Accelerator

Some organizations may wish to complete this hack as a follow-on to, or even a continuation of, the [Introduction to Kubernetes](../../001-IntroToKubernetes/) hack.

The Coach's Solution folder for Challenge 2 contains a set of YAML files and a README file that has instructions that will help students quickly deploy the sample application from pre-staged container images in Docker Hub to an existing AKS cluster.

For students that are already familiar with deploying applications in Kubernetes, but want to focus on the Azure integrations, you may wish to provide these files to "accelerate" them so they can start the hack with Challenge 3.

For more information, see the Coach's guide for [Challenge 2](Solution-02.md).

### Challenges 3-8: Choose Your Own Adventure

Challenges 3 through 8 do not build on each other. You may "choose your own adventure" once Challenge 2 is completed and focus on only the Challenges that are a priority for your organization.

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
