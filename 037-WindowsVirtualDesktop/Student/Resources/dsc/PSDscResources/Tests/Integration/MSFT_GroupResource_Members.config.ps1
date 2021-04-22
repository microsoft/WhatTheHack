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
        $GroupName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $Members = @()
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Group Group1
    {
        GroupName = $GroupName
        Ensure = $Ensure
        Members = $Members
    }
}
