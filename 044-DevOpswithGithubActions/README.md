# Welcome to Devops With GitHub Hackathon

## Introduction
This hack contain is designed to put the student in the role of a DevOps Engineer's day to day life. The hack tests the ability of students to create and manage Azure Cloud services using Github Actions.

Using a challenge-based approach, students will start by assessing and discovering existing customer requirements. The students will continue to solve additional challenges that build upon each other to implement the complete end-to-end solution as described in the blueprint image below. As students proceed, there are success criteria for each challenge against which they will be measured before proceeding to the next challenge.

## Learning Objectives
Contoso is an insurance company that provides a full range of long-term insurance services to help individuals who are under-insured, filling a void their founders saw in the market. From the beginning, they grew faster than anticipated and have struggled to cope with rapid growth. During their first year alone, they added over 100 new employees to keep up with the demand for their services.

To manage policies and associated documentation, Contoso uses a custom-developed Windows Forms application, called Policy Connect. Policy Connect uses an Azure SQL database as its data store.

Contoso recently started new web and mobile projects to allow policyholders, brokers, and employees to access policy information without requiring a VPN connection into the Contoso network. The web project is a new .NET Core 3.1 MVC web application, which accesses the Policy Connect database using REST APIs. They eventually intend to share the REST APIs across all their applications including the mobile app. They already have plan in place to host web applications on Azure.

The Contoso Architecture team has already created blueprint of their deployments on Azure.

• Work with your team to assess the solution requirements.

• Create a plan, as directed in the hack's challenges, to deploy solution components.

• The code repository is hosted on Github. The Contoso team needs your help to create Github Workflows to automate CI/CD and deploy application on Azure.

• Security is prime concern for Contoso, hence ensure secrets are stored in secured vaults.

Policy Documents for Policy Holders are stored in Cloud Storage and retrieved using the Web and Mobile apps using APIs.

![Solution BluePrint](/044-DevOpswithGithubActions/Student/Resources/images/solutionblueprint.png)

## Challenges
- Challenge 1: **[Assessment and Getting Ready for Prerequisite](Student/Challenge01.md)**
   - Go through the student resources, demonstrate your understanding of the environment to your coach.
   - Provide details of the tools and services you are going to use based on your assessment.
- Challenge 2: **[Build and Deploy API Website](Student/Challenge02.md)**
   - Based on your understand, create required services and demonstrate to coach.
   - Getting API Website up and running as per challenge requirements.
- Challenge 3: **[Build and Deploy Frontend Website](Student/Challenge03.md)**
   - Based on your understanding from the challenge requirements, create the required services and demonstrate to your coach.
   - Showcase Functional Website for Contoso Insurance.
- Challenge 4: **[Power of Serverless](Student/Challenge04.md)**
   - Based on your understanding from the challenge requirements, create the required services and demonstrate to your coach.
   - Showcase Functional Website for Contoso Insurance.
- Challenge 5: **[Secure your Solution](Student/Challenge05.md)**
   - Based on your understanding from the challenge requirements, secure the APIs and services.
   - Demonstrate secure functional solution implementation to coach.

   
## Prerequisites

- Ensure you have a Github Personal Account: [Sign Up for Personal Github Account](https://github.com)
- Ensure you have Azure Subscription: [Sign Up for Azure free if you don't have any subscription](https://azure.microsoft.com/en-us/free/)

## Repository Contents
- `../Coach`
  - Guidance for coaches to host this hack.
- `../Student/Resources`
   -  Hackathon code and challenges for students to work through.

## Contributors
- Vijay Jethani
