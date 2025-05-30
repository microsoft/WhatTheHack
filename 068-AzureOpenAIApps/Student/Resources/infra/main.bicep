var suffix = uniqueString('${subscription().subscriptionId}-${resourceGroup().name}')

#disable-next-line no-loc-expr-outside-params
var location = resourceGroup().location

param openAILocation string
param documentIntelligenceLocation string
param modelName string = 'gpt-4o'
param modelVersion string = '2024-11-20'
param embeddingModel string = 'text-embedding-ada-002'
param embeddingModelVersion string = '2'

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
output cosmosDBAccount string = cosmos.outputs.cosmosDBAccount

module openai 'modules/openai.bicep' = {
  name: 'openAIDeployment'
  params: {
    #disable-next-line no-hardcoded-location    
    location: openAILocation
    name: 'openai-${suffix}'
    deployments: [
      { name: modelName,                    version: modelVersion }
      { name: embeddingModel,   version: embeddingModelVersion }      
    ]    
  }
}

output openAIKey string = openai.outputs.key1
output openAIEndpoint string = openai.outputs.endpoint
output modelName string = modelName
output modelVersion string = modelVersion
output embeddingModel string = embeddingModel
output embeddingModelVersion string = embeddingModelVersion


module search 'modules/search.bicep' = {
  name: 'searchDeployment'
  params: {
    name: 'search-${suffix}'
    location: location
  }
}

output searchKey string = search.outputs.primaryKey
output searchEndpoint string = search.outputs.endpoint
output searchName string = search.outputs.name

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
    containers: [ 'classifications', 'f01-geography-climate', 'f02-tour-economy', 'f03-government-politics', 'f04-activity-preferences', 'submissions', 'government' ]
  }
}

output storagePrimaryKey string = storage.outputs.primaryKey
output storageConnectionString string = storage.outputs.connectionString
output name string = storage.outputs.name

module appinsights 'modules/appinsights.bicep' = {
  name: 'appInsightsDeployment'
  params: {    
    name: 'appinsights-${suffix}'
    location: location
  }
}

output appInsightsConnectionString string = appinsights.outputs.connectionString
