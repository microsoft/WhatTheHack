@description('The name of the Azure Open AI.')
param name string

@description('Location where the Azure Open AI will be created.')
param location string

@description('List of model deployments to create.')
param deployments array = []

resource account 'Microsoft.CognitiveServices/accounts@2021-10-01' = {
  name: name
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'OpenAI'
  properties: {
    apiProperties: {
      statisticsEnabled: false
    }
  }
}

@batchSize(1)
resource deploymentsToCreate 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = [for deployment in deployments: {
  name: deployment.name
  parent: account
  sku: {
    name: 'Standard'
    capacity: 1
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: deployment.name
      version: deployment.version      
    }    
  }
}]

#disable-next-line outputs-should-not-contain-secrets
output key1 string = account.listKeys().key1
output endpoint string = account.properties.endpoint
