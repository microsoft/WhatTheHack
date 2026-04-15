// =============================================================================
// Foundry Agents Hack - Resource Module
// All resources deployed into the resource group
// =============================================================================

param location string
param prefix string
param uniqueSuffix string

// --- Naming ---
var storageAccountName = toLower('${prefix}st${uniqueSuffix}')
var aiSearchName = '${prefix}-search-${uniqueSuffix}'
var foundryResourceName = '${prefix}-fdry-${uniqueSuffix}'
var foundryProjectName = '${prefix}-proj-${uniqueSuffix}'

// =============================================================================
// 1. Storage Account
// =============================================================================
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

// =============================================================================
// 2. Azure AI Search
// =============================================================================
resource aiSearch 'Microsoft.Search/searchServices@2024-06-01-preview' = {
  name: aiSearchName
  location: location
  sku: {
    name: 'basic'
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
  }
}

// =============================================================================
// 3. Microsoft Foundry Resource
// =============================================================================
resource foundryResource 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' = {
  name: foundryResourceName
  location: location
  kind: 'AIServices'
  sku: {
    name: 'S0'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    customSubDomainName: foundryResourceName
    publicNetworkAccess: 'Enabled'
    allowProjectManagement: true
  }
}

// =============================================================================
// 4. Microsoft Foundry Project
// =============================================================================
resource foundryProject 'Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview' = {
  parent: foundryResource
  name: foundryProjectName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Foundry Agents Project'
  }
}

// =============================================================================
// Outputs
// =============================================================================
output foundryResourceName string = foundryResource.name
output foundryEndpoint string = foundryResource.properties.endpoint
output foundryProjectName string = foundryProject.name
output storageAccountName string = storageAccount.name
output searchServiceName string = aiSearch.name
output searchServiceEndpoint string = 'https://${aiSearch.name}.search.windows.net'
