param containerAppEnvironmentName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param location string
#disable-next-line secure-secrets-in-params
param daprComponentSecretsName string
param daprComponentStateStoreName string
param daprComponentEntryCamInputBindingsName string
param daprComponentExitCamInputBindingsName string
param daprComponentPubSubName string
param daprComponentOutputBindingsName string
param containerAppTrafficControlServiceObject object
param containerAppFineCollectionServiceObject object
param keyVaultName string
param serviceBusNamespaceName string
param redisCacheName string
param storageAccountName string
param managedIdentityName string
param eventHubConsumerGroupName string
param eventHubNamespaceName string
param eventHubEntryCamName string
param eventHubExitCamName string
param logicAppName string
param eventHubListenAuthorizationRuleName string
param storageAccountEntryCamContainerName string
param storageAccountExitCamContainerName string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource serviceBus 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' existing = {
  name: serviceBusNamespaceName
}

resource redisCache 'Microsoft.Cache/Redis@2019-07-01' existing = {
  name: redisCacheName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' existing = {
  name: managedIdentityName
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2022-01-01-preview' existing = {
  name: eventHubNamespaceName
}

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' existing = {
  name: logicAppName
}

resource eventHubEntryCam 'Microsoft.EventHub/namespaces/eventhubs@2021-01-01-preview' existing = {
  name: '${eventHubNamespace.name}/${eventHubEntryCamName}'
}

resource eventHubExitCam 'Microsoft.EventHub/namespaces/eventhubs@2021-01-01-preview' existing = {
  name: '${eventHubNamespace.name}/${eventHubExitCamName}'
}

resource eventHubEntryCamListenAuthorizationRule 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2021-01-01-preview' existing = {
  name: '${eventHubEntryCam.name}/${eventHubListenAuthorizationRuleName}'
}

resource eventHubExitCamListenAuthorizationRule 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2021-01-01-preview' = {
  name: '${eventHubExitCam.name}/${eventHubListenAuthorizationRuleName}'
  properties: {
    rights: [
      'Listen'
      'Send'
    ]
  }
}

var serviceBusEndpoint = '${serviceBus.id}/AuthorizationRules/RootManageSharedAccessKey'

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2022-06-01-preview' = {
  name: containerAppEnvironmentName
  location: location
  sku: {
    name: 'Consumption'
  }
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }
    daprAIConnectionString: appInsights.properties.ConnectionString
    daprAIInstrumentationKey: appInsights.properties.InstrumentationKey
  }
  resource daprComponentSecrets 'daprComponents@2022-03-01' = {
    name: daprComponentSecretsName
    properties: {
      componentType: 'secretstores.azure.keyvault'
      version: 'v1'
      #disable-next-line BCP037
      secretStoreComponent: daprComponentSecretsName
      metadata: [
        {
          name: 'vaultName'
          value: keyVault.name
        }
        {
          name: 'azureClientId'
          value: managedIdentity.properties.clientId
        }
      ]
      scopes: [
        containerAppFineCollectionServiceObject.appId
      ]
    }
  }
  resource daprComponentStateStore 'daprComponents@2022-03-01' = {
    name: daprComponentStateStoreName
    properties: {
      componentType: 'state.redis'
      version: 'v1'
      metadata: [
        {
          name: 'redisHost'
          value: '${redisCache.properties.hostName}:6380'
        }
        {
          name: 'redisPassword'
          value: redisCache.listKeys().primaryKey
        }
        {
          name: 'enableTLS'
          value: 'true'
        }
      ]
    }
  }
  resource daprComponentEntryCamInputBindings 'daprComponents@2022-03-01' = {
    name: daprComponentEntryCamInputBindingsName
    properties: {
      componentType: 'bindings.azure.eventhubs'
      version: 'v1'
      metadata: [
        {
          name: 'connectionString'
          value: listKeys(eventHubEntryCamListenAuthorizationRule.id, eventHubEntryCamListenAuthorizationRule.apiVersion).primaryConnectionString
        }
        {
          name: 'consumerGroup'
          value: eventHubConsumerGroupName
        }
        {
          name: 'storageAccountName'
          value: storageAccount.name
        }
        {
          name: 'storageAccountKey'
          value: storageAccount.listKeys().keys[0].value
        }
        {
          name: 'storageContainerName'
          value: storageAccountEntryCamContainerName
        }
      ]
      scopes: [
        containerAppTrafficControlServiceObject.appId
      ]
    }
  }
  resource daprComponentExitCamInputBindings 'daprComponents@2022-03-01' = {
    name: daprComponentExitCamInputBindingsName
    properties: {
      componentType: 'bindings.azure.eventhubs'
      version: 'v1'
      metadata: [
        {
          name: 'connectionString'
          value: listKeys(eventHubExitCamListenAuthorizationRule.id, eventHubEntryCamListenAuthorizationRule.apiVersion).primaryConnectionString
        }
        {
          name: 'consumerGroup'
          value: eventHubConsumerGroupName
        }
        {
          name: 'storageAccountName'
          value: storageAccount.name
        }
        {
          name: 'storageAccountKey'
          value: storageAccount.listKeys().keys[0].value
        }
        {
          name: 'storageContainerName'
          value: storageAccountExitCamContainerName
        }
      ]
      scopes: [
        containerAppTrafficControlServiceObject.appId
      ]
    }
  }
  resource daprComponentPubSub 'daprComponents@2022-03-01' = {
    name: daprComponentPubSubName
    properties: {
      componentType: 'pubsub.azure.servicebus'
      version: 'v1'
      metadata: [
        {
          name: 'connectionString'
          value: 'Endpoint=sb://${serviceBus.name}.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=${listKeys(serviceBusEndpoint, serviceBus.apiVersion).primaryKey}'
        }
      ]
      scopes: [
        containerAppFineCollectionServiceObject.appId
        containerAppTrafficControlServiceObject.appId
      ]
    }
  }
  resource daprComponentOutputBindings 'daprComponents@2022-03-01' = {
    name: daprComponentOutputBindingsName
    properties: {
      componentType: 'bindings.http'
      version: 'v1'
      metadata: [
        {
          name: 'url'
          value: logicApp.listCallbackUrl().value
        }
      ]
      scopes: [
        containerAppFineCollectionServiceObject.appId
      ]
    }
  }
}

output containerAppEnvironmentName string = containerAppEnvironment.name
