param Location string
param LogAnalyticsWorkspaceName string
param NetworkSecurityGroupNames array
param StorageAccountName string

resource nsgDiags 'Microsoft.Network/networkSecurityGroups/providers/diagnosticSettings@2017-05-01-preview' = [ for NetworkSecurityGroup in NetworkSecurityGroupNames: {
  name: '${NetworkSecurityGroup}/Microsoft.Insights/diag-${NetworkSecurityGroup}'
  location: Location
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
