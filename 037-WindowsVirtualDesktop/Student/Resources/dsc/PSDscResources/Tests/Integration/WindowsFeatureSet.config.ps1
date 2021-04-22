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
        $WindowsFeatureNames,

        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [ValidateNotNullOrEmpty()]
        [System.String]
        $LogPath
    )

    Import-DscResource -ModuleName 'PSDscResources'

    WindowsFeatureSet WindowsFeatureSet1
    {
        Name = $WindowsFeatureNames
        Ensure = $Ensure
        LogPath = $LogPath
        IncludeAllSubfeature = $false
    }
}
