param location string
param appInsightsName string 
param resourceTags object

resource laWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: '${appInsightsName}ws'
  location: location
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: laWorkspace.id
  }
  tags: resourceTags
}

output appInsightsInstrumentationKey string = appInsights.properties.InstrumentationKey
output appInsightsResourceId string = appInsights.id
