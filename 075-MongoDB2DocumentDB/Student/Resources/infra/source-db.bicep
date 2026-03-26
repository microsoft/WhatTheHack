// Parameters

@description('Specifies a suffix used in Azure resource naming.')
@minLength(4)
@maxLength(10)
param suffix string = substring(uniqueString(resourceGroup().id), 0, 6)

@description('Specifies the location for all Azure resources.')
param location string = resourceGroup().location

@description('Specifies the administrator username for the source MongoDB instance.')
param administratorLogin string = 'mflixadmin'

@description('Specifies the administrator password for the source MongoDB instance.')
@secure()
param administratorPassword string

@description('Specifies the number of CPU cores for the source MongoDB container.')
param sourceMongoDbCpuCores int = 2

@description('Specifies the memory in GB for the source MongoDB container.')
param sourceMongoDbMemoryGb int = 4

@description('Specifies tags for all resources.')
param tags object = {}

// Resources

// Source MongoDB on Azure Container Instances
resource sourceMongoDb 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: 'mongodb-source-${suffix}'
  location: location
  tags: tags
  properties: {
    containers: [
      {
        name: 'mongodb'
        properties: {
          image: 'mongo:7'
          resources: {
            requests: {
              cpu: sourceMongoDbCpuCores
              memoryInGB: sourceMongoDbMemoryGb
            }
          }
          ports: [
            {
              port: 27017
              protocol: 'TCP'
            }
          ]
          environmentVariables: [
            {
              name: 'MONGO_INITDB_ROOT_USERNAME'
              value: administratorLogin
            }
            {
              name: 'MONGO_INITDB_ROOT_PASSWORD'
              secureValue: administratorPassword
            }
            {
              name: 'MONGO_INITDB_DATABASE'
              value: 'sample_mflix'
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    ipAddress: {
      type: 'Public'
      ports: [
        {
          port: 27017
          protocol: 'TCP'
        }
      ]
      dnsNameLabel: 'mflix-source-${suffix}'
    }
  }
}

// Outputs
output deploymentInfo object = {
  subscriptionId: subscription().subscriptionId
  resourceGroupName: resourceGroup().name
  location: location
  sourceMongoDbFqdn: sourceMongoDb.properties.ipAddress.fqdn
  sourceMongoDbName: sourceMongoDb.name
}
