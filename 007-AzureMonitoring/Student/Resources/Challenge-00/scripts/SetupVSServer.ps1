param (
    [string]$SQLServerName, 
    [string]$SQLPassword,
    [string]$AdminUsername
)

<#
# Install Microsoft .Net Core 3.1.100
$exeDotNetTemp = [System.IO.Path]::GetTempPath().ToString() + "dotnet-sdk-3.1.100-win-x64.exe"
if (Test-Path $exeDotNetTemp) { Remove-Item $exeDotNetTemp -Force }
# Download file from Microsoft Downloads and save to local temp file (%LocalAppData%/Temp/2)
$exeFileNetCore = [System.IO.Path]::GetTempFileName() | Rename-Item -NewName "dotnet-sdk-3.1.100-win-x64.exe" -PassThru
Invoke-WebRequest -Uri "https://download.visualstudio.microsoft.com/download/pr/639f7cfa-84f8-48e8-b6c9-82634314e28f/8eb04e1b5f34df0c840c1bffa363c101/dotnet-sdk-3.1.100-win-x64.exe" -OutFile $exeFileNetCore
# Run the exe with arguments
$proc = (Start-Process -FilePath $exeFileNetCore.Name.ToString() -ArgumentList ('/install','/quiet') -WorkingDirectory $exeFileNetCore.Directory.ToString() -Passthru)
$proc | Wait-Process 
#>

<#
# Install Microsoft .Net Core 6.0.4
$exeDotNetTemp = [System.IO.Path]::GetTempPath().ToString() + "dotnet-sdk-6.0.400-win-x64.exe"
if (Test-Path $exeDotNetTemp) { Remove-Item $exeDotNetTemp -Force }
# Download file from Microsoft Downloads and save to local temp file (%LocalAppData%/Temp/2)
$exeFileNetCore = [System.IO.Path]::GetTempFileName() | Rename-Item -NewName "dotnet-sdk-6.0.400-win-x64.exe" -PassThru
Invoke-WebRequest -Uri "https://download.visualstudio.microsoft.com/download/pr/9a1d2e89-d785-4493-aaf3-73864627a1ea/245bdfaa9c46b87acfb2afbd10ecb0d0/dotnet-sdk-6.0.400-win-x64.exe" -OutFile $exeFileNetCore
# Run the exe with arguments
$proc = (Start-Process -FilePath $exeFileNetCore.Name.ToString() -ArgumentList ('/install','/quiet') -WorkingDirectory $exeFileNetCore.Directory.ToString() -Passthru)
$proc | Wait-Process 
#>

# Install Microsoft .Net Core 7.0.102
$exeDotNetTemp = [System.IO.Path]::GetTempPath().ToString() + "dotnet-sdk-7.0.102-win-x64.exe"
if (Test-Path $exeDotNetTemp) { Remove-Item $exeDotNetTemp -Force }
# Download file from Microsoft Downloads and save to local temp file (%LocalAppData%/Temp/2)
$exeFileNetCore = [System.IO.Path]::GetTempFileName() | Rename-Item -NewName "dotnet-sdk-7.0.102-win-x64.exe" -PassThru
Invoke-WebRequest -Uri "https://download.visualstudio.microsoft.com/download/pr/6ba69569-ee5e-460e-afd8-79ae3cd4617b/16a385a4fab2c5806f50f49f5581b4fd/dotnet-sdk-7.0.102-win-x64.exe" -OutFile $exeFileNetCore
# Run the exe with arguments
$proc = (Start-Process -FilePath $exeFileNetCore.Name.ToString() -ArgumentList ('/install','/quiet') -WorkingDirectory $exeFileNetCore.Directory.ToString() -Passthru)
$proc | Wait-Process 

try
{
    # Disable Internet Explorer Enhanced Security Configuration
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
    Stop-Process -Name Explorer -Force
} 
catch {}

# Download eShopOnWeb to c:\eShopOnWeb and extract contents
$zipFileeShopTemp = [System.IO.Path]::GetTempPath().ToString() + "eShopOnWeb-main.zip"
if (Test-Path $zipFileeShopTemp) { Remove-Item $zipFileeShopTemp -Force }
$zipFileeShop = [System.IO.Path]::GetTempFileName() | Rename-Item -NewName "eShopOnWeb-main.zip" -PassThru
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://github.com/dotnet-architecture/eShopOnWeb/archive/master.zip" -OutFile $zipFileeShop
$BackUpPath = $zipFileeShop.FullName
New-Item -Path c:\eshoponweb -ItemType directory -Force
$Destination = "C:\eshoponweb"
Add-Type -assembly "system.io.compression.filesystem" -PassThru
[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)

<# New .NET 6 version of eShopOnWeb doesn't use this file. 
#  This setting is now maintained in the appsettings.json file and is on by default!
#Modified version of Update eShopOnWeb project to use SQL Server
#modify Startup.cs
$Startupfile = 'C:\eshoponweb\eShopOnWeb-master\src\Web\Startup.cs'
$find = '            ConfigureInMemoryDatabases(services);'
$replace = '            //ConfigureInMemoryDatabases(services);'
(Get-Content $Startupfile).replace($find, $replace) | Set-Content $Startupfile -Force
$find1 = '            //ConfigureProductionServices(services);'
$replace1 = '            ConfigureProductionServices(services);'
(Get-Content $Startupfile).replace($find1, $replace1) | Set-Content $Startupfile -Force
#>

#modify appsettings.json
$SQLusername = "sqladmin"
$appsettingsfile = 'C:\eshoponweb\eShopOnWeb-main\src\Web\appsettings.json'
$find = '    "CatalogConnection": "Server=(localdb)\\mssqllocaldb;Integrated Security=true;Initial Catalog=Microsoft.eShopOnWeb.CatalogDb;",'
$replace = '    "CatalogConnection": "Server=' + $SQLServername + ';Integrated Security=false;User ID=' + $SQLusername + ';Password=' + $SQLpassword + ';Initial Catalog=Microsoft.eShopOnWeb.CatalogDb;TrustServerCertificate=True",'
(Get-Content $appsettingsfile).replace($find, $replace) | Set-Content $appsettingsfile -Force
$find1 = '    "IdentityConnection": "Server=(localdb)\\mssqllocaldb;Integrated Security=true;Initial Catalog=Microsoft.eShopOnWeb.Identity;"'
$replace1 = '    "IdentityConnection": "Server=' + $SQLServername + ';Integrated Security=false;User ID=' + $SQLusername + ';Password=' + $SQLpassword + ';Initial Catalog=Microsoft.eShopOnWeb.Identity;TrustServerCertificate=True"'
(Get-Content $appsettingsfile).replace($find1, $replace1) | Set-Content $appsettingsfile -Force

#add exception to ManageController.cs
$ManageControllerfile = 'C:\eshoponweb\eShopOnWeb-main\src\Web\Controllers\ManageController.cs'
$Match = [regex]::Escape("public async Task<IActionResult> ChangePassword()")
$NewLine = 'throw new ApplicationException($"Oh no!  Error!  Error! Yell at Rob!  He put this here!");
#pragma warning disable CS0162 // Unreachable code detected'
$Content = Get-Content $ManageControllerfile -Force
$Index = ($content | Select-String -Pattern $Match).LineNumber + 2
$NewContent = @()
0..($Content.Count-1) | Foreach-Object {
    if ($_ -eq $index) {
        $NewContent += $NewLine
    }
    $NewContent += $Content[$_]
}
$NewContent | Out-File $ManageControllerfile -Force

#Configure Windows Firewall for File Sharing
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes


#Configure eShoponWeb application
# Run dotnet restore with arguments
$eShopWebDestination = "C:\eshoponweb\eShopOnWeb-main\src\Web"
$proc = (Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('restore') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnetrestoreoutput.txt" -Passthru)
$proc | Wait-Process

#This is the addition for dotnet tool restore command to be placed after Run dotnet restore with arguments and before Configure CatalogDb
$proc = (Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('tool','restore') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnettoolrestoreoutput.txt" -Passthru)
$proc | Wait-Process

#Configure CatalogDb

$proc = (Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('ef','database','update','-c','catalogcontext','-p','../Infrastructure/Infrastructure.csproj','-s','Web.csproj') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnetefcatoutput.txt" -Passthru)
$proc | Wait-Process

#Configure Identity Db
$proc = (Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('ef','database','update','-c','appidentitydbcontext','-p','../Infrastructure/Infrastructure.csproj','-s','Web.csproj') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnetefappoutput.txt" -Passthru)
$proc | Wait-Process

#Run dotnet build
$proc = (Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('build') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnetbuildoutput.txt" -Passthru)
$proc | Wait-Process

# Build Project and publish to a folder
# Share folder to vmadmin and SYSTEM
New-Item -ItemType directory -Path C:\eShopPub
New-Item -ItemType directory -Path C:\eShopPub\wwwroot
New-SmbShare -Name "eShopPub" -Path "C:\eShopPub" -FullAccess $($env:computername + "\" + $AdminUsername)
Grant-SmbShareAccess -Name "eShopPub" -AccountName SYSTEM -AccessRight Full -Force
Grant-SmbShareAccess -Name "eShopPub" -AccountName Everyone -AccessRight Full -Force

# Run dotnet publish to to publish files to our share created above
$eShopWebDestination = "C:\eshoponweb\eShopOnWeb-main\src\Web"
$proc = (Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('publish','--output','C:\eShopPub\wwwroot\') -WorkingDirectory $eShopWebDestination -Passthru -RedirectStandardOutput "c:\windows\temp\dotnetpuboutput.txt")
$proc | Wait-Process
