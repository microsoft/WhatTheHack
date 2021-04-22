<#
    .SYNOPSIS
        Disables the Windows optional features TelnetClient and LegacyComponents and removes all
        files associated with these features.
#>
Configuration WindowsOptionalFeatureSet_Disable
{
    Import-DscResource -ModuleName 'PSDscResources'

    WindowsOptionalFeatureSet WindowsOptionalFeatureSet1
    {
        Name = @('TelnetClient', 'LegacyComponents')
        Ensure = 'Absent'
        RemoveFilesOnDisable = $true
    }
}
