@description('Name of the Azure AI Search.')
param name string

@description('Location where the Azure AI Search will be created.')
param location string

@description('Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources.')
param userObjectId string = ''

resource search 'Microsoft.Search/searchServices@2023-11-01' = {
  name: name
  location: location
  sku: {
    name: 'basic'
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
    authOptions: {
      aadOrApiKey: {
        aadAuthFailureMode: 'http401WithBearerChallenge'
      }
    }
  }
}

// Search Index Data Contributor role - required for uploading/modifying documents in the search index
// https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#search-index-data-contributor
resource searchIndexDataContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '8ebe5a00-799e-43f5-93ac-243d3dce84a7'
  scope: subscription()
}

// Search Service Contributor role - required for managing indexes
// https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#search-service-contributor
resource searchServiceContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
  scope: subscription()
}

// This role assignment grants the user permissions to upload, modify, and delete documents in search indexes
resource searchIndexDataContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(userObjectId)) {
  name: guid(search.id, searchIndexDataContributorRoleDefinition.id, userObjectId)
  scope: search
  properties: {
    roleDefinitionId: searchIndexDataContributorRoleDefinition.id
    principalType: 'User'
    principalId: userObjectId
  }
}

// This role assignment grants the user permissions to manage search indexes
resource searchServiceContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(userObjectId)) {
  name: guid(search.id, searchServiceContributorRoleDefinition.id, userObjectId)
  scope: search
  properties: {
    roleDefinitionId: searchServiceContributorRoleDefinition.id
    principalType: 'User'
    principalId: userObjectId
  }
}

output endpoint string = 'https://${name}.search.windows.net'
