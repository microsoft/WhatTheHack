# Challenge 8 - Deploy to Azure Kubernetes Service (AKS)

[< Previous Challenge](./Challenge07.md) - **[Home](../README.md)**

## Introduction

In this assignment, you're going to deploy the Dapr-enabled services you have written locally to an [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/) cluster.

![architecture](../.img/Challenge-08/architecture.png)


## Success Criteria

To complete this assignment, you must reach the following goals:

- Successfully deploy all 3 services (VehicleRegistrationService, TrafficControlService & FineCollectionService) to an AKS cluster.
- Successfully run the Simulation service locally that connects to your AKS-hosted services

## Tips

1. 	Navigate to each service under the `src` directory, create images based upon the services and deploy these images to your Azure Container Registry. Hint: use [ACR Tasks](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview) to simplify creation & deployment of the images to the registry.

2. 	Navigate to each service under the `src` directory and use the `deploy/deploy.yaml` spec files to deploy to AKS. You will need to customize them with the
   	names of your specific Azure container registries, etc.

3.	Run the `Simulation` app and verify your services are running.


## Learning Resources

Thanks for participating in these hands-on assignments! Hopefully you've learned about Dapr and how to use it. Obviously, these assignment barely scratch the surface of what is possible with Dapr. We have not touched upon subjects like: hardening production environments, actors, integration with Azure Functions, Azure API Management and Azure Logic Apps just to name a few. So if you're interested in learning more, I suggest you read the [Dapr documentation](https://docs.dapr.io).
