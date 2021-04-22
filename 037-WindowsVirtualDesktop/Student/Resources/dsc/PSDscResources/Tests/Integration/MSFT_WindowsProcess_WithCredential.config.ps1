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
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential)
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Node $AllNodes.NodeName
    {
        WindowsProcess Process1
        {
            Path = $Path
            Arguments = $Arguments
            Credential = $Credential
            Ensure = $Ensure
        }
    }
}
