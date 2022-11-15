@description('Cosmos DB account name, max length 44 characters, lowercase')
param accountName string

var accountName_var = toLower(accountName)

resource accountName_resource 'Microsoft.DocumentDB/databaseAccounts@2021-01-15' existing = {
  name: accountName_var
}

output accountEndpoint string = accountName_resource.properties.documentEndpoint
output connString string = accountName_resource.listConnectionStrings().connectionStrings[0].connectionString
