param longName string

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-01-01-preview' = {
  name: 'ehn-${longName}-trafficcontrol'
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 1
  }
}

var eventHubEntryCamName = 'entrycam'

resource eventHubEntryCam 'Microsoft.EventHub/namespaces/eventhubs@2021-01-01-preview' = {
  name: '${eventHubNamespace.name}/${eventHubEntryCamName}'
  dependsOn: [
    eventHubNamespace
  ]
  properties: {
    partitionCount: 1
    messageRetentionInDays: 1
  }
}

resource eventHubEntryCamConsumerGroup 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2021-01-01-preview' = {
  name: '${eventHubNamespace.name}/${eventHubEntryCamName}/trafficcontrolservice'
  dependsOn: [
    eventHubEntryCam
  ]
}

resource eventHubEntryCamListenAuthorizationRule 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2021-01-01-preview' = {
  name: '${eventHubEntryCam.name}/listen'
  dependsOn: [
    eventHubEntryCam
  ]
  properties: {
    rights: [
      'Listen'
      'Send'
    ]
  }
}

var eventHubExitCamName = 'exitcam'

resource eventHubExitCam 'Microsoft.EventHub/namespaces/eventhubs@2021-01-01-preview' = {
  name: '${eventHubNamespace.name}/${eventHubExitCamName}'
  dependsOn: [
    eventHubNamespace
  ]
  properties: {
    partitionCount: 1
    messageRetentionInDays: 1
  }
}

resource eventHubExitCamConsumerGroup 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2021-01-01-preview' = {
  name: '${eventHubNamespace.name}/${eventHubExitCamName}/trafficcontrolservice'
  dependsOn: [
    eventHubExitCam
  ]
}

resource eventHubExitCamListenAuthorizationRule 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2021-01-01-preview' = {
  name: '${eventHubExitCam.name}/listen'
  dependsOn: [
    eventHubExitCam
  ]
  properties: {
    rights: [
      'Listen'
      'Send'
    ]
  }
}

var eventHubNamespaceEndpointUri = 'sb://${eventHubNamespace.name}.servicebus.windows.net'

resource iotHub 'Microsoft.Devices/IotHubs@2021-03-31' = {
  name: 'iothub-${longName}'
  location: resourceGroup().location
  sku: {
    name: 'B1'
    capacity: 1
  }
  properties: {
    routing: {
      endpoints: {
        eventHubs: [
          {
            name: 'entrycam'
            authenticationType: 'keyBased'
            connectionString: listKeys(eventHubEntryCamListenAuthorizationRule.id, eventHubEntryCamListenAuthorizationRule.apiVersion).primaryConnectionString
            subscriptionId: subscription().subscriptionId
            resourceGroup: resourceGroup().name
          }
          {
            name: 'exitcam'
            authenticationType: 'keyBased'
            connectionString: listKeys(eventHubExitCamListenAuthorizationRule.id, eventHubExitCamListenAuthorizationRule.apiVersion).primaryConnectionString
            subscriptionId: subscription().subscriptionId
            resourceGroup: resourceGroup().name
          }
        ]
      }
      routes: [
        {
          name: 'entrycam'
          source: 'DeviceMessages'
          condition: 'trafficcontrol = \'entrycam\''
          endpointNames: [
            eventHubEntryCamName
          ]
          isEnabled: true
        }
        {
          name: 'exitcam'
          source: 'DeviceMessages'
          condition: 'trafficcontrol = \'exitcam\''
          endpointNames: [
            eventHubExitCamName
          ]
          isEnabled: true
        }
      ]
    }
  }
}

output iotHubName string = iotHub.name
output eventHubNamespaceName string = eventHubNamespace.name
output eventHubNamespaceHostName string = eventHubNamespace.properties.serviceBusEndpoint
output eventHubNamespaceEndpointUri string = eventHubNamespaceEndpointUri
output eventHubEntryCamName string = eventHubEntryCam.name
output eventHubExitCamName string = eventHubExitCam.name
