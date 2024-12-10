targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unqiue hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param existingOpenAiInstance object

@description('Id of the user or app to assign application roles')
param principalId string = ''

@description('The Kubernetes version.')
param kubernetesVersion string = '1.28'

var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = { 'azd-env-name': environmentName }

// Resource group to hold all resources
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${abbrs.resourcesResourceGroups}${environmentName}'
  location: location
  tags: tags
}

// The Azure Container Registry to hold the images
module acr './resources/acr.bicep' = {
  name: 'container-registry'
  scope: resourceGroup
  params: {
    location: location
    name: '${abbrs.containerRegistryRegistries}${resourceToken}'
    tags: tags
  }
}

// The AKS cluster to host the application
module aks './resources/aks.bicep' = {
  name: 'aks'
  scope: resourceGroup
  params: {
    location: location
    name: '${abbrs.containerServiceManagedClusters}${resourceToken}'
    kubernetesVersion: kubernetesVersion
    logAnalyticsId: monitoring.outputs.logAnalyticsWorkspaceId
    tags: tags
  }
  dependsOn: [
    monitoring
  ]
}

// Grant ACR Pull access from cluster managed identity to container registry
module containerRegistryAccess './role-assignments/aks-acr-role-assignment.bicep' = {
  name: 'cluster-container-registry-access'
  scope: resourceGroup
  params: {
    aksPrincipalId: aks.outputs.clusterIdentity.objectId
    acrName: acr.outputs.name
    desc: 'AKS cluster managed identity'
  }
}

// Monitor application with Azure Monitor
module monitoring './monitoring/monitoring.bicep' = {
  name: 'monitoring'
  scope: resourceGroup
  params: {
    location: location
    azureMonitorWorkspaceLocation:location
    logAnalyticsName: '${abbrs.operationalInsightsWorkspaces}${resourceToken}'
    containerInsightsName: '${abbrs.containerInsights}${resourceToken}'
    azureMonitorName: '${abbrs.monitor}${resourceToken}'
    azureManagedGrafanaName: '${abbrs.grafanaWorkspace}${resourceToken}'
    clusterName:'${abbrs.containerServiceManagedClusters}${resourceToken}'
    tags: tags
  }
}

module cosmos './resources/cosmosdb.bicep' = {
  name: 'cosmos'
  params: {
    capabilities: [
      {
        name: 'EnableNoSQLVectorSearch'
      }
      {
        name: 'EnableServerless'
      }
    ]
    containers: [
      {
        name: 'completions'
        partitionKeyPath: '/sessionId'
        indexingPolicy: null
        vectorEmbeddingPolicy: {}
      }
      {
        name: 'product'
        partitionKeyPath: '/categoryId'
        indexingPolicy: null
        vectorEmbeddingPolicy: {}
      }
      {
        name: 'customer'
        partitionKeyPath: '/customerId'
        indexingPolicy: null
        vectorEmbeddingPolicy: {}
      }
      {
        name: 'leases'
        partitionKeyPath: '/id'
        indexingPolicy: null
        vectorEmbeddingPolicy: {}
      }
    ]
    databaseName: 'vsai-database'
    keyvaultName: keyVault.outputs.name
    location: location
    name: '${abbrs.documentDBDatabaseAccounts}${resourceToken}'
    tags: tags
  }
  scope: resourceGroup
}

module keyVault './resources/keyvault.bicep' = {
  name: 'keyvault'
  params: {
    location: location
    tags: tags
    name: '${abbrs.keyVaultVaults}${resourceToken}'
    principalId: principalId
  }
  scope: resourceGroup
}

module openAi './resources/openai.bicep' = {
  name: 'openai'
  params: {
    deployments: [
      {
        name: 'completions'
        sku: {
          name: 'Standard'
          capacity: 10
        }
        model: {
          name: 'gpt-4o'
          version: '2024-05-13'
        }
      }
      {
        name: 'embeddings'
        sku: {
          name: 'Standard'
          capacity: 10
        }
        model: {
          name: 'text-embedding-3-large'
          version: '1'
        }
      }
    ]
    keyvaultName: keyVault.outputs.name
    location: location
    name: '${abbrs.openAiAccounts}${resourceToken}'
    sku: 'S0'
    tags: tags
  }
  scope: resourceGroup
}

module storage './resources/storage.bicep' = {
  name: 'storage'
  params: {
    containers: [
      {
        name: 'system-prompt'
      }
      {
        name: 'memory-source'
      }
      {
        name: 'product-policy'
      }
    ]
    files: []
    keyvaultName: keyVault.outputs.name
    location: location
    name: '${abbrs.storageStorageAccounts}${resourceToken}'
    tags: tags
  }
  scope: resourceGroup
}

// Azure Monitor rule association with the AKS cluster to enable the portal experience
module ruleAssociations 'monitoring/rule-associations.bicep' = {
  name: 'monitoring-rules-associations'
  scope: resourceGroup
  params: {
    clusterName: aks.outputs.name
    prometheusDcrId: monitoring.outputs.prometheusDcrId
    containerInsightsDcrId: monitoring.outputs.containerInsightsDcrId
  }
  dependsOn: [
    monitoring
  ]
}

// Managed identity for KEDA
module kedaManagedIdentity 'managed-identity/keda-workload-identity.bicep' = {
  name: 'keda-managed-identity'
  scope: resourceGroup
  params: {
    managedIdentityName:  '${abbrs.managedIdentityUserAssignedIdentities}${resourceToken}-keda'
    federatedIdentityName:  '${abbrs.federatedIdentityCredentials}${resourceToken}-keda'
    aksOidcIssuer: aks.outputs.aksOidcIssuer
    location: location
    tags: tags
  }
}

// Assign Azure Monitor Data Reader role to the KEDA managed identity
module assignAzureMonitorDataReaderRoleToKEDA 'role-assignments/azuremonitor-role-assignment.bicep' = {
  name: 'assignAzureMonitorDataReaderRoleToKEDA'
  scope: resourceGroup
  params: {
    principalId: kedaManagedIdentity.outputs.managedIdentityPrincipalId
    azureMonitorName: monitoring.outputs.azureMonitorWorkspaceName
    desc: 'KEDA managed identity'
  }
}

// Managed identity for Azure Service Operator
module asoManagedIdentity 'managed-identity/aso-workload-identity.bicep' = {
  name: 'aso-managed-identity'
  scope: resourceGroup
  params: {
    managedIdentityName:  '${abbrs.managedIdentityUserAssignedIdentities}${resourceToken}-aso'
    federatedIdentityName:  '${abbrs.federatedIdentityCredentials}${resourceToken}-aso'
    aksOidcIssuer: aks.outputs.aksOidcIssuer
    location: location
    tags: tags
  }
}

// Assign subscription Contributor role to the ASO managed identity
// See docs on reducing scope of this role assignment: https://azure.github.io/azure-service-operator/introduction/authentication/#using-a-credential-for-aso-with-reduced-permissions
module assignContributorrRoleToASO 'role-assignments/subscription-contributor-role-assignment.bicep' = {
  name: 'subscriptionContributorRoleToASO'
  params: {
    principalId: asoManagedIdentity.outputs.managedIdentityPrincipalId
    desc: 'ASO managed identity'
  }
}

// Managed identity for ChatAPI
module chatServiceApiManagedIdentity 'managed-identity/chat-service-web-api-workload-identity.bicep' = {
  name: 'chat-service-api-managed-identity'
  scope: resourceGroup
  params: {
    cosmosDbAccountName: cosmos.outputs.name
    keyvaultName: keyVault.outputs.name
    storageAccountName: storage.outputs.name
    managedIdentityName:  '${abbrs.managedIdentityUserAssignedIdentities}${resourceToken}-chat'
    federatedIdentityName:  '${abbrs.federatedIdentityCredentials}${resourceToken}-chat'
    aksOidcIssuer: aks.outputs.aksOidcIssuer
    location: location
    tags: tags
  }
}

// Managed identity for Search
module searchManagedIdentity 'managed-identity/search-workload-identity.bicep' = {
  name: 'search-managed-identity'
  scope: resourceGroup
  params: {
    managedIdentityName:  '${abbrs.managedIdentityUserAssignedIdentities}${resourceToken}-search'
    federatedIdentityName:  '${abbrs.federatedIdentityCredentials}${resourceToken}-search'
    aksOidcIssuer: aks.outputs.aksOidcIssuer
    location: location
    tags: tags
  }
}


output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output AZURE_SUBSCRIPTION_ID string = subscription().subscriptionId
output AZURE_AKS_CLUSTER_NAME string = aks.outputs.name
output AZURE_RESOURCE_GROUP string = resourceGroup.name
output AZURE_AKS_CLUSTERIDENTITY_OBJECT_ID string = aks.outputs.clusterIdentity.objectId
output AZURE_AKS_CLUSTERIDENTITY_CLIENT_ID string = aks.outputs.clusterIdentity.clientId
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = acr.outputs.loginServer
output AZURE_CONTAINER_REGISTRY_NAME string = acr.outputs.name
output AZURE_MANAGED_PROMETHEUS_ENDPOINT string = monitoring.outputs.prometheusEndpoint
output AZURE_MANAGED_PROMETHEUS_NAME string = monitoring.outputs.azureMonitorWorkspaceName
output AZURE_MANAGED_GRAFANA_ENDPOINT string = monitoring.outputs.grafanaDashboard
output AZURE_MANAGED_PROMETHEUS_RESOURCE_ID string = monitoring.outputs.azureMonitorWorkspaceId
output AZURE_MANAGED_GRAFANA_RESOURCE_ID string = monitoring.outputs.grafanaId
output AZURE_MANAGED_GRAFANA_NAME string = monitoring.outputs.grafanaName
output API_WORKLOADIDENTITY_CLIENT_ID string = chatServiceApiManagedIdentity.outputs.managedIdentityClientId
output KEDA_WORKLOADIDENTITY_CLIENT_ID string = kedaManagedIdentity.outputs.managedIdentityClientId
output ASO_WORKLOADIDENTITY_CLIENT_ID string = asoManagedIdentity.outputs.managedIdentityClientId
output PROMETHEUS_ENDPOINT string = monitoring.outputs.prometheusEndpoint

output AZURE_COSMOS_DB_NAME string = cosmos.outputs.name
output AZURE_COSMOS_DB_ENDPOINT string = cosmos.outputs.endpoint
output AZURE_COSMOS_DB_VEC_NAME string = cosmos.outputs.name
output AZURE_COSMOS_DB_VEC_ENDPOINT string = cosmos.outputs.endpoint
output AZURE_OPENAI_NAME string = openAi.outputs.name
output AZURE_OPENAI_ENDPOINT string = openAi.outputs.endpoint
output AZURE_STORAGE_ACCOUNT_NAME string = storage.outputs.name

