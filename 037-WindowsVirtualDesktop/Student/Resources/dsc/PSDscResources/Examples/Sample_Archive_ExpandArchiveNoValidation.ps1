<#
    .SYNOPSIS
        Expands the archive located at 'C:\ExampleArchivePath\Archive.zip' to the destination path
        'C:\ExampleDestinationPath\Destination'.

        The resource will only check if the expanded archive files exist at the destination. 
        No validation is performed on any existing files at the destination to ensure that they
        match the files in the archive.  
#>
Configuration Sample_Archive_ExpandArchiveNoValidation
{
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Archive Archive1
        {
            Path = 'C:\ExampleArchivePath\Archive.zip'
            Destination = 'C:\ExampleDestinationPath\Destination'
            Ensure = 'Present'
        }
    }
}
