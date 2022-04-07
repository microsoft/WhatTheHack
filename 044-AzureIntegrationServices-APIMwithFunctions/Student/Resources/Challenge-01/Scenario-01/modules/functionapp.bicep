param location string 
param functionRuntime string = 'dotnet'
param functionSku string = 'Y1'
param storageAccountName string 
param functionAppName string 
param appServicePlanName string 
param appInsightsInstrumentationKey string



var functionTier = functionSku == 'Y1' ? 'Dynamic' : 'ElasticPremium'
var functionKind = functionSku == 'Y1' ? 'functionapp' : 'elastic'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
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

resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
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

resource plan 'Microsoft.Web/serverFarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  kind: functionKind
  sku: {
    name: functionSku
    tier: functionTier
    size: functionSku
    family: functionSku
    capacity: 0
  }
  properties: {}
}

// resource httpTrigger1Resource 'Microsoft.Web/sites/functions@2021-02-01' = {
//   parent: functionApp
//   name: 'HttpTrigger1'
//   properties: {
//     script_root_path_href: 'https://${functionAppName}.azurewebsites.net/admin/vfs/site/wwwroot/HttpTrigger1/'
//     script_href: 'https://${functionAppName}.azurewebsites.net/admin/vfs/site/wwwroot/HttpTrigger1/run.csx'
//     config_href: 'https://${functionAppName}.azurewebsites.net/admin/vfs/site/wwwroot/HttpTrigger1/function.json'
//     test_data_href: 'https://${functionAppName}.azurewebsites.net/admin/vfs/data/Functions/sampledata/HttpTrigger1.dat'
//     href: 'https://${functionAppName}.azurewebsites.net/admin/functions/HttpTrigger1'
//     config: {}
//     test_data: '{"method":"get","queryStringParams":[{"name":"name","value":"Noemi"}],"headers":[],"body":{"body":""}}'
//     invoke_url_template: 'https://${functionAppName}.azurewebsites.net/api/sayhello'
//     language: 'CSharp'
//     isDisabled: false
//   }
// }

output functionAppName string = functionApp.name
