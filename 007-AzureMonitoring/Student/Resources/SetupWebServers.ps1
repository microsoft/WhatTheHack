param (
    [string]$VSServerName,
    [string]$username,
    [string]$password
)

# Install IIS (with Management Console)
Install-WindowsFeature -name Web-Server -IncludeManagementTools

# Install ASP.NET 4.6
Install-WindowsFeature Web-Asp-Net45

# Install Web Management Service (enable and start service)
Install-WindowsFeature -Name Web-Mgmt-Service
Set-ItemProperty -Path  HKLM:\SOFTWARE\Microsoft\WebManagement\Server -Name EnableRemoteManagement -Value 1
Set-Service -name WMSVC -StartupType Automatic
if ((Get-Service WMSVC).Status -ne "Running") {
    net start wmsvc
}

# Install Web Deploy 3.6
$msiWebDeployTemp = [System.IO.Path]::GetTempPath().ToString() + "WebDeploy_amd64_en-US.msi"
if (Test-Path $msiWebDeployTemp) { Remove-Item $msiWebDeployTemp -Force }
# Download file from Microsoft Downloads and save to local temp file (%LocalAppData%/Temp/2)
$msiFile = [System.IO.Path]::GetTempFileName() | Rename-Item -NewName { $_ -replace 'tmp$', 'msi' } -PassThru
Invoke-WebRequest -Uri http://download.microsoft.com/download/0/1/D/01DC28EA-638C-4A22-A57B-4CEF97755C6C/WebDeploy_amd64_en-US.msi -OutFile $msiFile
# Prepare a log file name
$logFile = [System.IO.Path]::GetTempFileName()
# Prepare the arguments to execute the MSI
$arguments= '/i ' + $msiFile + ' ADDLOCAL=ALL /qn /norestart LicenseAccepted="0" /lv ' + $logFile
# Sample = msiexec /i C:\Users\{user}\AppData\Local\Temp\2\tmp9267.msi ADDLOCAL=ALL /qn /norestart LicenseAccepted="0" /lv $logFile
# Execute the MSI and wait for it to complete
$proc = (Start-Process -file msiexec -arg $arguments -Passthru)
$proc | Wait-Process
Get-Content $logFile

# Install Microsoft .Net Core 2.1.3
$exeDotNetTemp = [System.IO.Path]::GetTempPath().ToString() + "dotnet-hosting-2.1.3-win.exe"
if (Test-Path $exeDotNetTemp) { Remove-Item $exeDotNetTemp -Force }
# Download file from Microsoft Downloads and save to local temp file (%LocalAppData%/Temp/2)
$exeFileNetCore = [System.IO.Path]::GetTempFileName() | Rename-Item -NewName "dotnet-hosting-2.1.3-win.exe" -PassThru
Invoke-WebRequest -Uri "https://download.microsoft.com/download/6/E/B/6EBD972D-2E2F-41EB-9668-F73F5FDDC09C/dotnet-hosting-2.1.3-win.exe" -OutFile $exeFileNetCore
# Run the exe with arguments
$proc = (Start-Process -FilePath $exeFileNetCore.Name.ToString() -ArgumentList ('/install','/quiet') -WorkingDirectory $exeFileNetCore.Directory.ToString() -Passthru)
$proc | Wait-Process


# Disable Internet Explorer Enhanced Security Configuration
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
Stop-Process -Name Explorer -Force

# Copy eShoponWeb from Published Share and restart IIS
$SharePath = '\\'+$VSServerName+'\eShopPub'
New-SmbMapping -LocalPath v: -RemotePath $SharePath -UserName $username -Password $password >> c:\windows\temp\SetupWebServers.log
Copy-Item "V:\*.*" -Destination "C:\inetpub\wwwroot\" -Recurse -Force >> c:\windows\temp\SetupWebServers.log
Copy-Item "V:\wwwroot\" -Destination C:\inetpub\wwwroot\wwwroot -Recurse -Force >> c:\windows\temp\SetupWebServers.log


#Restart iis
Start-Process -FilePath C:\Windows\System32\iisreset.exe -ArgumentList /RESTART >> c:\windows\temp\SetupWebServers.log