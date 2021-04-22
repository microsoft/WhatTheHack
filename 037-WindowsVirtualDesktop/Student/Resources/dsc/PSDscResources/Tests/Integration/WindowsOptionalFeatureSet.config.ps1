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
        [System.String[]]
        $WindowsOptionalFeatureNames,

        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [ValidateNotNullOrEmpty()]
        [System.String]
        $LogPath
    )

    Import-DscResource -ModuleName 'PSDscResources'

    WindowsOptionalFeatureSet WindowsOptionalFeatureSet1
    {
        Name = $WindowsOptionalFeatureNames
        Ensure = $Ensure
        LogPath = $LogPath
        NoWindowsUpdateCheck = $false
        RemoveFilesOnDisable = $false
    }
}
