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
        $Name,

        [ValidateSet('Present', 'Absent')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [ValidateSet('LocalSystem', 'LocalService', 'NetworkService')]
        [System.String]
        $BuiltInAccount
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        ServiceSet ServiceSet1
        {
            Name           = $Name
            Ensure         = $Ensure
            BuiltInAccount = $BuiltInAccount
        }
    }
}
