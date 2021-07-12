# Welcome to Devops With GitHub Hackathon

## Overview

Contoso is Insurance company, they provide a full range of long-term insurance services to help individuals who are under-insured, filling a void their founders saw in the market. From the beginning, they grew faster than anticipated and have struggled to cope with rapid growth. During their first year alone, they added over 100 new employees to keep up with the demand for their services. To manage policies and associated documentation, they use a custom-developed Windows Forms application, called Policy Connect. Policy Connect uses an Azure Sql database as its data store. 
Contoso recently started a new web and mobile projects to allow policyholders, brokers, and employees to access policy information without requiring a VPN connection into the Contoso network. The web project is a new .NET Core 3.1 MVC web application, which accesses the PolicyConnect database using REST APIs. They eventually intend to share the REST APIs across all their applications including the mobile app. They already have plan in place to Host Web Applications on Azure. Contoso Architecture team has already created blueprint of their deployments on Azure. Work with your team to Assess Solution requirements. Create step by step plan as listed in Hackathon tasks and deploy solution components. Code repository is hosted on Github. Contoso team needs your help to create Github Workflows to automate CI/CD and deploy application on Azure. Security is prime concern for them hence ensure secrets are stored in secured vaults. Policy Documents for Policy Holders are stored in Cloud Storage and retrieved using Web and Mobile apps using APIs.


![Solution BluePrint](/044-DevOpswithGithubActions/Student/resources/images/solutionblueprint.png)

# Prerequisite (Mandate)

  ### 1. Ensure you have Github Personal Account
  ### 2. Ensure you have Azure Subscription
  
# Solution Flow of Hackathon Task by Task

1. Download this Reposistory as Zip and Provide Zip of Student folder using Teams
2. Remind contestants for prerequiste and ask them to have that in place before starting with Hackathon
3. Once contestants have Github Reposistory and Azure subscription, next they need to create Azure service principal 
4. Create Github secrets to store Azure Service Principal
5. Start with Restoration of SQL database , ensure functioning by accessing using Microsoft SQL Management studio.
6. Solution build for API website , Create API website and deploy API code
7. Solution build for frontend website, use solution file for front web builds
8. Azure function needs to be created for updating policy document with Frontend website
9. Deploy Function app code to Azure Function website
10. Secure Swagger and serverless API using API management service
11. Test end to end solution for any Insurance user
