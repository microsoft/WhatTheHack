# Challenge 0: Getting started

**[Home](../README.md)** - [Next Challenge>](./01-Alerts-Activity-Logs-And-Service-Health.md)

## Introduction

You have been contracted to deploy, monitor and manage an online shopping website in Azure for a start-up company called "eshoponweb".  After evaluating the requirements, you develop and test deployment templates before presenting the below diagram for approval. The company's management is excited about how quickly you are able to deploy the solution, and give you the green light to proceed with the deployment.

![Hack Diagram](../Images/monitoringhackdiagram1.png)

## Description

For Challenge 0, you will deploy an environment in Azure that consists of two Azure Resource Groups containing many different resources. These include the VNet, subnets, NSG(s), LB(s), NAT rules, scale set and a fully functional .NET Core Application (eShopOnWeb) to monitor.

### Requirements

You will need ONE of the following tools to deploy the prerequisites for this hack:
- [AZ Module for PowerShell](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-6.3.0) installed on your workstation.
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) installed on your workstation.
- [Azure Cloud Shell]() deployed in your Azure subscription.

### Deploy

#### Azure CLI

1. Copy the code below and paste it in your desired tool: PowerShell, Terminal, VSCode, or CloudShell.

```azurecli
az login --tenant "<Tenant ID>"
```

2. Replace `<Tenant ID>` with your Azure Tenant ID.  This can be found on the Overview blade of Azure AD in the Azure Portal.
3. Press the ENTER key and login to Azure using the prompt.
4. Copy the code below and paste it in your desired tool:

```azurecli
az account set --subscription "<Subscription ID>"
```

5. Replace `<Subscription ID>` with your Azure Subscription ID.  This can be round on the Overview blade of your Subscription in the Azure Portal.
6. Press the ENTER key to set your default Azure subscription.
7. Copy the PowerShell code below in your desired tool and press ENTER to start the deployment:

```azurecli
az deployment sub create --location "eastus" --template-uri "https://raw.githubusercontent.com/jamasten/WhatTheHack/master/007-AzureMonitoring/Student/Resources/challenge-00_Template.json"
```

#### PowerShell with the AZ Module

1. Copy the PowerShell code below and paste it in your desired tool: PowerShell, Terminal, VSCode, or CloudShell.

```powershell
Connect-AzAccount -Tenant '<Tenant ID>' -Environment 'AzureCloud' -Subscription '<Subscription ID>' 
```

2. Replace `<Tenant ID>` with your Azure Tenant ID.  This can be found on the Overview blade of Azure AD in the Azure Portal.  
3. Replace `<Subscription ID>` with your Azure Subscription ID.  This can be round on the Overview blade of your Subscription in the Azure Portal.
4. Press the ENTER key and login to Azure using the prompt.
5. Copy the PowerShell code below in your desired tool and press ENTER to start the deployment.

```powershell
New-AzDeployment -Location "eastus" -TemplateUri "https://raw.githubusercontent.com/jamasten/WhatTheHack/master/007-AzureMonitoring/Student/Resources/challenge-00_Template.json"
```

### Validation

Once the deployment has completed, navigate to the Public IP Address resource, **pip-wth-monitor-web-d-eus** , in the Azure Portal.  In the Overview blade, copy the DNS name to your clipboard.  Open a web browser, paste your DNS name in the address bar and press ENTER.  Your browser should render the eShopOnWeb site:

![Webpage of the eShopOnWeb site](../Images/00-23-Eshoponweb-Webpage.png)

### Troubleshooting

- Make sure the Admin password adheres to the Azure password policy
- Make sure you are logged into the correct subscription and you have the at least contributors role access.  
- Make sure you have the compute capacity in the region you are deploying to and request an increase to the limit if needed.
- Make sure you are using a region that supports the public preview for Azure Monitor for VMs

## Success Criteria

## Learning Resources
