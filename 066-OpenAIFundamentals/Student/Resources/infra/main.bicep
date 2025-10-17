// Parameters

@description('Specifies the name suffix or all the Azure resources.')
@minLength(4)
@maxLength(10)
param suffix string = substring(uniqueString(resourceGroup().id), 0, 6)

@description('Specifies the location for all the Azure resources.')
param location string = resourceGroup().location

@description('Specifies the name of the Network Security Perimeter.')
param nspName string = ''

@description('Specifies the name Azure AI Hub workspace.')
param hubName string = ''

@description('Specifies the friendly name of the Azure AI Hub workspace.')
param hubFriendlyName string = 'Demo AI Hub'

@description('Specifies the description for the Azure AI Hub workspace displayed in Azure AI Foundry.')
param hubDescription string = 'This is a demo hub for use in Azure AI Foundry.'

@description('Specifies the Isolation mode for the managed network of the Azure AI Hub workspace.')
@allowed([
  'AllowInternetOutbound'
  'AllowOnlyApprovedOutbound'
  'Disabled'
])
param hubIsolationMode string = 'Disabled'

@description('Specifies the public network access for the Azure AI Hub workspace.')
param hubPublicNetworkAccess string = 'Enabled'

@description('Specifies the authentication method for the OpenAI Service connection.')
@allowed([
  'ApiKey'
  'AAD'
  'ManagedIdentity'
  'None'
])
param connectionAuthType string = 'AAD'

@description('Determines whether or not to use credentials for the system datastores of the workspace workspaceblobstore and workspacefilestore. The default value is accessKey, in which case, the workspace will create the system datastores with credentials. If set to identity, the workspace will create the system datastores with no credentials.')
@allowed([
  'identity'
  'accessKey'
])
param systemDatastoresAuthMode string = 'identity'

@description('Specifies the name for the Azure AI Foundry Hub Project workspace.')
param projectName string = ''

@description('Specifies the friendly name for the Azure AI Foundry Hub Project workspace.')
param projectFriendlyName string = 'AI Foundry Hub Project'

@description('Specifies the public network access for the Azure AI Project workspace.')
param projectPublicNetworkAccess string = 'Enabled'

@description('Specifies the name of the Azure Log Analytics resource.')
param logAnalyticsName string = ''

@description('Specifies the service tier of the workspace: Free, Standalone, PerNode, Per-GB.')
@allowed([
  'Free'
  'Standalone'
  'PerNode'
  'PerGB2018'
])
param logAnalyticsSku string = 'PerNode'

@description('Specifies the workspace data retention in days. -1 means Unlimited retention for the Unlimited Sku. 730 days is the maximum allowed for all other Skus.')
param logAnalyticsRetentionInDays int = 60

@description('Specifies the name of the Azure Application Insights resource.')
param applicationInsightsName string = ''

@description('Specifies the name of the Azure AI Services resource.')
param aiServicesName string = ''

@description('Specifies the resource model definition representing SKU.')
param aiServicesSku object = {
  name: 'S0'
}

@description('Specifies the identity of the Azure AI Services resource.')
param aiServicesIdentity object = {
  type: 'SystemAssigned'
}

@description('Specifies an optional subdomain name used for token-based authentication.')
param aiServicesCustomSubDomainName string = ''

@description('Specifies whether disable the local authentication via API key.')
param aiServicesDisableLocalAuth bool = false

@description('Specifies whether or not public endpoint access is allowed for this account..')
@allowed([
  'Enabled'
  'Disabled'
])
param aiServicesPublicNetworkAccess string = 'Enabled'

@description('Specifies the OpenAI deployments to create.')
param openAiDeployments array = [
  {
    model: {
      name: 'text-embedding-ada-002'
      version: '2'
    }
    sku: {
      name: 'Standard'
      capacity: 10
    }
  }
  {
    model: {
      name: 'gpt-4'
      version: 'turbo-2024-04-09'
    }
    sku: {
      name: 'Standard'
      capacity: 10
    }
  }
]

@description('Specifies the name of the Azure Key Vault resource.')
param keyVaultName string = ''

@description('Specifies the default action of allow or deny when no other rules match for the Azure Key Vault resource. Allowed values: Allow or Deny')
@allowed([
  'Allow'
  'Deny'
])
param keyVaultNetworkAclsDefaultAction string = 'Allow'

@description('Specifies whether the Azure Key Vault resource is enabled for deployments.')
param keyVaultEnabledForDeployment bool = true

@description('Specifies whether the Azure Key Vault resource is enabled for disk encryption.')
param keyVaultEnabledForDiskEncryption bool = true

@description('Specifies whether the Azure Key Vault resource is enabled for template deployment.')
param keyVaultEnabledForTemplateDeployment bool = true

@description('Specifies whether the soft delete is enabled for this Azure Key Vault resource.')
param keyVaultEnableSoftDelete bool = true

@description('Specifies whether purge protection is enabled for this Azure Key Vault resource.')
param keyVaultEnablePurgeProtection bool = true

@description('Specifies whether enable the RBAC authorization for the Azure Key Vault resource.')
param keyVaultEnableRbacAuthorization bool = true

@description('Specifies the soft delete retention in days.')
param keyVaultSoftDeleteRetentionInDays int = 7

@description('Specifies whether creating the Azure Container Registry.')
param acrEnabled bool = false

@description('Specifies the name of the Azure Container Registry resource.')
param acrName string = ''

@description('Enable admin user that have push / pull permission to the registry.')
param acrAdminUserEnabled bool = false

@description('Tier of your Azure Container Registry.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param acrSku string = 'Standard'

@description('Specifies the name of the Azure Azure Storage Account resource resource.')
param storageAccountName string = ''

@description('Specifies the access tier of the Azure Storage Account resource. The default value is Hot.')
param storageAccountAccessTier string = 'Hot'

@description('Specifies whether the Azure Storage Account resource allows public access. The default value is enabled.')
param storageAccountAllowPublicAccess string = 'Enabled'

@description('Specifies whether the Azure Storage Account resource allows public access to blobs. The default value is false.')
param storageAccountAllowBlobPublicAccess bool = false

@description('Specifies whether the Azure Storage Account resource allows shared key access. The default value is true.')
param storageAccountAllowSharedKeyAccess bool = false

@description('Specifies whether the Azure Storage Account resource allows cross-tenant replication. The default value is false.')
param storageAccountAllowCrossTenantReplication bool = false

@description('Specifies the minimum TLS version to be permitted on requests to the Azure Storage Account resource. The default value is TLS1_2.')
param storageAccountMinimumTlsVersion string = 'TLS1_2'

@description('The default action of allow or deny when no other rules match. Allowed values: Allow or Deny')
@allowed([
  'Allow'
  'Deny'
])
param storageAccountANetworkAclsDefaultAction string = 'Allow'

@description('Specifies whether the Azure Storage Account resource should only support HTTPS traffic.')
param storageAccountSupportsHttpsTrafficOnly bool = true

@description('Specifies whether creating the Network Security Perimeter.')
param nspEnabled bool = false

@description('Specifies the resource tags for all the resoources.')
param tags object = {}

@description('Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources.')
param userObjectId string = ''

// Resources
module keyVault 'modules/keyVault.bicep' = {
  name: 'keyVault'
  params: {
    // properties
    name: empty(keyVaultName) ? ('key-vault-${suffix}') : keyVaultName
    location: location
    tags: tags
    networkAclsDefaultAction: keyVaultNetworkAclsDefaultAction
    enabledForDeployment: keyVaultEnabledForDeployment
    enabledForDiskEncryption: keyVaultEnabledForDiskEncryption
    enabledForTemplateDeployment: keyVaultEnabledForTemplateDeployment
    enablePurgeProtection: keyVaultEnablePurgeProtection
    enableRbacAuthorization: keyVaultEnableRbacAuthorization
    enableSoftDelete: keyVaultEnableSoftDelete
    softDeleteRetentionInDays: keyVaultSoftDeleteRetentionInDays
    workspaceId: workspace.outputs.id

    // role assignments
    userObjectId: userObjectId
  }
}

module workspace 'modules/logAnalytics.bicep' = {
  name: 'workspace'
  params: {
    // properties
    name: empty(logAnalyticsName) ? toLower('log-analytics-${suffix}') : logAnalyticsName
    location: location
    tags: tags
    sku: logAnalyticsSku
    retentionInDays: logAnalyticsRetentionInDays
  }
}

module applicationInsights 'modules/applicationInsights.bicep' = {
  name: 'applicationInsights'
  params: {
    // properties
    name: empty(applicationInsightsName) ? toLower('app-insights-${suffix}') : applicationInsightsName
    location: location
    tags: tags
    workspaceId: workspace.outputs.id
  }
}

module containerRegistry 'modules/containerRegistry.bicep' = if (acrEnabled) {
  name: 'containerRegistry'
  params: {
    // properties
    name: empty(acrName) ? toLower('acr${suffix}') : acrName
    location: location
    tags: tags
    sku: acrSku
    adminUserEnabled: acrAdminUserEnabled
    workspaceId: workspace.outputs.id
  }
}

module storageAccount 'modules/storageAccount.bicep' = {
  name: 'storageAccount'
  params: {
    // properties
    name: empty(storageAccountName) ? toLower('datastore${suffix}') : storageAccountName
    location: location
    tags: tags
    accessTier: storageAccountAccessTier
    allowBlobPublicAccess: storageAccountAllowBlobPublicAccess
    allowSharedKeyAccess: storageAccountAllowSharedKeyAccess
    allowCrossTenantReplication: storageAccountAllowCrossTenantReplication
    allowStorageAccountPublicAccess: storageAccountAllowPublicAccess
    minimumTlsVersion: storageAccountMinimumTlsVersion
    networkAclsDefaultAction: storageAccountANetworkAclsDefaultAction
    supportsHttpsTrafficOnly: storageAccountSupportsHttpsTrafficOnly
    workspaceId: workspace.outputs.id

    // role assignments
    userObjectId: userObjectId
    aiServicesPrincipalId: aiServices.outputs.principalId
  }
}

module aiServices 'modules/aiServices.bicep' = {
  name: 'aiServices'
  params: {
    // properties
    name: empty(aiServicesName) ? toLower('ai-services-${suffix}') : aiServicesName
    location: location
    tags: tags
    sku: aiServicesSku
    identity: aiServicesIdentity
    customSubDomainName: empty(aiServicesCustomSubDomainName)
      ? toLower('ai-services-${suffix}')
      : aiServicesCustomSubDomainName
    disableLocalAuth: aiServicesDisableLocalAuth
    publicNetworkAccess: aiServicesPublicNetworkAccess
    deployments: openAiDeployments
    workspaceId: workspace.outputs.id

    // role assignments
    userObjectId: userObjectId
  }
}

module hub 'modules/hub.bicep' = {
  name: 'hub'
  params: {
    // workspace organization
    name: empty(hubName) ? toLower('hub-${suffix}') : hubName
    friendlyName: hubFriendlyName
    description_: hubDescription
    location: location
    tags: tags

    // dependent resources
    aiServicesName: aiServices.outputs.name
    applicationInsightsId: applicationInsights.outputs.id
    containerRegistryId: acrEnabled ? containerRegistry.outputs.id : ''
    keyVaultId: keyVault.outputs.id
    storageAccountId: storageAccount.outputs.id
    connectionAuthType: connectionAuthType
    systemDatastoresAuthMode: systemDatastoresAuthMode

    // workspace configuration
    publicNetworkAccess: hubPublicNetworkAccess
    isolationMode: hubIsolationMode
    workspaceId: workspace.outputs.id

    // role assignments
    userObjectId: userObjectId
  }
}

module project 'modules/project.bicep' = {
  name: 'project'
  params: {
    // workspace organization
    name: empty(projectName) ? toLower('project-${suffix}') : projectName
    friendlyName: projectFriendlyName
    location: location
    tags: tags

    // workspace configuration
    publicNetworkAccess: projectPublicNetworkAccess
    hubId: hub.outputs.id
    workspaceId: workspace.outputs.id

    // role assignments
    userObjectId: userObjectId
    aiServicesPrincipalId: aiServices.outputs.principalId
  }
}

module networkSecurityPerimeter 'modules/networkSecurityPerimeter.bicep' = if (nspEnabled) {
  name: 'networkSecurityPerimeter'
  params: {
    name: empty(nspName) ? toLower('nsp-${suffix}') : nspName
    location: location
    keyVaultId: keyVault.outputs.id
    storageAccountId: storageAccount.outputs.id
  }
}

module search 'modules/search.bicep' = {
  name: 'searchDeployment'
  params: {
    name: 'search-${suffix}'
    location: location
  }
}

module document 'modules/document.bicep' = {
  name: 'documentDeployment'
  params: {
    name: 'document-${suffix}'
    location: location
  }
}

output deploymentInfo object = {
  subscriptionId: subscription().subscriptionId
  resourceGroupName: resourceGroup().name
  location: location
  aiServicesName: aiServices.outputs.name
  aiServicesEndpoint: aiServices.outputs.endpoint
  aiServicesOpenAiEndpoint: aiServices.outputs.openAiEndpoint
  aiServicesKey: aiServices.outputs.key1
  hubName: hub.outputs.name
  projectName: project.outputs.name
  documentKey: document.outputs.key1
  documentEndpoint: document.outputs.endpoint
  searchKey: search.outputs.primaryKey
  searchEndpoint: search.outputs.endpoint
  storageAccountName: storageAccount.outputs.name
  storageAccountId: storageAccount.outputs.id
  storageAccountConnectionString: storageAccount.outputs.connectionString
  storageAccountKey: storageAccount.outputs.primaryKey
  deployedModels: aiServices.outputs.deployedModels
}
