# What The Hack - Azure Route Server - Coach Guide

## Introduction

Welcome to the coach's guide for the Azure Route Server What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Building a Basic Hub and Spoke Topology utilizing a central Network Virtual Appliance](./Solution-01.md)**
	 - Warming up
- Challenge 02: **[Introduce Azure Route Server and peer with a Network Virtual appliance](./Solution-02.md)**
	 - Azure Route Server basic concepts, interaction with NVAs
- Challenge 03: **[Connect Network Virtual Appliance to an SDWAN environment](./Solution-03.md)**
	 - Azure Route Server interaction with Virtual Network Gateways (VPN or ExpressRoute)
- Challenge 04: **[Introduce a High Availability with Central Network Virtual Appliances](./Solution-04.md)**
	 - High Availability concepts

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack. For this hack, please provide the contents of the following files.
- [Hub and Spoke](./Resources/HubAndSpoke.azcli) Azure CLI Script file. This files contain the creations of a Hub and Spoke topology with Linux VMs.
- Username and password must be provided to the students for the Ubuntu VMs
	-username: azureuser
	-psswd: Msft123Msft123

**NOTE:** The script deploys Active/Active VPNs with BGP and the correspondent Vnet Peering attributes for transitivity. However, other aspects such as configuring Local Network Gateways, setting up required Route Tables (UDRs) will need to be done manually. Simulated on-premises and Central NVA templates are provided separately throughout the challenge

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

### Additional Coach Prerequisites

The coach should offer the student the aforementioned script file at the start of the event so credits using the VPN Gateway are not consumed before the Hack. If the student opts to do the initial setup manually, bring awareness that this is going to consume time and is prone to errors. 

The script takes about 30 minutes to deploy. In the meantime, the coach can proceed with a lecture or explanation of the challenges. 

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

_Please list Azure subscription requirements._

_For example:_

- Azure resources that will be consumed by a student implementing the hack's challenges
- Azure permissions required by a student to complete the hack's challenges.

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
