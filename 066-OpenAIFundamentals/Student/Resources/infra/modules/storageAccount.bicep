// Parameters
@description('Specifies the globally unique name for the storage account used to store the boot diagnostics logs of the virtual machine.')
param name string

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource id of the Log Analytics workspace.')
param workspaceId string

@description('Specifies the the storage SKU.')
@allowed([
  'Standard_LRS'
  'Standard_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param skuName string = 'Standard_LRS'

@description('Specifies the access tier of the storage account. The default value is Hot.')
param accessTier string = 'Hot'

@description('Specifies whether the storage account allows public access. The default value is enabled.')
param allowStorageAccountPublicAccess string = 'Enabled'

@description('Specifies whether the storage account allows public access to blobs. The default value is false.')
param allowBlobPublicAccess bool = false

@description('Specifies whether the storage account allows shared key access. The default value is false.')
param allowSharedKeyAccess bool = true

@description('Specifies whether the storage account allows cross-tenant replication. The default value is false.')
param allowCrossTenantReplication bool = false

@description('Specifies the minimum TLS version to be permitted on requests to storage. The default value is TLS1_2.')
param minimumTlsVersion string = 'TLS1_2'

@description('The default action of allow or deny when no other rules match. Allowed values: Allow or Deny')
@allowed([
  'Allow'
  'Deny'
])
param networkAclsDefaultAction string = 'Allow'

@description('Specifies whether the storage account should only support HTTPS traffic.')
param supportsHttpsTrafficOnly bool = true

@description('Specifies the object id of a Miccrosoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources.')
param userObjectId string = ''

@description('Specifies the principal id of the Azure AI Services resource.')
param aiServicesPrincipalId string = ''

@description('Specifies the resource tags.')
param tags object

@description('Specifies whether to create containers.')
param createContainers bool = false

@description('Specifies an array of containers to create.')
param containerNames array = []

// Variables
var diagnosticSettingsName = 'diagnosticSettings'
var logCategories = [
  'StorageRead'
  'StorageWrite'
  'StorageDelete'
]
var metricCategories = [
  'Transaction'
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
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  kind: 'StorageV2'

  // Containers live inside of a blob service
  resource blobService 'blobServices' = {
    name: 'default'

    // Creating containers with provided names if contition is true
    resource containers 'containers' = [
      for containerName in containerNames: if (createContainers) {
        name: containerName
        properties: {
          publicAccess: 'None'
        }
      }
    ]
  }

  properties: {
    accessTier: accessTier
    allowBlobPublicAccess: allowBlobPublicAccess
    allowCrossTenantReplication: allowCrossTenantReplication
    allowSharedKeyAccess: allowSharedKeyAccess
    encryption: {
      keySource: 'Microsoft.Storage'
      requireInfrastructureEncryption: false
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
        queue: {
          enabled: true
          keyType: 'Service'
        }
        table: {
          enabled: true
          keyType: 'Service'
        }
      }
    }
    isHnsEnabled: false
    isNfsV3Enabled: false
    keyPolicy: {
      keyExpirationPeriodInDays: 7
    }
    largeFileSharesState: 'Disabled'
    minimumTlsVersion: minimumTlsVersion
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: networkAclsDefaultAction
    }
    publicNetworkAccess: allowStorageAccountPublicAccess
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
  }
}

resource storageAccountContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '17d1049b-9a84-46fb-8f53-869881c3d3ab'
  scope: subscription()
}

resource storageBlobDataContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  scope: subscription()
}

resource storageFileDataPrivilegedContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '69566ab7-960f-475b-8e7c-b3118f30c6bd'
  scope: subscription()
}

resource storageTableDataContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '0a9a7e1f-b9d0-4cc4-a60d-0319b160aaa3'
  scope: subscription()
}

// This role assignment grants the user the required permissions to create a Prompt Flow in Azure AI Foundry
resource storageAccountContributorUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(userObjectId)) {
  name: guid(storageAccount.id, storageAccountContributorRoleDefinition.id, userObjectId)
  scope: storageAccount
  properties: {
    roleDefinitionId: storageAccountContributorRoleDefinition.id
    principalType: 'User'
    principalId: userObjectId
  }
}

resource storageBlobDataContributorUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(userObjectId)) {
  name: guid(storageAccount.id, storageBlobDataContributorRoleDefinition.id, userObjectId)
  scope: storageAccount
  properties: {
    roleDefinitionId: storageBlobDataContributorRoleDefinition.id
    principalType: 'User'
    principalId: userObjectId
  }
}

resource storageFileDataPrivilegedContributorUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(userObjectId)) {
  name: guid(storageAccount.id, storageFileDataPrivilegedContributorRoleDefinition.id, userObjectId)
  scope: storageAccount
  properties: {
    roleDefinitionId: storageFileDataPrivilegedContributorRoleDefinition.id
    principalType: 'User'
    principalId: userObjectId
  }
}

resource storageTableDataContributorUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(userObjectId)) {
  name: guid(storageAccount.id, storageTableDataContributorRoleDefinition.id, userObjectId)
  scope: storageAccount
  properties: {
    roleDefinitionId: storageTableDataContributorRoleDefinition.id
    principalType: 'User'
    principalId: userObjectId
  }
}

// This role assignment grants the Azure AI Services managed identity the required permissions to access and transcribe the input audio and video files stored in the storage account
resource storageBlobDataContributorManagedIdentityRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(aiServicesPrincipalId)) {
  name: guid(storageAccount.id, storageBlobDataContributorRoleDefinition.id, aiServicesPrincipalId)
  scope: storageAccount
  properties: {
    roleDefinitionId: storageBlobDataContributorRoleDefinition.id
    principalType: 'ServicePrincipal'
    principalId: aiServicesPrincipalId
  }
}

resource blobServiceDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingsName
  scope: storageAccount::blobService
  properties: {
    workspaceId: workspaceId
    logs: logs
    metrics: metrics
  }
}

// Outputs
output id string = storageAccount.id
output name string = storageAccount.name
#disable-next-line outputs-should-not-contain-secrets
output primaryKey string = storageAccount.listKeys().keys[0].value

#disable-next-line outputs-should-not-contain-secrets
output connectionString string = 'DefaultEndpointsProtocol=https;AccountName=${name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
