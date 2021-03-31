param webAppName string
param mysqlUrl string
param mysqlUser string
param mysqlPassword string
param javaOpts string = '-Dspring.profiles.active=mysql'
param appInsightsConnStr string = ''

resource webAppSettings 'Microsoft.Web/sites/config@2020-09-01' = {
  name: '${webAppName}/appsettings'
  properties: {
    MYSQL_URL: mysqlUrl
    MYSQL_USER: mysqlUser
    MYSQL_PASS: mysqlPassword
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnStr
    JAVA_OPTS: javaOpts
  }
}
