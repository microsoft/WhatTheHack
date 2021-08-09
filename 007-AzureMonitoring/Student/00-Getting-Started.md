# Challenge 0: Getting started

**[Home](../README.md)** - [Next Challenge>](./01-Alerts-Activity-Logs-And-Service-Health.md)

## Introduction

You have been contracted to deploy, monitor and manage an online shopping website in Azure for a start-up company called "eshoponweb".  After evaluating the requirements, you develop and test deployment templates before presenting the below diagram for approval. The company's management is excited about how quickly you are able to deploy the solution, and give you the green light to proceed with the deployment.

![Hack Diagram](../Images/monitoringhackdiagram1.png)

## Description

For Challenge 0, you will deploy an environment in Azure that consists of two Azure Resource Groups containing many different resources. These include the VNet, subnets, NSG(s), LB(s), NAT rules, scale set and a fully functional .NET Core Application (eShopOnWeb) to monitor.

### Requirements

- Install [Visual Studio Code (VSCode)](https://code.visualstudio.com/) on your workstation.
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) on your workstation.
- Download the [code repository](https://github.com/jamasten/WhatTheHack/archive/refs/heads/master.zip).

### Deploy

- Open VSCode
- Change the working directory to the "Resources" directory within the Monitoring hack directory.
- Run the following Azure CLI command to deploy the template:

```azurecli
az deployment sub create --location eastus --template-file challenge-00_Template.bicep
```

### Validation

Once the deployment has completed, navigate to the Public IP Address resource in the Azure Portal.  Copy the DNS name to your clipboard.  Open a web browser, paste your clipboard contents in the address bar, and press ENTER.

![Copy DNS Name from Public IP Address](../Images/00-22-Azure-Portal-Copy-Pip-Dns-Name.png)

You should render the eShopOnWeb site

![Webpage of the eShopOnWeb site](../Images/00-23-Eshoponweb-Webpage.png)

### Troubleshooting

- Make sure the Admin password adheres to the Azure password policy
- Make sure you are logged into the correct subscription and you have the at least contributors role access.  
- Make sure you have the compute capacity in the region you are deploying to and request an increase to the limit if needed.
- Make sure you are using a region that supports the public preview for Azure Monitor for VMs - link

## Success Criteria

## Learning Resources
