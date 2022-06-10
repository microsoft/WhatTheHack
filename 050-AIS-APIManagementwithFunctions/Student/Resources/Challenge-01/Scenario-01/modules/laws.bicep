@description('The name of the Log Analytics resource')
param log_analytics_workspace_name string

@description('The name of the Application Insights resource')
param app_insights_name string

@description('The location where the resource would be created')
param location string

resource log_analytics_workspace_name_resource 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: log_analytics_workspace_name
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource appInsightsResource 'Microsoft.Insights/components@2020-02-02' = {
  name: app_insights_name
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: log_analytics_workspace_name_resource.id
  }
}



output logAnalyticsWorkspaceId string = log_analytics_workspace_name_resource.id 
output appInsightsResourceId string = appInsightsResource.id
output appInsightsInstrumentationKey string = appInsightsResource.properties.InstrumentationKey
