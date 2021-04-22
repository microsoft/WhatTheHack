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
        [AllowEmptyString()]
        [System.String]
        $Arguments,

        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present'
    )

    Import-DscResource -ModuleName 'PSDscResources'

    WindowsProcess Process1
    {
        Path = $Path
        Arguments = $Arguments
        Ensure = $Ensure
    }
}
