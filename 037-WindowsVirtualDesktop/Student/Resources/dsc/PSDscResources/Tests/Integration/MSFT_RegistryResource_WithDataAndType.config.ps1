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
        $Key,

        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.String]
        [AllowEmptyString()]
        $ValueName,

        [Parameter(Mandatory = $true)]
        [ValidateSet('String', 'Binary', 'DWord', 'QWord', 'MultiString', 'ExpandString')]
        [System.String]
        $ValueType,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        [AllowEmptyCollection()]
        $ValueData
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Registry Registry1
        {
            Key = $Key
            Ensure = $Ensure
            ValueName = $ValueName
            ValueType = $ValueType
            ValueData = $ValueData
            Force = $true
        }
    }
}
