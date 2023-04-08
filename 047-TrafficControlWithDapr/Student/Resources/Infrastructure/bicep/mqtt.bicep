param eventHubNamespaceName string
param location string
param logAnalyticsWorkspaceName string
param eventHubEntryCamName string
param eventHubExitCamName string
param eventHubConsumerGroupName string
param eventHubListenAuthorizationRuleName string
param iotHubName string

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-01-01-preview' = {
  name: eventHubNamespaceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 1
  }
}

resource eventHubEntryCam 'Microsoft.EventHub/namespaces/eventhubs@2021-01-01-preview' = {
  parent: eventHubNamespace
  name: eventHubEntryCamName
  properties: {
    partitionCount: 1
    messageRetentionInDays: 1
  }
}

resource eventHubEntryCamConsumerGroup 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2021-01-01-preview' = {
  parent: eventHubEntryCam
  name: eventHubConsumerGroupName
}

resource eventHubEntryCamListenAuthorizationRule 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2021-01-01-preview' = {
  parent: eventHubEntryCam
  name: eventHubListenAuthorizationRuleName
  properties: {
    rights: [
      'Listen'
      'Send'
    ]
  }
}

resource eventHubExitCam 'Microsoft.EventHub/namespaces/eventhubs@2021-01-01-preview' = {
  parent: eventHubNamespace
  name: eventHubExitCamName
  properties: {
    partitionCount: 1
    messageRetentionInDays: 1
  }
}

resource eventHubExitCamConsumerGroup 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2021-01-01-preview' = {
  parent: eventHubExitCam
  name: eventHubConsumerGroupName
}

resource eventHubExitCamListenAuthorizationRule 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2021-01-01-preview' = {
  parent: eventHubExitCam
  name: eventHubListenAuthorizationRuleName
  properties: {
    rights: [
      'Listen'
      'Send'
    ]
  }
}

resource iotHub 'Microsoft.Devices/IotHubs@2021-03-31' = {
  name: iotHubName
  location: location
  sku: {
    name: 'B1'
    capacity: 1
  }
  properties: {
    routing: {
      endpoints: {
        eventHubs: [
          {
            name: eventHubEntryCamName
            authenticationType: 'keyBased'
            #disable-next-line use-resource-symbol-reference
            connectionString: listKeys(eventHubEntryCamListenAuthorizationRule.id, eventHubEntryCamListenAuthorizationRule.apiVersion).primaryConnectionString
            subscriptionId: subscription().subscriptionId
            resourceGroup: resourceGroup().name
          }
          {
            name: eventHubExitCamName
            authenticationType: 'keyBased'
            #disable-next-line use-resource-symbol-reference
            connectionString: listKeys(eventHubExitCamListenAuthorizationRule.id, eventHubExitCamListenAuthorizationRule.apiVersion).primaryConnectionString
            subscriptionId: subscription().subscriptionId
            resourceGroup: resourceGroup().name
          }
        ]
      }
      routes: [
        {
          name: eventHubEntryCamName
          source: 'DeviceMessages'
          condition: 'trafficcontrol = \'${eventHubEntryCamName}\''
          endpointNames: [
            eventHubEntryCamName
          ]
          isEnabled: true
        }
        {
          name: eventHubExitCamName
          source: 'DeviceMessages'
          condition: 'trafficcontrol = \'${eventHubExitCamName}\''
          endpointNames: [
            eventHubExitCamName
          ]
          isEnabled: true
        }
      ]
    }
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource diagnosticSettingsEventHub 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: eventHubNamespace
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'ArchiveLogs'
        enabled: true
      }
      {
        category: 'OperationalLogs'
        enabled: true
      }
      {
        category: 'AutoScaleLogs'
        enabled: true
      }
      {
        category: 'KafkaCoordinatorLogs'
        enabled: true
      }
      {
        category: 'KafkaUserErrorLogs'
        enabled: true
      }
      {
        category: 'EventHubVNetConnectionEvent'
        enabled: true
      }
      {
        category: 'CustomerManagedKeyUserLogs'
        enabled: true
      }
      {
        category: 'ApplicationMetricsLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

resource diagnosticSettingsIotHub 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: iotHub
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'Connections'
        enabled: true
      }
      {
        category: 'DeviceTelemetry'
        enabled: true
      }
      {
        category: 'C2DCommands'
        enabled: true
      }
      {
        category: 'DeviceIdentityOperations'
        enabled: true
      }
      {
        category: 'FileUploadOperations'
        enabled: true
      }
      {
        category: 'Routes'
        enabled: true
      }
      {
        category: 'D2CTwinOperations'
        enabled: true
      }
      {
        category: 'C2DTwinOperations'
        enabled: true
      }
      {
        category: 'TwinQueries'
        enabled: true
      }
      {
        category: 'JobsOperations'
        enabled: true
      }
      {
        category: 'DirectMethods'
        enabled: true
      }
      {
        category: 'DistributedTracing'
        enabled: true
      }
      {
        category: 'Configurations'
        enabled: true
      }
      {
        category: 'DeviceStreams'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output iotHubName string = iotHub.name
output eventHubNamespaceName string = eventHubNamespace.name
output eventHubNamespaceHostName string = eventHubNamespace.properties.serviceBusEndpoint
output eventHubNamespaceEndpointUri string = 'sb://${eventHubNamespace.name}.servicebus.windows.net'
output eventHubEntryCamName string = eventHubEntryCam.name
output eventHubExitCamName string = eventHubExitCam.name
