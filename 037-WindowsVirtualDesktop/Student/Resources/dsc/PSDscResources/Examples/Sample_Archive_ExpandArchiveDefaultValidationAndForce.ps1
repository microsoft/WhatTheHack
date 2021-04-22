<#
    .SYNOPSIS
        Expands the archive located at 'C:\ExampleArchivePath\Archive.zip' to the destination path
        'C:\ExampleDestinationPath\Destination'.

        Since Validate is specified as $true and the Checksum parameter is not provided, the
        resource will check if the last write time of the archive file matches the last write time
        of the corresponding file at the destination and replace any files that do not match.

        Since Force is specified as $true, the resource will overwrite any mismatching files at the
        destination. If Force is specified as $false, the resource will throw an error instead of
        overwrite any files at the destination.
#>
Configuration Sample_Archive_ExpandArchiveDefaultValidationAndForce
{
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Archive Archive3
        {
            Path = 'C:\ExampleArchivePath\Archive.zip'
            Destination = 'C:\ExampleDestinationPath\Destination'
            Validate = $true
            Force = $true
            Ensure = 'Present'
        }
    }
}
