param LawId string
param Location string
param Names array

resource pip 'Microsoft.Network/publicIPAddresses@2020-06-01' = [for Name in Names: {
  name: Name
  location: Location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: 'wth${toLower(uniqueString(resourceGroup().id, Name))}'
    }
  }
}]

resource pipDiags 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = [for i in range(0, length(Names)): {
  name: 'diag-${pip[i].name}'
  scope: pip[i]
  location: Location
  properties: {
    workspaceId: LawId
    metrics: [
      {
        timeGrain: 'PT1M'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 31
        }
      }
    ]
    logs: [
      {
        category: 'DDoSProtectionNotifications'
        enabled: true
      }
    ]
  }
}]

output FQDNs array = [for i in range(0, length(Names)): '${pip[i].properties.dnsSettings.fqdn}']
output Ids array = [for i in range(0, length(Names)): '${pip[i].id}']
