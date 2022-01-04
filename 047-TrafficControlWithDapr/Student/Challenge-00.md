# Challenge 0: Install tools and Azure pre-requisites

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

In this challenge, you'll install the pre-requisites tools and software as well as create the Azure resources required.

*Resource provisioning can take up to **25 minutes**, depending on the region used. Once you launch the script to create the Azure resources, you can move on to challenge 1 while the resources are provisioned.*

## Azure resources

This WhatTheHack will create the following Azure resources in your Azure resource group. Make sure you can create the following:

- Application Insights
- Azure Kubernetes Service
- Azure Container Registry
- Event Hub Namespace
- IoT Hub
- KeyVault
- Log Analytics Workspace
- Logic App
- Azure Cache for Redis
- Storage Account
- Service Bus Namespace

## Description

### Architecture

The traffic-control application architecture consists of four microservices:

![Services](../images/services.png)

- The **Camera Simulation** is a .NET Core console application that will simulate passing cars.
- The **Traffic Control Service** is an ASP.NET Core WebAPI application that offers entry and exit endpoints: `/entrycam` and `/exitcam`.
- The **Fine Collection Service** is an ASP.NET Core WebAPI application that offers 1 endpoint: `/collectfine` for collecting fines.
- The **Vehicle Registration Service** is an ASP.NET Core WebAPI application that offers 1 endpoint: `/getvehicleinfo/{license-number}` for retrieving vehicle and owner information of a vehicle.

These services compose together to simulate a traffic control scenario.

The following sequence diagram describes how the application works:

<img src="../images/sequence.png" alt="Sequence diagram" style="zoom:67%;" />

1. The Camera `Simulation` generates a random license plate number and sends a *VehicleRegistered* message (containing this license plate number, a random entry-lane (1-3) and the timestamp) to the `/entrycam` endpoint of the `TrafficControlService`.
1. The `TrafficControlService` stores the *VehicleState* (license plate number and entry-timestamp).
1. After a random interval, the Camera `Simulation` sends a follow-up *VehicleRegistered* message to the `/exitcam` endpoint of the `TrafficControlService`. It contains the license plate number generated in step 1, a random exit-lane (1-3), and the exit timestamp.
1. The `TrafficControlService` retrieves the previously-stored *VehicleState*.
1. The `TrafficControlService` calculates the average speed of the vehicle using the entry and exit timestamp. It also stores the *VehicleState* with the exit timestamp for audit purposes, which is left out of the sequence diagram for clarity.
1. If the average speed is above the speed-limit, the `TrafficControlService` calls the `/collectfine` endpoint of the `FineCollectionService`. The request payload will be a *SpeedingViolation* containing the license plate number of the vehicle, the identifier of the road, the speeding-violation in KMh, and the timestamp of the violation.
1. The `FineCollectionService` calculates the fine for the speeding-violation.
1. The `FineCollectionService` calls the `/vehicleinfo/{license-number}` endpoint of the `VehicleRegistrationService` with the license plate number of the speeding vehicle to retrieve vehicle and owner information.
1. The `FineCollectionService` sends a fine notice to the owner of the vehicle by email.

All actions described in the previous sequence are logged to the console during execution so you can follow the flow.

The `Resources` folder contains the starting projects for the WhatTheHack. It contains a version of the services that use plain HTTP communication and store state in memory. With each challenge, you'll add a Dapr building block to enhance this application architecture.

*It's important to understand that all calls between services are direct, synchronous HTTP calls using the HttpClient library in .NET Core. While sometimes necessary, this type of synchronous communication [isn't considered a best practice](https://docs.microsoft.com/dotnet/architecture/cloud-native/service-to-service-communication#requestresponse-messaging) for distributed microservice applications. When possible, you should consider decoupling microservices using asynchronous messaging. However, decoupling communication can dramatically increase the architectural and operational complexity of an application. You'll soon see how Dapr reduces the inherent complexity of distributed microservice applications.*

### End-state with Dapr applied

As you complete the challenges, you'll evolve the application architecture to work with Dapr and consume Azure-based backing services:

- Azure IoT Hub
- Azure Redis Cache
- Azure Service Bus
- Azure Logic Apps
- Azure Key Vault

The following diagram shows the end-state of the application:

<img src="../images/dapr-setup.png" alt="Dapr setup" style="zoom:67%;" />

1. To retrieve driver information using synchronous request/response communication between the `FineCollectionService` and `VehicleRegistrationService`, you'll implement the Dapr **service invocation** building block.
1. To send speeding violations to the `FineCollectionService`, you'll implement the Dapr **publish and subscribe** building block (asynchronous communication) with the Dapr Azure Service Bus component.
1. To store vehicle state, you'll implement the Dapr **state management** building block with the Dapr Azure Redis Cache component.
1. To send fine notices to the owner of a speeding vehicle by email, you'll implement the HTTP **output binding** building block with the Dapr Azure Logic App component.
1. To send vehicle info to the `TrafficControlService`, you'll use the Dapr **input binding** for MQTT using Dapr Azure IoT Hub component as the MQTT broker.
1. To retrieve a license key for the fine calculator component and credentials for connecting to the SMTP server, you'll implement the Dapr **secrets management** building block with Dapr Azure Key Vault component.

The following sequence diagram shows how the solution will work after implementing Dapr:

<img src="../images/sequence-dapr.png" alt="Sequence diagram with Dapr" style="zoom:67%;" />

*It's helpful to refer back to the preceding sequence diagram as you progress through the challenges.*

### Prevent port collisions

For most of the challenges, you'll run the microservices in the solution on your local machine. To prevent port collisions, all services will listen on a different HTTP port. When running with Dapr, you need additional ports for HTTP and gRPC communication between the sidecar services. By default, these ports are `3500` and `50001`. However, you'll use different port numbers for each service to prevent collisions. Please closely follow the instructions so that your microservices use the following ports for their Dapr sidecars:

| Service                    | Application Port | Dapr sidecar HTTP port | Dapr sidecar gRPC port |
| -------------------------- | ---------------- | ---------------------- | ---------------------- |
| TrafficControlService      | 6000             | 3600                   | 60000                  |
| FineCollectionService      | 6001             | 3601                   | 60001                  |
| VehicleRegistrationService | 6002             | 3602                   | 60002                  |

Use the ports specified in the preceding table *whether* using the DIY or step-by-step approach.

You'll specify the ports from the command-line when starting a service with the Dapr CLI using the following command-line arguments:

- `--app-port`
- `--dapr-http-port`
- `--dapr-grpc-port`

### Step 1. Install pre-requisites

1.  To start, you'll need access to an Azure Subscription:

    - If you don't have one, [Sign Up for an Azure account](https://azure.microsoft.com/en-us/free/).
    - If you already have an Azure account, make sure you have at least [Contributor access instructions](https://docs.microsoft.com/azure/role-based-access-control/check-access)) for the resource group in which you'll provision Azure resources.
        
    *Your IT organization may provide you access to an Azure resource group, but not the entire subscription. If that's the case, take note of that resource group name and make sure you have `Contributor` access to it, using the instructions mentioned above.*
  
1.  Install all the pre-requisites listed below and make sure they're working correctly:

    - Git ([download](https://git-scm.com/))
    - .NET 5 SDK ([download](https://dotnet.microsoft.com/download/dotnet/5.0))
    - Visual Studio Code ([download](https://code.visualstudio.com/download)) with the following extensions installed:
      - [C#](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp)
      - [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)
    - Docker for desktop ([download](https://www.docker.com/products/docker-desktop))
    - Dapr CLI and Dapr runtime ([instructions](https://docs.dapr.io/getting-started/install-dapr-selfhost/))
    - Install Azure CLI
      - Linux ([instructions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#linux))
      - macOS ([instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos))
      - Windows ([instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli))
    - Install Bicep extension for VS Code ([instructions](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep))   
    - If you're running Windows, you'll need to install a **bash shell** to run some of the commands. Install either the [Git Bash](https://git-scm.com/downloads) client or the [Windows Subsystem for Linux 2](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

    Make sure the following minimum software versions are installed by executing the commands in the following table:

    | Software             | Version | Command Line       |
    | -------------------- | ------- | ------------------ |
    | Dapr runtime version | v1.2.2  | ```dapr --version```   |
    | Dapr CLI version     | v1.2.0  | ```dapr --version```   |
    | DotNet version       | 5.0.302 | ```dotnet --version``` |
    | azure-cli            | 2.24.0  | ```az --version```     |

### Step 2. Create Azure Resources

Next, you'll create the Azure resources for the subsequent challenges using [Azure Bicep](https://docs.microsoft.com/azure/azure-resource-manager/bicep/overview) and the [Azure CLI](https://docs.microsoft.com/cli/azure/what-is-azure-cli).

1.  If you're using [Azure Cloud Shell](https://shell.azure.com), skip this step and proceed to step 2. Open the [terminal window](https://code.visualstudio.com/docs/editor/integrated-terminal) in VS Code and make sure you're logged in to Azure

    ```shell
    az login
    ```

1.  Make sure you have selected the Azure subscription in which you want to work. Replace the 'x's with your subscription GUID or subscription name. The subscription GUID can be found in the Azure Resource Group blade from the Azure Portal.

    ```shell
    az account set --subscription "xxxx-xxxx-xxxx-xxxx"
    ```

1.  Generate an [SSH key pair](https://docs.microsoft.com/azure/virtual-machines/linux/ssh-from-windows#overview-of-ssh-and-keys) if you don't already have one.

    ```shell
    ssh-keygen -t rsa -b 2048
    ```
    - If prompted for a file name, leave the entry blank, and press enter.
    - If prompted for a passphrase, leave the entry blank, and press enter.
   
    Once complete, you'll find two SSH key files in the following directory: `%USERPROFILE%\.ssh`. Right-click on the `id_rsa` file and open with Notepad. Copy the entire contents of the file which is the public key. You'll need it to configure the parameter file in an upcoming step.

1.  In the accompanying source code, modify the `Resources/Infrastructure/bicep/main.parameters.json` file so it contains the proper data for the deployment:

    ```json
    {
      "appName": {
         "value": "dapr"
      },
      "region": {
         "value": "southcentralus"
      },
      "environment": {
         "value": "youruniqueid123"
      },
      "adminUserName": {
         "value": "adminbruce"
      },
      "publicSSHKey": {
         "value": "ssh-rsa AAAAB...wnBTn bruce.wayne@<your computer name>"        
      }
    }
    ```

1.  Create a new resource group for your WhatTheHack using the `Resources/Infrastructure/bicep/rg.bicep` script file. When invoking the command, replace the location parameter with the Azure region you want to use:

    ```shell
    cd ./Resources/Infrastructure/bicep/
    az deployment sub create --location "<resource-group-location>" --template-file rg.bicep --parameters ./main.parameters.json --query "properties.outputs" --output yamlc
    ```

1.  Upon completion, the command will display the name of the newly-created resource group:

    ```yaml
    resourceGroupName:
    type: String
    value: rg-dapr-youruniqueid123
    ```

    Copy the resource group as you'll use in the next command.

1.  You'll now create the required Azure resources inside the new resource group with the following Azure CLI command.

    ```shell
    az deployment group create --resource-group "rg-dapr-youruniqueid123" --template-file main.bicep --parameters ./main.parameters.json --query "properties.outputs" --output yaml
    ```

    *Creating the resources can take some time. You're encouraged to jump to the **challenge 01** while the command executes.*

    Upon completion, the command will output information about the newly-created Azure resources:

    ```yaml
    aksFQDN:
      type: String
      value: dapr-mce123-609718f5.hcp.southcentralus.azmk8s.io
    aksName:
      type: String
      value: aks-dapr-mce123
    aksazurePortalFQDN:
      type: String
      value: dapr-mce123-609718f5.portal.hcp.southcentralus.azmk8s.io
    containerRegistryLoginServerName:
      type: String
      value: crdaprmce123.azurecr.io
    containerRegistryName:
      type: String
      value: crdaprmce123
    eventHubEntryCamName:
      type: String
      value: ehn-dapr-mce123-trafficcontrol/entrycam
    eventHubExitCamName:
      type: String
      value: ehn-dapr-mce123-trafficcontrol/exitcam
    eventHubNamespaceHostName:
      type: String
      value: https://ehn-dapr-mce123-trafficcontrol.servicebus.windows.net:443/
    eventHubNamespaceName:
      type: String
      value: ehn-dapr-mce123-trafficcontrol
    iotHubName:
      type: String
      value: iothub-dapr-mce123
    keyVaultName:
      type: String
      value: kv-dapr-mce123
    logicAppAccessEndpoint:
      type: String
      value: https://prod-29.southcentralus.logic.azure.com:443/workflows/9bd179c8dd7049b8a152e5f2608f8efc
    logicAppName:
      type: String
      value: logic-smtp-dapr-mce123
    redisCacheName:
      type: String
      value: redis-dapr-mce123
    serviceBusEndpoint:
      type: String
      value: https://sb-dapr-mce123.servicebus.windows.net:443/
    serviceBusName:
      type: String
      value: sb-dapr-mce123
    storageAccountContainerName:
      type: String
      value: trafficcontrol
    storageAccountKey:
      type: String
      value: 7Ck76nP/5kFEhNx6C...V85L+0dFMFOA/xJLIvK25f2irUmVouPRbSGXKEzRQ==
    storageAccountName:
      type: String
      value: sadaprmce123
    ```

    Copy these values into Notepad. You'll need them to configure your Dapr services.

1.  Run the following command to fetch the AKS credentials for your cluster.

    ```shell
    az aks get-credentials --name "<aks-name>" --resource-group "<resource-group-name>"
    ```
   
    *The `az aks get-credentials` command retrieves credentials for an AKS cluster. It merges the credentials into your local kubeconfig file.*

1.  Verify your "target" cluster is set correctly.

    ```shell
    kubectl config get-contexts
    ```

    Make sure that you see a listing for `aks-dapr-<your value>` and that it has a star next to it as shown below:

    ```shell
    CURRENT  NAME                   CLUSTER                AUTHINFO                                               NAMESPACE
    *        aks-dapr-<your value>  aks-dapr-<your value>  clusterUser_rg-dapr-<your value>_aks-dapr-<your value> blah-blah-blah
    ```
   
1.  Install Dapr in your AKS cluster

    Run the following command to initialize Dapr in your Kubernetes cluster using your current context.

    ```shell
    dapr init -k
    ```

    Your results should resemble the following:

    ```shell
    Making the jump to hyperspace...
    Note: To install Dapr using Helm, see here: https://docs.dapr.io/getting-started/install-dapr-kubernetes/#install-with-helm-advanced

    Deploying the Dapr control plane to your cluster...
    Success! Dapr has been installed to namespace dapr-system. To verify, run `dapr status -k' in your terminal. To get started, go here: https://aka.ms/dapr-getting-started
    ```

    Verify the Dapr deployment to your AKS cluster with the following command:

    ```shell
    dapr status -k
    ```

    Your results should resemble the following:

    ```shell
    NAME                   NAMESPACE    HEALTHY  STATUS   REPLICAS  VERSION  AGE  CREATED
    dapr-sentry            dapr-system  True     Running  1         1.2.2    1m   2021-07-02 08:45.44
    dapr-sidecar-injector  dapr-system  True     Running  1         1.2.2    1m   2021-07-02 08:45.44
    dapr-operator          dapr-system  True     Running  1         1.2.2    1m   2021-07-02 08:45.44
    dapr-dashboard         dapr-system  True     Running  1         0.6.0    1m   2021-07-02 08:45.44
    dapr-placement-server  dapr-system  True     Running  1         1.2.2    1m   2021-07-02 08:45.45
    ```

1.  Create Kubernetes secret to allow AKS to pull images from ACR

    You need to grant the AKS cluster access to your Azure Container Registry so that it can pull Docker images. 
    
    Get the credentials:

    ```shell
    az acr credential show -n "<container-registry-name>"
    ```
    
    Run the following command, substituting the username & password you got in the previous step:

    ```shell
    kubectl create secret docker-registry dapr-acr-pull-secret --namespace dapr-trafficcontrol --docker-server="<container-registry-name>".azurecr.io --docker-username="<container-registry-username>" --docker-password="<container-registry-password>"
    ```

1.  Assign permissions to KeyVault

    Lastly, assign yourself access to the KeyVault so you can create secrets:

    ```shell
    az keyvault set-policy --resource-group "<resource-group-name>" --name "<key-vault-name>" --upn "dwight.k.schrute@dunder-mifflin.com" --secret-permissions get list set delete --certificate-permissions get list create delete update
    ```
