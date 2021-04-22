<#
    .SYNOPSIS
        Removes the registry key called MyNewKey under the parent key
        'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'.
#>
Configuration Sample_RegistryResource_RemoveKey
{
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Registry Registry1
        {
            Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyNewKey'
            Ensure = 'Absent'
            ValueName = ''
        }
    }
}
