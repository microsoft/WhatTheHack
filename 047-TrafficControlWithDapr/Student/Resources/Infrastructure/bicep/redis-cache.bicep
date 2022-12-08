param redisCacheName string
param location string
param logAnalyticsWorkspaceName string

resource redisCache 'Microsoft.Cache/Redis@2019-07-01' = {
  name: redisCacheName
  location: location
  properties: {
    sku: {
      capacity: 1
      family: 'C'
      name: 'Basic'
    }
    minimumTlsVersion: '1.2'
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: redisCache
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'ConnectedClientList'
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

output redisCacheName string = redisCache.name
