param loadTestingName string

resource loadtestingName_resource 'Microsoft.LoadTestService/loadTests@2022-12-01' existing = {
  name: loadTestingName
}

output loadtestingId string = loadtestingName_resource.id
output loadtestingNameDataPlaneUri string = loadtestingName_resource.properties.dataPlaneURI
