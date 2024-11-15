var suffix = uniqueString('${subscription().subscriptionId}-${resourceGroup().name}')

#disable-next-line no-loc-expr-outside-params
var location = resourceGroup().location

param openAILocation string
param documentIntelligenceLocation string

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
    queues: ['orange', 'lemon', 'grapefruit', 'tangerine']    
  }
}

output serviceBusConnectionString string = serviceBus.outputs.connectionString

module cosmos 'modules/cosmos.bicep' = {
  name: 'cosmosDeployment'  
  params: {
    name: 'cosmos-${suffix}'
    databaseName: 'contoso'
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
output cosmosDBDatabaseName string = cosmos.outputs.databaseName
output cosmosDBConnectionString string = cosmos.outputs.connectionString

module openai 'modules/openai.bicep' = {
  name: 'openAIDeployment'
  params: {
    #disable-next-line no-hardcoded-location    
    location: openAILocation
    name: 'openai-${suffix}'
    deployments: [
      { name: 'gpt-4',                    version: '1106-Preview' }
      { name: 'text-embedding-ada-002',   version: '2' }      
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
output searchEndpoint string = search.outputs.endpoint

module document 'modules/document.bicep' = {
  name: 'documentDeployment'
  params: {
    name: 'document-${suffix}'
    location: documentIntelligenceLocation
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
output webjobsConnectionString string = webjobs.outputs.connectionString

module storage 'modules/storage.bicep' = {
  name: 'storageDeployment'
  params: {    
    name: 'storage${suffix}'
    location: location
    containers: [ 'classifications', 'f01-geo-climate', 'f02-tour-economy', 'f03-gov-politics', 'f04-activity-preferences', 'submissions', 'government' ]
  }
}

output storagePrimaryKey string = storage.outputs.primaryKey
output storageConnectionString string = storage.outputs.connectionString

module appinsights 'modules/appinsights.bicep' = {
  name: 'appInsightsDeployment'
  params: {    
    name: 'appinsights-${suffix}'
    location: location
  }
}

output appInsightsConnectionString string = appinsights.outputs.connectionString
