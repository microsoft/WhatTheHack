# Challenge 2: AKS Network Integration and Private Clusters

[< Previous Challenge](./01-containers.md) - **[Home](../README.md)** - [Next Challenge >](./03-aks_monitoring.md)

## Introduction

This challenge will cover deployment of AKS clusters fully integrated in a Virtual Network. Make sure to check the optional objectives if you are up to a harder exercise.

## Description

You need to fulfill these requirements to complete this challenge:

- Deploy an AKS cluster integrated in an existing VNet (you need to create the VNet in advance)
- Deploy as few nodes as possible
- Deploy an Azure SQL Database if you did not have one from the previous challenge
- Deploy the API and Web containers, expose them over an ingress controller (consider the Application Gateway Ingress Controller, although it is not required). Make sure the links in the section `Direct access to API` of the web page exposed by the Web container are working, as well as the links in the Web menu bar (`Info`, `HTML Healthcheck`, `PHPinfo`, etc)

## Success Criteria

- The application is reachable over the ingress controller, and the API can read the database version successfully
- The links in the `Direct access to API` section of the frontend are working

## Advanced Challenges (Optional)

- Make sure the AKS cluster does not have **any** public IP address
- Configure the Azure SQL Database so that it is only reachable over a private IP address
- Use an open source managed database, such as Azure SQL Database for MySQL or Azure Database for Postgres

## Learning Resources

These docs might help you achieving these objectives:

- [Azure Private Link](https://docs.microsoft.com/azure/private-link/private-link-overview)
- [Restrict AKS egress traffic](https://docs.microsoft.com/azure/aks/limit-egress-traffic)
- [Azure SQL Database](https://docs.microsoft.com/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview)
- [AKS Overview](https://docs.microsoft.com/azure/aks/)
- [Application Gateway Ingress Controller](https://docs.microsoft.com/azure/application-gateway/ingress-controller-overview)
- [Create an Nginx ingress controller in AKS](https://docs.microsoft.com/azure/aks/ingress-basic?tabs=azure-cli)
- [Web Application Routing Addon](https://docs.microsoft.com/azure/aks/web-app-routing)