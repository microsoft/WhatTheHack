# What The Hack: DevOps with GitHub 

## Challenge 3 - Infrastructure as Code (IaC)

[< Previous](challenge02.md) - [Home](../readme.md) - [Next >](challenge04.md)

### Introduction

Now that we have some code, we need an environment to deploy it to! The term Infrastructure as Code (IaC) refers to using templates (code) to repeatedly and consistently create the dev, test, prod (infrastructure) environments. We can automate the process of deploying the Azure services we need with an Azure Resource Manager (ARM) template. 

Review the following articles:

- [Azure Resource Manager overview](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview)
- [Create Azure Resource Manager template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/how-to-create-template)


### Challenge

We will use GitHub Actions to automate the deployment of our Azure infrastructure. For our application, we will deploy 3 environments: `dev`, `test` and `prod`. Each environment will have its own Web App, however all of our environments will share a single Resource Group, App Service Plan, Application Insights instance, and Azure Container Registry. NOTE: in real deployments, you will likely not share all of these resources.

First, we are going to deploy the dev environment:

1. Review the [ARM template](./Code/ARM-Templates/container-webapp-template.json). Notice how it defines a number of parameters and uses them to create the Resource Group, App Service Plan, Web App, Application Insights, and Azure Container Registry.

2. Update the ARM template, replacing the `<prefix>` part with a unique lowercase 5 letter name. The resulting name needs to be globally unique to correctly provision resources.

3. Create a GitHub workflow (`deployDev.yml`) that accomplishes the following:
    - Only runs when changes are made to the workflow file itself 
    - Uses a service principal to authenticate to Azure
    - Uses the "Deploy Azure Resource Manager (ARM) Template" action to call your ARM template in your repo

When your workflow completes successfully, go to the Azure portal to see the environment. If everything worked, create the test environment:

4. Update the webAppName template parameter (line #6) to `<prefix>devops-test`. Important: commit and push to GitHub before proceeding!

5. Copy your `dev` workflow file and use it to create a new workflow file for `test` (`deployTest.yml`)
    - Be sure to update the `paths` in your workflow file (i.e., `.github/workflows/deployTest.yml`)

When your workflow completes successfully, go to the Azure portal to see the `test` environment. If everything worked, create the `prod` environment:

6. Update the webAppName template parameter (line #6) to `<prefix>devops-prod`. Important: commit and push to GitHub before proceeding!

7. Copy your `test` workflow file and use it to create a new workflow file for `prod` (`deployProd.yml`)
    - Be sure to update the `paths` in your workflow file (i.e., `.github/workflows/deployProd.yml`)

You should see all three environments in Azure.

### Success Criteria

- Your workflows completes without any errors.
- Your resource group contains 6 resources: 3 App Services, 1 Application Insights, 1 App Service plan and 1 Container registry. 

### Learning Resources

- [What is Infrastructure as Code?](https://docs.microsoft.com/en-us/azure/devops/learn/what-is-infrastructure-as-code)
- [Introduction to GitHub Actions](https://docs.github.com/en/free-pro-team@latest/actions/learn-github-actions/introduction-to-github-actions)
- [Understanding workflow path filters](https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions#onpushpull_requestpaths)
- [Migrating from Azure Pipelines to GitHub Actions](https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions#onpushpull_requestpaths)
- [Deploy Azure Resource Manager templates by using GitHub Actions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-github-actions)


### Advanced Challenges (optional)

1. In this challenge, we edited the ARM template for each environment (`dev`, `test`, `prod`) but there are ways of [overriding template parameters](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-cli#parameters).

    - Create a fourth environment, called `staging`, by overriding the template parameters. ([hint](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-cli#parameters))
    - When you have successfully created the `staging` environment, you can delete it as it will not be used in the upcoming challenges. 

2. In this challenge, we setup three separate workflow files to handle `dev`, `test` and `prod`, however, this could be done with a single workflow with the target environment stored as a secret instead of hardcoding it in the workflow file.
    - Create a GitHub secret (called `targetEnv`) and set the *value* to `staging2` ([hint](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets))
    - In your workflow, read the GitHub secret ([hint](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets#using-encrypted-secrets-in-a-workflow))
and pass the value as a overriding template parameter (as described in Advanced Challenge #1)
    - When you have successfully created the `staging2` environment, you can delete it as it will not be used in the upcoming challenges.


NOTE: If you are interested in learning more about Infrastructure as Code, there are [multiple](https://github.com/microsoft/WhatTheHack) What the Hacks that cover it in greater depth.

[< Previous](challenge02.md) - [Home](../readme.md) - [Next >](challenge04.md)