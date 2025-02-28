param aksPrincipalId string
param acrName string
param desc string = ''

resource acr 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' existing = {
  name: acrName
}

@description('This is the built-in ACR Pull role. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#acrpull')
resource acrPullRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  name: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
}

resource aksAcrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, aksPrincipalId, acrPullRoleDefinition.id)
  scope: acr
  properties: {
    roleDefinitionId: acrPullRoleDefinition.id
    principalId: aksPrincipalId
    principalType: 'ServicePrincipal' 
    description: desc
  }
}
