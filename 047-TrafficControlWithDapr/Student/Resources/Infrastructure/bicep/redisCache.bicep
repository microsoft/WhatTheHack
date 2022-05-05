param longName string

resource redisCache 'Microsoft.Cache/Redis@2019-07-01' = {
  name: 'redis-${longName}'
  location: resourceGroup().location
  properties: {
    sku: {
      capacity: 1
      family: 'C'
      name: 'Basic'
    }
    minimumTlsVersion: '1.2'
  }  
}

output redisCacheName string = redisCache.name
