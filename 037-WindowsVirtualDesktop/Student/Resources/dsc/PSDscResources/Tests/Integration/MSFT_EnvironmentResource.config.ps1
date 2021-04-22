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

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $Value = [System.String]::Empty,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Boolean]
        $Path = $false,

        [Parameter()]
        [ValidateSet('Process', 'Machine')]
        [System.String[]]
        $Target = @('Process', 'Machine')
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Environment Environment1
    {
        Name = $Name
        Value = $Value
        Ensure = $Ensure
        Path = $Path
        Target = $Target
    }
}
