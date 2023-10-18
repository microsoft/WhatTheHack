# Challenge 0: Install local tools and Azure prerequisites

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Description

In this challenge, you'll do the following:

- Create Azure resources required.
  - Resource provisioning can take up to **25 minutes**, depending on the region used. Once you launch the script to create the Azure resources, review the application architecture & description with your coach.
- Review TrafficControl application architecture.

Your coach will provide you with a `Resources.zip` package file that contains the starting projects for this hack. It contains a version of the services that use plain HTTP communication and store state in memory. With each challenge, you'll add a Dapr building block to enhance the application architecture.

### Install local prerequisites

Your coach will have indicated which tools you need to install locally.

- Git ([download](https://git-scm.com/))
- .NET 6 SDK ([download](https://dotnet.microsoft.com/download/dotnet/6.0))
- Visual Studio Code ([download](https://code.visualstudio.com/download)) with the following extensions installed:
  - [C#](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp)
  - [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)
- Docker for desktop ([download](https://www.docker.com/products/docker-desktop))
- Dapr CLI and Dapr runtime ([instructions](https://docs.dapr.io/getting-started/install-dapr-selfhost/))
- Install Azure CLI
  - Linux ([instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt))
  - macOS ([instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos))
  - Windows ([instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli))
- Install Bicep extension for VS Code ([instructions](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep))
- If you're running Windows, you'll need to install a **bash shell** to run some of the commands. Install either the [Git Bash](https://git-scm.com/downloads) client or the [Windows Subsystem for Linux 2](https://docs.microsoft.com/en-us/windows/wsl/install-win10).
- Helm ([instructions](https://helm.sh/docs/intro/install/))

Make sure the following minimum software versions are installed by executing the commands in the following table:

| Software             | Version | Command Line       |
| -------------------- | ------- | ------------------ |
| Dapr runtime version | v1.8.4  | `dapr --version`   |
| Dapr CLI version     | v1.2.0  | `dapr --version`   |
| DotNet version       | 6.0.0   | `dotnet --version` |
| azure-cli            | 2.42.0  | `az --version`     |

### Deployment

This hack's setup files will create the following resources in your Azure Resource Group. Make sure you can create the following:

- Application Insights
- Azure Cache for Redis
- Azure Container Registry
- Azure Kubernetes Service (or Azure Container Apps)
- Event Hub Namespace
- IoT Hub
- Key Vault
- Log Analytics Workspace
- Logic App (with the Office 365 activity for sending email)
- Storage Account
- Service Bus Namespace

_If you can't instantiate some of these resources, you won't be able to complete the part of the challenge that uses them, but you may still be able to complete the other challenges_

### Deployment

- AKS requires the ability to create a public IP address. This may be blocked by some organizations. You will either need to get an exception or have an admin create the AKS cluster for you.
- The `Resources\Infrastructure\bicep\aks.bicep` file specifies the default values for the cluster that will work for this hack. Customize as needed.
  - 1 Agent Pool with 3 Linux VMs using the **Standard_DS2_v2** SKU.
  - 3 services using a total of `300m` of CPU & `300Mi` of memory by default, limited to a total of `3000m` of CPU & `600Mi` of memory.
  - 1 Zipkin service running to monitor communication between the services.
- **WARNING:** For simplicity, a Kubernetes secret is used to allow AKS to pull images from the Azure Container Registry via the [admin account](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-authentication?tabs=azure-cli#admin-account). **This is not a best practice**. In a production example, you should use a managed identity & RBAC.

**IMPORTANT:** You will need to register the AKS Workload Identity extension feature flags in your Azure subscription. Follow the instructions at the links provided below.

1.  [Install the AKS Preview Azure CLI Extension](https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster#install-the-aks-preview-azure-cli-extension)
1.  [Register the `enableworkloadidentitypreview` feature flag](https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster#register-the-enableworkloadidentitypreview-feature-flag)
1.  [Register the `enabledoidcissuepreview` feature flag](https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster#register-the-enableoidcissuerpreview-feature-flag)

### Deployment

To start, you'll need access to an Azure Subscription & Resource Group:

- If you don't have one, [Sign Up for an Azure account](https://azure.microsoft.com/en-us/free/).
  - You will need the following subscription [resource providers](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types) registered.
    - `Microsoft.App`
    - `Microsoft.Cache`
    - `Microsoft.ContainerService`
    - `Microsoft.ContainerRegistry`
    - `Microsoft.Devices`
    - `Microsoft.EventHub`
    - `Microsoft.Insights`
    - `Microsoft.KeyVault`
    - `Microsoft.KubernetesConfiguration`
    - `Microsoft.Logic`
    - `Microsoft.OperationalInsights`
    - `Microsoft.OperationsManagement`
    - `Microsoft.ServiceBus`
    - `Microsoft.Storage`
    - `Microsoft.Web`
- If you already have an Azure account, make sure you have at least [Owner access instructions](https://docs.microsoft.com/azure/role-based-access-control/check-access)) for the resource group in which you'll provision Azure resources.

_Your IT organization may provide you access to an Azure resource group, but not the entire subscription. If that's the case, take note of that resource group name and make sure you have `Owner` access to it, using the instructions mentioned above._

# Next, you'll create the Azure resources for the subsequent challenges using [Azure Bicep](https://docs.microsoft.com/azure/azure-resource-manager/bicep/overview) and the [Azure CLI](https://docs.microsoft.com/cli/azure/what-is-azure-cli).

1.  Login to Azure Portal and create a Resource Group. Create the Resource Group in an Azure region that can support AKS version 1.26.0 & a VM size of `Standard_B4ms` (such as South Central US or Central US).

1.  If you're using [Azure Cloud Shell](https://shell.azure.com), skip this step and proceed to step 2. Open the [terminal window](https://code.visualstudio.com/docs/editor/integrated-terminal) in VS Code and make sure you're logged in to Azure

    ```shell
    az login
    ```

1.  _Optional_: Make sure you have selected the Azure subscription in which you want to work. Replace the 'x's with your subscription GUID or subscription name. The subscription GUID can be found in the Azure Resource Group blade from the Azure Portal.

    ```shell
    az account set --subscription "xxxx-xxxx-xxxx-xxxx"
    ```

1.  Install the `aks-preview` extension.

    ```shell
    az extension add --name aks-preview
    ```

    > **Note**: If you have previously installed the `aks-preview` extension, please update it.

    ```shell
    az extension update --name aks-preview
    ```

1.  Install the `k8s-extension`.

    ```shell
    az extension add --name k8s-extension
    ```

    > **Note**: If you have previously installed the `k8s-extension`, please update it.

    ```shell
    az extension update --name k8s-extension
    ```

1.  Enable the `Workload Identity Preview` feature.

    Register the feature:

    ```shell
    az feature register --namespace "Microsoft.ContainerService" --name "EnableWorkloadIdentityPreview"
    ```

    Wait a few minutes and verify its registered.

    ```shell
    az feature show --namespace "Microsoft.ContainerService" --name "EnableWorkloadIdentityPreview"
    ```

    Refresh the registration.

    ```shell
    az provider register --namespace Microsoft.ContainerService
    ```

1.  Enabled the `AKS Extension Manager` feature.

    ```shell
    az feature register --namespace "Microsoft.ContainerService" --name "AKS-ExtensionManager"
    ```

    Wait a few minutes and verify its registered.

    ```shell
    az feature show --namespace "Microsoft.ContainerService" --name "AKS-ExtensionManager"
    ```

    Refresh the registration.

    ```shell
    az provider register --namespace Microsoft.ContainerService
    ```

1.  Enable the `Dapr` Feature.

    ```shell
    az feature register --namespace "Microsoft.ContainerService" --name "AKS-Dapr"
    ```

    Wait a few minutes and verify its registered.

    ```shell
    az feature show --namespace "Microsoft.ContainerService" --name "AKS-Dapr"
    ```

    Refresh the registrations.

    ```shell
    az provider register --namespace Microsoft.ContainerService

    az provider register --namespace Microsoft.KubernetesConfiguration
    ```

1.  _Optional_: The following steps assume you already have a resource group created. If not, run the following command to create one. Replace the resource group name and location with your own values.

    ```shell
    az group create --name <resource-group-name> --location <location>
    ```

1.  _Optional_: You can run the following PowerShell script to evaluate if you have installed all the prerequisites.

    ```shell
    ./Resources/Infrastructure/setup.ps1
    ```

1.  In the accompanying source code, modify the `Resources/Infrastructure/bicep/env/main.parameters.json` file so it is _unique to you_ (each person will get their own copy of each Azure resource). You can modify the app name, region & environment as you see fit. These will be concatenated together to generate the names of the Azure resources. Try to keep the name short, as certain Azure resources (like Key Vault) have name limits.

        ```json
        {
          "appName": {
            "value": "dapr<your-initials><3-random-numbers>"
          },
          "region": {
            "value": "ussc"
          },
          "environment": {
            "value": "dev"
          }
        }
        ```

1.  You'll now create the required Azure resources inside your resource group with the following Azure CLI command (replace the resource group name).

        **If you are going to deploy to Azure Kubernetes Service (AKS).**

        ```shell
        cd Resources/Infrastructure/bicep

        az deployment group create --resource-group <resource-group-name> --template-file ./main.bicep --parameters ./env/main.parameters.json --query "properties.outputs" --output yamlc
        ```

        **If you are going to deploy to Azure Container Apps (ACA) service.**

        ```shell
        az deployment group create --resource-group <resource-group-name> --template-file ./main.bicep --parameters ./env/main.parameters.json --query "properties.outputs" --output yamlc --parameters shouldDeployToContainerApps=true
        ```

        _Creating the resources can take some time (>20 minutes). You're encouraged to jump to review the [TrafficControl app architecture](./Resources/README.md) while the command executes._

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
          value: **_REMOVED_**
        storageAccountName:
          type: String
          value: sadaprmce123
        ```

        Copy these values into a text editor. You'll need them to configure your Dapr services.

1.  Assign permissions to KeyVault

    Assign yourself access to the KeyVault so you can create secrets:

    ```shell
    az keyvault set-policy --resource-group "<resource-group-name>" --name "<key-vault-name>" --upn "dwight.k.schrute@dunder-mifflin.com" --secret-permissions get list set delete --certificate-permissions get list create delete update
    ```

1.  Run the following command to initialize your local Dapr environment:

    ```shell
    dapr init
    ```

#### Additional instructions for Azure Kubernetes Service (AKS), skip these if using Azure Container Apps (ACA)

1.  Run the following command to fetch the AKS credentials for your cluster.

    ```shell
    az aks get-credentials --name <aks-name> --resource-group <resource-group-name>
    ```

    _The `az aks get-credentials` command retrieves credentials for an AKS cluster. It merges the credentials into your local kubeconfig file._

1.  Verify your "target" cluster is set correctly.

    ```shell
    kubectl config get-contexts
    ```

    Make sure that you see a listing for `aks-dapr-<your value>` and that it has a star next to it as shown below:

    ```shell
    CURRENT  NAME                   CLUSTER                AUTHINFO                                               NAMESPACE
    *        aks-dapr-<your value>  aks-dapr-<your value>  clusterUser_rg-dapr-<your value>_aks-dapr-<your value> default
    ```

1.  Create the `dapr-trafficcontrol` Kubernetes namespace

    You will need to create a namespace to own all of the TrafficControl Kubernetes objects.

    ```shell
    kubectl create namespace dapr-trafficcontrol
    ```

1.  Change your local `kubectl` context to the `dapr-trafficcontrol` namespace so all resources are created in that namespace.

    ```shell
    kubectl config set-context --current --namespace=dapr-trafficcontrol
    ```

1.  Assign permissions to Key Vault

    Assign yourself access to the Key Vault so you can create secrets:

    ```shell
    az ad signed-in-user show --query userPrincipalName -o tsv

    az keyvault set-policy --resource-group <resource-group-name> --name <key-vault-name> --upn "dwight.k.schrute@dunder-mifflin.com" --secret-permissions get list set delete
    ```

1.  Update the AKS cluster with the OIDC issuer & Workload Identity feature flags.

    ```shell
    az aks update -g "<resource-group-name>" -n "<cluster-name>" --enable-oidc-issuer --enable-workload-identity
    ```

1.  Install the Dapr extension in your AKS cluster.

    ```shell
    az k8s-extension create --cluster-type managedClusters --cluster-name <aks-name> --resource-group <resource-group-name> --name dapr --extension-type Microsoft.Dapr
    ```

1.  Shut down your AKS cluster to save money until we need it for Assignment 8

    ```shell
    az aks stop --name <aks-name> --resource-group <resource-group-name>
    ```

### Review TrafficControl application architecture

Spend some time with your teammates reviewing the TrafficControl application architecture & services.

The TrafficControl application architecture consists of four microservices:

![Services](../images/services.png)

- The **Camera Simulation** is a .NET Core console application that will simulate passing cars.
- The **Traffic Control Service** is an ASP.NET Core WebAPI application that offers entry and exit endpoints: `/entrycam` and `/exitcam`.
- The **Fine Collection Service** is an ASP.NET Core WebAPI application that offers 1 endpoint: `/collectfine` for collecting fines.
- The **Vehicle Registration Service** is an ASP.NET Core WebAPI application that offers 1 endpoint: `/getvehicleinfo/{license-number}` for retrieving vehicle and owner information of a vehicle.

These services compose together to simulate a traffic control scenario.

[TrafficControl Application & Services Description](./Resources/README.md)

## Success Criteria

- Verify all local prerequisite tools are installed locally.
- Verify all Azure resources have been successfully created.
- Verify your understanding of the TrafficControl application architecture with your coach.
