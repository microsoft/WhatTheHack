# Challenge 8 - Dapr-enabled Services running in Azure Kubernetes Service (AKS)

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)**

## Introduction

In this challenge, you're going to deploy the Dapr-enabled services you have written locally to an [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/) cluster.

![architecture](../images/Challenge-08/architecture.png)

- Update all the port numbers to use the Dapr defaults since it will be running in AKS.
- Create a Kubernetes secret in your AKS cluster that references your Azure KeyVault secrets.
- Update the Dapr secret configuration file to pull secrets from the Kubernetes secret.
- Build Docker images of all 3 services & upload to the Azure Container Registry.
- Deploy your service images to your AKS cluster.
- Run your **Simulation** service locally.

## Success Criteria

To complete this challenge, you must reach the following goals:

- Validate that all 3 services are compiled into Docker images & stored in an Azure Container Registry.
- Validate that you have successfully deployed all 3 services (`VehicleRegistrationService`, `TrafficControlService` & `FineCollectionService`) to an AKS cluster.
- Validate that the local **Simulation** service runs & connects to your AKS-hosted services and that all the previous functionality still works (input messages, output messages, speeding violation emails, etc).

## Tips

- Use [ACR Tasks](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview) to simplify creation & deployment of the images to the registry.
- Modify the `Resources/dapr/components/fine-collection-service.yaml` (and other services) spec files to deploy each service to AKS. You will need to customize them with the names of your specific Azure container registries, etc.
- Use the Kubernetes [Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/) command to deploy all the services in the `Resources/dapr/components` directory simulatiously
  ```shell
  cd Resources/dapr/components
  kubectl apply -k .
  ```

## Learning Resources

Thanks for participating in these hands-on challenges! Hopefully you've learned about Dapr and how to use it. Obviously, these challenges barely scratch the surface of what is possible with Dapr. We have not touched upon subjects like: hardening production environments, actors, integration with Azure Functions, Azure API Management and Azure Logic Apps just to name a few. So if you're interested in learning more, I suggest you read the [Dapr documentation](https://docs.dapr.io).
