# Challenge 05 - Infrastructure as Code (IaC)

[< Previous Challenge](Challenge-04.md) - [Home](../README.md) - [Next Challenge >](Challenge-06.md)

## Introduction

Now that we have some code, we need an environment to deploy it to! The term Infrastructure as Code (IaC) refers to using templates (code) to repeatedly and consistently create the dev, test, prod (infrastructure) environments. We can automate the process of deploying the Azure services we need with an Azure Resource Manager (ARM) template. invoked from automation in a GitHub Actions workflow 

Review the following articles:

- [Azure Resource Manager overview](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview)
- [Create Azure Resource Manager template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/how-to-create-template)


## Description

We will use GitHub Actions to automate the deployment of our Azure infrastructure. For our application, we will deploy 3 environments: `dev`, `test` and `prod`. Each environment will have its own Web App, however all of our environments will share a single Resource Group, App Service Plan, Application Insights instance, and Azure Container Registry. 

**NOTE:** In real deployments, you will likely not share all of these resources.


- Review the Bicep template. Notice how it is configured to create an App Service Plan, Web App, Application Insights, and Azure Container Registry into your resource group

- Notice how the Bicep file uses the `uniqueString` function to create a unique names for your resources. This function is not random, but a hash function on your resource group id to provide a consistent, but likely unique 13 character string that is useful to avoid naming conflicts in Azure.

- Notice the environment and location are defined as parameters that have default values but are able to be overridden. You will be able to use this within the challenge to supply other names like `test` and `prod` in this challenge to create other resources that represent different environments for deployment.

- Create a service principal to login to Azure (your coach may supply you these credentials and a resource group name or if you have your own Azure subscription you will need to login and create a resource group and then create a service principal with permissions (e.g. contributor) in this group. 
    **HINT:** Details on creating the service principal can be found in the [Azure/login](https://github.com/Azure/login) README.md. 

- Create a GitHub repository level secret to store the above login credentials

- Create a GitHub repository level configuration variable to store the name of the Azure resource group name 
    **HINT:** If you found the page to find Secrets for Actions you will see another tab in the same place to enter configuration variables at a repository level.

- Create a new GitHub workflow (`deploy.yml`) that runs on a manual trigger (*not* triggered by a push or pull request).

- Configure your workflow to accomplish the following:
    - Use a service principal to login to Azure using your secret and configuration variable values.
    - Use the "Deploy Azure Resource Manager (ARM) Template" action to call the Bicep template in your repo
    **NOTE:** The name is a little confusing here as this action supports both ARM and Bicep as the template file.  This is because Bicep is a transparent abstraction of ARM.  For more details check out this [article](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep)

- Manually run your workflow. When your workflow completes successfully, go to the Azure portal to see the `dev` environment. 
    
    **NOTE:** If you were supplied Azure connection details your coach may need to help you see this. 

If everything worked, we are going to call the Bicep template again, but override the `environment` parameter in the Bicep template supplying the value of `test` to override the default `dev` value that was used before.

- Rerun the workflow. When your workflow completes successfully, go to the Azure portal to see the new `test` App Service. 
    
    **NOTE:** If you were supplied Azure connection details your coach may need to help you see this. 

- Finally we want resources to represent production so replace the `test` value supplied for your overridden environment variable and change this to `prod` and rerun the workflow. When your workflow completes successfully, go to the Azure portal to see the new `prod` App Service has been created. 
   
   **NOTE:** If you were supplied Azure connection details your coach may need to help you see this.

You should see now have all three environments in Azure.

## Success Criteria

- Your `deploy.yaml` workflow completes without any errors and overrides the `environment` parameter when calling the Bicep template.
- Your resource group contains 6 resources: 3 App Services (dev, test, prod), 1 Application Insights, 1 App Service plan and 1 Container registry. 

## Learning Resources

- [What is Infrastructure as Code?](https://docs.microsoft.com/en-us/azure/devops/learn/what-is-infrastructure-as-code)
- [Secrets in GitHub Actions](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Configuration Variables in GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/variables#creating-configuration-variables-for-a-repository)
- [Deploy Bicep and Azure Resource Manager templates by using GitHub Actions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-github-actions)
- [Overriding ARM template parameters](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-cli#parameters)

## Advanced Challenges (optional)

Instead of changing the environment variable for each environment that we want to create in the deploy.yaml, you can configure the workflow to prompt the user to enter the environment name before the workflow runs - eliminating the need to hard code the environment name.
- Configure your workflow to collect the environment name as a [workflow input](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#onworkflow_callinputs) and use that value to override the environment parameter when calling the Bicep template.

**NOTE**: If you are interested in learning more about Infrastructure as Code, there are multiple [What the Hacks](https://aka.ms/wth) that cover it in greater depth:

   - [Infrastructure As Code: Bicep](https://microsoft.github.io/WhatTheHack/045-InfraAsCode-Bicep/)
   - [Infrastructure As Code: ARM Templates & PowerShell DSC](https://microsoft.github.io/WhatTheHack/011-InfraAsCode-ARM-DSC/)
   - [Infrastructure As Code: Terraform](https://microsoft.github.io/WhatTheHack/012-InfraAsCode-Terraform/Student/)
   - [Infrastructure As Code: Ansible](https://microsoft.github.io/WhatTheHack/013-InfraAsCode-Ansible/Student/)
    
[< Previous Challenge](Challenge-04.md) - [Home](../README.md) - [Next Challenge >](Challenge-06.md)
