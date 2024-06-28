# Challenge 00 - Prerequisites - Ready, Set, GO! - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Introduction

Thank you for participating in the Data Science In Microsoft Fabric What The Hack. Before you can hack, you will need to set up some prerequisites.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

- [Azure Subscription](../Student/000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Managing Cloud Resources](../Student/000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../Student/000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../Student/000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../Student/000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell CmdLets](../Student/000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)
  - [Azure Cloud Shell](../Student/000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Azure Storage Explorer](../Student/000-HowToHack/WTH-Common-Prerequisites.md#azure-storage-explorer)

## Description

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specifc to this hack.

Your coach will provide you with a Resources.zip file that contains resources you will need to complete the hack. This folder contains the data that you will use during this hack. Please download and unzip the folder.

To begin setting up your Azure subscription for this hack, you will run a bash script that will deploy and configure a list of resources. You can find this script as the HackSetup.sh file in the resources folder. 
 - Donwnload the setup file to your computer
 - Go to the Azure portal and click on the cloud shell button on the top navigation bar, to the right of the Copilot button.
 - Once the cloud shell connects, make sure you are using a Bash shell. If you are not, click on the button on the top-right corner of the cloud shell to switch to bash.
 - Click on the Manage Files button on the shell's navigation bar and select upload. Select the setup file from your computer.
 - Run the `sh HackSetup.sh` command in your cloud shell.
 - Follow the prompts in the shell.


## Success Criteria

_Success criteria goes here. The success criteria should be a list of checks so a student knows they have completed the challenge successfully. These should be things that can be demonstrated to a coach._

_The success criteria should not be a list of instructions._

_Success criteria should always start with language like: "Validate XXX..." or "Verify YYY..." or "Show ZZZ..." or "Demonstrate you understand VVV..."_

_Sample success criteria for the IoT prerequisites challenge:_

To complete this challenge successfully, you should be able to:

- Verify that you have a bash shell with the Azure CLI available.
- Verify that the ARM template has deployed the following resources in Azure:
  - Azure IoT Hub
  - Virtual Network
  - Jumpbox VM

## Learning Resources

_List of relevant links and online articles that should give the attendees the knowledge needed to complete the challenge._

_Think of this list as giving the students a head start on some easy Internet searches. However, try not to include documentation links that are the literal step-by-step answer of the challenge's scenario._

**\*Note:** Use descriptive text for each link instead of just URLs.\*

_Sample IoT resource links:_

- [What is a Thingamajig?](https://www.bing.com/search?q=what+is+a+thingamajig)
- [10 Tips for Never Forgetting Your Thingamajic](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
- [IoT & Thingamajigs: Together Forever](https://www.youtube.com/watch?v=yPYZpwSpKmA)

## Notes & Guidance

This is the only section you need to include.

Use general non-bulleted text for the beginning of a solution area for this challenge

- Then move into bullets
  - And sub-bullets and even
    - sub-sub-bullets

Break things apart with more than one bullet list

- Like this
- One
- Right
- Here
