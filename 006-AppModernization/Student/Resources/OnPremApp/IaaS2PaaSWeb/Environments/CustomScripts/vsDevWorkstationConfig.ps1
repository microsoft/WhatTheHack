## Dev Workstation Configuration Script
Param (
	[string]$repoUri,
	[string]$adminUserName,
	[string]$adminUserPassword,
	[string]$webSrvUri,
	[string]$dbSrvUri,
	[string]$dbName,
	[string]$dbUserName,
	[string]$dbUserPassword
)

## Clone Repo
mkdir 'c:\Source'
cd 'c:\Source'
git clone $repoUri

## Build and Package App
$vs_path = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise"
if (!(Test-Path $vs_path)) {
	$vs_path = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community"
}

#Set Path Variables for build
$env:Path += ";$vs_path\VC\Tools\MSVC\14.12.25827\bin\HostX86\x86"
$env:Path += ";$vs_path\Common7\IDE\VC\VCPackages"
$env:Path += ";C:\Program Files (x86)\Microsoft SDKs\TypeScript\2.5"
$env:Path += ";$vs_path\Common7\IDE\CommonExtensions\Microsoft\TestWindow"
$env:Path += ";$vs_path\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer"
$env:Path += ";$vs_path\MSBuild\15.0\bin\Roslyn"
$env:Path += ";$vs_path\Team Tools\Performance Tools"
$env:Path += ";C:\Program Files (x86)\Microsoft Visual Studio\Shared\Common\VSPerfCollectionTools\"
$env:Path += ";C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools\"
$env:Path += ";C:\Program Files (x86)\Microsoft SDKs\F#\4.1\Framework\v4.0\"
$env:Path += ";C:\Program Files (x86)\Windows Kits\10\bin\x86"
$env:Path += ";C:\Program Files (x86)\Windows Kits\10\bin\10.0.16299.0\x86"
$env:Path += ";$vs_path\\MSBuild\15.0\bin"
$env:Path += ";C:\Windows\Microsoft.NET\Framework\v4.0.30319"
$env:Path += ";$vs_path\Common7\IDE\"
$env:Path += ";$vs_path\Common7\Tools\"
$env:Path += ";C:\Program Files\Microsoft MPI\Bin\;C:\Windows\system32;C:\Windows"
$env:Path += ";C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\"
$env:Path += ";C:\Program Files\dotnet\"
$env:Path += ";C:\Program Files\Microsoft SQL Server\130\Tools\Binn\"
$env:Path += ";C:\Program Files\Git\cmd"

#Restore NuGet packages
& "C:\Source\AppWorkshop\IaaS2PaaSWeb\nuget.exe" restore C:\Source\AppWorkshop\IaaS2PaaSWeb\IaaS2PaaSWeb.sln

#Build App using VS Tools
msbuild C:\Source\AppWorkshop\IaaS2PaaSWeb\PartsUnlimitedWebsite\partsunlimitedwebsite.csproj /p:DeployOnBuild=true /p:WebPublishMethod=Package /p:PackageAsSingleFile=true /p:SkipInvalidConfigurations=true /p:VisualStudioVersion=15.0

## Deploy Webapp

#Recreate Parameters File with correct values
$SettingsFile = "<?xml version=""1.0"" encoding=""utf-8""?>"
$SettingsFile += "<parameters>"
$SettingsFile += "<setParameter name=""IIS Web Application Name"" value=""Default Web Site"" />"
$SettingsFile += "<setParameter name=""DefaultConnectionString-Web.config Connection String"" value=""Server=" + $dbSrvUri + ";Database=" + $dbName + "; User Id=" + $dbUserName + "; password= " + $dbUserPassword + """/>"
$SettingsFile += "</parameters>"
Set-Content -Path C:\Source\AppWorkshop\IaaS2PaaSWeb\PartsUnlimitedWebsite\obj\Debug\Package\partsunlimitedwebsite.SetParameters.xml -Value $SettingsFile

#Deploy Website
C:\Source\AppWorkshop\IaaS2PaaSWeb\PartsUnlimitedWebsite\obj\Debug\Package\partsunlimitedwebsite.deploy.cmd /Y /M:$webSrvUri/MSDeployAgentService /U:$adminUserName /P:$adminUserPassword

## Install Chocolatey and packages
Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) 
## Add startup bat to install additional packages on sign in
$choco_exe = "C:\ProgramData\chocolatey\bin\choco.exe"
$install_packages_bat = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\install_packages.bat"
if (!(Test-Path $install_packages_bat)) {
	Set-Content -Path $install_packages_bat -Value "$choco_exe install postman googlechrome -y"
}
