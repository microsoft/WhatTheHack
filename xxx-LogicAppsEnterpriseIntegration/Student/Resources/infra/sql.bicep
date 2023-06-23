param sqlServerName string
param sqlDbName string
param tags object
param location string
param sqlAdminLoginName string
param sqlAdminLoginObjectId string
param sqlClientIpAddress string
param managedIdentityName string
param logAnalyticsWorkspaceName string

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: location
  tags: tags
  properties: {
    administrators: {
      azureADOnlyAuthentication: true
      administratorType: 'ActiveDirectory'
      tenantId: subscription().tenantId
      principalType: 'User'
      login: sqlAdminLoginName
      sid: sqlAdminLoginObjectId
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: sqlDbName
  tags: tags
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

resource azurefirewallRules 'Microsoft.Sql/servers/firewallRules@2022-08-01-preview' = {
  name: 'AllowAllAzureIps'
  parent: sqlServer
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource clientFirewallRules 'Microsoft.Sql/servers/firewallRules@2022-08-01-preview' = {
  name: 'AllowClientIp'
  parent: sqlServer
  properties: {
    startIpAddress: sqlClientIpAddress
    endIpAddress: sqlClientIpAddress
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: managedIdentityName
}

resource sqlDbContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '9b7fa17d-e63e-47b0-bb0a-15c516ac86ec'
}

resource sqlDbContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: sqlServer
  name: guid(sqlServer.id, managedIdentity.name, sqlDbContributorRoleDefinition.name)
  properties: {
    roleDefinitionId: sqlDbContributorRoleDefinition.id
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource contributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
}

resource resourceGroupContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: resourceGroup()
  name: guid(resourceGroup().id, managedIdentity.name, contributorRoleDefinition.name)
  properties: {
    roleDefinitionId: contributorRoleDefinition.id
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: sqlDB
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'Errors'
        enabled: true
      }
      {
        category: 'Timeouts'
        enabled: true
      }
      {
        category: 'Blocks'
        enabled: true
      }
      {
        category: 'Deadlocks'
        enabled: true
      }
      {
        category: 'SQLInsights'
        enabled: true
      }
      {
        category: 'DatabaseWaitStatistics'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output sqlServerName string = sqlServer.name
output sqlDbName string = sqlDbName
