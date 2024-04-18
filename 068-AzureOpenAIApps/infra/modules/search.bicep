@description('Name of the Azure AI Search.')
param name string

@description('Location where the Azure AI Search will be created.')
param location string

resource search 'Microsoft.Search/searchServices@2020-08-01' = {
  name: name
  location: location
  sku: {
    name: 'basic'
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
  }
}

output primaryKey string = search.listAdminKeys().primaryKey
