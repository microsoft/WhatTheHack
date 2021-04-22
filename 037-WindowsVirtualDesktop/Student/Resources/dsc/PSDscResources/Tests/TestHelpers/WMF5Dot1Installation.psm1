Set-StrictMode -Version 'latest'
$errorActionPreference = 'Stop'

<#
    .SYNOPSIS
        Retrieves the URL for downloading the WMF 5.1 installation file for Windows 8.1 and Windows Server 2012 R2(amd64).
#>
function Get-Wmf5Dot1InstallFileUrl
{
    [OutputType([String])]
    [CmdletBinding()]
    param ()
    
    return 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1AndW2K12R2-KB3191564-x64.msu'
}

<#
    .SYNOPSIS
        Downloads the WMF 5.1 installation file to the given location.

    .PARAMETER DownloadLocation
        The file path to download the WMF 5.1 install file to.
#>
function Download-Wmf5Dot1InstallFile
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $DownloadLocation
    )

    $wmf5Dot1InstallFileUrl = Get-Wmf5Dot1InstallFileUrl
    $null = Invoke-WebRequest -Uri $wmf5Dot1InstallFileUrl -OutFile $DownloadLocation
}

<#
    .SYNOPSIS
        Invokes WUSA to install the given file.
        Outputs the exit code from WUSA.
    
    .PARAMETER InstallFile
        The file to install using WUSA.

    .NOTES
        WUSA: Windows Update Service Application
#>
function Invoke-Wusa
{
    [OutputType([Int])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $InstallFile
    )

    Write-Verbose -Message "Installing $InstallFile..."

    $wusaProcess = [System.Diagnostics.Process]::Start($InstallFile, "/quiet /norestart ")

    Write-Verbose -Message 'Waiting for WUSA install to complete...'

    # Wait for 60 minutes for the process to exit
    if (-not $wusaProcess.WaitForExit(60 * 60 * 1000))
    { 
        throw "Installing $InstallFile timed out after 60 minutes. Exiting..."
    }
   
    return $wusaProcess.ExitCode
}

<#
    .SYNOPSIS
        Installs WMF 5.1.
#>
function Install-Wmf5Dot1
{
    [CmdletBinding()]
    param ()

    $downloadLocation = "$env:SystemDrive\WMF5Dot1.msu"

    $null = Download-Wmf5Dot1InstallFile -DownloadLocation $downloadLocation
    
    Write-Verbose -Message 'Restarting the Windows Update service (wuauserv)...'

    $null = Set-Service -Name 'wuauserv' -StartupType 'Manual'
    $null = Start-Service -Name 'wuauserv'

    Write-Verbose -Message 'Installing WMF 5.1...'

    $wusaExitCode = Invoke-Wusa -InstallFile $downloadLocation

    Write-Verbose -Message "Completed WMF 5.1 installation with exit code $wusaExitCode"
}

Export-ModuleMember -Function @( 'Install-Wmf5Dot1' )
