param principalId string
param azureMonitorName string
param desc string = ''

resource azureMonitor 'microsoft.monitor/accounts@2021-06-03-preview' existing = {
  name: azureMonitorName
}

@description('This is the built-in Azure Monitor Data Reader role.')
resource azureMonitorDataReaderRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  name: 'b0d8363b-8ddd-447d-831f-62ca05bff136'
}

resource azureMonitorDataReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, principalId, azureMonitorDataReaderRoleDefinition.id)
  scope: azureMonitor
  properties: {
    roleDefinitionId: azureMonitorDataReaderRoleDefinition.id
    principalId: principalId
    principalType: 'ServicePrincipal' 
    description: desc
  }
}
