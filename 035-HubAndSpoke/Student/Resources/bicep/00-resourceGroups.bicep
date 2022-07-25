param location string = 'eastus2'

targetScope = 'subscription'
//hub resources
resource wthrghub 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'wth-rg-hub'
  location: location
}

resource wthrgspoke01 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'wth-rg-spoke01'
  location: location
}

resource wthrgspoke02 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'wth-rg-spoke02'
  location: location
}

resource wthrgonprem 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'wth-rg-onprem01'
  location: location
}
