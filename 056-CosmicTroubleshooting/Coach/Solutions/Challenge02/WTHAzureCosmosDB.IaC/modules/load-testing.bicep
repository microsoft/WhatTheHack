param loadTestingName string

resource loadtestingName_resource 'Microsoft.LoadTestService/loadtests@2022-04-15-preview' existing = {
  name: loadTestingName
}

output loadtestingId string = loadtestingName_resource.id
output loadtestingNameDataPlaneUri string = loadtestingName_resource.properties.dataPlaneURI
