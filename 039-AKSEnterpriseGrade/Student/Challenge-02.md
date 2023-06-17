# Challenge 02 - AKS Network Integration and Private Clusters

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

This challenge will cover deployment of an AKS cluster fully integrated in a Virtual Network as well as deploying the sample app, and configuring ingress. 

Make sure to check the optional objectives if you are up to a harder exercise.

## Description

You need to fulfill these requirements to complete this challenge:

### Deploy an AKS Cluster

- Deploy an AKS cluster integrated in an existing VNet (you need to create the VNet in advance)
- Deploy as few nodes as possible
- Attach the cluster to the Azure Container Registry you created in the previous challenge.

**NOTE:** If you do not have "Owner" permissions on your Azure subscription, you will not have permission to attach your AKS cluster to your ACR.  We have staged the sample application on Docker Hub so that you can use the container images at these locations:
- **API app:** `whatthehackmsft/api`
- **Web app:** `whatthehackmsft/web`

**HINT:** If you decide to use your own ACR with the images for api and web, you must fully qualify the name of your ACR. An image with a non-fully qualified registry name is assumed to be in Docker Hub. 

### Deploy the sample application

- Deploy an Azure SQL Database if you did not have one from the previous challenge
- Deploy the API and Web containers, expose them over an ingress controller (consider the Application Gateway Ingress Controller, although it is not required). 
    - Make sure the links in the section `Direct access to API` of the web page exposed by the Web container are working, as well as the links in the Web menu bar (`Info`, `HTML Healthcheck`, `PHPinfo`, etc)

## Success Criteria

- Verify the application is reachable over the ingress controller, and the API can read the database version successfully
- Verify the links in the `Direct access to API` section of the frontend are working

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