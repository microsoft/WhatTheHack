param Location string
param LogAnalyticsWorkspaceName string
param StorageAccountName string
param Subnets array

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = [for Subnet in Subnets: {
  name: Subnet.NSG
  location: Location
  properties: {
    securityRules: [for SecurityRule in Subnet.SecurityRules: {
      name: SecurityRule.name
      properties: SecurityRule.properties
    }]
  }
}]

resource nsgDiags 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = [ for i in range(0, length(Subnets)): {
  name: 'diag-${Subnets[i].NSG}'
  scope: nsg[i]
  properties: {
    workspaceId: resourceId('Microsoft.OperationalInsights/workspaces', LogAnalyticsWorkspaceName)
    storageAccountId: resourceId('Microsoft.Storage/storageAccounts', StorageAccountName)
    logs: [
      {
        category: 'NetworkSecurityGroupEvent'
        enabled: true
        retentionPolicy: {
          days: 31
          enabled: true
        }
      }
      {
        category: 'NetworkSecurityGroupRuleCounter'
        enabled: true
        retentionPolicy: {
          days: 31
          enabled: true
        }
      }
    ]
  }
}]

output Ids array = [for Subnet in Subnets: '${resourceId('Microsoft.Network/networkSecurityGroups', Subnet.NSG)}']
