var suffix = uniqueString(subscription().subscriptionId)
var location = resourceGroup().location

module redis 'modules/redis.bicep' = {
  name: 'redisDeployment'
  params: {
    name: 'redis-${suffix}'
    location: location
  }
}

output redisPrimaryKey string = redis.outputs.primaryKey
output redisHostname string = redis.outputs.hostname

module serviceBus 'modules/servicebus.bicep' = {
  name: 'serviceBusDeployment'
  params: {
    name: 'sbus-${suffix}'
    location: location
    queues: ['orange', 'lemon', 'grapfruit', 'tangerine']    
  }
}

output serviceBusConnectionString string = serviceBus.outputs.connectionString

module cosmos 'modules/cosmos.bicep' = {
  name: 'cosmosDeployment'
  params: {
    name: 'cosmos-${suffix}'
    location: location
    containers: [
      { name: 'yachts',           partitionKey: '/yachtId' }
      { name: 'customers',        partitionKey: '/email' }   
      { name: 'reservations',     partitionKey: '/id' }    
      { name: 'examsubmissions',  partitionKey: '/id' }
    ]
  }
}

output cosmosDBPrimaryMasterKey string = cosmos.outputs.primaryMasterKey
output cosmosDBAddress string = cosmos.outputs.uri

module openai 'modules/openai.bicep' = {
  name: 'openAIDeployment'
  params: {
    location: 'East US 2'
    name: 'openai-${suffix}'
    deployments: [
      { name: 'gpt-4',                    version: '1106-Preview' }
      { name: 'text-embedding-3-small',   version: '1' }      
    ]    
  }
}

output openAIKey string = openai.outputs.key1
output openAIEndpoint string = openai.outputs.endpoint

module search 'modules/search.bicep' = {
  name: 'searchDeployment'
  params: {
    name: 'search-${suffix}'
    location: location
  }
}

output searchKey string = search.outputs.primaryKey

module document 'modules/document.bicep' = {
  name: 'documentDeployment'
  params: {
    name: 'document-${suffix}'
    location: location
  }
}

output documentKey string = document.outputs.key1
output documentEndpoint string = document.outputs.endpoint

module webjobs 'modules/storage.bicep' = {
  name: 'webjobsDeployment'
  params: {    
    name: 'webjobs${suffix}'
    location: location
  }
}

output webjobsPrimaryKey string = webjobs.outputs.primaryKey

module storage 'modules/storage.bicep' = {
  name: 'storageDeployment'
  params: {    
    name: 'storage${suffix}'
    location: location
    containers: [ 'contoso-civics-all-forms', 'f01-geo-climate', 'f02-tour-economy', 'f03-gov-politics', 'f04-meal-preferences' ]
  }
}

output storagePrimaryKey string = storage.outputs.primaryKey
