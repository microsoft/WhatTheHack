# Coach's Pre-Hack Setup

**[Home](README.md)** - [Next Challenge >](./Challenge-00.md)

## Introduction

Someone who’s kicking off the hack needs to have access to a running version of the solution to demonstrate the end goal.

## Setup Procedure

1. Chose the script file you will use for this setup. We have provided both bash and powershell:
	- [./Solutions/Scripts/deployHack.sh](Solutions/Scripts/deployHack.sh)
	- [./Solutions/Scripts/deployHack.ps1](Solutions/Scripts/deployHack.ps1)
1. Login to Azure Portal and start the Cloud Shell
1. Upload the appropriate script file through Cloud Shell based on which shell you’re using:
	- bash: `deployHack.sh`
		- **NOTE:** Once uploaded you must make this file executable by running: `chmod 755 ./deployHack.sh`
	- Powershell: `deployHack.ps1`
	- For info on uploading, [look here](https://docs.microsoft.com/en-us/azure/cloud-shell/persisting-shell-storage) and find the section on transferring local files to the Cloud Shell
1. Both scripts take 3 parameters
	- `deployHack.sh <AzureDataCenter> <SubscriptionId> <BaseName>`
	- `deployHack.ps1 -loc <AzureDataCenter> -sub <SubscriptionId> -baseName <BaseName>`
	- **NOTE:** `<BaseName>` must be globally unique, alpha only and less than 8 characters.
1. After successfully deploying, open up the portal, and go to the resource group you just deployed, and get the URL of the web site.
1. Copy the file [Load.webtest](Solutions/Code/Load.webtest) to a temp directory locally, edit it, look at the bottom and change the `ContextParameter Name="WebServer1"` XML Element’s Value attribute to the HTTP (not HTTPS) URL of the web site.
1. Login to [https://dev.azure.com/](https://dev.azure.com/) and create a new project.
1. Select **Test Plans / Load Tests** and add a new Load Test. Choose **Visual Studio test** and select your copy of Load.webtest to upload it to this new Load Test.
1. Name the Load Test and click Save.
1. Click the **Settings** tab beside **Web Scenarios** to configure the test.
1. Specify a decent amount of load, eg: 25 max vUsers running for 10 minutes to drive a good amount of traffic.
1. Click Save and then click Run test.

## Demonstrating the End State

After the load test initializes and starts running, you should have data streaming into Application Insights.  These are some areas of Application Insights to highlight:

1. Application Map
1. Live Metrics Stream (while the load test is running)
1. Performance
1. Browsers
