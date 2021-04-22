<#
    .SYNOPSIS
        Stops the gpresult process if it is running. 
        Since the Arguments parameter isn't needed to stop the process,
        an empty string is passed in.
#>
Configuration Sample_WindowsProcess_Stop
{
    param ()

    Import-DSCResource -ModuleName 'PSDscResources'

    Node localhost
    {
        WindowsProcess GPresult
        {
            Path = 'C:\Windows\System32\gpresult.exe'
            Arguments = ''
            Ensure = 'Absent'
        }
    }
}
 
Sample_WindowsProcess_Stop

