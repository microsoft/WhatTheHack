@description('The name of the Azure Document Intelligence.')
param name string

@description('Location where the Azure Document Intelligence will be created.')
param location string

@description('Custom subdomain name for the Azure Document Intelligence.')
param customSubDomainName string

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

output endpoint string = account.properties.endpoint
