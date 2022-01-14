@description('The edition of Azure API Management to use. This must be an edition that supports VNET Integration. This selection can have a significant impact on consumption cost and \'Developer\' is recommended for non-production use.')
@allowed([
  'Developer'
  'Premium'
])
param apim_sku string 

@description('The number of Azure API Management capacity units to provision. For Developer edition, this must equal 1.')
param apim_capacity int 

@description('Descriptive name for publisher to be used in the portal')
param apim_publisher_name string 

@description('Email adddress associated with publisher')
param apim_publisher_email string 

@description('The name of the API Management resource')
param apim_name string

@description('The reference to the APIM subnet')
param subnetResourceId string

@description('The reference to the Application Insights resource')
param appInsightsResourceId string

@description('The instrumentation key of the Application Insights resource')
param appInsightsInstrumentationKey string

@description('The refrence to the Log Analytics workspace resource')
param log_analytics_workspace_id string

@description('The location where the resource would be created')
param location string


resource apimResource 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: apim_name
  location: location
  sku: {
    name: apim_sku
    capacity: apim_capacity
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publisherName: apim_publisher_name
    publisherEmail: apim_publisher_email
    virtualNetworkType: 'Internal'
    virtualNetworkConfiguration: {
      subnetResourceId: subnetResourceId
    }
  }
}

resource apim_name_my_gateway 'Microsoft.ApiManagement/service/gateways@2021-08-01' = {
  parent: apimResource
  name: 'my-gateway'
  properties: {
    locationData: {
      name: 'My internal location'
    }
    description: 'Self hosted gateway bringing API Management to the edge'
  }
}

resource apim_name_AppInsightsLogger 'Microsoft.ApiManagement/service/loggers@2021-08-01' = {
  parent: apimResource
  name: 'AppInsightsLogger'
  properties: {
    loggerType: 'applicationInsights'
    resourceId: appInsightsResourceId
    credentials: {
      instrumentationKey: appInsightsInstrumentationKey
    }
  }
}

resource apim_name_applicationinsights 'Microsoft.ApiManagement/service/diagnostics@2021-08-01' = {
  parent: apimResource
  name: 'applicationinsights'
  properties: {
    alwaysLog: 'allErrors'
    httpCorrelationProtocol: 'Legacy'
    verbosity: 'information'
    logClientIp: true
    loggerId: apim_name_AppInsightsLogger.id
    sampling: {
      samplingType: 'fixed'
      percentage: 100
    }
    frontend: {
      request: {
        body: {
          bytes: 0
        }
      }
      response: {
        body: {
          bytes: 0
        }
      }
    }
    backend: {
      request: {
        body: {
          bytes: 0
        }
      }
      response: {
        body: {
          bytes: 0
        }
      }
    }
  }
}

resource Microsoft_Insights_diagnosticSettings_logToAnalytics 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  scope: apimResource
  name: 'logToAnalytics'
  
  properties: {
    workspaceId: log_analytics_workspace_id
    logs: [
      {
        category: 'GatewayLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }

}


output apimName string = apimResource.name
output apimPrivateIpAddresses string = apimResource.properties.privateIPAddresses[0]
