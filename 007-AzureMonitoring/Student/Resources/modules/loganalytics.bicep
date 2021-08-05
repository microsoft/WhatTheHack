param Datasources array
param Location string
param Name string
param Solutions array


resource workspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: Name
  location: Location
  properties: {
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource datasources 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = [for Datasource in Datasources: {
  name: Datasource.name
  kind: Datasource.kind
  properties: Datasource.properties
  dependsOn:[
    workspace
  ]
}]

resource solutions 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = [for Solution in Solutions: {
  name: Solution.name
  location: Location
  properties: {
    workspaceResourceId: workspace.id
  }
  plan: {
    name: Solution.name
    product: 'OMSGallery/${Solution.marketplaceName}'
    promotionCode: ''
    publisher: 'Microsoft'
  }
  dependsOn:[
    workspace
    datasources
  ]
}]

output Name string = workspace.name
output ResourceId string = workspace.id
output CustomerId string =  workspace.properties.customerId
output Key string = listKeys(workspace.id,'2020-08-01').primarySharedKey
