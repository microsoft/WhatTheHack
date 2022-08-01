# What the Hack Networking Bicep Deployment

This directory contains Bicep templates to deploy and configure resources as described in each WTH Networking challenge. These deployments represent one way to meet the challenge requirements--there are many others.

## Who should use these templates?

The WTH philosophy intends to have students learn by doing, and recognizes that one of the best ways to learn is to troubleshoot problems. As such, using these templates instead of building your own lab will detract from your learning experience, and only recommended for the scenarios below: 

- Students who will not be completing a challenge which is a prerequisite to a later challenge
- Students who are falling behind in the WTH due to issues unrelated to the core learning goals of this WTH
- Students looking for a reference implementation to compare against their own approach

## Using these templates

Using Cloud Shell is recommended, as it already has the necessary tools installed. However, Cloud Shell has a timeout of about 20 minutes

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