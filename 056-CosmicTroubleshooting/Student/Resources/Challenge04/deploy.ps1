param(
    [Parameter(Mandatory = $true)]
    ${resource-group-name[rg-wth-azurecosmosdb]}
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
    -Name "Challenge04-PS" `
    -Location $parameters.parameters.location.value `
    -TemplateFile WTHAzureCosmosDB.IaC\main.bicep `
    -TemplateParameterFile WTHAzureCosmosDB.IaC\main.parameters.json `
    -resourceGroupName ${resource-group-name[rg-wth-azurecosmosdb]}