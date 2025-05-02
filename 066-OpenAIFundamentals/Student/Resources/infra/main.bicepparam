using './main.bicep'


param userObjectId = '<user-object-id>'
param keyVaultEnablePurgeProtection = false
param acrEnabled = false
param nspEnabled = false
param openAiDeployments = [
  {
    model: {
      name: 'text-embedding-ada-002'
      version: '2'
    }
    sku: {
      name: 'Standard'
      capacity: 10
    }
  }
  {
    model: {
      name: 'gpt-4'
      version: 'turbo-2024-04-09'
    }
    sku: {
      name: 'Standard'
      capacity: 10
    }
  }
  {
    model: {
      name: 'gpt-35-turbo'
      version: '0125'
    }
    sku: {
      name: ''
      capacity: 10
    }
  }
]
param tags = {
  environment: 'development'
  iac: 'bicep'
}
