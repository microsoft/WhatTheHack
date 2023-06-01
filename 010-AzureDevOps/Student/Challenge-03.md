# Challenge 03 - Azure Pipelines: Infrastructure as Code

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

Great we now have some code, now we need an environment to deploy it to. In DevOps we can automate the process of deploying the Azure Services we need with an Azure Resource Manager (ARM) template. Review the following articles:

1. [Azure Resource Manager overview](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview)
2. [Create Azure Resource Manager template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/how-to-create-template)

## Description

In Azure DevOps we can use Azure Pipelines to automate deploying our Azure infrastructure. For our application we will deploy 3 environments: Dev, Test and Prod. Each environment will consist of an Azure App Service, however all of our environments will share a single Resource Group, Azure App Service Plan, Application Insights Instance, and Azure Container Registry. 

**NOTE:** In real world deployments you will likely not share all of these resources.

Please note, while you can create a pipeline with the UI with a Release Pipeline, we will be focused on the YAML pipelines for this hack.

- Create a pipeline using the **Starter Pipeline** template, call it `Infrastructure Release`
- Next let's create the first stage in our Infrastructure Release to deploy our ARM template to Dev. Name the stage `Dev`, and it should have a single `Azure Resource Group Deployment` task. 
   - The task will ask you what Azure Subscription, Resource Group, and Resource Group Location you wish to use.
   - The task will also ask you what Template you want to deploy. You will need to supply the relative path to the file during the pipeline run.
   - You will need to override many of the templates parameters, replacing the `<prefix>` part with a unique lowercase 5 letter name.
- You should now be able to save and execute your infrastructure release pipeline successfully and see the dev environment out in Azure. 
- If everything worked, go ahead and clone the `dev` stage two more times for `test` and `prod`.
   - The only change you need to make in the `test` and `prod` stages is changing the `webAppName` template parameter to `<prefix>devops-test` and `<prefix>devops-prod` respectively. 
- You should now be able to save and execute your infrastructure release pipeline successfully and see all three environments out in Azure. 

## Success Criteria

1. Your infrastructure release should complete without any errors and you should see all three environments out in Azure. 

## Learning Resources

We are just scratching the surface of what is offered in Azure for Infrastructure as Code, if you are interested in learning more, there are multiple What the Hacks focused on Azure Infrastructure as Code:
- [Infrastructure As Code: Bicep](../../045-InfraAsCode-Bicep/README.md)
- [Infrastructure As Code: ARM & DSC](../../011-InfraAsCode-ARM-DSC/readme.md)
- [Infrastructure As Code: Terraform](../../012-InfraAsCode-Terraform/Student/readme.md)
- [Infrastructure As Code: Ansible](../../013-InfraAsCode-Ansible/Student/readme.md)
