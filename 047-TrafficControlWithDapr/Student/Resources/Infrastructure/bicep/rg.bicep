param appName string
param region string
param environment string
param adminUsername string
param publicSSHKey string

targetScope = 'subscription'

var longName = '${appName}-${environment}'
var rgName = 'rg-${longName}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: region
}

output resourceGroupName string = rgName
