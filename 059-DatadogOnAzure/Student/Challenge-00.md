# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

You have been contracted to deploy, monitor and manage an online shopping website in Azure for a start-up company called "eShopOnWeb".  

After evaluating the requirements, your team has provided you with a set of Azure Bicep templates and scripts that will deploy the "eShopOnWeb" application and its underlying infrastructure resources into Azure. The Azure environment consists of a VNet, subnets, NSG(s), LoadBalancer(s), NAT rules, a SQL Server VM, a Visual Studio VM, a VM scale set, and an AKS cluster.

Upon successful testing, you present your deployment solution to the company's leadership for approval along with Azure CLI, PowerShell, and Azure Cloud Shell options for quick deployment. 

They were very excited about how quickly your team was able to create a deployment solution, and give you the green light to proceed.

Your job will be to use Datadog to configure the eShopOnWeb solution to be monitored so you can demonstrate to the company's leadership team that you can effectively manage it.

## Prerequisites

You will need an Azure Subscription with the Owner role assigned to deploy the eShopOnWeb Azure environment at the subscription scope.

You can complete this entire hack in a web browser using the [Azure Portal](https://portal.azure.com), [Datadog Portal](https://datadog.com), and [Azure Cloud Shell](https://shell.azure.com). 

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

### Student Resources

Your coach will provide you with a `Resources.zip` file that contains resource files you will use to complete some of the challenges for this hack.  

The Azure Bicep templates and scripts developed by your team to deploy the eShopOnWeb Azure environment are included in this package.

If you have installed all of the tools listed above and plan to work on your local workstation, you should download and unpack the `Resources.zip` file there too.

If you plan to use the Azure Cloud Shell, download and unpack this file in your Azure Cloud Shell environment. 

```bash
# Download the Resources.zip file from the URL provided by your coach
wget https://aka.ms/WTHDashResources -O Resources.zip
# Unpack the zip file
unzip Resources.zip
# Navigate to the "Resources" folder
cd Resources
```
The rest of the challenges will refer to the relative paths inside the `Resources.zip` file where you can find the various resources to complete the challenges.

## Description

For this challenge, you will deploy the eShopOnWeb application and its underlying infrastructure resources to Azure using a set of pre-developed Bicep templates. Once the application and its infrastructure are deployed, you will complete the hack's challenges using Datadog to monitor it.

### Deploy Resources

You will find the provided `main.bicep` template and its associated script files in the `/Challenge-00/` folder of the `Resources.zip` file provided to you by your coach. 

Navigate to this location in your Azure Cloud Shell or Windows Terminal. You may use either the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/?msclkid=6b97242fb99411ec83659823c955fa16) or the [PowerShell Az module](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps) to deploy the Bicep template.

#### Use Azure CLI

1. Log into your Azure Subscription with the Azure CLI: 
    ```bash
    az login
    ```
    **NOTE:** If you are using the Azure Cloud Shell, you can skip this step as the Azure CLI is already logged into your Azure subscription.

1. Deploy the template by running the following Azure CLI command from wherever you have unpacked the `/Challenge-00/` folder:

    ```bash
    az deployment sub create --name "<deploymentName>" --location "<azure-region>" -f main.bicep --verbose
    ```
    
    - We recommend you use your initials for the  `<deploymentName>` value.
    - The `<azure-region>` value must be one of the pre-defined Azure Region names. You can view the list of available region names by running the following command: `az account list-locations -o table`
    - You will be prompted to enter values for the local admin Username and Password for the Azure virtual machines and scale set instances.  Enter a username and password that adheres to [Azure VM Username Requirements](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/faq#what-are-the-username-requirements-when-creating-a-vm-) and [Azure VM Password Requirements](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/faq#what-are-the-password-requirements-when-creating-a-vm-)
    - **NOTE:** This deployment will take approximately 20-25 minutes.

#### Use PowerShell with the AZ Module

1. Log into your Azure Subscription with the PowerShell:

    ```PowerShell
    Connect-AzAccount -Tenant '<Tenant ID>' -Environment 'AzureCloud' -Subscription '<Subscription ID>'
    ```

    **NOTE:** If you are using the Azure Cloud Shell, you can skip this step as PowerShell is already logged into your Azure subscription.

1. Deploy the template by running the following PowerShell command from wherever you have unpacked the `/Challenge-00/` folder:

    ```PowerShell
    New-AzDeployment -Name "<deploymentName>" -Location "<azure-region>" -TemplateUri "main.bicep" -Verbose
    ```
    - We recommend you use your initials for the  `<deploymentName>` value.
    - The `<azure-region>` value must be one of the pre-defined Azure Region names. You can view the list of available region names by running the following command: `az account list-locations -o table`
    - You will be prompted to enter values for the local admin Username and Password for the Azure virtual machines and scale set instances.  Enter a username and password that adheres to [Azure VM Username Requirements](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/faq#what-are-the-username-requirements-when-creating-a-vm-) and [Azure VM Password Requirements](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/faq#what-are-the-password-requirements-when-creating-a-vm-)
    - **NOTE:** This deployment will take approximately 20-25 minutes.

### View Deployed Resources

- Once the deployment has completed, navigate to the Public IP Address resource, **pip-wth-monitor-web-d-XX** , in the Azure Portal.  
- In the Overview blade, copy the DNS name to your clipboard.  
- Open a web browser, paste your DNS name in the address bar and press ENTER.  Your browser should render the eShopOnWeb site. 

![Webpage of the eShopOnWeb site](../Images/00-23-Eshoponweb-Webpage.png)

### Deploy Datadog from Azure Marketplace
- Go to the Azure Marketplace and deploy Datadog into your subscription using the `Datadog Pro Pay-As-You-Go` offering.
- Create a new Datadog organization when asked to choose between linking to an existing Datadog org or creating a new one.
- Select the existing resource group `XXX-rg-wth-monitor-d-XX` to deploy the Datadog resource.
  >**Note** The "XXX" in the resource group name will vary based on the Azure region the eShopOnWeb Azure environment has been deployed to.
- Ensure that the Azure resource details show as `West US 2` and the Datadog site is `US3`.
- You do not need to enable single sign-on through Azure Active Directory for this workshop, but we recommend doing so in a production environment.
- Proceed with the deployment, and once the deployment is finished, click the link **Set Password in Datadog.**
- Choose a password that you will remember for the duration of this workshop.
- Proceed to log in to Datadog. 
  - The username/email can be found in the Azure portal, top right. 
  - Click View account to see the full email address.
  - Use the password from the previous step.
-  We recommend keeping the Datadog and Azure portal browser tabs open for the duration of this workshop.

## Success Criteria

- Verify you have access to the contents of the `Resources.zip` package provided by your Coach.
- Verify you can see the website deployed
- Verify the resources contained in architecture diagram below are present in your own Azure subscription.
- Verify that you have deployed Datadog into your Azure lab environment.

![Hack Diagram](../Images/datadoghackdiagram.png)

## Learning Resources

- [Get Started with Azure PowerShell](https://docs.microsoft.com/en-us/powershell/azure/get-started-azureps?view=azps-6.4.0)
- [Get Started with Azure Command-Line Interface (CLI)](https://docs.microsoft.com/en-us/cli/azure/get-started-with-azure-cli)
- [Overview of Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview)
- [New Microsoft partnership embeds Datadog natively in the Azure portal](https://www.datadoghq.com/blog/azure-datadog-partnership/)
- [Datadog in the Azure Portal](https://docs.datadoghq.com/integrations/guide/azure-portal/)