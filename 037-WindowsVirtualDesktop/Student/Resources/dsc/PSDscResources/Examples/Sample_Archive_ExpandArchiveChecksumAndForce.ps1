<#
    .SYNOPSIS
        Expands the archive located at 'C:\ExampleArchivePath\Archive.zip' to the destination path
        'C:\ExampleDestinationPath\Destination'.

        Since Validate is specified as $true and the Checksum parameter is specified as SHA-256, the
        resource will check if the SHA-256 hash of the file in the archive matches the SHA-256 hash
        of the corresponding file at the destination and replace any files that do not match.

        Since Force is specified as $true, the resource will overwrite any mismatching files at the
        destination. If Force is specified as $false, the resource will throw an error instead of
        overwrite any files at the destination.
#>
Configuration Sample_Archive_ExpandArchiveChecksumAndForce
{
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Archive Archive4
        {
            Path = 'C:\ExampleArchivePath\Archive.zip'
            Destination = 'C:\ExampleDestinationPath\Destination'
            Validate = $true
            Checksum = 'SHA-256'
            Force = $true
            Ensure = 'Present'
        }
    }
}
