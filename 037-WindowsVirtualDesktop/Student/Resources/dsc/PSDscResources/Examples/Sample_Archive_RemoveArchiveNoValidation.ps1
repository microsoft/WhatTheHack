<#
    .SYNOPSIS
        Removes the expansion of the archive located at 'C:\ExampleArchivePath\Archive.zip' from the
        destination path 'C:\ExampleDestinationPath\Destination'.

        The resource will only check if the expanded archive files exist at the destination. 
        No validation is performed on any existing files at the destination to ensure that they
        match the files in the archive before removing them.  
#>
Configuration Sample_Archive_RemoveArchiveNoValidation
{
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Archive Archive5
        {
            Path = 'C:\ExampleArchivePath\Archive.zip'
            Destination = 'C:\ExampleDestinationPath\Destination'
            Ensure = 'Absent'
        }
    }
}
