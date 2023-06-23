param location string
param appServicePlanName string
param functionAppName string
param managedIdentityName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param functionAppStorageAccountName string
param tags object
param keyVaultName string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  kind: 'Windows'
  sku: {
    name: 'Y1'
  }
  properties: {}
}

resource functionAppStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: functionAppStorageAccountName
  tags: tags
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource functionAppStorageAccountFileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-09-01' = {
  #disable-next-line use-parent-property
  name: '${functionAppStorageAccount.name}/default/${functionAppName}'
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

var storageAccountConnectionStringSecretName = 'function-storage-account-connection-string'
var storageAccountConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${functionAppStorageAccount.name};AccountKey=${functionAppStorageAccount.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'

resource storageAccountConnectionStringSecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: storageAccountConnectionStringSecretName
  parent: keyVault
  properties: {
    value: storageAccountConnectionString
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' existing = {
  name: managedIdentityName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  tags: union(tags, { 'azd-service-name': 'api' })
  dependsOn: [
    storageAccountConnectionStringSecret
    functionAppStorageAccountFileShare
  ]
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    serverFarmId: appServicePlan.id
    keyVaultReferenceIdentity: managedIdentity.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'Recommended'
        }
        {
          name: 'AzureWebJobsStorage'
          value: '@Microsoft.KeyVault(VaultName=${keyVault.name};SecretName=${storageAccountConnectionStringSecretName})'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: '@Microsoft.KeyVault(VaultName=${keyVault.name};SecretName=${storageAccountConnectionStringSecretName})'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: functionAppName
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'WEBSITE_SKIP_CONTENTSHARE_VALIDATION'
          value: '1'
        }
      ]
    }
  }
}

resource functionAppNameDiagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: functionApp
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'FunctionAppLogs'
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

output provisionTeamsFunctionAppName string = functionApp.name
