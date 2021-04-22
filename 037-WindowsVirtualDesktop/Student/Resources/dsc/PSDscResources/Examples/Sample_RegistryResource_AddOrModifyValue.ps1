<#
    .SYNOPSIS
        If the registry key value MyValue under the key
        'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' does not exist,
        creates it with the Binary value 0.

        If the registry key value MyValue under the key
        'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' already exists,
        overwrites it with the Binary value 0.
#>
Configuration Sample_RegistryResource_AddOrModifyValue
{
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Registry Registry1
        {
            Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
            Ensure = 'Present'
            ValueName = 'MyValue'
            ValueType = 'Binary'
            ValueData = '0x00'
            Force = $true
        }
    }
}
