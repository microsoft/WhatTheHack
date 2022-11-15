param(
    $seedDatabase = $true,
    [Parameter(Mandatory = $true)]
    ${resource-group-name[rg-wth-azurecosmosdb]},
    $showDebugOutput = $false
)
${resource-group-name[rg-wth-azurecosmosdb]} = if (${resource-group-name[rg-wth-azurecosmosdb]}) { ${resource-group-name[rg-wth-azurecosmosdb]} }
else {
    'rg-wth-azurecosmosdb'
}
Write-Host "Installing bicep"
# Install Bicep
# Create the install folder
$installPath = "$env:USERPROFILE\.bicep"
$installDir = New-Item -ItemType Directory -Path $installPath -Force
$installDir.Attributes += 'Hidden'
# Fetch the latest Bicep CLI binary
(New-Object Net.WebClient).DownloadFile("https://github.com/Azure/bicep/releases/latest/download/bicep-win-x64.exe", "$installPath\bicep.exe")
# Add bicep to your PATH
$currentPath = (Get-Item -path "HKCU:\Environment" ).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
if (-not $currentPath.Contains("%USERPROFILE%\.bicep")) { setx PATH ($currentPath + ";%USERPROFILE%\.bicep") }
if (-not $env:path.Contains($installPath)) { $env:path += ";$installPath" }

# Read the bicep parameters
$parameters = Get-Content .\WTHAzureCosmosDB.IaC\main.parameters.json | ConvertFrom-Json
Write-Host "Deploying infrastructure"
# Deploy our infrastructure
$output = New-AzSubscriptionDeployment `
    -Name "Challenge00-PS" `
    -Location $parameters.parameters.location.value `
    -TemplateFile WTHAzureCosmosDB.IaC\main.bicep `
    -TemplateParameterFile WTHAzureCosmosDB.IaC\main.parameters.json `
    -resourceGroupName ${resource-group-name[rg-wth-azurecosmosdb]}

Write-Host "Building and publishing solution"
# Build and publish the solution
dotnet publish WTHAzureCosmosDB.sln -c Release -clp:ErrorsOnly
Compress-Archive -Path .\WTHAzureCosmosDB.Web\bin\Release\net6.0\publish\* deploy.zip -Force

# Publish the web app to azure and clean up
$zipPath = Get-Item .\deploy.zip | % { $_.FullName }
$suppressOutput = Publish-AzWebApp -ArchivePath $zipPath -Name $output.Outputs.webAppName.Value -ResourceGroupName ${resource-group-name[rg-wth-azurecosmosdb]} -Force
Remove-Item deploy.zip


echo "Building and publishing proxy func app solution"
# Build and publish the solution
cd "./WTHAzureCosmosDB.ProxyFuncApp"
dotnet publish "WTHAzureCosmosDB.ProxyFuncApp.csproj" -c "Release" -clp:ErrorsOnly
Compress-Archive -Path .\bin\Release\net6.0\publish\* deploy.zip -Force

# Publish the web app to azure and clean up
$zipPath = Get-Item .\deploy.zip | % { $_.FullName }
$suppressOutput = Publish-AzWebApp -ArchivePath $zipPath -Name $output.Outputs.proxyFuncAppName.Value -ResourceGroupName ${resource-group-name[rg-wth-azurecosmosdb]} -Force
Remove-Item deploy.zip


Set-Location ..\WTHAzureCosmosDB.Console
# Seed the database
if ($seedDatabase) {
    Write-Host "Seeding the Azure Cosmos DB database with data"
    dotnet run /seedProducts /connString $output.Outputs.cosmosDbConnectionString.Value -clp:ErrorsOnly
}

$bicepDeploymentOutputs = $output.Outputs

Set-Location ..


# Set up load testing service

Write-Host "Setting up a load testing service..."

$loadtestingId = $output.Outputs.loadtestingId.Value
$loadTestFilename = $output.Outputs.loadTestingNewTestFileId.Value
$loadTestNewTestId = $output.Outputs.loadTestingNewTestId.Value

$loadTestingTestEndpoint = "https://" + $output.Outputs.loadTestingDataPlaneUri.Value + "/loadtests/" + $loadTestNewTestId


$tokenResourceUrl = "https://loadtest.azure-dev.com"
$azToken = (Get-AzAccessToken -Resource $tokenResourceUrl)

# As first we create a test

$createTestInvokeParams = @{
    'Uri'     = "${loadTestingTestEndpoint}?api-version=2022-06-01-preview"
    'Method'  = 'PATCH'
    'Headers' = @{ 
        'Authorization' = $azToken.Type + ' ' + $azToken.Token 
        'content-type'  = 'application/merge-patch+json'
    }
    'Body'    = (@{
            description                   = "A test to simulate load to eshop";
            displayName                   = "Eshop users load";
            environmentVariables          = @{};
            resourceId                    = $loadtestingId;
            secrets                       = @{};
            subnet                        = $null;
            keyvaultReferenceIdentityId   = $null;
            keyvaultReferenceIdentityType = "SystemAssigned";
            loadTestConfig                = @{
                engineInstances = 4;
                splitAllCSVs    = $FALSE;
            }
            passFailCriteria              = @{
                passFailMetrics = @{

                }
            }
            testId                        = $loadTestNewTestId;

        } | ConvertTo-Json)
}

$output = Invoke-RestMethod @createTestInvokeParams -StatusCodeVariable "statusCode"

if ( [int]($statusCode) -ne 200 -and [int]($statusCode) -ne 201) {
    Write-Error -Message "Azure Load Testing dataplane returned different status code (${statusCode}, was expecting 200 or 201) for test creation.\n${output}" -ErrorAction Stop
}

# next is uploading a file
$loadTestingTestFilesEndpoint = $loadTestingTestEndpoint + "/files/" + $loadTestFilename + "?fileType=0&api-version=2022-06-01-preview"
if ($showDebugOutput) {
    Write-Host "Load testing files endpoing: "
    Write-Host $loadTestingTestFilesEndpoint
}

$uploadInvokeParams = @{
    'Uri'    = $loadTestingTestFilesEndpoint
    'Method' = 'PUT'   
}

$uploadInvokeForm = @{
    file = Get-Item -Path './WTHAzureCosmosDB.IaC/simulate-load-eshop.jmx'
}

$output = Invoke-RestMethod @uploadInvokeParams -Form $uploadInvokeForm -StatusCodeVariable "statusCode" -Authentication $azToken.Type -Token (ConvertTo-SecureString $azToken.Token  -AsPlainText)

if ( [int]($statusCode) -ne 200 -and [int]($statusCode) -ne 201) {
    Write-Error -Message "Azure Load Testing dataplane returned different status code (${statusCode}, was expecting 200 or 201) for test plan upload.\n${output}" -ErrorAction Stop
}

# waiting for test validation
Write-Host "Waiting for test plan validation by Azure..."
$waitForResultUpToMinutes = 2

$ts = New-TimeSpan -Days 0 -Hours 0 -Minutes $waitForResultUpToMinutes
$waitUntilDatetime = (get-date) + $ts

$testPlanStatus = "VALIDATION_INITIATED";

while ((get-date) -lt $waitUntilDatetime) {
    
    if ($azToken.ExpiresOn -lt (get-date) ) {
        Write-Host "Refreshing access token..."
        $azToken = (Get-AzAccessToken -Resource $tokenResourceUrl);
    }


    $getTestInfoInvokeParams = @{
        'Uri'     = "${loadTestingTestEndpoint}?api-version=2022-06-01-preview"
        'Method'  = 'GET'
        'Headers' = @{ 
            'Authorization' = $azToken.Type + ' ' + $azToken.Token
        }
    }
    
    $output = Invoke-RestMethod @getTestInfoInvokeParams -StatusCodeVariable "statusCode"

    
    if ( [int]($statusCode) -ne 200) {
        Write-Error -Message "Azure Load Testing dataplane returned different status code (${statusCode}, was expecting 200) during gathering test plan status.\n${output}" -ErrorAction Stop
    }
    #Write-Progress -Activity "JMX"
    $state = $output.InputArtifacts.TestScriptUrl.validationStatus
    "checking for updates... $state"
    if ($state -eq "") {
        Write-Information "Empty validation status - skipping"
        continue;
    }
    
    if ($state -eq "VALIDATION_SUCCESS") {
        $testPlanStatus = "VALIDATION_SUCCESS"
        break;
    }


    Start-Sleep -Seconds 10
}

if ($testPlanStatus -ne "VALIDATION_SUCCESS" -and $testPlanStatus -eq "VALIDATION_INITIATED") {
    Write-Error -Message "Azure Load Testing JMX test plan validation timeout-ed!" #-ErrorAction Stop - for now we ignore this
}
elseif ($testPlanStatus -ne "VALIDATION_SUCCESS" -and $testPlanStatus -ne "VALIDATION_INITIATED") {
    Write-Error -Message "Azure Load Testing JMX test plan validation failed!"# -ErrorAction Stop- for now we ignore this
}
else {
    # ok
    Write-Host "Azure Load Testing JMX test plan validation completed."
}
