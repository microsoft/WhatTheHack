targetScope = 'resourceGroup'

@description('Unique workshop identifier; use a dedicated resource group.')
@minLength(4)
@maxLength(24)
param workshopId string

param location string = resourceGroup().location

@description('A region-supported OpenAI model selected by the organizer.')
param modelName string

@description('The exact model version available in the selected region.')
param modelVersion string

param deploymentName string = 'support-chat'
param deploymentSku string = 'GlobalStandard'

@minValue(1)
param capacity int = 10

@description('Microsoft Entra user object ID for project access.')
param userObjectId string

@description('Administrator-selected Foundry project role definition GUID. Must allow agent, connection and evaluation work.')
param projectRoleDefinitionId string

var accountName = 'cq-${uniqueString(resourceGroup().id, workshopId)}'
var projectName = 'context-quest'

resource account 'Microsoft.CognitiveServices/accounts@2025-09-01' = {
  name: accountName
  location: location
  kind: 'AIServices'
  sku: {
    name: 'S0'
  }
  identity: {
    type: 'SystemAssigned'
  }
  tags: {
    workshop: workshopId
  }
  properties: {
    customSubDomainName: accountName
    allowProjectManagement: true
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: true
  }
}

resource project 'Microsoft.CognitiveServices/accounts/projects@2025-09-01' = {
  parent: account
  name: projectName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    description: 'Context Quest synthetic-data workshop'
  }
}

resource model 'Microsoft.CognitiveServices/accounts/deployments@2025-09-01' = {
  parent: account
  name: deploymentName
  sku: {
    name: deploymentSku
    capacity: capacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: modelName
      version: modelVersion
    }
  }
}

resource projectAccess 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(project.id, userObjectId, projectRoleDefinitionId)
  scope: project
  properties: {
    principalId: userObjectId
    principalType: 'User'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', projectRoleDefinitionId)
  }
}

resource inferenceAccess 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(account.id, userObjectId, '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd')
  scope: account
  properties: {
    principalId: userObjectId
    principalType: 'User'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd')
  }
}

output projectEndpoint string = project.properties.endpoints['AI Foundry API']
output modelDeploymentName string = model.name
output accountResourceId string = account.id
output projectResourceId string = project.id
