# What The Hack - Intro To Azure Red Hat OpenShift - Coach Guide

## Introduction

Welcome to the coach's guide for the Intro To Azure Red Hat OpenShift What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx?raw=true) that features a short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[ARO Cluster Deployment](./Solution-01.md)**
	 - Deploy an ARO cluster and access it using CLI and the Red Hat Portal
- Challenge 02: **[Application Deployment](./Solution-02.md)**
	 - Deploy the frontend and backend of an application onto the ARO cluster
- Challenge 03: **[Logging and Metrics](./Solution-03.md)**
	 - View application logs to identify application errors
- Challenge 04: **[Storage](./Solution-04.md)**
	 - Deploy a MongoDB database service to address application errors
- Challenge 05: **[Configuration](./Solution-05.md)**
	 - Configure the frontend and backend applications
- Challenge 06: **[Networking](./Solution-06.md)**
	 - Secure cluster traffic between pods using network policies
- Challenge 07: **[Scaling](./Solution-07.md)**
	 - Scale the frontend and backend applications
- Challenge 08: **[Azure Active Directory Integration](./Solution-08.md)**
	 - Provide authentication to your ARO Web Console
- Challenge 09: **[Azure Service Operator Connection](./Solution-09.md)**
	 - Integrate Azure Service Operator

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into two public GitHub repositories, one that contains the contents from the folder `**/rating-api**` and the other containing the contents from the folder `**/rating-web**`. The coach should then provide the URLs of the GitHub repositories to all students at the start of the hack in challenge 0.

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

As a coach, you should communicate to the stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students about the quota requirement and Azure Requirements listed below, **days in advance** of the hack.

- Make sure the students increase the VM quotas to use a minimum of 40 cores. Docs on how to do that can be found here: [Increase VM-family vCPU quotas](https://docs.microsoft.com/en-us/azure/azure-portal/supportability/per-vm-quota-requests) 
  - To check your current subscription quota of the smallest supported virtual machine family SKU `Standard DSv3`, run this command: `az vm list-usage -l $LOCATION --query "[?contains(name.value, 'standardDSv3Family')]" -o table`
    - **NOTE:** Quotas are set per region.  If you increase the quota in a single region, you need to ensure that all students deploy to the same region.  Or else, they will bump up against the quota limits in the region they deploy to.

- For students ability to create an Azure Red Hat OpenShift cluster, verify the following permissions on their Azure subscription, Azure Active Directory user, or service principal:

| Permissions  | Resource Group which contains the VNet | User executing `az aro create` | Service Principal passed as `–client-id` |
| ------------- | ------------- | ------------- | ------------- |
| User Access Administrator | X | X | |
| Contributor  | X | X | X |
- Register the resource providers in their subscription:
```
# Register the Microsoft.RedHatOpenShift resource provider
az provider register -n Microsoft.RedHatOpenShift --wait

# Register the Microsoft.Compute resource provider
az provider register -n Microsoft.Compute --wait

# Register the Microsoft.Storage resource provider
az provider register -n Microsoft.Storage --wait

# Register the Microsoft.Authorization resource provider
az provider register -n Microsoft.Authorization --wait
```

## Suggested Hack Agenda
This hack has challenges that are built off of each other and some that are not. Below is the suggested challenge order to run the hack.

- Challenges that must be done in numerical order
  - Challenge 1 
  - Challenge 2 
  - Challenge 3 
  - Challenge 4 
  - Challenge 5 
  - Challenge 6 
- Challenges that can be done in any order
  - Challenge 7 
  - Challenge 8 
  - Challenge 9

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc. meant to be provided to students. (The coach must package up the frontend and backend applications and deploy them to two public GitHub repositories for their specified hack)
