param
(
    [Parameter(Mandatory = $true)]
    [System.String]
    $ConfigurationName
)

Configuration $ConfigurationName
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [ValidateSet('Present', 'Absent')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Ensure = 'Present',

        [ValidateNotNullOrEmpty()]
        [System.String]
        $LogPath = (Join-Path -Path (Get-Location) -ChildPath 'WOFTestLog.txt'),

        [System.Boolean]
        $RemoveFilesOnDisable = $false,

        [System.Boolean]
        $NoWindowsUpdateCheck = $true
    )

    Import-DscResource -ModuleName 'PSDscResources'

    WindowsOptionalFeature WindowsOptionalFeature1
    {
        Name = $Name
        Ensure = $Ensure
        LogPath = $LogPath
        NoWindowsUpdateCheck = $NoWindowsUpdateCheck
        RemoveFilesOnDisable = $RemoveFilesOnDisable
    }
}
