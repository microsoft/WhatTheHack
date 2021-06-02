# What The Hack - Java on App Service

## Introduction

Welcome to the coach's guide for Java on Azure What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

## Coach's Guides

> Make sure that you've zipped the `spring-petclinic` folder from the [Resources](../Student/Resources) folder and provide it to the students before the challenges.

There's a number of Azure resources that need to be created during this hack. You could create those incrementally, following the challenges and their corresponding solutions, but you could also create all of the resources at once as described in the [final solution](solution-all.md). Otherwise see the solutions for individual challenges as listed below. Note that this repository uses `bicep` files to create the required resources, but that's by no means a requirement for the students (or even the coaches). Any method (Portal, CLI, ARM, Terraform etc.) is allowed to provision the Azure services.

- Challenge 0: **[Getting your feet wet](solution-00.md)**
  - Get yourself ready to deploy a Spring Boot application on Azure
- Challenge 1: **[Head in the cloud, feet on the ground](solution-01.md)**
  - Deploy a Azure Database for MySQL and configure the app to connect to it
- Challenge 2: **[Azure App Services &#10084;&#65039; Spring Boot](solution-02.md)**
  - Deploy the application on a new Azure App Service instance
- Challenge 3: **[Keep your secrets safe](solution-03.md)**
  - Store credentials and other sensitive data in a Key Vault
- Challenge 4: **[Do you know what's going on in your application?](solution-04.md)**
  - Configure an Application Insights instance and monitor the basics
- Challenge 5: **[Operational dashboards](solution-05.md)**
  - Create a dashboard with Azure Monitor metrics and Application Insights information
- Challenge 6: **[It's all about the scale](solution-06.md)**
  - Configure the App Service instance to scale
