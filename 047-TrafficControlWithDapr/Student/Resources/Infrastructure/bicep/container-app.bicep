param containerAppTrafficControlServiceObject object
param containerAppFineCollectionServiceObject object
param containerAppVehicleRegistrationServiceObject object
param location string
param containerAppEnvironmentName string
param containerRegistryName string
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: managedIdentityName
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' existing = {
  name: containerRegistryName
}

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2022-06-01-preview' existing = {
  name: containerAppEnvironmentName
}

var containerRegistryPasswordSecretName = '${containerRegistry.name}-password'

resource containerAppVehicleRegistrationService 'Microsoft.App/containerApps@2022-03-01' = {
  name: containerAppVehicleRegistrationServiceObject.name
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    managedEnvironmentId: containerAppEnvironment.id
    configuration: {
      dapr: {
        enabled: true
        appId: containerAppVehicleRegistrationServiceObject.appId
        appPort: containerAppVehicleRegistrationServiceObject.appPort
        appProtocol: 'http'
      }
      registries: [
        {
          server: containerRegistry.properties.loginServer
          username: containerRegistry.listCredentials().username
          passwordSecretRef: containerRegistryPasswordSecretName
        }
      ]
      secrets: [
        {
          name: containerRegistryPasswordSecretName
          value: containerRegistry.listCredentials().passwords[0].value
        }
      ]
    }
    template: {
      containers: [
        {
          name: containerAppVehicleRegistrationServiceObject.appId
          image: '${containerRegistry.properties.loginServer}/${containerAppVehicleRegistrationServiceObject.repositoryName}:${containerAppVehicleRegistrationServiceObject.imageTag}'
          resources: {
            cpu: containerAppVehicleRegistrationServiceObject.cpu
            memory: containerAppVehicleRegistrationServiceObject.memory
          }
          probes: [
            {
              type: 'Readiness'
              httpGet: {
                path: '/healthz'
                port: containerAppVehicleRegistrationServiceObject.appPort
                scheme: 'HTTP'
              }
              initialDelaySeconds: 30
              periodSeconds: 10
              timeoutSeconds: 5
              failureThreshold: 3
            }
            {
              type: 'Liveness'
              httpGet: {
                path: '/healthz'
                port: containerAppVehicleRegistrationServiceObject.appPort
                scheme: 'HTTP'
              }
              initialDelaySeconds: 30
              periodSeconds: 10
              timeoutSeconds: 5
              failureThreshold: 3
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}

resource containerAppFineCollectionService 'Microsoft.App/containerApps@2022-03-01' = {
  name: containerAppFineCollectionServiceObject.name
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    managedEnvironmentId: containerAppEnvironment.id
    configuration: {
      dapr: {
        enabled: true
        appId: containerAppFineCollectionServiceObject.appId
        appPort: containerAppFineCollectionServiceObject.appPort
        appProtocol: 'http'
      }
      registries: [
        {
          server: containerRegistry.properties.loginServer
          username: containerRegistry.listCredentials().username
          passwordSecretRef: containerRegistryPasswordSecretName
        }
      ]
      secrets: [
        {
          name: containerRegistryPasswordSecretName
          value: containerRegistry.listCredentials().passwords[0].value
        }
      ]
    }
    template: {
      containers: [
        {
          name: containerAppFineCollectionServiceObject.appId
          image: '${containerRegistry.properties.loginServer}/${containerAppFineCollectionServiceObject.repositoryName}:${containerAppFineCollectionServiceObject.imageTag}'
          resources: {
            cpu: containerAppFineCollectionServiceObject.cpu
            memory: containerAppFineCollectionServiceObject.memory
          }
          probes: [
            {
              type: 'Readiness'
              httpGet: {
                path: '/healthz'
                port: containerAppFineCollectionServiceObject.appPort
              }
              initialDelaySeconds: 30
              periodSeconds: 10
              timeoutSeconds: 5
              failureThreshold: 3
            }
            {
              type: 'Liveness'
              httpGet: {
                path: '/healthz'
                port: containerAppFineCollectionServiceObject.appPort
              }
              initialDelaySeconds: 30
              periodSeconds: 10
              timeoutSeconds: 5
              failureThreshold: 3
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}

resource containerAppTrafficControlService 'Microsoft.App/containerApps@2022-03-01' = {
  name: containerAppTrafficControlServiceObject.name
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    managedEnvironmentId: containerAppEnvironment.id
    configuration: {
      dapr: {
        enabled: true
        appId: containerAppTrafficControlServiceObject.appId
        appPort: containerAppTrafficControlServiceObject.appPort
        appProtocol: 'http'
      }
      registries: [
        {
          server: containerRegistry.properties.loginServer
          username: containerRegistry.listCredentials().username
          passwordSecretRef: containerRegistryPasswordSecretName
        }
      ]
      secrets: [
        {
          name: containerRegistryPasswordSecretName
          value: containerRegistry.listCredentials().passwords[0].value
        }
      ]
    }
    template: {
      containers: [
        {
          name: containerAppTrafficControlServiceObject.appId
          image: '${containerRegistry.properties.loginServer}/${containerAppTrafficControlServiceObject.repositoryName}:${containerAppTrafficControlServiceObject.imageTag}'
          resources: {
            cpu: containerAppTrafficControlServiceObject.cpu
            memory: containerAppTrafficControlServiceObject.memory
          }
          probes: [
            {
              type: 'Readiness'
              httpGet: {
                path: '/healthz'
                port: containerAppTrafficControlServiceObject.appPort
                scheme: 'HTTP'
              }
              initialDelaySeconds: 30
              periodSeconds: 10
              timeoutSeconds: 5
              failureThreshold: 3
            }
            {
              type: 'Liveness'
              httpGet: {
                path: '/healthz'
                port: containerAppTrafficControlServiceObject.appPort
                scheme: 'HTTP'
              }
              initialDelaySeconds: 30
              periodSeconds: 10
              timeoutSeconds: 5
              failureThreshold: 3
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}

output containerAppTrafficControlServiceName string = containerAppTrafficControlService.name
output containerAppFineCollectionServiceName string = containerAppFineCollectionService.name
output containerAppVehicleRegistrationServiceName string = containerAppVehicleRegistrationService.name
