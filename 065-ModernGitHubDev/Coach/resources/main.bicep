@minLength(3)
@maxLength(11)
param namePrefix string

param location string = resourceGroup().location

resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
  name: '${namePrefix}cosmos'
  kind: 'MongoDB'
  location: location
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    apiProperties: {
      serverVersion: '4.0'
    }
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
  }

  resource database 'mongodbDatabases' = {
    name: 'Pets'
    properties: {
      resource: {
        id: 'Pets'
      }
    }

    resource list 'collections' = {
      name: 'PetList'
      properties: {
        resource: {
          id: 'PetList'
          shardKey: {
            _id: 'Hash'
          }
          indexes: [
            {
              key: {
                keys: [
                  '_id'
                ]
              }
            }
          ]
        }
      }
    }
  }
}

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: '${namePrefix}loganalytics'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource containerRegistry 'microsoft.containerregistry/registries@2021-12-01-preview' = {
  name: '${namePrefix}acr'
  location: location
  properties: {
    adminUserEnabled: true
  }
  sku: {
    name: 'Basic'
  }
}

resource conatinerAppEnvironment 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: '${namePrefix}containerappenvironment'
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalytics.properties.customerId
        sharedKey: logAnalytics.listKeys().primarySharedKey
      }
    }
  }
}

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: '${namePrefix}containerapp'
  location: location
  properties: {
    managedEnvironmentId: conatinerAppEnvironment.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80
        allowInsecure: false
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
      registries: [
        {
          server: containerRegistry.name
          username: containerRegistry.properties.loginServer
          passwordSecretRef: 'container-registry-password'
        }
      ]
      secrets: [
        {
          name: 'container-registry-password'
          value: containerRegistry.listCredentials().passwords[0].value
        }
        {
          name: 'cosmosdb-connection-string'
          value: cosmos.listConnectionStrings().connectionStrings[0].connectionString
        }
      ]
    }
    template: {
      containers: [
        {
          name: '${namePrefix}containerapp'
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          env: [
            {
              name: 'MONGODB_URI'
              secretRef: 'cosmosdb-connection-string'
            }
          ]
          resources: {
            cpu: '0.5'
            memory: '1.0Gi'
          }
        }
      ]
    }  
  }
}
