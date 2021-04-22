<#
    .SYNOPSIS
        Stops and then removes the service with the name Service1.
#>
Configuration Sample_Service_DeleteService
{
    [CmdletBinding()]
    param
    ()

    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Service ServiceResource1
        {
            Name = 'Service1'
            Ensure = 'Absent'
        }
    }
}
