param location string
param appServicePlanName string
param logicAppName string
param managedIdentityName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param keyVaultName string
param logicAppStorageAccountName string
param logicAppStorageAccountConnectionStringSecretName string
param tags object
param containerName string
param sqlServerName string
param sqlDbName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' existing = {
  name: managedIdentityName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  kind: 'elastic'
  sku: {
    name: 'WS1'
  }
  properties: {}
}

#disable-next-line BCP035
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: logicAppStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    defaultToOAuthAuthentication: true
  }
}

var storageAccountConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, '2019-06-01').keys[0].value};EndpointSuffix=${environment().suffixes.storage}'

resource storageAccountConnectionStringSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: keyVault
  name: logicAppStorageAccountConnectionStringSecretName
  properties: {
    #disable-next-line use-resource-symbol-reference
    value: storageAccountConnectionString
  }
}

resource logicApp 'Microsoft.Web/sites@2018-11-01' = {
  name: logicAppName
  tags: union(tags, { 'hidden-link: /app-insights-resource-id': appInsights.id })
  location: location
  kind: 'functionapp,workflowapp'
  dependsOn: [
    storageAccountConnectionStringSecret
  ]
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    serverFarmId: appServicePlan.id
    #disable-next-line BCP037
    keyVaultReferenceIdentity: managedIdentity.id
    clientAffinityEnabled: false
    #disable-next-line BCP037
    publicNetworkAccess: 'Enabled'
    #disable-next-line BCP037
    virtualNetworkSubnetId: null
    httpsOnly: true
    siteConfig: {
      netFrameworkVersion: 'v6.0'
      use32BitWorkerProcess: false
      ftpsState: 'FtpsOnly'
      cors: {}
      appSettings: []
      #disable-next-line BCP037
      functionsRuntimeScaleMonitoringEnabled: false
    }
  }
}

resource logicAppAppConfigSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: logicApp
  name: 'appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsights.properties.InstrumentationKey
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsights.properties.ConnectionString
    APP_KIND: 'workflowApp'
    AzureFunctionsJobHost__extensionBundle__id: 'Microsoft.Azure.Functions.ExtensionBundle.Workflows'
    AzureFunctionsJobHost__extensionBundle__version: '[1.*, 2.0.0)'
    AzureWebJobsStorage: '@Microsoft.KeyVault(VaultName=${keyVault.name};SecretName=${logicAppStorageAccountConnectionStringSecretName})'
    FUNCTIONS_EXTENSION_VERSION: '~4'
    FUNCTIONS_WORKER_RUNTIME: 'node'
    SQL_DATABASE_NAME: sqlDbName
    SQL_SERVER_FQDN: '${sqlServerName}${environment().suffixes.sqlServerHostname}'
    STORAGE_ACCOUNT_CONTAINER_NAME: containerName
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: '@Microsoft.KeyVault(VaultName=${keyVault.name};SecretName=${logicAppStorageAccountConnectionStringSecretName})'
    WEBSITE_CONTENTSHARE: logicAppName
    WEBSITE_NODE_DEFAULT_VERSION: '~16'
  }
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: logicApp
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'WorkflowRuntime'
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

output appServicePlanName string = appServicePlan.name
output logicAppName string = logicApp.name
