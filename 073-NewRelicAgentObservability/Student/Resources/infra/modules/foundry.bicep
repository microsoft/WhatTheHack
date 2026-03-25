@description('The name of the Microsoft Foundry.')
param name string

@description('Location where the Azure Open AI will be created.')
param location string

param foundryDefaultProject string = 'gameday-project'

resource accounts_foundry_gameday_name_resource 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
  name: name
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'AIServices'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    apiProperties: {}
    customSubDomainName: name
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    allowProjectManagement: true
    defaultProject: foundryDefaultProject
    associatedProjects: [
      foundryDefaultProject
    ]
    publicNetworkAccess: 'Enabled'
  }
}

resource accounts_foundry_gameday_name_project_gameday 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' = {
  parent: accounts_foundry_gameday_name_resource
  name: foundryDefaultProject
  location: location
  //kind: 'AIServices'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    description: 'Default project created with the resource'
    displayName: foundryDefaultProject
  }
}

// resource accounts_foundry_gameday_name_Default 'Microsoft.CognitiveServices/accounts/defenderForAISettings@2025-06-01' = {
//   parent: accounts_foundry_gameday_name_resource
//   name: 'Default'
//   properties: {
//     state: 'Disabled'
//   }
// }

// resource accounts_foundry_gameday_name_gpt_4_1_nano 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
//   parent: accounts_foundry_gameday_name_resource
//   name: 'gpt-4.1-nano'
//   sku: {
//     name: 'GlobalStandard'
//     capacity: 100
//   }
//   properties: {
//     model: {
//       format: 'OpenAI'
//       name: 'gpt-4.1-nano'
//       version: '2025-04-14'
//     }
//     versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
//     currentCapacity: 100
//     raiPolicyName: 'Microsoft.DefaultV2'
//   }
// }

// resource accounts_foundry_gameday_name_gpt_4o_mini 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
//   parent: accounts_foundry_gameday_name_resource
//   name: 'gpt-4o-mini'
//   sku: {
//     name: 'GlobalStandard'
//     capacity: 100
//   }
//   properties: {
//     model: {
//       format: 'OpenAI'
//       name: 'gpt-4o-mini'
//       version: '2024-07-18'
//     }
//     versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
//     currentCapacity: 100
//     raiPolicyName: 'Microsoft.DefaultV2'
//   }
// }

resource accounts_foundry_gameday_name_gpt_5_mini 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
  parent: accounts_foundry_gameday_name_resource
  name: 'gpt-5-mini'
  sku: {
    name: 'GlobalStandard'
    capacity: 100
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-5-mini'
      version: '2025-08-07'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    currentCapacity: 100
    raiPolicyName: 'Microsoft.DefaultV2'
  }
}

// resource accounts_foundry_gameday_name_gpt_5_nano 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
//   parent: accounts_foundry_gameday_name_resource
//   name: 'gpt-5-nano'
//   sku: {
//     name: 'GlobalStandard'
//     capacity: 100
//   }
//   properties: {
//     model: {
//       format: 'OpenAI'
//       name: 'gpt-5-nano'
//       version: '2025-08-07'
//     }
//     versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
//     currentCapacity: 100
//     raiPolicyName: 'Microsoft.DefaultV2'
//   }
// }

// resource accounts_foundry_gameday_name_o4_mini 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
//   parent: accounts_foundry_gameday_name_resource
//   name: 'o4-mini'
//   sku: {
//     name: 'GlobalStandard'
//     capacity: 100
//   }
//   properties: {
//     model: {
//       format: 'OpenAI'
//       name: 'o4-mini'
//       version: '2025-04-16'
//     }
//     versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
//     currentCapacity: 100
//     raiPolicyName: 'Microsoft.DefaultV2'
//   }
// }

// resource accounts_foundry_gameday_name_Phi_4_mini_reasoning 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
//   parent: accounts_foundry_gameday_name_resource
//   name: 'Phi-4-mini-reasoning'
//   sku: {
//     name: 'GlobalStandard'
//     capacity: 1
//   }
//   properties: {
//     model: {
//       format: 'Microsoft'
//       name: 'Phi-4-mini-reasoning'
//       version: '1'
//     }
//     versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
//     currentCapacity: 1
//     raiPolicyName: 'Microsoft.DefaultV2'
//   }
// }

// resource accounts_foundry_gameday_name_Microsoft_Default 'Microsoft.CognitiveServices/accounts/raiPolicies@2025-06-01' = {
//   parent: accounts_foundry_gameday_name_resource
//   name: 'Microsoft.Default'
//   properties: {
//     mode: 'Blocking'
//     contentFilters: [
//       {
//         name: 'Hate'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Prompt'
//       }
//       {
//         name: 'Hate'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Completion'
//       }
//       {
//         name: 'Sexual'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Prompt'
//       }
//       {
//         name: 'Sexual'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Completion'
//       }
//       {
//         name: 'Violence'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Prompt'
//       }
//       {
//         name: 'Violence'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Completion'
//       }
//       {
//         name: 'Selfharm'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Prompt'
//       }
//       {
//         name: 'Selfharm'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Completion'
//       }
//     ]
//   }
// }

// resource accounts_foundry_gameday_name_Microsoft_DefaultV2 'Microsoft.CognitiveServices/accounts/raiPolicies@2025-06-01' = {
//   parent: accounts_foundry_gameday_name_resource
//   name: 'Microsoft.DefaultV2'
//   properties: {
//     mode: 'Blocking'
//     contentFilters: [
//       {
//         name: 'Hate'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Prompt'
//       }
//       {
//         name: 'Hate'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Completion'
//       }
//       {
//         name: 'Sexual'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Prompt'
//       }
//       {
//         name: 'Sexual'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Completion'
//       }
//       {
//         name: 'Violence'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Prompt'
//       }
//       {
//         name: 'Violence'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Completion'
//       }
//       {
//         name: 'Selfharm'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Prompt'
//       }
//       {
//         name: 'Selfharm'
//         severityThreshold: 'Medium'
//         blocking: true
//         enabled: true
//         source: 'Completion'
//       }
//       {
//         name: 'Jailbreak'
//         blocking: true
//         enabled: true
//         source: 'Prompt'
//       }
//       {
//         name: 'Protected Material Text'
//         blocking: true
//         enabled: true
//         source: 'Completion'
//       }
//       {
//         name: 'Protected Material Code'
//         blocking: false
//         enabled: true
//         source: 'Completion'
//       }
//     ]
//   }
// }

#disable-next-line outputs-should-not-contain-secrets
//output key1 string = accounts_foundry_gameday_name_resource.listKeys().key1
//output endpoint string = accounts_foundry_gameday_name_resource.properties.endpoint
