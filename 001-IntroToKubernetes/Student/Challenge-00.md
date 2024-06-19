# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the Intro To Kubernetes What The Hack. Before you can hack, you will need to set up some prerequisites.

A smart cloud solution architect always has the right tools in their toolbox.

## Description

In this challenge we'll be setting up all the tools we will need to complete our challenges.

### Install Cloud Tools on Your Workstation

- Install the recommended toolset:
    - Windows Subsystem for Linux
    - Azure CLI 
        - Update to the latest
        - Must be at least version 2.7.x
        - **NOTE for Windows users:** Install Azure CLI on Windows Subsystem for Linux following the instructions for the Linux distribution you are using in WSL.
        - **NOTE:** If you’re running into issues running Azure CLI command on Windows, disable Global Protect (VPN)
    - Visual Studio Code
- **NOTE:** You can start the next challenge even if this one is still running by using the Azure Cloud Shell.
- **Tip:** You can complete almost all of the challenges with the Azure Cloud Shell!  But be a good cloud architect and make sure you have experience installing the tools locally.

### Student Resources

Your coach will provide you with a `Resources.zip` file that contains resource files you will use to complete some of the challenges for this hack.  

You may also download the file here: ['Resources.zip'](https://aka.ms/wth/IntroToK8SResources)

If you have installed all of the tools listed above on your local workstation, you should unpack the `Resources.zip` file there too.

If you plan to use the Azure Cloud Shell, you should upload the `Resources.zip` file to your cloud shell first and then unpack it there.

## Success Criteria

1. You have a bash shell at your disposal (WSL, Mac, Linux or Azure Cloud Shell)
1. Running `az --version` shows the version of your Azure CLI
1. Visual Studio Code is installed.