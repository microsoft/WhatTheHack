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
        $Path,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Destination,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Boolean]
        $Validate = $false
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Archive Archive1
        {
            Path = $Path
            Destination = $Destination
            Ensure = $Ensure
            Validate = $Validate
        }
    }
}
