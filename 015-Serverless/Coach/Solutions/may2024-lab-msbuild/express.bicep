param rgName string = 'wth-serverless-test'

var location = resourceGroup().location

var resourcePrefix = 'wth-serverless'
var cosmosDbAccountName = '${resourcePrefix}-cosmosdb-${uniqueString(resourceGroup().id)}'
var storageAccountName = 'wth${uniqueString(resourceGroup().id)}'
var keyVaultName = 'wth-kv-${uniqueString(resourceGroup().id)}'
var computerVisionServiceName = '${resourcePrefix}-ocr'
var eventGridTopicName = '${resourcePrefix}-topic-${uniqueString(resourceGroup().id)}'
var funcStorageAccountName = 'func${uniqueString(resourceGroup().id)}'
var hostingPlanName = '${resourcePrefix}-hostingplan'
//var hostingPlanName2 = '${resourcePrefix}-hostingplanEvents'
var functionTollBoothApp = '${resourcePrefix}-app-${uniqueString(resourceGroup().id)}'
var functionTollBoothEvents = '${resourcePrefix}-events-${uniqueString(resourceGroup().id)}'
 
// Create an Azure Cosmos DB account 
resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2021-06-15' = {
  name: cosmosDbAccountName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
  }
}

//Create a SQL-compatible Database
resource cosmosDbSqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-06-15' = {
  name: 'LicensePlates'
  parent: cosmosDb
  properties: {
    resource: {
      id: 'LicensePlates'
    }
    options: {}
  }
}

//Create two containers in the Cosmos DB: "Processed" and "NeedsManualReview"
resource cosmosDbSqlContainerProcessed 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-06-15' = {
  name: 'Processed'
  parent: cosmosDbSqlDatabase
  properties: {
    resource: {
      id: 'Processed'
      partitionKey: {
        paths: [
          '/licensePlateText'
        ]
        kind: 'Hash'
      }
    }
    options: {}
  }
}

resource cosmosDbSqlContainerReview 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-06-15' = {
  name: 'NeedsManualReview'
  parent: cosmosDbSqlDatabase
  properties: {
    resource: {
      id: 'NeedsManualReview'
      partitionKey: {
        paths: [
          '/fileName'
        ]
        kind: 'Hash'
      }
    }
    options: {}
  }
}

// Create storage account for processing images
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

//Get the blob service from the storage account...
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  name: 'default'
  parent: storageAccount
}

//Create two containers in the storage account: 1) images & 2) export
resource imagesContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobService
  name: 'images'
}

resource exportContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobService
  name: 'export'
}

//Create an Event Grid Topic
resource eventGridTopic 'Microsoft.EventGrid/topics@2023-12-15-preview' = {
  name: eventGridTopicName
  location: location
}

//// LAB-ACTIVITY: Create a Computer Vision API Service via the Azure Portal
// resource cognitiveServices 'Microsoft.CognitiveServices/accounts@2023-10-01-preview' = {
//   name: computerVisionServiceName
//   location: location
//   kind: 'ComputerVision'
//   sku: {
//     name: 'S1'
//   }
//   properties: {
//     publicNetworkAccess: 'Enabled'
//   }
// }

@description('Specifies whether Azure Resource Manager is permitted to retrieve secrets from the Key Vault.')
param enabledForTemplateDeployment bool = true

//Create a Key Vault
// if done via the portal, set RBAC mode from the get-go, then add your ID as KV Admin role in order to read/write secrets
// Via the CLI it's easier to create secrets if the RBAC is disabled now, we'll enable RBAC later, so we avoid CLI Permission issues
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enableRbacAuthorization: true
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

//Get the keys for the resources created above so they can be added to the Key Vault
//var computerVisionApiKey = cognitiveServices.listKeys().key1
var cosmosDBAuthorizationKey = cosmosDb.listKeys().primaryMasterKey
var blobStorageConnection = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
var eventGridTopicKey = eventGridTopic.listKeys().key1
var cosmosDBConnString = cosmosDb.listConnectionStrings().connectionStrings[0].connectionString

// //Put the keys in Key Vault
// resource computerVisionSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
//   parent: keyVault
//   name: 'ComputerVisionApiKey'
//   properties: {
//     value: computerVisionApiKey
//   }
// }

resource eventGridSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'EventGridTopicKey'
  properties: {
    value: eventGridTopicKey
  }
}

resource cosmosDBSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'CosmosDBAuthorizationKey'
  properties: {
    value: cosmosDBAuthorizationKey
  }
}

resource cosmosDBConnSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'CosmosDBConnectionString'
  properties: {
    value: cosmosDBConnString
  }
}

resource blobStorageSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'BlobStorageConnection'
  properties: {
    value: blobStorageConnection
  }
}

//Create storage account for the function apps
resource funcStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: funcStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

//Add AppInsights for the functions
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'AppInsights-Serverless'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}

//Create hosting plan
resource hostingPlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: hostingPlanName
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    reserved: true
  }
}

var linuxFxVersion = 'DOTNET-ISOLATED|8.0'

//Create function app for TollBoothApp
resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
  name: functionTollBoothApp
  location: location
  kind: 'functionapp'
  identity:{
    type:'SystemAssigned'
  }
  properties:{
    serverFarmId: hostingPlan.id
    reserved: true
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${funcStorageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${funcStorageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${funcStorageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${funcStorageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionTollBoothApp)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_DOTNET_DEFAULT_VERSION'
          value: '8'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'eventGridTopicEndpoint'
          value: eventGridTopic.properties.endpoint
        }
        {
          name: 'eventGridTopicKey'
          value: '@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}secrets/eventGridTopicKey/)'
        }
        {
          name: 'cosmosDBEndPointUrl'
          value: cosmosDb.properties.documentEndpoint
        }
        {
          name: 'cosmosDBAuthorizationKey'
          value: '@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}secrets/cosmosDBAuthorizationKey/)'
        }
        {
          name: 'cosmosDBDatabaseId'
          value: 'LicensePlates'
        }
        {
          name: 'cosmosDBCollectionId'
          value: 'Processed'
        }
        {
          name: 'exportCsvContainerName'
          value: 'export'
        }
        {
          name: 'blobStorageConnection'
          value: '@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}secrets/blobStorageConnection/)'
        }
        // LAB-ACTIVITY: ADD computerVisionApiUrl and computerVisionApiKey
      ]
    }
  }
}

//Create function app for TollBoothEvents
resource functionEvents 'Microsoft.Web/sites@2023-01-01' = {
  name: functionTollBoothEvents
  location: location
  kind: 'functionapp'
  identity:{
    type:'SystemAssigned'
  }
  properties:{
    serverFarmId: hostingPlan.id
    reserved: true
    siteConfig: {
      linuxFxVersion: 'NODE|18'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${funcStorageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${funcStorageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${funcStorageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${funcStorageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionTollBoothEvents)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~18'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'cosmosDBConnectionString'
          value: '@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}secrets/cosmosDBConnectionString/)'
        }
      ]
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
    }
  }
}


//Grant permissions for the Functions to read secrets from KeyVault using RBAC
var functionAppPrincipalId = functionApp.identity.principalId
var functionEventsPrincipalId = functionEvents.identity.principalId

var roleDefinitionID = '4633458b-17de-408a-b874-0445c86b69e6' //Key Vault Secret User

var roleAssignmentKVAppName = guid(functionApp.id, roleDefinitionID, resourceGroup().id)
resource roleAssignmentKVApp 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentKVAppName
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionID)
    principalId: functionAppPrincipalId
  }
}

var roleAssignmentKVEventsName = guid(functionEvents.id, roleDefinitionID, resourceGroup().id)
resource roleAssignmentKVEvents 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentKVEventsName
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionID)
    principalId: functionEventsPrincipalId
  }
}
