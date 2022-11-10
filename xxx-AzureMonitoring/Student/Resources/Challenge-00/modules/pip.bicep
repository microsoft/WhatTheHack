param LawId string
param Location string
param PIPs array

resource pip 'Microsoft.Network/publicIPAddresses@2020-06-01' = [for PIP in PIPs: {
  name: PIP.Name
  location: Location
  sku: {
    name: PIP.Sku
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    dnsSettings: {
      domainNameLabel: 'wth${toLower(uniqueString(resourceGroup().id, PIP.Name))}'
    }
  }
}]

resource pipDiags 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = [for i in range(0, length(PIPs)): {
  name: 'diag-${pip[i].name}'
  scope: pip[i]
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

output FQDNs array = [for i in range(0, length(PIPs)): '${pip[i].properties.dnsSettings.fqdn}']
output Ids array = [for i in range(0, length(PIPs)): '${pip[i].id}']
