param (
    [string]$ohmdwSqlserverName,
    [string]$databaseName,
    [string]$covid19BaseUri,
    [string]$databaseDacPacName,
    [string]$databaseBackupName,
    [string]$sqlUserName,
    [string]$sqlPassword
)

$dataFolder = "data/"

# SQL Server restore
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://aka.ms/mdw-oh-azcopy -OutFile azcopy-v10-windows.zip
Expand-Archive -Path azcopy-v10-windows.zip -DestinationPath .
$azcopy = Get-ChildItem -Recurse | Where-Object { $_.Name -ieq "azcopy.exe" }
$env:path += ";$($azcopy.DirectoryName)"

Invoke-WebRequest -Uri "$($covid19BaseUri)$($dataFolder)$($databaseBackupName)" -OutFile $($databaseBackupName)

$localBackupFile = Get-Item "$($databaseBackupName)"
Invoke-Sqlcmd -Username $sqlUserName -Password $sqlPassword -Query "RESTORE DATABASE $($databaseName) FROM DISK = '$($localBackupFile.FullName)' WITH STATS = 5" -ServerInstance "."

# SQL DB restore
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://go.microsoft.com/fwlink/?linkid=2157302 -OutFile sqlpackage-win7-x64-en-US-15.0.5084.2.zip
Expand-Archive -Path sqlpackage-win7-x64-en-US-15.0.5084.2.zip -DestinationPath .
$sqlpackage = Get-ChildItem -Recurse | Where-Object { $_.Name -ieq "sqlpackage.exe" }
$env:path += ";$($sqlpackage.DirectoryName)"

Invoke-WebRequest -Uri "$($covid19BaseUri)$($dataFolder)$($databaseDacPacName)" -OutFile $($databaseDacPacName)
$localBacpacFile = Get-Item $($databaseDacPacName)
sqlpackage.exe /Action:Import /tsn:tcp:$($ohmdwSqlserverName).database.windows.net,1433 /tdn:$($databaseName) /tu:$($sqlUserName) /tp:$($sqlPassword) /sf:$($localBacpacFile) /p:DatabaseEdition=Standard /p:DatabaseServiceObjective=S2