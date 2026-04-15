// =============================================================================
// Foundry Agents Hack - Main Bicep Template
// Deploys: Microsoft Foundry Resource & Project, Storage Account, AI Search
// =============================================================================

targetScope = 'subscription'

@description('Name of the resource group to create.')
param resourceGroupName string

@description('Azure region for all resources.')
param location string = 'swedencentral'

@description('Unique suffix to avoid naming collisions. Pass a new value on each deployment to prevent soft-delete conflicts.')
param uniqueSuffix string

@description('Name prefix for resources.')
param prefix string = 'fndry'

// --- Resource Group ---
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

// --- Deploy all resources into the resource group ---
module resources 'modules/resources.bicep' = {
  name: 'deploy-foundry-resources'
  scope: rg
  params: {
    location: location
    prefix: prefix
    uniqueSuffix: uniqueSuffix
  }
}

// --- Outputs ---
output resourceGroupName string = rg.name
output foundryResourceName string = resources.outputs.foundryResourceName
output foundryEndpoint string = resources.outputs.foundryEndpoint
output foundryProjectName string = resources.outputs.foundryProjectName
output storageAccountName string = resources.outputs.storageAccountName
output searchServiceName string = resources.outputs.searchServiceName
output searchServiceEndpoint string = resources.outputs.searchServiceEndpoint
