Param(
    [parameter(Mandatory=$true)][string]$resourceGroup,
    [parameter(Mandatory=$true)][string]$cosmosDbAccountName
)

Push-Location $($MyInvocation.InvocationName | Split-Path)
Push-Location ..
Remove-Item -Path dMT -Recurse -Force -ErrorAction Ignore
New-Item -ItemType Directory -Force -Path "dMT"
Push-Location "dMT"

$dmtUrl="https://github.com/AzureCosmosDB/data-migration-desktop-tool/releases/download/2.1.1/dmt-2.1.1-win-x64.zip"
Invoke-WebRequest -Uri $dmtUrl -OutFile dmt.zip
Expand-Archive -Path dmt.zip -DestinationPath .
Push-Location "windows-package"
Copy-Item -Path "../../migrationsettings.json" -Destination "./migrationsettings.json" -Force

#Write-Host "Bumping up the throughput on the customer container to avoid a known DMT issue..."
#az cosmosdb sql container throughput update --account-name $cosmosDbAccountName --database-name vsai-database --name customer --resource-group $resourceGroup --max-throughput 2000

& "./dmt.exe"

#Write-Host "Restoring the throughput on the customer container..."
#az cosmosdb sql container throughput update --account-name $cosmosDbAccountName --database-name vsai-database --name customer --resource-group $resourceGroup --max-throughput 1000

Pop-Location
Pop-Location
Pop-Location
Pop-Location
