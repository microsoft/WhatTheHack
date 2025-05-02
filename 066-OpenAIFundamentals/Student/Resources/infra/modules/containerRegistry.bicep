// Parameters
@description('Name of your Azure Container Registry')
@minLength(5)
@maxLength(50)
param name string = 'acr${uniqueString(resourceGroup().id)}'

@description('Enable admin user that have push / pull permission to the registry.')
param adminUserEnabled bool = false

@description('Whether to allow public network access. Defaults to Enabled.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Tier of your Azure Container Registry.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Premium'

@description('Specifies the resource id of the Log Analytics workspace.')
param workspaceId string

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object

// Variables
var diagnosticSettingsName = 'diagnosticSettings'
var logCategories = [
  'ContainerRegistryRepositoryEvents'
  'ContainerRegistryLoginEvents'
]
var metricCategories = [
  'AllMetrics'
]
var logs = [
  for category in logCategories: {
    category: category
    enabled: true
    retentionPolicy: {
      enabled: true
      days: 0
    }
  }
]
var metrics = [
  for category in metricCategories: {
    category: category
    enabled: true
    retentionPolicy: {
      enabled: true
      days: 0
    }
  }
]

// Resources
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: adminUserEnabled
    publicNetworkAccess: publicNetworkAccess
  }
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingsName
  scope: containerRegistry
  properties: {
    workspaceId: workspaceId
    logs: logs
    metrics: metrics
  }
}

// Outputs
output id string = containerRegistry.id
output name string = containerRegistry.name
