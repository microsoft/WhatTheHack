Param(
	[string]$loginName,
	[string]$dbUserName,
	[string]$password,
	[string]$databaseName,
	[string]$databaseRole,
	[string]$sqlSchemaScript,
	[string]$sqlDataScript
)

# Variables
$instanceName = $env:COMPUTERNAME

Write-Host("loginName  $loginName")
Write-Host("dbUserName  $dbUserName")
Write-Host("password  $password")
Write-Host("databaseName  $databaseName")
Write-Host("databaseRole  $databaseRole")
Write-Host("sqlSchemaScript  $sqlSchemaScript")
Write-Host("sqlDataScript  $sqlDataScript")

# Install Nuget, needed to install DSC modules via PowerShellGet
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install DSC modules used by DSC Scripts run via DSC Extension
# - Note, was told this is not a best practice.  It was suggested
# - that the module should be zipped with the script, downloaded
# - then installed.  This is to ensure you have the same version 
# - of the module to prevent your script from breaking.
install-module -name xSqlServer -Force

# Import SQL Server module
Import-Module SQLPS -DisableNameChecking

# Create SQL Server Object
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

# Change authentication mode to mixed
$server.Settings.LoginMode = "Mixed"
$server.Alter()

# Restart SQL Service, think this is needed to pickup the security mode change
Restart-Service  MSSQLSERVER -Force

# Create SQL Server Object
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

# Create new database
$db = New-Object Microsoft.SqlServer.Management.Smo.Database($server,$databaseName)
$db.Create()
Write-Host("Database  $databaseName created successfully.")

# Drop login if it exists
if ($server.Logins.Contains($loginName))  
{   
    Write-Host("Deleting the existing login $loginName.")
       $server.Logins[$loginName].Drop() 
}

# Add login
$login = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $server, $loginName
$login.LoginType = "SqlLogin"
$login.PasswordExpirationEnabled = $false
$login.Create($password)
Write-Host("Login $loginName created successfully.")

# Add user to database
$dbUser = New-Object -TypeName Microsoft.SqlServer.Management.Smo.User -ArgumentList $db, $dbUserName
$dbUser.Login = $loginName
$dbUser.Create()
Write-Host("User $dbUser created successfully.")

# Assign database role for a new user
$dbrole = $server.Databases[$databaseName].Roles[$databaseRole]
$dbrole.AddMember($dbUserName)
$dbrole.Alter()
Write-Host("User $dbUser successfully added to $databaseRole role.")

# Download SQL Scripts
mkdir "c:\sqlScripts"
Invoke-WebRequest -Uri $sqlSchemaScript -OutFile 'C:\sqlScripts\Schema.ps1'
Invoke-WebRequest -Uri $sqlDataScript -OutFile 'C:\sqlScripts\Data.ps1'

# Execute SQL Scripts
Invoke-sqlcmd -InputFile 'C:\sqlScripts\Schema.ps1' -Database $databaseName -Username $dbUserName -Password $password 
Invoke-sqlcmd -InputFile 'C:\sqlScripts\Data.ps1' -Database $databaseName -Username $dbUserName -Password $password 