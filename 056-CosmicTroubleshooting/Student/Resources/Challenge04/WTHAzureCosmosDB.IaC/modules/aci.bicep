/*
Parameters
*/
@description('Name for the container group')
param name string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Container image to deploy. Should be of the form repoName/imagename:tag for images stored in public Docker Hub, or a fully qualified URI for other registries. Images from private registries require additional registry credentials.')
param image string = 'iostavri/clickstream-generator:latest'

@description('Port to open on the container and the public IP address.')
param port int = 80

@description('The number of CPU cores to allocate to the container.')
param cpuCores int = 1

@description('The amount of memory to allocate to the container in gigabytes.')
param memoryInGb int = 2

@description('Object Id of AAD identity to assign to the container group.')
param msiObjectId string

@description('The behavior of Azure runtime if container has stopped.')
@allowed([
  'Always'
  'Never'
  'OnFailure'
])
param restartPolicy string = 'Never'

@description('The URI of the Azure Key Vault to use for secrets.')
param akvVaultUri string

@description('The URI of the Cosmos DB account.')
param cosmosDBAccountUri string

@description('The name of the Cosmos DB database.')
param cosmosDBDatabaseName string

@description('The name of the Cosmos DB container.')
param cosmosDBContainerName string

/*
Container Group
*/
resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: name
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${msiObjectId}': {}
    }
  }
  properties: {
    containers: [
      {
        name: name
        properties: {
          image: image
          ports: [
            {
              port: port
              protocol: 'TCP'
            }
          ]
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryInGb
            }
          }
          environmentVariables: [
            {
              name: 'VAULT_URL'
              value: akvVaultUri
            }
            {
              name: 'ACCOUNT_URI'
              value: cosmosDBAccountUri
            }
            {
              name: 'COSMOS_DATABASE_NAME'
              value: cosmosDBDatabaseName
            }
            {
              name: 'COSMOS_CONTAINER_NAME'
              value: cosmosDBContainerName
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    restartPolicy: restartPolicy
    ipAddress: {
      type: 'Public'
      ports: [
        {
          port: port
          protocol: 'TCP'
        }
      ]
    }
  }
}
