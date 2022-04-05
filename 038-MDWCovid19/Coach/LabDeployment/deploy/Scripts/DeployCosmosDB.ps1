param (
    [string]$databaseName,
    [string]$covid19BaseUri,
    [string]$databaseBackupName,
    [string]$sqlUserName,
    [string]$sqlPassword,
    [string]$cosmosDBConnectionString,
    [string]$cosmosDBDatabaseName
)

$dataFolder = "data/"
$covidFileName = "covid_policy_tracker.csv"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://github.com/Azure/azure-documentdb-datamigrationtool/releases/download/1.8.3/azure-documentdb-datamigrationtool-1.8.3.zip -OutFile dt1.8.3.zip
Expand-Archive -Path dt1.8.3.zip -DestinationPath .
$dtutil = Get-ChildItem -Recurse | Where-Object { $_.Name -ieq "Dt.exe" }
$env:path += ";$($dtutil.DirectoryName)"
$azcopy = Get-ChildItem -Recurse | Where-Object { $_.Name -ieq "azcopy.exe" }
$env:path += ";$($azcopy.DirectoryName)"

Invoke-WebRequest -Uri "$($covid19BaseUri)$($dataFolder)$($covidFileName)" -OutFile $($covidFileName)
dt.exe /s:CsvFile /s.Files:.\$($covidFileName) /t:DocumentDBBulk /t.ConnectionString:"$($cosmosDBConnectionString);Database=$($cosmosDBDatabaseName)" /t.Collection:covidpolicy /t.CollectionThroughput:10000
