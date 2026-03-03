using './main.bicep'

param location = 'eastus'
param freeTier = true
param tags = {
  environment: 'development'
  iac: 'bicep'
  workload: 'mflix'
}
