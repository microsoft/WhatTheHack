<#
    .SYNOPSIS
        Starts the processes with the executables at the file paths C:\Windows\cmd.exe and
        C:\TestPath\TestProcess.exe with no arguments.
#>
Configuration Sample_ProcessSet_Start
{
    [CmdletBinding()]
    param ()

    Import-DscResource -ModuleName 'PSDscResources'

    ProcessSet ProcessSet1
    {
        Path = @( 'C:\Windows\System32\cmd.exe', 'C:\TestPath\TestProcess.exe' )
        Ensure = 'Present'
    }
}
