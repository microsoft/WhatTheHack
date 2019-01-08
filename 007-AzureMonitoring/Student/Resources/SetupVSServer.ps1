param (
    [string]$SQLServerName, 
    [string]$SQLpassword
)

# Install Microsoft .Net Core 2.2.101
$exeDotNetTemp = [System.IO.Path]::GetTempPath().ToString() + "dotnet-sdk-2.2.101-win-x64.exe"
if (Test-Path $exeDotNetTemp) { Remove-Item $exeDotNetTemp -Force }
# Download file from Microsoft Downloads and save to local temp file (%LocalAppData%/Temp/2)
$exeFileNetCore = [System.IO.Path]::GetTempFileName() | Rename-Item -NewName "dotnet-sdk-2.2.101-win-x64.exe" -PassThru
Invoke-WebRequest -Uri "https://download.visualstudio.microsoft.com/download/pr/d4592a50-b583-434a-bcda-529e506a7e0d/b1fee3bb02e4d5b831bd6057af67a91b/dotnet-sdk-2.2.101-win-x64.exe" -OutFile $exeFileNetCore
# Run the exe with arguments
$proc = (Start-Process -FilePath $exeFileNetCore.Name.ToString() -ArgumentList ('/install','/quiet') -WorkingDirectory $exeFileNetCore.Directory.ToString() -Passthru)
$proc | Wait-Process

# Disable Internet Explorer Enhanced Security Configuration
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
Stop-Process -Name Explorer -Force

# Download eShopOnWeb to c:\eShopOnWeb and extract contents
$zipFileeShopTemp = [System.IO.Path]::GetTempPath().ToString() + "eShopOnWeb-master.zip"
if (Test-Path $zipFileeShopTemp) { Remove-Item $zipFileeShopTemp -Force }
$zipFileeShop = [System.IO.Path]::GetTempFileName() | Rename-Item -NewName "eShopOnWeb-master.zip" -PassThru
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://github.com/dotnet-architecture/eShopOnWeb/archive/master.zip" -OutFile $zipFileeShop
$BackUpPath = $zipFileeShop.FullName
New-Item -Path c:\eshoponweb -ItemType directory -Force
$Destination = "C:\eshoponweb"
Add-Type -assembly "system.io.compression.filesystem" -PassThru
[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)

#Update eShopOnWeb project to use SQL Server
#modify Startup.cs
$Startupfile = 'C:\eshoponweb\eShopOnWeb-master\src\Web\Startup.cs'
$find = '            ConfigureInMemoryDatabases(services);'
$replace = '            //ConfigureInMemoryDatabases(services);'
(Get-Content $Startupfile).replace($find, $replace) | Set-Content $Startupfile -Force
$find1 = '            // ConfigureProductionServices(services);'
$replace1 = '            ConfigureProductionServices(services);'
(Get-Content $Startupfile).replace($find1, $replace1) | Set-Content $Startupfile -Force

#modify appsettings.json
$SQLusername = "sqladmin"
$appsettingsfile = 'C:\eshoponweb\eShopOnWeb-master\src\Web\appsettings.json'
$find = '    "CatalogConnection": "Server=(localdb)\\mssqllocaldb;Integrated Security=true;Initial Catalog=Microsoft.eShopOnWeb.CatalogDb;",'
$replace = '    "CatalogConnection": "Server=' + $SQLServername + ';Integrated Security=false;User ID=' + $SQLusername + ';Password=' + $SQLpassword + ';Initial Catalog=Microsoft.eShopOnWeb.CatalogDb;",'
(Get-Content $appsettingsfile).replace($find, $replace) | Set-Content $appsettingsfile -Force
$find1 = '    "IdentityConnection": "Server=(localdb)\\mssqllocaldb;Integrated Security=true;Initial Catalog=Microsoft.eShopOnWeb.Identity;"'
$replace1 = '    "IdentityConnection": "Server=' + $SQLServername + ';Integrated Security=false;User ID=' + $SQLusername + ';Password=' + $SQLpassword + ';Initial Catalog=Microsoft.eShopOnWeb.Identity;"'
(Get-Content $appsettingsfile).replace($find1, $replace1) | Set-Content $appsettingsfile -Force

#add exception to ManageController.cs
$ManageControllerfile = 'C:\eshoponweb\eShopOnWeb-master\src\Web\Controllers\ManageController.cs'
$Match = [regex]::Escape("public async Task<IActionResult> ChangePassword()")
$NewLine = 'throw new ApplicationException($"Oh no!  Error!  Error! Yell at Rob!  He put this here!");'
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

#Configure eShoponWeb application
# Run dotnet restore with arguments
$eShopWebDestination = "C:\eshoponweb\eShopOnWeb-master\src\Web"
$proc = (Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('restore') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnetrestoreoutput.txt" -Passthru)
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
New-SmbShare -Name "eShopPub" -Path "C:\eShopPub" -FullAccess $env:computername"\vmadmin"
Grant-SmbShareAccess -Name "eShopPub" -AccountName SYSTEM -AccessRight Full -Force
Grant-SmbShareAccess -Name "eShopPub" -AccountName Everyone -AccessRight Full -Force

# Run dotnet publish to to publish files to our share created above
$eShopWebDestination = "C:\eshoponweb\eShopOnWeb-master\src\Web"
$proc = (Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('publish','--output','C:\eShopPub') -WorkingDirectory $eShopWebDestination -Passthru -RedirectStandardOutput "c:\windows\temp\dotnetpuboutput.txt")
$proc | Wait-Process
