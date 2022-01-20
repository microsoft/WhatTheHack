# Challenge 8 - Dapr-enabled Services running in Azure Kubernetes Service (AKS) - Coach's Guide

[< Previous Challenge](./Solution-07.md) - **[Home](./README.md)**

## Notes & Guidance

In this challenge, you're going to deploy the Dapr-enabled services you have written locally to an [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/) cluster.

![architecture](../images/Challenge-08/architecture.png)

### Challenge goals

To complete this challenge, you must reach the following goals:

- Successfully deploy all 3 services (`VehicleRegistrationService`, `TrafficControlService` & `FineCollectionService`) to an AKS cluster.
- Successfully run the Simulation service locally that connects to your AKS-hosted services

### Step 1: Update all port numbers

By default, Dapr sidecars run on port 3500 when deployed to AKS. This means you will need to change the port numbers in the `FineCollectionService` & `TrafficControlService` class files to port 3500 for the calls to Dapr when deploying to the AKS cluster.

Look in the following files and make changes as appropriate.

- ```Resources/FineCollectionService/Proxies/VehicleRegistrationService.cs```
- ```Resources/TrafficControlService/Controllers/TrafficController.cs```

### Step 2: Update the Dapr secrets configuration file to pull secrets from Azure KeyVault in AKS

*Note: This assumes you have already downloaded the certificate PFX file from challenge 7.*

1.  Create the Kubernetes namespace for all the services to live under.

    ```shell
    kubectl create namespace dapr-trafficcontrol
    ```

1.  Set the default Kubernetes namespace for all future `kubectl` commands.

    ```shell
    kubectl config set-context --current --namespace=dapr-trafficcontrol
    ```

1.  Create a Kubernetes secret.

    ```shell
    kubectl create secret generic "<service-principal-name>" --from-file="<service-principal-name>"="<pfx-certificate-file-fully-qualified-local-path>" -n dapr-trafficcontrol
    ```

1.  Update the ```Resources/dapr/components/secrets-file.yaml``` with the Azure KeyVault configuration values. You will need to customize the **KeyVault name**, **tenant ID**, **client ID**, **resource ID**.

    ```yaml
    apiVersion: dapr.io/v1alpha1
    kind: Component
    metadata:
      name: trafficcontrol-secrets
    spec:
      type: secretstores.azure.keyvault
      version: v1
      metadata:
      - name: vaultName
        value: kv-dapr-ussc-demo
      - name: spnTenantId
        value: 72f988bf-86f1-41af-91ab-2d7cd011db47
      - name: spnClientId
        value: 1d62c4a7-287d-47ec-9e31-6c9c382ed0d2
      - name: spnCertificate
        secretKeyRef:
          name: sp-dapr-workshop-ussc-demo
          key: sp-dapr-workshop-ussc-demo
      - name: nestedSeparator
        value: "-"
    scopes:
    - finecollectionservice   
    auth:
      secretStore: kubernetes

### Step 3: Build container images for each service & upload to Azure Container Registry

You will need to build these services, create a Docker container image that has this source code baked into it and then upload to an Azure Container Registry. The easiest way to do that is to use [ACR tasks](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview).

1. 	Navigate to the `Resources/VehicleRegistrationService` directory & use the Azure Container Registry task to build your image from source.

    ```shell
    az acr build --registry <container-registry-name> --image vehicleregistrationservice:assignment08 .
    ```

1. 	Navigate to the `Resources/TrafficControlService` directory & use the Azure Container Registry task to build your image from source.

    ```shell
    az acr build --registry <container-registry-name> --image trafficcontrolservice:assignment08 .
    ```

1. 	Navigate to the `Resources/FineCollectionService` directory & use the Azure Container Registry task to build your image from source.
  
    ```shell
    az acr build --registry <container-registry-name> --image trafficcontrolservice:assignment08 .		
    ```

### Step 4: Deploy container images to Azure Kubernetes Service

Now that your container images have been uploaded to the Azure Container Registry, you can deploy these images to your Azure Kubernetes Service. Deployment spec files have been added to each service to make this easier. You will need to customize them to reference your container registry path & AKS ingress.

1.	Open the `Resources/dapr/components/fine-collection-service.yaml` file and update the container registry name to be the one you have deployed.

    ```yaml
    spec:
      containers:
      - name: finecollectionservice
        image: <container-registry-name>.azurecr.io/finecollectionservice:assignment08
    ```

1.	Modify the ingress host to match your AKS instance's HTTP application routing domain. You can query for this if you don't have it.

    ```shell
    az aks show --resource-group <resource-group-name> --name <aks-name> --query="addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName"
    ```

    ```shell
    "e13e6fb6d2534a41ae60.southcentralus.aksapp.io"
    ```

    ```yaml
    spec:
    rules:
    - host: finecollectionservice.<aks-http-application-routing-zone-name>
    ```
    
1.  Repeat these steps for the `TrafficControlService` and the `VehicleRegistrationService`.

1.  Grant your AKS instance access to pull images from your Azure Container Registry.

    Create a Kubernetes **secret** to store the credentials in. Update the `<container-registry-name>` and `<container-registry-password>`. You can find this in the output from the Azure Bicep deployment `containerRegistryAdminPassword` or by running the following code.

    ```shell
    az acr credential show -n <container-registry-name>
    ```

    ```shell
    kubectl create secret docker-registry dapr-acr-pull-secret \
      --namespace dapr-trafficcontrol \
      --docker-server=<container-registry-name>.azurecr.io \
      --docker-username=<container-registry-name> \
      --docker-password=<service-principal-password>
    ```

    *IMPORTANT: The Azure Container Registry has the **admin** account enabled to make this demo easier to deploy (doesn't require the deployer to have Owner access to the subscription or resource group the Azure resources are deployed to). **This is not a best practice!** In a production deployment, use a managed identity or service principal to authenticate between the AKS cluster & the ACR. See the [documentation](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-authentication?tabs=azure-cli) for more about the options and how to set up.*

1. 	Deploy your new services to AKS. Navigate to the `Resources/dapr/components` directory and run the following:

    ```shell
    cd Resources/dapr/components
    kubectl apply -k .
    ```

1.	Verify your services are running (it may take a little while for all the services to finish starting up). Make sure the **READY** status for all pods says `2/2`.

    ```shell
    kubectl get pods
    ```

    ```shell
    NAME                                           READY   STATUS    RESTARTS   AGE
    fine-collection-service-55c7bfcf64-kqfvf       2/2     Running   0          11s
    traffic-control-service-64dc9cb676-2lcbz       2/2     Running   0          11s
    vehicle-registration-service-dd6fbbbc6-qvt4p   2/2     Running   0          11s
    zipkin-f5c696fb7-ns65k                         1/1     Running   0          11s
    ```

    If you pods are not running (their status is `CrashLoopBackOff`), you will need to look into the pod logs to see what is wrong.

    Remember, there are 2 containers in each pod, the actual service container & the `daprd` container.

    Example:

    ```shell
    kubectl logs vehicle-registration-service-dd6fbbbc6-sxt4z vehicle-registration-service
    
    kubectl logs vehicle-registration-service-dd6fbbbc6-sxt4z daprd
    ```

### Step 7: Run Simulation application

Run the Simluation service, which writes to your IoT Hub's MQTT queue. You will begin to see fines get emailed to you as appropriate.

## Security note

To make this example as accesible as possible, SAS tokens and default AKS security settings are in place. In a production environment, a more secure option is to use managed identities for the various services to talk to each other in Azure (for instance, allowing Azure Kubernetes Service to pull from Azure Container Registry) & [AKS security baseline](https://github.com/mspnp/aks-fabrikam-dronedelivery).
