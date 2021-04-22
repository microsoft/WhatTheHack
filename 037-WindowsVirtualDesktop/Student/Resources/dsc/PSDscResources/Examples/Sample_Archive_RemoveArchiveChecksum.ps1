<#
    .SYNOPSIS
        Remove the expansion of the archive located at 'C:\ExampleArchivePath\Archive.zip' from the
        destination path 'C:\ExampleDestinationPath\Destination'.

        Since Validate is specified as $true and the Checksum parameter is specified as SHA-256, the
        resource will check if the SHA-256 hash of the file in the archive matches the SHA-256 hash
        of the corresponding file at the destination and will not remove any files that do not match.
#>
Configuration Sample_Archive_RemoveArchiveChecksum
{
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Archive Archive6
        {
            Path = 'C:\ExampleArchivePath\Archive.zip'
            Destination = 'C:\ExampleDestinationPath\Destination'
            Validate = $true
            Checksum = 'SHA-256'
            Ensure = 'Absent'
        }
    }
}
