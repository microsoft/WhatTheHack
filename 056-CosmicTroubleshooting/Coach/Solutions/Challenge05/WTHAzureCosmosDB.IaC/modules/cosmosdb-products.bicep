@description('Cosmos DB account name, max length 44 characters, lowercase')
param accountName string

param primaryRegion string
param secondaryRegion string

var accountName_var = toLower(accountName)

var locations = [
  {
    locationName: primaryRegion
    failoverPriority: 0
    isZoneRedundant: false
  }
  {
    locationName: secondaryRegion
    failoverPriority: 1
    isZoneRedundant: false
  }
]

resource accountName_resource 'Microsoft.DocumentDB/databaseAccounts@2021-01-15' = {
  name: accountName_var
  location: toLower(primaryRegion)
  properties: {
    locations: locations
    databaseAccountOfferType: 'Standard'
    enableMultipleWriteLocations: true
    enableAnalyticalStorage: true
  }
}

output accountEndpoint string = accountName_resource.properties.documentEndpoint
output connString string = accountName_resource.listConnectionStrings().connectionStrings[0].connectionString
