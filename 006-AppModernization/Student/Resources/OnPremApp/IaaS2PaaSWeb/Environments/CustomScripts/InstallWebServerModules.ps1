# Install Nuget, needed to install DSC modules via PowerShellGet
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install required PowerShell Modules
Install-Module -Name cChoco -Force
