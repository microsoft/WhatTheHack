@description('The name of the Azure Open AI.')
param name string

@description('Location where the Azure Open AI will be created.')
param location string = 'East US 2'

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
  properties: {
    model: {
      format: 'OpenAI'
      name: deployment.name
      version: deployment.version
    }    
  }
}]

output key1 string = account.listKeys().key1
output endpoint string = account.properties.endpoint
