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
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Archive Archive1
        {
            Path = $Path
            Destination = $Destination
            Ensure = $Ensure
            Credential = $Credential
        }
    }
}
