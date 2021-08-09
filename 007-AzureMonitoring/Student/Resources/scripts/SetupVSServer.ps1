param (
    [string]$SQLServerName, 
    [string]$SQLPassword,
    [string]$SQLUsername = "sqladmin"
)

function Write-Log
{
    param(
        [parameter(Mandatory)]
        [string]$Message,
        
        [parameter(Mandatory)]
        [string]$Type
    )
    $Path = 'C:\cse.log'
    if(!(Test-Path -Path C:\cse.log))
    {
        New-Item -Path C:\ -Name cse.log | Out-Null
    }
    $Timestamp = Get-Date -Format 'MM/dd/yyyy HH:mm:ss.ff'
    $Entry = '[' + $Timestamp + '] [' + $Type + '] ' + $Message
    $Entry | Out-File -FilePath $Path -Append
}

try
{
    # Install Microsoft .Net Core 3.1.100
    $exeDotNetTemp = [System.IO.Path]::GetTempPath().ToString() + "dotnet-sdk-3.1.100-win-x64.exe"
    if (Test-Path $exeDotNetTemp) { Remove-Item $exeDotNetTemp -Force -ErrorAction 'Stop' }
    # Download file from Microsoft Downloads and save to local temp file (%LocalAppData%/Temp/2)
    $exeFileNetCore = [System.IO.Path]::GetTempFileName() | Rename-Item -NewName "dotnet-sdk-3.1.100-win-x64.exe" -PassThru -ErrorAction 'Stop'
    Invoke-WebRequest -Uri "https://download.visualstudio.microsoft.com/download/pr/639f7cfa-84f8-48e8-b6c9-82634314e28f/8eb04e1b5f34df0c840c1bffa363c101/dotnet-sdk-3.1.100-win-x64.exe" -OutFile $exeFileNetCore -ErrorAction 'Stop'
    # Run the exe with arguments
    Start-Process -FilePath $exeFileNetCore.Name.ToString() -ArgumentList ('/install','/quiet') -WorkingDirectory $exeFileNetCore.Directory.ToString() -Wait -ErrorAction 'Stop'
    Write-Log -Message 'Installed .Net Core 3' -Type 'INFO'

    # # Disable Internet Explorer Enhanced Security Configuration
    # $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    # $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    # Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
    # Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
    # Stop-Process -Name 'Explorer' -Force
    # Write-Log -Message 'Disabled IE Enhanced Security' -Type 'INFO'

    # Download eShopOnWeb to c:\eShopOnWeb and extract contents
    $zipFileeShopTemp = [System.IO.Path]::GetTempPath().ToString() + "eShopOnWeb-master.zip"
    if (Test-Path $zipFileeShopTemp) { Remove-Item $zipFileeShopTemp -Force -ErrorAction 'Stop' }
    $zipFileeShop = [System.IO.Path]::GetTempFileName() | Rename-Item -NewName "eShopOnWeb-master.zip" -PassThru -ErrorAction 'Stop'
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri "https://github.com/jamasten/WhatTheHack/raw/master/007-AzureMonitoring/Student/Resources/sources/master.zip" -OutFile $zipFileeShop -ErrorAction 'Stop'
    $BackUpPath = $zipFileeShop.FullName
    New-Item -Path c:\eshoponweb -ItemType directory -Force -ErrorAction 'Stop'
    $Destination = "C:\eshoponweb"
    Expand-Archive -Path $BackUpPath -DestinationPath $Destination -Force -ErrorAction 'Stop'
    Write-Log -Message 'Downloaded the eShopOnWeb website' -Type 'INFO'

    #Modified version of Update eShopOnWeb project to use SQL Server
    #modify Startup.cs
    $Startupfile = 'C:\eshoponweb\eShopOnWeb-master\src\Web\Startup.cs'
    $find = '            ConfigureInMemoryDatabases(services);'
    $replace = '            //ConfigureInMemoryDatabases(services);'
    (Get-Content $Startupfile -ErrorAction 'Stop').replace($find, $replace) | Set-Content $Startupfile -Force -ErrorAction 'Stop'
    $find1 = '            //ConfigureProductionServices(services);'
    $replace1 = '            ConfigureProductionServices(services);'
    (Get-Content $Startupfile -ErrorAction 'Stop').replace($find1, $replace1) | Set-Content $Startupfile -Force -ErrorAction 'Stop'
    Write-Log -Message 'Modified the Startup.cs file' -Type 'INFO'

    #modify appsettings.json
    $appsettingsfile = 'C:\eshoponweb\eShopOnWeb-master\src\Web\appsettings.json'
    $find = '    "CatalogConnection": "Server=(localdb)\\mssqllocaldb;Integrated Security=true;Initial Catalog=Microsoft.eShopOnWeb.CatalogDb;",'
    $replace = '    "CatalogConnection": "Server=' + $SQLServerName + ';Integrated Security=false;User ID=' + $SQLUsername + ';Password=' + $SQLPassword + ';Initial Catalog=Microsoft.eShopOnWeb.CatalogDb;",'
    (Get-Content $appsettingsfile -ErrorAction 'Stop').replace($find, $replace) | Set-Content $appsettingsfile -Force -ErrorAction 'Stop'
    $find1 = '    "IdentityConnection": "Server=(localdb)\\mssqllocaldb;Integrated Security=true;Initial Catalog=Microsoft.eShopOnWeb.Identity;"'
    $replace1 = '    "IdentityConnection": "Server=' + $SQLServerName + ';Integrated Security=false;User ID=' + $SQLUsername + ';Password=' + $SQLPassword + ';Initial Catalog=Microsoft.eShopOnWeb.Identity;"'
    (Get-Content $appsettingsfile -ErrorAction 'Stop').replace($find1, $replace1) | Set-Content $appsettingsfile -Force -ErrorAction 'Stop'
    Write-Log -Message 'Modified the appsettings.json file' -Type 'INFO'

    #add exception to ManageController.cs
    $ManageControllerfile = 'C:\eshoponweb\eShopOnWeb-master\src\Web\Controllers\ManageController.cs'
    $Match = [regex]::Escape("public async Task<IActionResult> ChangePassword()")
    $NewLine = 'throw new ApplicationException($"Oh no!  Error!  Error! Yell at Rob!  He put this here!");'
    $Content = Get-Content $ManageControllerfile -Force -ErrorAction 'Stop'
    $Index = ($content | Select-String -Pattern $Match -ErrorAction 'Stop').LineNumber + 2
    $NewContent = @()
    0..($Content.Count-1) | Foreach-Object {
        if ($_ -eq $index) {
            $NewContent += $NewLine
        }
        $NewContent += $Content[$_]
    }
    $NewContent | Out-File $ManageControllerfile -Force -ErrorAction 'Stop'
    Write-Log -Message 'Added exception to ManageController.cs file' -Type 'INFO'

    #Configure Windows Firewall for File Sharing
    Start-Process -FilePath 'netsh' -ArgumentList 'advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes' -Wait -ErrorAction 'Stop'
    Write-Log -Message 'Configured Windows Firewall for File Sharing' -Type 'INFO'

    #Configure eShoponWeb application
    # Run dotnet restore with arguments
    $eShopWebDestination = "C:\eshoponweb\eShopOnWeb-master\src\Web"
    Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('restore') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnetrestoreoutput.txt" -Wait -ErrorAction 'Stop'
    Write-Log -Message 'Ran .NET restore' -Type 'INFO'

    #This is the addition for dotnet tool restore command to be placed after Run dotnet restore with arguments and before Configure CatalogDb
    Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('tool','restore') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnettoolrestoreoutput.txt" -Wait -ErrorAction 'Stop'
    Write-Log -Message 'Added .NET tool for restore command' -Type 'INFO'

    #Configure CatalogDb
    Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('ef','database','update','-c','catalogcontext','-p','../Infrastructure/Infrastructure.csproj','-s','Web.csproj') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnetefcatoutput.txt" -Wait -ErrorAction 'Stop'
    Write-Log -Message 'Configured the Catalog database' -Type 'INFO'

    #Configure Identity Db
    Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('ef','database','update','-c','appidentitydbcontext','-p','../Infrastructure/Infrastructure.csproj','-s','Web.csproj') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnetefappoutput.txt" -Wait -ErrorAction 'Stop'
    Write-Log -Message 'Configured the Identity database' -Type 'INFO'

    #Run dotnet build
    Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('build') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnetbuildoutput.txt" -Wait -ErrorAction 'Stop'
    Write-Log -Message 'Ran .NET build' -Type 'INFO'

    # Build Project and publish to a folder
    # Share folder to vmadmin and SYSTEM
    New-Item -ItemType directory -Path C:\eShopPub -ErrorAction 'Stop'
    New-Item -ItemType directory -Path C:\eShopPub\wwwroot -ErrorAction 'Stop'
    Write-Log -Message 'Created the website directory' -Type 'INFO'
    New-SmbShare -Name "eShopPub" -Path "C:\eShopPub" -FullAccess $($env:computername + "\" + $SQLUsername) -ErrorAction 'Stop'
    Write-Log -Message 'Created the file share on the website directory' -Type 'INFO'
    Grant-SmbShareAccess -Name "eShopPub" -AccountName SYSTEM -AccessRight Full -Force -ErrorAction 'Stop'
    Grant-SmbShareAccess -Name "eShopPub" -AccountName Everyone -AccessRight Full -Force -ErrorAction 'Stop'
    Write-Log -Message 'Configured the permissions on the file share for the website directory' -Type 'INFO'

    # Run dotnet publish to to publish files to our share created above
    $eShopWebDestination = "C:\eshoponweb\eShopOnWeb-master\src\Web"
    Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('publish','--output','C:\eShopPub\wwwroot\') -WorkingDirectory $eShopWebDestination -Passthru -RedirectStandardOutput "c:\windows\temp\dotnetpuboutput.txt" -Wait -ErrorAction 'Stop'
    Write-Log -Message 'Configured the Catalog database' -Type 'INFO'
} 
catch 
{
    Write-Log -Message $_ -Type 'ERROR'
    throw 
}