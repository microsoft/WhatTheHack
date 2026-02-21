@description('The name of the Azure Document Intelligence.')
param name string

@description('Location where the Azure Document Intelligence will be created.')
param location string

@description('Custom subdomain name for the Azure Document Intelligence.')
param customSubDomainName string

@description('Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources.')
param userObjectId string = ''

resource account 'Microsoft.CognitiveServices/accounts@2025-09-01' = {
  name: name
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'FormRecognizer'
  properties: {   
    customSubDomainName: customSubDomainName
    
  }
}

// Cognitive Services Data Reader role - required for reading Cognitive Services data plane resources
// https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#ai--machine-learning
resource cognitiveServicesDataReaderRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b59867f0-fa02-499b-be73-45a86b5b3e1c'
  scope: subscription()
}

// This role assignment grants the user permissions to read Cognitive Services data plane resources
resource cognitiveServicesDataReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(userObjectId)) {
  name: guid(account.id, cognitiveServicesDataReaderRoleDefinition.id, userObjectId)
  scope: account
  properties: {
    roleDefinitionId: cognitiveServicesDataReaderRoleDefinition.id
    principalType: 'User'
    principalId: userObjectId
  }
}

output endpoint string = account.properties.endpoint
