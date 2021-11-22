# Challenge 0: Install tools and Azure pre-requisites

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

In this assignment, you'll install the pre-requisites tools and software as well as create the Azure resources required for the workshop.

> [!NOTE]
> Resource provisioning can take up to 25 minutes, depending on the region used. Once you launch the script to create the Azure resources, you can move on to Assignment 1 while the resources are provisioned.

## Description

### Step 1. Install pre-requisites

1.  To start, you'll need access to an Azure Subscription:

    - If you don't have one, [Sign Up for an Azure account](https://azure.microsoft.com/en-us/free/).
    - If you already have an Azure account, make sure you have at least [Contributor access instructions](https://docs.microsoft.com/azure/role-based-access-control/check-access)) for the resource group in which you'll provision Azure resources.
        
    > [!IMPORTANT]
    > Your IT organization may provide you access to an Azure resource group, but not the entire subscription. If that's the case, take note of that resource group name and make sure you have `Contributor` access to it, using the instructions mentioned above.
  
1.  Install all the pre-requisites listed below and make sure they're working correctly:

    - Git ([download](https://git-scm.com/))
    - .NET 5 SDK ([download](https://dotnet.microsoft.com/download/dotnet/5.0))
    - Visual Studio Code ([download](https://code.visualstudio.com/download)) with the following extensions installed:
      - [C#](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp)
      - [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)
    - Docker for desktop ([download](https://www.docker.com/products/docker-desktop))
    - Dapr CLI and Dapr runtime ([instructions](https://docs.dapr.io/getting-started/install-dapr-selfhost/))
    - Install Azure CLI ([instructions]())
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

Next, you'll create the Azure resources for the subsequent assignments using [Azure Bicep](https://docs.microsoft.com/azure/azure-resource-manager/bicep/overview) and the [Azure CLI](https://docs.microsoft.com/cli/azure/what-is-azure-cli).

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

1.  Create a new resource group for your lab project using the `Resources/Infrastructure/bicep/rg.bicep` script file. When invoking the command, replace the location parameter with the Azure region you want to use:

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

    > [!NOTE]
    > Creating the resources can take some time. You're encouraged to jump to the **Assignment 01** while the command executes.

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
   
    > [!NOTE]
    > The `az aks get-credentials` command retrieves credentials for an AKS cluster. It merges the credentials into your local kubeconfig file.

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
