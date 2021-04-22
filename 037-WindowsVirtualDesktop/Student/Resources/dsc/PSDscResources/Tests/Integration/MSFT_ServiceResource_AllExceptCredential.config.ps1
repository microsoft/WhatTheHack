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

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [ValidateSet('Present', 'Absent')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DisplayName = "$Name DisplayName",

        [Parameter()]
        [System.String]
        $Description = 'TestDescription',

        [Parameter()]
        [System.String[]]
        [AllowEmptyCollection()]
        $Dependencies = @(),

        [Parameter()]
        [ValidateSet('LocalSystem', 'LocalService', 'NetworkService')]
        [System.String]
        $BuiltInAccount = 'LocalSystem',

        [Parameter()]
        [System.Boolean]
        $DesktopInteract = $false,

        [Parameter()]
        [ValidateSet('Automatic', 'Manual', 'Disabled')]
        [System.String]
        $StartupType = 'Automatic',

        [Parameter()]
        [ValidateSet('Running', 'Stopped', 'Ignore')]
        [System.String]
        $State = 'Running',

        [Parameter()]
        [System.UInt32]
        $StartupTimeout = 30000,

        [Parameter()]
        [System.UInt32]
        $TerminateTimeout = 30000
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Service Service1
        {
            Name             = $Name
            Ensure           = $Ensure
            Path             = $Path
            StartupType      = $StartupType
            BuiltInAccount   = $BuiltInAccount
            DesktopInteract  = $DesktopInteract
            State            = $State
            DisplayName      = $DisplayName
            Description      = $Description
            Dependencies     = $Dependencies
            StartupTimeout   = $StartupTimeout
            TerminateTimeout = $TerminateTimeout
        }
    }
}
