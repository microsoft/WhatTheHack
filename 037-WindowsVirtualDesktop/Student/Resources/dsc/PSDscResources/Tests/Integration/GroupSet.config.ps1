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
        $GroupName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $MembersToInclude = @(),

        [Parameter()]
        [System.String[]]
        $MembersToExclude = @()
    )

    Import-DscResource -ModuleName 'PSDscResources'

    GroupSet GroupSet1
    {
        GroupName = $GroupName
        Ensure = $Ensure
        MembersToInclude = $MembersToInclude
        MembersToExclude = $MembersToExclude
    }
}
