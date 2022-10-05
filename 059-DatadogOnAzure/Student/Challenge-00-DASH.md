# Challenge 00 - Prerequisites - Ready, Set, GO! DASH Conference

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

You have been contracted to monitor and manage an online shopping website in Azure for a start-up company called "eShopOnWeb".  The eShopOnWeb solution in Azure has an Azure environment that consists of (2) Azure resource groups that include a VNet, subnets, NSG(s), LB(s), NAT rules, scale set and a fully functional .NET Core Application (eShopOnWeb) to monitor.

The eShopOnWeb solution in Azure has been pre-deployed by our lab partner, Spektra Systems. Your job will be to use Datadog to configure the eShopOnWeb solution to be monitored so you can demonstrate to your company's leadership team that you can effectively manage it.

## Prerequisites

You will be provided with access to an Azure Subscription where the eShopOnWeb solution has been deployed.

You can complete this entire hack in a web browser using the [Azure Portal](https://portal.azure.com), [Datadog Portal](https://datadog.com), and [Azure Cloud Shell](https://shell.azure.com). The Azure Cloud Shell has most of the common Azure management tools already pre-installed.

However, if you work with Azure and on a regular basis, these are tools you should consider having installed on your local workstation:

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Windows Subsystem for Linux](../../000-HowToHack/WTH-Common-Prerequisites.md#windows-subsystem-for-linux)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell CmdLets](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
  - [VS Code plugin for ARM Templates](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code-plugins-for-arm-templates)
  - [VS Code plugin for Bicep](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
- [Terraform for Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/overview)

>**Note** Datadog is commonly automated via [Terraform](https://www.terraform.io/). Some of the challenges have you use Terraform to configure Datadog features. Terraform is already included in the Azure Cloud Shell. If you want Terraform to work on your local workstation, you will need to [Install Terraform on Windows with Bash](https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-windows-bash?tabs=bash).


## Description

### Accessing the eShopOnWeb Azure Environment

To access the Azure lab environment for this hack, you will need to do the following:

- Login to Spektra Systems' website with your email address and the password provided by your coach: [https://URL.TBD](https://url.tbd)
- Copy the provided username & password for the Azure environment to an easy to access location on your workstation (Notepad, OneNote, etc).
- Login to the Azure portal at: [https://portal.azure.com](https://portal.azure.com)
- Login to the Azure Cloud Shell and create a new Bash environment (if it does not exist): [https://shell.azure.com](https://shell.azure.com)

>**Note** While you can access the Azure Cloud Shell from the Azure Portal, we recommend you keep the Azure Cloud Shell open "fullscreen" in its own browser tab or window by accessing [https://shell.azure.com](https://shell.azure.com). During the hack, you will want to observe things in the Azure Portal while interacting with the Azure Cloud Shell in a separate browser window side by side.

### Student Resources

Your coach will provide you with a link to a `Resources.zip` file that contains resource files you will use to complete some of the challenges for this hack.  

- Download and unpack this file in your Azure Cloud Shell environment. 

```bash
# Download the Resources.zip file from the URL provided by your coach
wget https://aka.ms/WTHDashResources -O Resources.zip
# Unpack the zip file
unzip Resources.zip
# Navigate to the "Resources" folder
cd Resources
```

The rest of the challenges will refer to the relative paths inside the `Resources.zip` file where you can find the various resources to complete the challenges.

### View Deployed Resources

- To view the eShopOnWeb website, navigate to the Public IP Address resource, **`pip-wth-monitor-web-d-eu`**, in the Azure Portal.  
- In the Overview blade, copy the DNS name to your clipboard.  
- Open a web browser, paste your DNS name in the address bar and press ENTER.  Your browser should render the eShopOnWeb site. 

![Webpage of the eShopOnWeb site](../Images/00-23-Eshoponweb-Webpage.png)

## Deploy Datadog from Azure Marketplace
- Go to the Azure Marketplace and deploy Datadog into your subscription using the "Datadog Pro Pay-As-You-Go" offering.
- Create a new Datadog organization when asked to choose between linking to an existing Datadog org or creating a new one.
- Select the existing resource group ".._rg-wth-monitor-d_.." to deploy the Datadog resource.
- Ensure that the Azure resource details show as "West US 2" and the Datadog site is "US3".
- You do not need to enable single sign-on through Azure Active Directory for this workshop, but we recommend doing so in a production environment.
- Proceed with the deployment, and once the deployment is finished, click the link **Set Password in Datadog.**
- Choose a password that you will remember for the duration of this workshop.
- Proceed to log in to Datadog. The username/Email can be found in the Azure portal, top right. Click View account to see the full email address. Use the password from the previous step.
-  We recommend keeping the Datadog and Azure portal browser tabs open for the duration of this workshop.

## Success Criteria

- Verify you have access to the contents of the `Resources.zip` package in your Azure Cloud Shell environment
- Verify you can see the website deployed
- Verify the resources contained in architecture diagram below are present in your own Azure subscription.

![Hack Diagram](../Images/monitoringhackdiagram1.png)

## Learning Resources

- [Get Started with Azure PowerShell](https://docs.microsoft.com/en-us/powershell/azure/get-started-azureps?view=azps-6.4.0)
- [Get Started with Azure Command-Line Interface (CLI)](https://docs.microsoft.com/en-us/cli/azure/get-started-with-azure-cli)
- [Overview of Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview)
