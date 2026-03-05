// Parameters

@description('Specifies a suffix used in Azure resource naming.')
@minLength(4)
@maxLength(10)
param suffix string = substring(uniqueString(resourceGroup().id), 0, 6)

@description('Specifies the location for all Azure resources.')
param location string = resourceGroup().location

@description('Specifies the Azure DocumentDB for MongoDB vCore cluster name.')
param clusterName string = ''

@description('Specifies the cluster administrator username.')
param administratorLogin string = 'mflixadmin'

@description('Specifies the cluster administrator password.')
@secure()
param administratorPassword string

@description('Specifies the MongoDB server version.')
param serverVersion string = '7.0'

@description('Specifies the cluster compute tier.')
param computeTier string = 'M30'

@description('Specifies the storage size in GB per node.')
param storageSizeGb int = 32

@description('Specifies the shard count for the cluster.')
param shardCount int = 1

@description('Specifies the target high availability mode.')
param highAvailabilityTargetMode string = 'Disabled'

@description('Specifies whether public network access is enabled.')
param publicNetworkAccess string = 'Enabled'

@description('Specifies tags for all resources.')
param tags object = {}

@description('Specifies the number of CPU cores for the source MongoDB container.')
param sourceMongoDbCpuCores int = 2

@description('Specifies the memory in GB for the source MongoDB container.')
param sourceMongoDbMemoryGb int = 4

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

// Target Azure DocumentDB for MongoDB vCore cluster
resource mongoCluster 'Microsoft.DocumentDB/mongoClusters@2024-07-01' = {
  name: empty(clusterName) ? toLower('mflix${suffix}') : clusterName
  location: location
  tags: tags
  properties: {
    administrator: {
      userName: administratorLogin
      password: administratorPassword
    }
    serverVersion: serverVersion
    compute: {
      tier: computeTier
    }
    storage: {
      sizeGb: storageSizeGb
    }
    sharding: {
      shardCount: shardCount
    }
    highAvailability: {
      targetMode: highAvailabilityTargetMode
    }
    publicNetworkAccess: publicNetworkAccess
  }
}

// Outputs
output deploymentInfo object = {
  subscriptionId: subscription().subscriptionId
  resourceGroupName: resourceGroup().name
  location: location
  clusterName: mongoCluster.name
  sourceMongoDbFqdn: sourceMongoDb.properties.ipAddress.fqdn
  sourceMongoDbName: sourceMongoDb.name
}
