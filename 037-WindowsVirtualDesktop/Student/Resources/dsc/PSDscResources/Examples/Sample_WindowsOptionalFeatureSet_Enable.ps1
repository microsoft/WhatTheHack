<#
    .SYNOPSIS
        Enables the Windows optional features MicrosoftWindowsPowerShellV2 and
        Internet-Explorer-Optional-amd64 and outputs a log of the operations to a file at the path
        'C:\LogPath\Log.txt'.
#>
Configuration WindowsOptionalFeatureSet_Enable
{
    Import-DscResource -ModuleName 'PSDscResources'

    WindowsOptionalFeatureSet WindowsOptionalFeatureSet1
    {
        Name = @('MicrosoftWindowsPowerShellV2', 'Internet-Explorer-Optional-amd64')
        Ensure = 'Present'
        LogPath = 'C:\LogPath\Log.txt'
    }
}
