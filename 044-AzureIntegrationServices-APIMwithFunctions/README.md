# Azure Integration Services - API Management with Function Apps

## Introduction
The Azure Integration Services (AIS) Hack will provide you a deep dive experience in building a solution to seamlessly connect apps to services whether hosted on premises or in the cloud.  This hack - the first of many series - will enable participants to solve common business scenarios our customers face when building AIS from ground-up, from deploying, configuring and securing API management and its backend services. 


## Learning Objectives
In this hack, the participants will learn how to build an integration solutin using API Management and Function Apps.  This involves the following:

1. Authoring Bicep templates to build API Management Service and backend APIs hosted in Function Apps
2. Creating CI/CD pipeline to deploy environment
3. Securing backend API services via OAuth
4. Securing backend API services over the VNET


## Challenges
1. Challenge 0: **[Prepare your development environment](Student/Challenge-00.md)**
   - Get yourself ready to build your integration solution
2. Challenge 1: **[Provision an integration environment](Student/Challenge-01.md)**
   - Create a bicep template that will provision a baseline integration environment.
3. Challenge 2: **[Deploy your integration environment](Student/Challenge-02.md)**
   - Create a CI/CD pipeline to do automated deployment of your integration environment.
4. Challenge 3: **[Create backend API](Student/Challenge-03.md)**
   - Create backend APIs
5. Challenge 4: **[Secure backend APIs](Student/Challenge-04.md)**
   - Securing backend APIs by configuring them in the VNET or by using OAuth 2.0 authorization


## Prerequisites
- Your own Azure subscription with Owner access
- Visual Studio Code
- Azure CLI
- Azure DevOps project 

## Repository Contents (Optional)
- `../Coach/Guides`
  - Coach's Guide and related files
- `../images`
  - Generic image files needed
- `../Student/Guides`
  - Student's Challenge Guide

## Contributors
- Noemi Veneracion (novenera@microsoft.com)
- Will Velida (willvelida@microsoft.com)
- Sateeshkumar Mohan (samanoh@microsoft.com)
- Chun Liu (chunliu@microsoft.com)


<!-- 6. Challenge 5: **[Secure backend API using client certificate](Student/Challenge-05.md)**
   - Securing backend API using client certificate -->