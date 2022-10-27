param Location string
param AppInsightsName string
param laWsId string

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: AppInsightsName
  location: Location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Bluefield'
    Request_Source: 'rest'
    WorkspaceResourceId: laWsId
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

output Name string = appInsights.name
output ResourceId string = appInsights.id
