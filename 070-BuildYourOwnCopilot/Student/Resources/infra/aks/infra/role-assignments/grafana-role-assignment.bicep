param principalId string
param grafanaName string
param desc string = ''

resource grafana 'Microsoft.Dashboard/grafana@2022-08-01' existing = {
  name: grafanaName
}

@description('This is the built-in Grafana Admin role.')
resource grafanaAdminRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  name: '22926164-76b3-42b3-bc55-97df8dab3e41'
}

resource grafanaAdminRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, principalId, grafanaAdminRoleDefinition.id)
  scope: grafana
  properties: {
    roleDefinitionId: grafanaAdminRoleDefinition.id
    principalId: principalId
    principalType: 'ServicePrincipal' 
    description: desc
  }
}
