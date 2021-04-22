<#
    .SYNOPSIS
        Expands the archive located at 'C:\ExampleArchivePath\Archive.zip' to the destination path
        'C:\ExampleDestinationPath\Destination'.

        The added specification of a Credential here allows you to provide the credential of a user
        to provide the resource access to the archive and destination paths.

        The resource will only check if the expanded archive files exist at the destination. 
        No validation is performed on any existing files at the destination to ensure that they
        match the files in the archive.
#>
Configuration Sample_Archive_ExpandArchiveNoValidationCredential
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Archive Archive2
        {
            Path = 'C:\ExampleArchivePath\Archive.zip'
            Destination = 'C:\ExampleDestinationPath\Destination'
            Credential = $Credential
            Ensure = 'Present'
        }
    }
}
