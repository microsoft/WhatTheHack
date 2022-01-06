# Solution 01 - Provision your Integration Environment

[< Previous Solution](./Solution-00.md) - **[Home](../readme.md)** - [Next Solution>](./Solution-02.md)

## Introduction

The students should be able to create a set of Bicep files that will be used to deploy the AIS environment.  This prepares them for the second challenge where they will be asked to create a CI/CD pipeline that will call these IaC for automated deployment.


## Description
The students should be doing the following:
- Create main.bicep - The main Bicep file.  In there, you will reference the modules, define parameter values, and then pass those values as input to the modules.

- Then, create a folder entitled "module", then add several [Bicep modules](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules) as follows:

 - appInsights.bicep - Defines the Application Insights resource and should be the very first resource that need to be created. Make sure to define an [output parameter](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/outputs?tabs=azure-powershell) for the instrumentation key, which will then need to be passed as input into the Function App and APIM modules. 

    ```
    resource appInsights 'Microsoft.Insights/components@2018-05-01-preview' = {
      name: appInsightsName
      location: location
      kind: 'web'
      properties: {
        Application_Type: 'web'
        publicNetworkAccessForIngestion: 'Enabled'
        publicNetworkAccessForQuery: 'Enabled'
      }
      tags: resourceTags
    }
    ```

    See [Microsoft.Insights components](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/components?tabs=bicep) for reference


  - apim.bicep  - This contains the definition for creating the API management resource.  At a minimum, the module should have the following properties:

    ```
    resource apiManagementService 'Microsoft.ApiManagement/service@2020-12-01' = {
      name: apiManagementServiceName
      location: location
      sku: {
        name: sku
        capacity: skuCount
      }
      properties: {
        publisherEmail: publisherEmail
        publisherName: publisherName
      }
      tags: resourceTags
    }
    ```

    See [Microsoft.ApiManagement service](https://docs.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service?tabs=bicep) for reference

  - function.bicep - This contains the definition for creating the Function App resource.  At a minimum, the module should have the following properties:

    ```
    resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
      name: storageAccountName
      location: location
      tags: resourceTags
      sku: {
        name: 'Standard_LRS'
      }
      kind: 'StorageV2'
      properties: {
        supportsHttpsTrafficOnly: true
        encryption: {
          services: {
            file: {
              keyType: 'Account'
              enabled: true
            }
            blob: {
              keyType: 'Account'
              enabled: true
            }
          }
          keySource: 'Microsoft.Storage'
        }
        accessTier: 'Hot'
      }
    }

    resource plan 'Microsoft.Web/serverFarms@2020-06-01' = {
      name: appServicePlanName
      location: location
      kind: functionKind
      tags: resourceTags
      sku: {
        name: functionSku
        tier: functionTier
      }
      properties: {}
    }

    resource functionApp 'Microsoft.Web/sites@2020-06-01' = {
      name: functionAppName
      location: location
      kind: 'functionapp'
      tags: resourceTags
      properties: {
        serverFarmId: plan.id
        siteConfig: {
          appSettings: [
            {
              name: 'AzureWebJobsStorage'
              value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
            }
            {
              name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
              value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
            }
            {
              name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
              value: appInsightsInstrumentationKey
            }
            {
              name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
              value: 'InstrumentationKey=${appInsightsInstrumentationKey}'
            }
            {
              name: 'FUNCTIONS_WORKER_RUNTIME'
              value: functionRuntime
            }
            {
              name: 'FUNCTIONS_EXTENSION_VERSION'
              value: '~3'
            }
          ]
        }
        httpsOnly: true
      }
      identity: {
        type: 'SystemAssigned'
      }  
    }
    ```

    See [Microsoft.Web sites/functions](https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites/functions?tabs=bicep) for reference

 
- You can recommend the students to follow this [MS Learn Bicep tutorial](https://docs.microsoft.com/en-us/learn/modules/build-first-bicep-template/8-exercise-refactor-template-modules?pivots=cli) to guide them on how to author the files above.

- Otherwise, you can give them snippets from the completed templates which can be found at [/Solutions/Challenge-01/bicep](./Solutions/Challenge-01/bicep)

- You should run the following Azure CLI command to deploy the Bicep templates as follows:

```
az deployment group create --template-file main.bicep --parameters [enter parameter values you need to overwrite]
```

