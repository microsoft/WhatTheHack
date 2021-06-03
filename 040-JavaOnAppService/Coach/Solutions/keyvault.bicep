param baseName string = 'wth'

param mysqlUser string
@secure()
param mysqlPassword string
param mysqlUrl string


// Default location for the resources
var location = resourceGroup().location
var resourceSuffix = substring(concat(baseName, uniqueString(resourceGroup().id)), 0, 8)

var mysqlUrlSecretKey = 'secret-mysql-url'
var mysqlUserSecretKey = 'secret-mysql-user'
var mysqlPasswordSecretKey = 'secret-mysql-password'

var mysqlUrlRef = '@Microsoft.KeyVault(SecretUri=${reference(mysqlUrlSecret.id).secretUri})'
var mysqlUserRef = '@Microsoft.KeyVault(SecretUri=${reference(mysqlUserSecret.id).secretUri})'
var mysqlPasswordRef = '@Microsoft.KeyVault(SecretUri=${reference(mysqlPasswordSecret.id).secretUri})'


resource webApp 'Microsoft.Web/sites@2020-06-01' existing = {
  name: 'web-${resourceSuffix}'
}

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: 'kv-${resourceSuffix}'
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
    enabledForTemplateDeployment: true // otherwise we can't deploy through ARM
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: reference(webApp.id, '2018-11-01', 'Full').identity.principalId
        permissions: {
          secrets: [
            'get'
          ]
        }
      }
    ]
  }
}

resource mysqlUrlSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVault.name}/${mysqlUrlSecretKey}'
  properties: {
    value: mysqlUrl
  }
}

resource mysqlUserSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVault.name}/${mysqlUserSecretKey}'
  properties: {
    value: mysqlUser
  }
}

resource mysqlPasswordSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVault.name}/${mysqlPasswordSecretKey}'
  properties: {
    value: mysqlPassword
  }
}

module webAppSettings './appsettings.bicep' = {
  name: 'appsettings'
  params: {
    webAppName: webApp.name
    mysqlUrl: mysqlUrlRef
    mysqlUser: mysqlUserRef
    mysqlPassword: mysqlPasswordRef
  }
}

output keyVaultName string = keyVault.name
output mysqlUrl string = mysqlUrlRef
output mysqlUser string = mysqlUserRef
output mysqlPassword string = mysqlPasswordRef
