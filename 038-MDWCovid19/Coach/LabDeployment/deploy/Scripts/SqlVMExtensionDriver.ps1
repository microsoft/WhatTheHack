param (
    [string]$ohmdwSqlserverName,    
    [string]$databaseName,
    [string]$covid19BaseUri,
    [string]$databaseDacPacName,
    [string]$databaseBackupName,
    [string]$sqlUserName,
    [string]$sqlPassword,
    [string]$cosmosDBConnectionString,
    [string]$cosmosDBDatabaseName
)

.\DeploySQLVM.ps1 -ohmdwSqlserverName $ohmdwSqlserverName `
    -databaseName $databaseName `
    -covid19BaseUri $covid19BaseUri `
    -databaseDacPacName $databaseDacPacName `
    -databaseBackupName $databaseBackupName `
    -sqlUserName $sqlUserName `
    -sqlPassword $sqlPassword

.\DeployCosmosDB.ps1 -databaseName $databaseName `
    -covid19BaseUri $covid19BaseUri `
    -databaseBackupName $databaseBackupName `
    -sqlUserName $sqlUserName `
    -sqlPassword $sqlPassword `
    -cosmosDBConnectionString $cosmosDBConnectionString `
    -cosmosDBDatabaseName $cosmosDBDatabaseName

.\DisableIEESC.ps1