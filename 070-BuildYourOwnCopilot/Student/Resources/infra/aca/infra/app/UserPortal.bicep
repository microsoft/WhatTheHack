param apiUri string
param name string
param location string = resourceGroup().location
param tags object = {}

param keyvaultName string
param identityName string
param containerRegistryName string
param containerAppsEnvironmentName string
param applicationInsightsName string
param exists bool
@secure()
param appDefinition object
param envSettings array = []
param secretSettings array = []

var appSettingsArray = filter(array(appDefinition.settings), i => i.name != '')
var secrets = union(map(filter(appSettingsArray, i => i.?secret != null), i => {
  name: i.name
  value: i.value
  secretRef: i.?secretRef ?? take(replace(replace(toLower(i.name), '_', '-'), '.', '-'), 32)
}), secretSettings)

var env = union(map(filter(appSettingsArray, i => i.?secret == null), i => {
  name: i.name
  value: i.value
}), envSettings)

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' existing = {
  name: containerRegistryName
}

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2023-04-01-preview' existing = {
  name: containerAppsEnvironmentName
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
}

resource acrPullRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: containerRegistry
  name: guid(subscription().id, resourceGroup().id, identity.id, 'acrPullRole')
  properties: {
    roleDefinitionId:  subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalType: 'ServicePrincipal'
    principalId: identity.properties.principalId
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyvaultName
}

resource secretsAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2023-07-01' = {
  parent: keyvault
  name: 'add'
  properties: {
    accessPolicies: [
      {
        objectId: identity.properties.principalId
        permissions: { secrets: [ 'get', 'list' ] }
        tenantId: subscription().tenantId
      }
    ]
  }
}

module fetchLatestImage '../modules/fetch-container-image.bicep' = {
  name: '${name}-fetch-image'
  params: {
    exists: exists
    name: name
  }
}

resource app 'Microsoft.App/containerApps@2023-04-01-preview' = {
  name: name
  location: location
  tags: union(tags, {'azd-service-name':  'UserPortal' })
  dependsOn: [ acrPullRole ]
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { '${identity.id}': {} }
  }
  properties: {
    managedEnvironmentId: containerAppsEnvironment.id
    configuration: {
      ingress:  {
        external: true
        targetPort: 80
        transport: 'auto'
      }
      registries: [
        {
          server: '${containerRegistryName}.azurecr.io'
          identity: identity.id
        }
      ]
      secrets: union([
      ],
      map(secrets, secret => {
        identity: identity.id
        keyVaultUrl: secret.value
        name: secret.secretRef
      }))
    }
    template: {
      containers: [
        {
          image: fetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          name: 'main'
          env: union([
            {
              name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
              value: applicationInsights.properties.ConnectionString
            }
            {
              name: 'MSCosmosDBOpenAI__ChatManager__APIUrl'
              value: apiUri
            }
            {
              name: 'PORT'
              value: '80'
            }
          ],
          env,
          map(secrets, secret => {
            name: secret.name
            secretRef: secret.secretRef
          }))
          resources: {
            cpu: json('1.0')
            memory: '2.0Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 10
      }
    }
  }
}

output defaultDomain string = containerAppsEnvironment.properties.defaultDomain
output name string = app.name
output uri string = 'https://${app.properties.configuration.ingress.fqdn}'
output id string = app.id
