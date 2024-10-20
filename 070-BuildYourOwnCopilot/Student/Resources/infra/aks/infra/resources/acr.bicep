@description('The name of the Azure Container Registry.')
param name string

@description('The location of the Azure Container Registry.')
param location string

@description('Custom tags to apply to the resources')
param tags object = {}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
  tags: tags
}

output name string = containerRegistry.name
output loginServer string = containerRegistry.properties.loginServer
