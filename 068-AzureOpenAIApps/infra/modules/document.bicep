@description('The name of the Azure Document Intelligence.')
param name string

@description('Location where the Azure Document Intelligence will be created.')
param location string = 'East US'

resource account 'Microsoft.CognitiveServices/accounts@2021-10-01' = {
  name: name
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'FormRecognizer'
  properties: {
  }
}

output key1 string = account.listKeys().key1
output endpoint string = account.properties.endpoint
