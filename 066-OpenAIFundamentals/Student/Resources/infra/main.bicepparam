using './main.bicep'


param userObjectId = '<user-object-id>'
param keyVaultEnablePurgeProtection = false
param acrEnabled = false
param nspEnabled = false
//The first model in the list will be the default model for the Jupyter notebooks
param openAiDeployments = [
{
    model: {
      name: 'gpt-4o'
      version: '2024-08-06'
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
]
param tags = {
  environment: 'development'
  iac: 'bicep'
}
