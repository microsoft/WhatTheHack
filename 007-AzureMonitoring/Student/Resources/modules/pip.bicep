param LawId string
param Location string
param Name string

resource pip 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: Name
  location: Location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: toLower(uniqueString(resourceGroup().id))
    }
  }
}

resource pipDiags 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'diag-${pip.name}'
  scope: pip
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
}

output fqdn string = pip.properties.dnsSettings.fqdn
output id string = pip.id
