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
        $ProductId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.String]
        $LogPath
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        MsiPackage MsiPackage1
        {
            ProductId = $ProductId
            Path = $Path
            Ensure = $Ensure
            LogPath = $LogPath
        }
    }
}
