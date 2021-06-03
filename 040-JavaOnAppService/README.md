# What The Hack - Java on App Service

## Introduction

There's a number of ways to host a Java app on Azure. Depending on the nature of the application (Spring Boot, microservices as Spring Cloud or containerized services, WAR/EAR projects) Azure provides different options to host your application in a managed fashion.

During this hack we'll explore one of the easiest paths to host a simple Java application (using Spring Boot) on Azure, **without making any changes to the application.**

## Learning Objectives

In this hack you'll address the most common challenges faced when deploying any application on a cloud service. We'll assume that there's an application that works just fine, and we'd like to host that on Azure without making any changes to the application and/or introducing any Azure specific functionality.

You'll get introduced to App Service for hosting applications, you'll learn about managed Open Source databases on Azure, you'll monitor your applications's performance without making any changes and observe it scale automatically.

## Challenges

- Challenge 0: **[Getting your feet wet](Student/challenge-00.md)**
  - Get yourself ready to deploy a Spring Boot application on Azure
- Challenge 1: **[Head in the cloud, feet on the ground](Student/challenge-01.md)**
  - Deploy a Azure Database for MySQL and configure the app to connect to it
- Challenge 2: **[Azure App Services &#10084;&#65039; Spring Boot](Student/challenge-02.md)**
  - Deploy the application on a new Azure App Service instance
- Challenge 3: **[Keep your secrets safe](Student/challenge-03.md)**
  - Store credentials and other sensitive data in a Key Vault
- Challenge 4: **[Do you know what's going on in your application?](Student/challenge-04.md)**
  - Configure an Application Insights instance and monitor the basics
- Challenge 5: **[Operational dashboards](Student/challenge-05.md)**
  - Create a dashboard with Azure Monitor metrics and Application Insights information
- Challenge 6: **[It's all about the scale](Student/challenge-06.md)**
  - Configure the App Service instance to scale

## Prerequisites

- Your own Azure subscription with Owner access
- Java 8+ installed locally
- Your favourite code editor
- Azure CLI

## Contributors

- Murat Eken
- Gino Filicetti
