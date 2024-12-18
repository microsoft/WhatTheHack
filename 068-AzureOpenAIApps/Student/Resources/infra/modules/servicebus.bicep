@description('Name of the Azure Service Bus.')
param name string

@description('Location where the Azure Service Bus will be created.')
param location string

@description('List of queues to create in the Azure Service Bus.')
param queues array = []

resource serviceBus 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {}
}

resource queuesToCreate 'Microsoft.ServiceBus/namespaces/queues@2021-11-01' = [for queue in queues: {
    parent: serviceBus
    name: '${queue}'
    properties: {
      lockDuration: 'PT5M'
      maxSizeInMegabytes: 1024
      requiresDuplicateDetection: false
      requiresSession: false
      defaultMessageTimeToLive: 'P14D'
      deadLetteringOnMessageExpiration: false
      duplicateDetectionHistoryTimeWindow: 'PT10M'
      maxDeliveryCount: 10
      autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
      enablePartitioning: false
      enableExpress: false
    }
}]

#disable-next-line outputs-should-not-contain-secrets
output connectionString string = listKeys('${serviceBus.id}/AuthorizationRules/RootManageSharedAccessKey', serviceBus.apiVersion).primaryConnectionString
