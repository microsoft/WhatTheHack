param baseName string = 'wth'
param databaseName string = 'petclinic'
param userName string = 'petclinic'
@secure()
param password string = concat('P', uniqueString(resourceGroup().id), 'x!')
param clientIp string


// Default location for the resources
var location = resourceGroup().location
var resourceSuffix = substring(concat(baseName, uniqueString(resourceGroup().id)), 0, 8)

resource mysql 'Microsoft.DBForMySQL/servers@2017-12-01' = {
  name: 'mysql-${resourceSuffix}'
  location: location
  properties: {
    createMode: 'Default'
    administratorLogin: userName
    administratorLoginPassword: password
  }
}

resource firewallAzure 'Microsoft.DBForMySQL/servers/firewallRules@2017-12-01' = {
  name: '${mysql.name}/AllowAzureIPs'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource firewallClient 'Microsoft.DBForMySQL/servers/firewallRules@2017-12-01' = {
  name: '${mysql.name}/AllowClientIP'
  properties: {
    startIpAddress: clientIp
    endIpAddress: clientIp
  }
}

resource database 'Microsoft.DBForMySQL/servers/databases@2017-12-01' = {
  name: '${mysql.name}/${databaseName}'
}

output jdbcUrl string = 'jdbc:mysql://${mysql.name}.mysql.database.azure.com:3306/${databaseName}?useSSL=true&requireSSL=false&serverTimezone=UTC'
output userName string = '${userName}@${mysql.name}'
output password string = password