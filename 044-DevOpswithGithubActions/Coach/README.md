# Welcome to Devops With GitHub Hackathon

## Overview

Contoso is Insurance company, they provide a full range of long-term insurance services to help individuals who are under-insured, filling a void their founders saw in the market. From the beginning, they grew faster than anticipated and have struggled to cope with rapid growth. During their first year alone, they added over 100 new employees to keep up with the demand for their services. To manage policies and associated documentation, they use a custom-developed Windows Forms application, called Policy Connect. Policy Connect uses an Azure Sql database as its data store. 
Contoso recently started a new web and mobile projects to allow policyholders, brokers, and employees to access policy information without requiring a VPN connection into the Contoso network. The web project is a new .NET Core 3.1 MVC web application, which accesses the PolicyConnect database using REST APIs. They eventually intend to share the REST APIs across all their applications including the mobile app. They already have plan in place to Host Web Applications on Azure. Contoso Architecture team has already created blueprint of their deployments on Azure. Work with your team to Assess Solution requirements. Create step by step plan as listed in Hackathon tasks and deploy solution components. Code repository is hosted on Github. Contoso team needs your help to create Github Workflows to automate CI/CD and deploy application on Azure. Security is prime concern for them hence ensure secrets are stored in secured vaults. Policy Documents for Policy Holders are stored in Cloud Storage and retrieved using Web and Mobile apps using APIs.


![Solution BluePrint](/044-DevOpswithGithubActions/Student/Resources/images/solutionblueprint.png)

## Coach Guidance for Challenges
- Challenge 1: **[Assessment](./Challenge01.md)**
   - Navigate through Source code and services required
   - Create service principal with contributer role on Azure Subscription
 - Challenge 2: **[Service creation](./Challenge02.md)**
   - Create Azure services for SQL Databases and API Website .
   - Build and Deploy API website.
- Challenge 3: **[Deploy Front end Website](./Challenge03.md)**
   - Create Azure Services for Front Website.
   - Build and Deploy Frontend Website
- Challenge 4: **[Power of Serverless](./Challenge04.md)**
   - Create Azure Function Website.
   - Build and Deploy Azure Function Wesbite.
- Challenge 5: **[Secure your Solution](./Challenge05.md)**
   - Create API Management service.
   - Import Open API and Azure Function API.

   
## Prerequisites

- Ensure you have Github Personal Account ,[Sign Up for Personal Github Account](https://github.com)
- Ensure you have Azure Subscription ,[Sign Up for Azure free if you don't have any subscription](https://azure.microsoft.com/en-us/free/)
