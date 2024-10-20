targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param existingOpenAiInstance object

param chatAPIExists bool
@secure()
param chatAPIDefinition object
param searchExists bool
@secure()
param searchDefinition object

@description('Id of the user or app to assign application roles')
param principalId string

var deployOpenAi = empty(existingOpenAiInstance.name)
var azureOpenAiEndpoint = deployOpenAi ? openAi.outputs.endpoint : customerOpenAi.properties.endpoint
var azureOpenAi = deployOpenAi ? openAiInstance : existingOpenAiInstance
var openAiInstance = {
  name: openAi.outputs.name
  resourceGroup: rg.name
  subscriptionId: subscription().subscriptionId
}

// Tags that should be applied to all resources.
// 
// Note that 'azd-service-name' tags should be applied separately to service host resources.
// Example usage:
//   tags: union(tags, { 'azd-service-name': <service name in azure.yaml> })
var tags = {
  'azd-env-name': environmentName
}

var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

resource customerOpenAiResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing =
  if (!deployOpenAi) {
    scope: subscription(existingOpenAiInstance.subscriptionId)
    name: existingOpenAiInstance.resourceGroup
  }

resource customerOpenAi 'Microsoft.CognitiveServices/accounts@2023-05-01' existing =
  if (!deployOpenAi) {
    name: existingOpenAiInstance.name
    scope: customerOpenAiResourceGroup
  }

module monitoring './shared/monitoring.bicep' = {
  name: 'monitoring'
  params: {
    keyvaultName: keyVault.outputs.name
    location: location
    tags: tags
    logAnalyticsName: '${abbrs.operationalInsightsWorkspaces}${resourceToken}'
    applicationInsightsName: '${abbrs.insightsComponents}${resourceToken}'
  }
  scope: rg
}

module cosmos './shared/cosmosdb.bicep' = {
  name: 'cosmos'
  params: {
    capabilities: [
      {
        name: 'EnableNoSQLVectorSearch'
      }
      {
        name: 'EnableServerless'
      }
    ]
    containers: [
      {
        name: 'completions'
        partitionKeyPath: '/sessionId'
        indexingPolicy: null
        vectorEmbeddingPolicy: {}
      }
      {
        name: 'product'
        partitionKeyPath: '/categoryId'
        indexingPolicy: null
        vectorEmbeddingPolicy: {}
      }
      {
        name: 'customer'
        partitionKeyPath: '/customerId'
        indexingPolicy: null
        vectorEmbeddingPolicy: {}
      }
      {
        name: 'leases'
        partitionKeyPath: '/id'
        indexingPolicy: null
        vectorEmbeddingPolicy: {}
      }
    ]
    databaseName: 'vsai-database'
    keyvaultName: keyVault.outputs.name
    location: location
    name: '${abbrs.documentDBDatabaseAccounts}${resourceToken}'
    tags: tags
  }
  scope: rg
}

module dashboard './shared/dashboard-web.bicep' = {
  name: 'dashboard'
  params: {
    name: '${abbrs.portalDashboards}${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    location: location
    tags: tags
  }
  scope: rg
}

module registry './shared/registry.bicep' = {
  name: 'registry'
  params: {
    location: location
    tags: tags
    name: '${abbrs.containerRegistryRegistries}${resourceToken}'
  }
  scope: rg
}

module keyVault './shared/keyvault.bicep' = {
  name: 'keyvault'
  params: {
    location: location
    tags: tags
    name: '${abbrs.keyVaultVaults}${resourceToken}'
    principalId: principalId
  }
  scope: rg
}

module openAi './shared/openai.bicep' = if (deployOpenAi) {
  name: 'openai'
  params: {
    deployments: [
      {
        name: 'completions'
        sku: {
          name: 'Standard'
          capacity: 10
        }
        model: {
          name: 'gpt-4o'
          version: '2024-05-13'
        }
      }
      {
        name: 'embeddings'
        sku: {
          name: 'Standard'
          capacity: 10
        }
        model: {
          name: 'text-embedding-3-large'
          version: '1'
        }
      }
    ]
    keyvaultName: keyVault.outputs.name
    location: location
    name: '${abbrs.openAiAccounts}${resourceToken}'
    sku: 'S0'
    tags: tags
  }
  scope: rg
}

module openAiSecrets './shared/openai-secrets.bicep' = {
  name: 'openaiSecrets'
  scope: rg

  params: {
    keyvaultName: keyVault.outputs.name
    openAiInstance: azureOpenAi
    tags: tags
  }
}

module storage './shared/storage.bicep' = {
  name: 'storage'
  params: {
    containers: [
      {
        name: 'system-prompt'
      }
      {
        name: 'memory-source'
      }
      {
        name: 'product-policy'
      }
    ]
    files: []
    keyvaultName: keyVault.outputs.name
    location: location
    name: '${abbrs.storageStorageAccounts}${resourceToken}'
    tags: tags
  }
  scope: rg
}

module appsEnv './shared/apps-env.bicep' = {
  name: 'apps-env'
  params: {
    name: '${abbrs.appManagedEnvironments}${resourceToken}'
    location: location
    tags: tags
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    logAnalyticsWorkspaceName: monitoring.outputs.logAnalyticsWorkspaceName
  }
  scope: rg
}

module chatAPI './app/ChatAPI.bicep' = {
  name: 'ChatAPI'
  params: {
    name: '${abbrs.appContainerApps}chatservicew-${resourceToken}'
    location: location
    tags: tags
    cosmosDbAccountName: cosmos.outputs.name
    storageAccountName: storage.outputs.name
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}chatservicew-${resourceToken}'
    keyvaultName: keyVault.outputs.name
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: chatAPIExists
    appDefinition: chatAPIDefinition
    envSettings: [
      {
        name: 'MSCosmosDBOpenAI__CosmosDBVectorStore__Endpoint'
        value: cosmos.outputs.endpoint
      }
      {
        name: 'MSCosmosDBOpenAI__OpenAI__Endpoint'
        value: azureOpenAiEndpoint
      }
      {
        name: 'MSCosmosDBOpenAI__CosmosDB__Endpoint'
        value: cosmos.outputs.endpoint
      }
    ]
    secretSettings: [
      {
        name: 'ApplicationInsights__ConnectionString'
        value: monitoring.outputs.applicationInsightsConnectionSecretRef
        secretRef: monitoring.outputs.applicationInsightsConnectionSecretName
      }
      {
        name: 'MSCosmosDBOpenAI__BlobStorageMemorySource__ConfigBlobStorageConnection'
        value: storage.outputs.connectionSecretRef
        secretRef: storage.outputs.connectionSecretName
      }
      {
        name: 'MSCosmosDBOpenAI__CosmosDB__Key'
        value: cosmos.outputs.keySecretRef
        secretRef: cosmos.outputs.keySecretName
      }
      {
        name: 'MSCosmosDBOpenAI__CosmosDBVectorStore__Key'
        value: cosmos.outputs.keySecretRef
        secretRef: cosmos.outputs.keySecretName
      }
      {
        name: 'MSCosmosDBOpenAI__DurableSystemPrompt__BlobStorageConnection'
        value: storage.outputs.connectionSecretRef
        secretRef: storage.outputs.connectionSecretName
      }
      {
        name: 'MSCosmosDBOpenAI__OpenAI__Key'
        value: openAiSecrets.outputs.keySecretRef
        secretRef: openAiSecrets.outputs.keySecretName
      }
    ]
  }
  scope: rg
  dependsOn: [ cosmos, monitoring, openAi, storage ]
}

module search './app/UserPortal.bicep' = {
  name: 'UserPortal'
  params: {
    apiUri: chatAPI.outputs.uri
    name: '${abbrs.appContainerApps}search-${resourceToken}'
    location: location
    tags: tags
    keyvaultName: keyVault.outputs.name
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}search-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: searchExists
    appDefinition: searchDefinition
    envSettings: [
      {
        name: 'MSCosmosDBOpenAI__ChatManager__APIRoutePrefix'
        value: ''
      }
      {
        name: 'MSCosmosDBOpenAI__ChatManager__APIUrl'
        value: chatAPI.outputs.uri
      }
    ]
    secretSettings: [
      {
        name: 'ApplicationInsights__ConnectionString'
        value: monitoring.outputs.applicationInsightsConnectionSecretRef
        secretRef: monitoring.outputs.applicationInsightsConnectionSecretName
      }
    ]
  }
  scope: rg
  dependsOn: [ chatAPI, monitoring ]
}

output AZURE_CONTAINER_REGISTRY_ENDPOINT string = registry.outputs.loginServer
output AZURE_COSMOS_DB_NAME string = cosmos.outputs.name
output AZURE_COSMOS_DB_VEC_NAME string = cosmos.outputs.name
output AZURE_KEY_VAULT_NAME string = keyVault.outputs.name
output AZURE_KEY_VAULT_ENDPOINT string = keyVault.outputs.endpoint
output AZURE_STORAGE_ACCOUNT_NAME string = storage.outputs.name

output SERVICE_CHATAPI_ENDPOINT_URL string = chatAPI.outputs.uri
