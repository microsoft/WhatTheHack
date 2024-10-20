param deployments array
param keyvaultName string
param location string = resourceGroup().location
param name string
param sku string = 'S0'
param tags object = {}


resource openAi 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  kind: 'OpenAI'
  properties: {
    customSubDomainName: name
    publicNetworkAccess: 'Enabled'
  }
  tags: tags
}

@batchSize(1)
resource openAiDeployments 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = [
  for deployment in deployments: {
    parent: openAi
    name: deployment.name
    sku: {
      capacity: deployment.sku.capacity
      name: deployment.sku.name
    }
    properties: {
      model: {
        format: 'OpenAI'
        name: deployment.model.name
        version: deployment.model.version
      }
    }
  }
]

resource keyvault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyvaultName
}

resource apiKeySecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'openai-apikey'
  parent: keyvault
  tags: tags
  properties: {
    value: openAi.listKeys().key1
  }
}

output endpoint string = openAi.properties.endpoint
output keySecretName string = apiKeySecret.name
output keySecretRef string = apiKeySecret.properties.secretUri
output name string = openAi.name
