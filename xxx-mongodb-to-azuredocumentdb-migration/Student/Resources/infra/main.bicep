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

// Resources

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
}
