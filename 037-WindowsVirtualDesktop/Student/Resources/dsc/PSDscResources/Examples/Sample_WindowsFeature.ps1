<#
    .SYNOPSIS
        Creates a custom configuration for installing or uninstalling a Windows role or feature.

    .PARAMETER Name
        The name of the role or feature to install or uninstall.
        Default is 'Telnet-Client'.

    .PARAMETER Ensure
        Specifies whether the role or feature should be installed ('Present')
        or uninstalled ('Absent').
        By default this is set to Present.

    .PARAMETER IncludeAllSubFeature
        Specifies whether or not all subfeatures should be installed or uninstalled with
        the specified role or feature. Default is false.
        If this property is true and Ensure is set to Present, all subfeatures will be installed.
        If this property is false and Ensure is set to Present, subfeatures will not be installed or uninstalled.
        If Ensure is set to Absent, all subfeatures will be uninstalled.

    .PARAMETER Credential
        The credential (if required) to install or uninstall the role or feature.
        Optional. This must be added to the Node if it is required, as it is not being set
        in this configuration file currently.

    .PARAMETER LogPath
        The custom path to the log file to log this operation.
        If not passed in, the default log path will be used (%windir%\logs\ServerManager.log).
        Optional. This must be added to the Node if it is required, as it is not being set
        in this configuration file currently.
#>

Configuration 'Install_Feature_Telnet_Client'
{
    param 
    (       
        [System.String]
        $Name = 'Telnet-Client',

        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [System.Boolean]
        $IncludeAllSubFeature = $false,

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [ValidateNotNullOrEmpty()]
        [System.String]
        $LogPath
    )
    
    Import-DscResource -ModuleName 'PSDscResources'
    
    Node Localhost
    {
        WindowsFeature WindowsFeatureTest
        {
            Name = $Name
            Ensure = $Ensure
            IncludeAllSubFeature = $IncludeAllSubFeature
        }
    }
}

