@description('Name of the Azure Cache for Redis.')
param name string

@description('Location where the Azure Cache for Redis will be created.')
param location string

resource redis 'Microsoft.Cache/Redis@2023-04-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: 'Basic'
      family: 'C'
      capacity: 0
    }
  }
}

#disable-next-line outputs-should-not-contain-secrets
output primaryKey string = redis.listKeys().primaryKey
output hostname string = redis.properties.hostName
