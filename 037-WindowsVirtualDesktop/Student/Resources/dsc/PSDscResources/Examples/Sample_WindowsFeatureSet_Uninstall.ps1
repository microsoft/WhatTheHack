<#
    .SYNOPSIS
        Uninstalls the TelnetClient and RSAT-File-Services Windows features, including all their
        subfeatures. Logs the operation to the file at 'C:\LogPath\Log.log'.
#>
Configuration WindowsFeatureSetExample_Install
{
    [CmdletBinding()]
    param ()

    Import-DscResource -ModuleName 'PSDscResources'

    WindowsFeatureSet WindowsFeatureSet1
    {
        Name = @( 'Telnet-Client', 'RSAT-File-Services' )
        Ensure = 'Absent'
        IncludeAllSubFeature = $true
        LogPath = 'C:\LogPath\Log.log'
    }
}
