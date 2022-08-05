# What the Hack Networking Bicep Deployment

This directory contains Bicep templates to deploy and configure resources as described in each WTH Networking challenge. These deployments represent one way to meet the challenge requirements--there are many others.

## Who should use these templates?

The WTH philosophy intends to have students learn by doing, and recognizes that one of the best ways to learn is to troubleshoot problems. As such, using these templates instead of building your own lab will detract from your learning experience, and only recommended for the scenarios below: 

- Students who will not be completing a challenge which is a prerequisite to a later challenge
- Students who are falling behind in the WTH due to issues unrelated to the core learning goals of this WTH
- Students looking for a reference implementation to compare against their own approach

## Using these templates

Using Cloud Shell is recommended, as it already has the necessary tools installed. However, Cloud Shell has a timeout of about 20 minutes and may experience timeouts (in which case, run the same command again to pick up the deployments where they stopped).

### Prerequisites

- Azure PowerShell module
- git

### Download Options

#### Clone the Git repo (slow)

1. Clone this repo to your local system or Cloud Shell
   `git clone https://github.com/microsoft/WhatTheHack.git`
1. Navigate to the `035-HubAndSpoke\Student\Resources\bicep` directory in your clone of the repo
1. Run the deployBicep.ps1 script. For example:
   `./deployBicep.ps1 -challengeNumber 1`

#### Download a zip of the bicep directory

1. Browse to https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Fmicrosoft%2FWhatTheHack%2Ftree%2Fnetwork-bicep%2F035-HubAndSpoke%2FStudent%2FResources%2Fbicep
1. A zip of the directory will download to your system
1. Expand the downloaded zip file and navigate to it in a PowerShell window
1. Run the deployBicep.ps1 script. For example:
   `./deployBicep.ps1 -challengeNumber 1`

## Deployed Configuration

### Challenge 1

- Windows VMs are deployed in the hub, both spokes, and on-prem Resource Groups
- VM usernames are 'admin-wth' and passwords are the one supplied when executing the script
- All Windows VMs have associated Public IP Addresses and are accessible via RDP using alternate port 33899 (ex: `mstsc /v:4.32.1.5:33899`)
- The Cisco CSR deployed in the 'wth-rg-onprem' Resource Group uses the same username and password, but is not accessible from the internet. To access it, RDP to the Windows VM in the onprem Resource Group, then connect to the CSR using ssh and its private IP address

### Challenge 2

- With Azure Firewall deployed and traffic routing through it following the Challenge, the Windows VMs are no longer directly accessible via Public IP. Use the Azure Firewall public IP with the following DNAT port mapping:
  - Hub: 33980
  - Spoke 1: 33891
  - Spoke 2: 33892
  - On-prem (still accessible by Public IP and custom 33899 RDP port)

- All Windows VMs have a diagnostic website configured in IIS called Inspector Gadget. To access it locally, browse to `http://localhost/default.aspx`. Web server DNAT through the Azure Firewall uses the following port mapping:

  - Hub: 8080
  - Spoke 1: 8081
  - Spoke 2: 8082
