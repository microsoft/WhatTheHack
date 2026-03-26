using './source-db.bicep'

param location = 'eastus2'
param administratorLogin = 'mflixadmin'
param administratorPassword = ''
param sourceMongoDbCpuCores = 2
param sourceMongoDbMemoryGb = 4
param tags = {
  environment: 'development'
  iac: 'bicep'
  workload: 'mflix'
}
