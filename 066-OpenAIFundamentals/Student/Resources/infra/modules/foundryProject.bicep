// Parameters
@description('Specifies the name')
param name string

@description('Specifies the location.')
param location string

@description('Specifies the resource tags.')
param tags object

@description('The SKU name to use for the Microsoft Foundry Project')
param skuName string = 'Basic'

@description('The SKU tier to use for the Microsoft Foundry Project')
@allowed(['Basic', 'Free', 'Premium', 'Standard'])
param skuTier string = 'Basic'

@description('Specifies the display name')
param friendlyName string = name

@description('Specifies the public network access for the Foundry project.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Specifies the resource ID of the application insights resource for storing diagnostics logs')
param applicationInsightsId string

@description('Specifies the resource ID of the container registry resource for storing docker images')
param containerRegistryId string

@description('Specifies the resource ID of the key vault resource for storing connection strings')
param keyVaultId string

@description('Specifies the resource ID of the storage account resource for storing experimentation outputs')
param storageAccountId string

@description('Specifies the name of the Azure AI Services resource')
param aiServicesName string

@description('Specifies the resource id of the Log Analytics workspace.')
param workspaceId string

@description('Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources.')
param userObjectId string = ''

@description('Specifies the principal id of the Azure AI Services.')
param aiServicesPrincipalId string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'AmlComputeClusterEvent'
  'AmlComputeClusterNodeEvent'
  'AmlComputeJobEvent'
  'AmlComputeCpuGpuUtilization'
  'AmlRunStatusChangedEvent'
  'ModelsChangeEvent'
  'ModelsReadEvent'
  'ModelsActionEvent'
  'DeploymentReadEvent'
  'DeploymentEventACI'
  'DeploymentEventAKS'
  'InferencingOperationAKS'
  'InferencingOperationACI'
  'EnvironmentChangeEvent'
  'EnvironmentReadEvent'
  'DataLabelChangeEvent'
  'DataLabelReadEvent'
  'DataSetChangeEvent'
  'DataSetReadEvent'
  'PipelineChangeEvent'
  'PipelineReadEvent'
  'RunEvent'
  'RunReadEvent'
])
param logsToEnable array = [
  'AmlComputeClusterEvent'
  'AmlComputeClusterNodeEvent'
  'AmlComputeJobEvent'
  'AmlComputeCpuGpuUtilization'
  'AmlRunStatusChangedEvent'
  'ModelsChangeEvent'
  'ModelsReadEvent'
  'ModelsActionEvent'
  'DeploymentReadEvent'
  'DeploymentEventACI'
  'DeploymentEventAKS'
  'InferencingOperationAKS'
  'InferencingOperationACI'
  'EnvironmentChangeEvent'
  'EnvironmentReadEvent'
  'DataLabelChangeEvent'
  'DataLabelReadEvent'
  'DataSetChangeEvent'
  'DataSetReadEvent'
  'PipelineChangeEvent'
  'PipelineReadEvent'
  'RunEvent'
  'RunReadEvent'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param metricsToEnable array = [
  'AllMetrics'
]

// Variables
var diagnosticSettingsName = 'diagnosticSettings'
var logs = [
  for log in logsToEnable: {
    category: log
    enabled: true
    retentionPolicy: {
      enabled: true
      days: 0
    }
  }
]

var metrics = [
  for metric in metricsToEnable: {
    category: metric
    timeGrain: null
    enabled: true
    retentionPolicy: {
      enabled: true
      days: 0
    }
  }
]

// Resources
resource aiServices 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' existing = {
  name: aiServicesName
}

// Standalone Foundry Project (not hub-based)
resource project 'Microsoft.MachineLearningServices/workspaces@2024-04-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuTier
  }
  // Note: For standalone Foundry projects, kind is NOT set to 'Project'
  // Omitting the kind property creates a standalone workspace that works with Foundry
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    // organization
    friendlyName: friendlyName
    hbiWorkspace: false
    v1LegacyMode: false
    publicNetworkAccess: publicNetworkAccess

    // dependent resources - directly on the project (not inherited from hub)
    keyVault: keyVaultId
    storageAccount: storageAccountId
    applicationInsights: applicationInsightsId
    containerRegistry: containerRegistryId == '' ? null : containerRegistryId
    systemDatastoresAuthMode: 'identity'
  }

  // Create AI Services connection directly on the standalone project
  resource aiServicesConnection 'connections@2024-01-01-preview' = {
    name: toLower('${aiServices.name}-connection')
    properties: {
      category: 'AIServices'
      target: aiServices.properties.endpoint
      authType: 'AAD'
      isSharedToAll: true
      metadata: {
        ApiType: 'Azure'
        ResourceId: aiServices.id
      }
    }
  }
}

resource azureAIDeveloperRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '64702f94-c441-49e6-a78b-ef80e0188fee'
  scope: subscription()
}

resource azureMLDataScientistRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'f6c7c914-8db3-469d-8ca1-694a8f32e121'
  scope: subscription()
}

// This resource defines the Azure AI Developer role, which provides permissions for managing Azure AI resources, including deployments and configurations
resource aiDeveloperRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(userObjectId)) {
  name: guid(project.id, azureAIDeveloperRoleDefinition.id, userObjectId)
  scope: project
  properties: {
    roleDefinitionId: azureAIDeveloperRoleDefinition.id
    principalType: 'User'
    principalId: userObjectId
  }
}

// This role assignment grants the user the required permissions to start a Prompt Flow in a compute service within Microsoft Foundry
resource azureMLDataScientistUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(userObjectId)) {
  name: guid(project.id, azureMLDataScientistRole.id, userObjectId)
  scope: project
  properties: {
    roleDefinitionId: azureMLDataScientistRole.id
    principalType: 'User'
    principalId: userObjectId
  }
}

// This role assignment grants the Azure AI Services managed identity the required permissions to start Prompt Flow in a compute service defined in Microsoft Foundry
resource azureMLDataScientistManagedIdentityRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(aiServicesPrincipalId)) {
  name: guid(project.id, azureMLDataScientistRole.id, aiServicesPrincipalId)
  scope: project
  properties: {
    roleDefinitionId: azureMLDataScientistRole.id
    principalType: 'ServicePrincipal'
    principalId: aiServicesPrincipalId
  }
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingsName
  scope: project
  properties: {
    workspaceId: workspaceId
    logs: logs
    metrics: metrics
  }
}

// Outputs
output name string = project.name
output id string = project.id
output principalId string = project.identity.principalId
