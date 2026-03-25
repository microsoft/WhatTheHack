// param resources_AzureNativeNewRelic_externalid string = '/subscriptions/${subscription().subscriptionId}/resourceGroups/newrelic-gameday/providers/Microsoft.SaaS/resources/AzureNativeNewRelic'

// @description('The name of the New Relic resource.')
// param name string

// @description('Location where the Azure Open AI will be created.')
// param location string

// param newRelicAccountId string
// param newRelicOrganizationId string

// resource monitors_NewRelicResource_GameDay_name_resource 'NewRelic.Observability/monitors@2025-05-01-preview' = {
//   name: name
//   location: location
//   identity: {
//     type: 'SystemAssigned'
//   }
//   properties: {
//     orgCreationSource: 'LIFTR'
//     accountCreationSource: 'LIFTR'
//     newRelicAccountProperties: {
//       accountInfo: {
//         accountId: newRelicAccountId
//       }
//       organizationInfo: {
//         organizationId: newRelicOrganizationId
//       }
//     }
//     userInfo: {
//       firstName: 'Harry'
//       lastName: 'Kimpel'
//       emailAddress: 'harry@kimpel.com'
//       phoneNumber: '+49 8841-6726777'
//     }
//     planData: {
//       usageType: 'PAYG'
//       billingCycle: 'MONTHLY'
//       planDetails: 'newrelic-pay-as-you-go-free-live@TIDn7ja87drquhy@PUBIDnewrelicinc1635200720692.newrelic_liftr_payg_2025'
//       effectiveDate: '2026-01-13T06:47:27.061Z'
//     }
//     saaSData: {
//       saaSResourceId: resources_AzureNativeNewRelic_externalid
//     }
//   }
// }

// resource monitors_NewRelicResource_GameDay_name_default 'NewRelic.Observability/monitors/monitoredSubscriptions@2025-05-01-preview' = {
//   parent: monitors_NewRelicResource_GameDay_name_resource
//   name: 'default'
//   properties: {
//     patchOperation: 'AddBegin'
//     monitoredSubscriptionList: []
//   }
// }

// resource NewRelic_Observability_monitors_tagRules_monitors_NewRelicResource_GameDay_name_default 'NewRelic.Observability/monitors/tagRules@2025-05-01-preview' = {
//   parent: NewRelicMonitorResource
//   name: 'default'
//   properties: {
//     logRules: {
//       sendAadLogs: 'Disabled'
//       sendSubscriptionLogs: 'Disabled'
//       sendActivityLogs: 'Enabled'
//       filteringTags: []
//     }
//     metricRules: {
//       sendMetrics: 'Enabled'
//       filteringTags: []
//     }
//   }
// }
