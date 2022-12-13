# What The Hack - Azure Route Server - Coach Guide

## Introduction

Welcome to the coach's guide for the Azure Route Server What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

<!-- Commenting this section out until a lecture deck is published in a future PR.
This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.
-->

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

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the `Resources.zip` file to all students at the start of the hack. 

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

### Additional Coach Prerequisites

In Challenge 00, the students will run a script from the `Resources.zip` file that deploys a baseline Hub & Spoke network topology into their Azure subscriptions with Linux VMs.  The script file name is `HubAndSpoke.sh`.

Students will need to open the `HubAndSpoke.sh` script file and set the following values:
  - `rg` - The name of the resource group that will be created in Azure to deploy the baseline hub & spoke topology. Students using a shared Azure subscription with other students should include their name or initials in the value to make it unique.
  - `adminpassword` - Provide a password value which will be used for the admin account on the Linux VMs that the script deploys.

The coach should point out that the script sets the admin username for the VMs to `"azureuser"`.

**NOTE:** The script deploys Active/Active VPNs with BGP and the correspondent Vnet Peering attributes for transitivity. However, other aspects such as configuring Local Network Gateways, setting up required Route Tables (UDRs) will need to be done manually. Simulated on-premises and Central NVA templates are provided separately throughout the challenge

**NOTE:** The script takes about 30 minutes to deploy. In the meantime, the coach should proceed with an overview lecture or explanation of the challenges. 

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Attendees should have an Azure Subscription with Owner or Contributor role  to be able to create, modify and delete Resource Groups, Virtual Network components, Virtual Machines with managed disks or regular Storage Accounts. Attendees should also have these permissions to be able to create Network Virtual Appliances.  For more info: <https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#all>

- At the end of the hack, each student will have (but not limited to) the following resources in Azuree:
	- One or two VPN Gateways depending on the On Premises simulation (Virtual on Premises with VPN Gateway, or NVA)
	- One or two Local Network Gateways depending on the On Premises simulation (Virtual on Premises with VPN Gateway, or NVA)
	- At least one Ubuntu LTS VM Standard B1s (1 vcpu, 1 GiB memory) per Vnet. Students may choose to deploy other flavors depending on their solution. For more info on Burstable SKUs: <https://learn.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable>
	- One Route Server
	- At least 6 Virtual Networks
	- Up to Four Cisco Cloud Services Router 1000v Standard B2s (2 vcpus, 4 GiB memory) or any other NVA flavor of their choice. For more info <https://azuremarketplace.microsoft.com/en/marketplace/apps/cisco.cisco-csr-1000v?tab=Overview>
	- Public IPs amount may vary depending on student solution. 
 
 **NOTE:** The VPN Gateway resources as well as the Azure Route Server used for the hack are expensive and can consume the monthly Azure credits in a Visual Studio account or Azure Trial account in a few days!  Students should be advised to delete these resources as soon as the hack is completed.

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
