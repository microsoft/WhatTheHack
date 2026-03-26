using './main.bicep'

param location = 'eastus2'
param administratorLogin = 'mflixadmin'
param administratorPassword = ''
param serverVersion = '7.0'
param computeTier = 'M20'
param storageSizeGb = 32
param shardCount = 1
param highAvailabilityTargetMode = 'Disabled'
param publicNetworkAccess = 'Enabled'
param tags = {
  environment: 'development'
  iac: 'bicep'
  workload: 'mflix'
}
