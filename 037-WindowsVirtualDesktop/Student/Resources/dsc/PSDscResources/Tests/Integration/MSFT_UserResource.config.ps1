
# Integration Test Config Template Version 1.0.0
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
        [System.String]
        $UserName = 'Test UserName',

        [System.String]
        $Description = 'Test Description',

        [System.String]
        $FullName = 'Test Full Name',

        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Password,

        [Boolean]
        $PasswordNeverExpires = $false
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {

        User UserResource1
        {
            UserName = $UserName
            Ensure = $Ensure
            FullName = $FullName
            Description = $Description
            Password = $Password
            PasswordNeverExpires = $PasswordNeverExpires
        }
    }
}
