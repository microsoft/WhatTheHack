<#
    .SYNOPSIS
        Starts the gpresult process which generates a log about the group policy.
        The path to the log is provided in 'Arguments'.
#>
Configuration Sample_WindowsProcess_Start
{
    param ()

    Import-DSCResource -ModuleName 'PSDscResources'

    Node localhost
    {
        WindowsProcess GPresult
        {
            Path = 'C:\Windows\System32\gpresult.exe'
            Arguments = '/h C:\gp2.htm'
            Ensure = 'Present'
        }
    }
}

Sample_WindowsProcess_Start

