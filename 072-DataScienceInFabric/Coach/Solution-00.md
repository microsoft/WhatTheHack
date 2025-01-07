# Challenge 00 - Prerequisites - Ready, Set, GO! - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Introduction

Thank you for participating in the Data Science in Microsoft Fabric What The Hack. Before you can hack, you will need to set up some prerequisites.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Postman](https://www.postman.com/downloads/)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
- [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
    - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
  - [Azure CLI (optional)](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell CmdLets](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)

- [Azure Storage Explorer (optional)](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-storage-explorer)

Additionally please refer to the [Coach Hack introduction](./README.md) for more information about licensing requirements and options
## Description

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specific to this hack.

In Challenge 0 on the student guide, students are instructed to download the Resources folder [here](https://aka.ms/FabricdsWTHResources). This folder contains the notebooks students will be working with, as well as a shell script that they will use to deploy some needed Azure resources. 

The [coach solution notebooks](./Solutions/) are the completed versions of the student notebooks. The solutions can be used as a guide or uploaded to Fabric to complete each Challenge.


**NOTE:** The resources.zip folder also includes the heart.csv file. You can upload this data directly to the Fabric Lakehouse if you decide you want to go through this hack without needing an Azure subscription. However, this will skip half of Challenge 1 and the important concept of using shortcuts in Fabric. If you are going to be setting up the Azure resources and using the shortcut, ignore the heart.csv file.

To begin setting up your Azure subscription for this hack, you will run a bash script that will deploy and configure a list of resources. You can find this script as the `HackSetup.sh` file in the resources folder. 
 - Download the setup file to your computer
 - Go to the Azure portal and click on the cloud shell button on the top navigation bar, to the right of the Copilot button.
  - **NOTE**: This script has been designed for the Azure CLI. It might fail to deploy if you attempt to run it from a local terminal.
 - Once the cloud shell connects, make sure you are using a Bash shell. If you are not, click on the button on the top-right corner of the cloud shell to switch to bash.
 - Click on the Manage Files button on the shell's navigation bar and select upload. Select the setup file from your computer.
 - Run the `sh HackSetup.sh` command in your cloud shell.
 - Follow the prompts in the shell.

After setting up your Azure resources, head to [Microsoft Fabric](https://fabric.microsoft.com/). 
 - Create a new workspace by clicking on 'Workspaces' in the vertical menu on the left side of the screen. Use the 'New Workspace' button at the bottom of the list.
 - Once you are inside your new workspace, select the Data Science experience using the button on the bottom left corner of the screen.
 - At the top of the Data Science experience menu, check that you are still in the new workspace and select 'Import Notebook' from the top row of options.
 - Follow the prompts to upload the 4 notebook (`.ipynb`) files contained within the resources folder.


## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have a storage account with the heart.csv data in a container
- Verify that you have a Fabric workspace where your 4 notebooks are available
- (Optional) Verify that your Azure ML workspace has correctly deployed (if completing Challenge)
