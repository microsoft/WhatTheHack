# Deployment

## Using ACA

Clone the `BuildYourOwnCopilot` repository and change to the `main` branch

```pwsh
git clone https://github.com/Azure/BuildYourOwnCopilot
git checkout main
```

Run the following script to provision the infrastructure and deploy the API and frontend. This will provision all of the required infrastructure, deploy the API and web app services into ACA, and import data into Cosmos.

```pwsh
./scripts/Unified-Deploy.ps1 -resourceGroup <resource-group-name> `
                             -location <location> `
                             -subscription <subscription-id>
```

## Using AKS

Deployment using AKS instead of ACA requires the addition of the argument `-deployAks 1` to the command line call.

```pwsh
./scripts/Unified-Deploy.ps1 -resourceGroup <resource-group-name> `
                             -location <location> `
                             -subscription <subscription-id> `
                             -deployAks 1
```

## Deployments using an existing OpenAI service

For deployments that need to use an existing OpenAI service, run the following from the `scripts`.  This will provision all of the necessary infrastructure except the Azure OpenAI service and will deploy the API and frontend to an AKS cluster via Helm.

```pwsh
.\Unified-Deploy.ps1 -resourceGroup <resource-group-name> `
                     -location <location> `
                     -subscription <subscription-id> `
                     -openAiName <openAi-service-name> `
                     -openAiRg <openAi-resource-group-name> `
                     -openAiCompletionsDeployment <openAi-completions-deployment-name> `
                     -openAiEmbeddingsDeployment <openAi-embeddings-deployment-name>
```

## Enabling/Disabling Deployment Steps

The following flags can be used to enable/disable specific deployment steps in the `Unified-Deploy.ps1` script.

| Parameter Name | Description |
|----------------|-------------|
| `stepDeployArm` | Enables or disables the provisioning of resources in Azure via ARM templates (located in `./arm`). Valid values are 0 (Disabled) and 1 (Enabled). See the `scripts/Deploy-Arm-Azure.ps1` script.
| `stepBuildPush` | Enables or disables the build and push of Docker images to the Azure Container Registry in the target resource group. Valid values are 0 (Disabled) and 1 (Enabled). See the `scripts/BuildPush.ps1` script.
| `stepDeployCertManager` | Enables or disables the Helm deployment of a LetsEncrypt capable certificate manager to the AKS cluster. Valid values are 0 (Disabled) and 1 (Enabled). See the `scripts/DeployCertManager.ps1` script.
| `stepDeployTls` | Enables or disables the Helm deployment of the LetsEncrypt certificate request resources to the AKS cluster. Valid values are 0 (Disabled) and 1 (Enabled). See the `scripts/PublishTlsSupport.ps1` script.
| `stepDeployImages` | Enables or disables the Helm deployment of the `ChatAPI` and `UserPortal` services to the AKS cluster. Valid values are 0 (Disabled) and 1 (Enabled). See the `scripts/Deploy-Images-Aks.ps1` script.
| `stepUploadSystemPrompts` | Enables or disables the upload of OpenAI system prompt artifacts to a storage account in the target resource group. Valid values are 0 (Disabled) and 1 (Enabled). See the `scripts/UploadSystemPrompts.ps1` script.
| `stepImportData` | Enables or disables the import of data into a Cosmos account in the target resource group using the Data Migration Tool. Valid values are 0 (Disabled) and 1 (Enabled). See the `scripts/Import-Data.ps1` script.
| `stepLoginAzure` | Enables or disables interactive Azure login. If disabled, the deployment assumes that the current Azure CLI session is valid. Valid values are 0 (Disabled).

Example command:
```pwsh
cd deploy/powershell
./Unified-Deploy.ps1 -resourceGroup myRg `
                     -subscription 0000... `
                     -stepLoginAzure 0 `
                     -stepDeployArm 0 `
                     -stepBuildPush 1 `
                     -stepDeployCertManager 0 `
                     -stepDeployTls 0 `
                     -stepDeployImages 1 `
                     -stepUploadSystemPrompts 0 `
                     -stepImportData 0
```

