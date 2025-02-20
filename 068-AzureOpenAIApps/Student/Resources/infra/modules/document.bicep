@description('The name of the Azure Document Intelligence.')
param name string

@description('Location where the Azure Document Intelligence will be created.')
param location string

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

#disable-next-line outputs-should-not-contain-secrets
output key1 string = account.listKeys().key1
output endpoint string = account.properties.endpoint
