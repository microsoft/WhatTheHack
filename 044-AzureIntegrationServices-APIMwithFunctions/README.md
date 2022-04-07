# Azure Integration Services - API Management with Function Apps

## Introduction
The Azure Integration Services will take you on lap around the world of enterprise integration in Azure.  

## Learning Objectives
In this hack you will be solving common business scenario our customers face when building integration solution in Azure from ground-up.  The goal of this hack is to adopt what are the best practices for deploying, configuring and securing integration services, which includes:

1. Authoring Bicep templates to build an APIM + backend services hosted in Function Apps
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


<!-- 6. Challenge 5: **[Secure backend API using client certificate](Student/Challenge-05.md)**
   - Securing backend API using client certificate -->