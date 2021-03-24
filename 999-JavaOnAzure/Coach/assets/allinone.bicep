param baseName string = 'wth'
param appInsightsAgentVersion string = '3.0.2'
param clientIp string

var agentConfig = '-javaagent:/home/site/wwwroot/applicationinsights-agent-${appInsightsAgentVersion}.jar'

module mysql './mysql.bicep' = {
  name: 'mysql'
  params: {
    baseName: baseName
    clientIp: clientIp
  }
}

module webApp './webapp.bicep' = {
  name: 'webapp'
  params: {
    baseName: baseName
    mysqlUser: mysql.outputs.userName
    mysqlPassword: mysql.outputs.password
    mysqlUrl: mysql.outputs.jdbcUrl
  }
}

module keyVault './keyvault.bicep' = {
  name: 'keyvault'
  params: {
    baseName: baseName
    mysqlUser: mysql.outputs.userName
    mysqlPassword: mysql.outputs.password
    mysqlUrl: mysql.outputs.jdbcUrl    
  }
  dependsOn: [
    webApp
  ]
}

module appInsights './appinsights.bicep' = {
  name: 'appinsights'
  params: {    
    baseName: baseName
  }
  dependsOn: [
    keyVault
  ]
}

module webAppSettings './appsettings.bicep' = {
  name: 'appsettings'
  params: {
    webAppName: webApp.outputs.webAppName
    mysqlUrl: keyVault.outputs.mysqlUrl
    mysqlUser: keyVault.outputs.mysqlUser
    mysqlPassword: keyVault.outputs.mysqlPassword
    appInsightsConnStr: appInsights.outputs.appInsights
    javaOpts: '-Dspring.profiles.active=mysql ${agentConfig}'
  }
  dependsOn: [
    appInsights
  ]
}

module dashboard './dashboard.bicep' = {
  name: 'dashboard'
  params: {
    baseName: baseName
  }
  dependsOn: [
    appInsights
  ]
}

module autoscale './autoscale.bicep' = {
  name: 'autoscale'
  params: {
    baseName: baseName
  }
  dependsOn: [
    webApp
  ]
}

output webAppName string = webApp.outputs.webAppName
