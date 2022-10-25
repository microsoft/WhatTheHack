# Challenge 8 - Dapr-enabled Services running in Azure Kubernetes Service (AKS)

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)**

## Introduction

In this challenge, you're going to deploy the Dapr-enabled services you have written locally to an [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/) cluster.

![architecture](../images/Challenge-08/architecture.png)

- Update all the host names & port numbers to use the Dapr defaults since it will be running in AKS.
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

- Change the host name for each service (in the `Program.cs` file) from `http://localhost` to `http://*` as this will allow the Kestrel server to bind to 0.0.0.0 instead of 127.0.0.1. This is needed to ensure the health probes work in Kubernetes.
  - [Debugging K8S Connection Refused](https://miuv.blog/2021/12/08/debugging-k8s-connection-refused)
- Use [ACR Tasks](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview) to simplify creation & deployment of the images to the registry.
- Modify the `Resources/Infrastructure/Helm/dapr-trafficcontrol/values.yaml` with the specific connection strings, tenant IDs, registry names, etc for your deployment.
- Use [Helm](https://helm.sh/docs/) to deploy all the AKS configuration files to Azure. Helm will substitute the values in the `values.yaml` file into the various configuration files.
- Use various `kubectl` commands to validate that all the services are running in your AKS cluster. Here are some useful ones.

  - Get all pods (in the current namespace)

    ```shell
    kubectl get pods
    ```

  - Describe a specific pod (to help debug deployment issues)

    ```shell
    kubectl describe pod <pod-name>
    ```

  - Tail the logs of a specific pod (and follow)

    ```shell
    kubectl logs fine-collection-service-7c99df4c85-2bxvf -f
    ```

## Learning Resources

- [AKS Key Vault integration](https://learn.microsoft.com/en-us/azure/aks/csi-secrets-store-driver)
- [AKS Workload Identity](https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview)

Thanks for participating in these hands-on challenges! Hopefully you've learned about Dapr and how to use it. Obviously, these challenges barely scratch the surface of what is possible with Dapr. We have not touched upon subjects like: hardening production environments, actors, integration with Azure Functions and Azure API Management just to name a few. So if you're interested in learning more, I suggest you read the [Dapr documentation](https://docs.dapr.io).
