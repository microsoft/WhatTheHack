# Challenge 02 - Deploy your Integration Environment


[<Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge>](./Challenge-03.md)

## Pre-requisites

- You should have completed Challenge 01

## Introduction
Now that you've created your Bicep templates, you would like to create a CI/CD pipeline to deploy these templates to your Azure environment. 

## Description
- Create a repository and upload your Bicep templates to the main branch.
- Create a CI/CD pipeline using either GitHub Actions or Azure DevOps.
    - If using GitHub actions (recommended), a sample workflow (deploy.yml) can be found at `/Challenge-02` of the `Resources.zip` provided by your coach.
    - If using Azure Pipelines, it is ideal that you are using an organization that has [parallel jobs configured](https://docs.microsoft.com/en-us/azure/devops/pipelines/licensing/concurrent-jobs?view=azure-devops&tabs=ms-hosted).  Otherwise, you will need to request free parallel jobs which will take 2-3 days to complete or set-up paid jobs for a cost.
    A sample YAML pipeline (azure-pipelines.yaml) can be found at `/Challenge-02` of the `Resources.zip` provided by your coach.
- Deploy your environment using the Bicep templates that you created from Challenge 01.

## Success Criteria
- Verify that you are able to run an automated deployment of your environment using the Bicep templates that you created from Challenge 01.
- Verify that you are able to send a GET or POST request to Echo API (the default API configured in APIM).

## Learning Resources
- [Quickstart for GitHub Actions](https://docs.github.com/en/actions/quickstart)
- [Quickstart: Deploy Bicep files by using GitHub Actions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-github-actions?tabs=CLI)
- [Quickstart: Integrate Bicep with Azure Pipelines](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/add-template-to-azure-pipelines?tabs=CLI)
- [Deploy Azure resources by using Bicep and GitHub Actions](https://docs.microsoft.com/en-us/learn/paths/bicep-github-actions/)
- [Deploy Azure resources by using Bicep and Azure Pipelines](https://docs.microsoft.com/en-gb/learn/paths/bicep-azure-pipelines/)


## Advanced Challenges
- In your GitHub Actions workflow or Azure DevOps pipeline, rather than having a single task that deploys your Bicep template straight to Azure, extend it to include some or all of the suggested tasks:
    - Linting and validating your Bicep code.
    - Adding a preview job to see what will be deployed to Azure and an approval step before deploying your template.
    - Adding a test job to verify that your template deployed correctly.

[Back to Top](#challenge-02---deploy-your-integration-environment)
