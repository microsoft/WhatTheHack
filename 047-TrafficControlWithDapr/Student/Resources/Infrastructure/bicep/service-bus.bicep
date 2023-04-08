param serviceBusNamespaceName string
param location string
param logAnalyticsWorkspaceName string

resource serviceBus 'Microsoft.ServiceBus/namespaces@2021-01-01-preview' = {
  name: serviceBusNamespaceName
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

resource serviceBusTrafficControlTopic 'Microsoft.ServiceBus/namespaces/topics@2017-04-01' = {
  parent: serviceBus
  name: 'collectfine'
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: serviceBus
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'OperationalLogs'
        enabled: true
      }
      {
        category: 'RuntimeAuditLogs'
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

output serviceBusName string = serviceBus.name
output serviceBusEndpoint string = serviceBus.properties.serviceBusEndpoint
var endpoint = '${serviceBus.id}/AuthorizationRules/RootManageSharedAccessKey'
#disable-next-line outputs-should-not-contain-secrets
output serviceBusConnectionString string = 'Endpoint=sb://${serviceBus.name}.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=${listKeys(endpoint, serviceBus.apiVersion).primaryKey}'
