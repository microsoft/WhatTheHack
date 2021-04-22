$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADReplicationSiteLink'

<#
    .SYNOPSIS
        Gets the current configuration on an AD Replication Site Link.

    .PARAMETER Name
        Specifies the name of the AD Replication Site Link.

    .PARAMETER SitesExcluded
        Specifies the list of sites to remove from a site link.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $SitesExcluded
    )

    try
    {
        $siteLink = Get-ADReplicationSiteLink -Identity $Name -Properties 'Description', 'Options'
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {
        Write-Verbose -Message ($script:localizedData.SiteLinkNotFound -f $Name)

        $returnValue = @{
            Name                          = $Name
            Cost                          = $null
            Description                   = $null
            ReplicationFrequencyInMinutes = $null
            SitesIncluded                 = $null
            SitesExcluded                 = $SitesExcluded
            OptionChangeNotification      = $false
            OptionTwoWaySync              = $false
            OptionDisableCompression      = $false
            Ensure                        = 'Absent'
        }
        $siteLink = $null
    }
    catch
    {
        $errorMessage = $script:localizedData.GetSiteLinkUnexpectedError -f $Name
        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
    }

    if ($null -ne $siteLink)
    {
        if ($siteLink.SitesIncluded)
        {
            $siteCommonNames = @()

            foreach ($siteDN in $siteLink.SitesIncluded)
            {
                $siteCommonNames += Resolve-SiteLinkName -SiteName $siteDn
            }
        }

        if ($null -eq $siteLink.Options)
        {
            $siteLinkOptions = Get-EnabledOptions -OptionValue 0
        }
        else
        {
            $siteLinkOptions = Get-EnabledOptions -OptionValue $siteLink.Options
        }

        $sitesExcludedEvaluated = $SitesExcluded |
            Where-Object -FilterScript { $_ -notin $siteCommonNames }

        $returnValue = @{
            Name                          = $Name
            Cost                          = $siteLink.Cost
            Description                   = $siteLink.Description
            ReplicationFrequencyInMinutes = $siteLink.ReplicationFrequencyInMinutes
            SitesIncluded                 = $siteCommonNames
            SitesExcluded                 = $sitesExcludedEvaluated
            OptionChangeNotification      = $siteLinkOptions.USE_NOTIFY
            OptionTwoWaySync              = $siteLinkOptions.TWOWAY_SYNC
            OptionDisableCompression      = $siteLinkOptions.DISABLE_COMPRESSION
            Ensure                        = 'Present'
        }
    }

    return $returnValue
}

<#
    .SYNOPSIS
        Sets the desired configuration on an AD Replication Site Link.

    .PARAMETER Name
        Specifies the name of the AD Replication Site Link.

    .PARAMETER Cost
        Specifies the cost to be placed on the site link.

    .PARAMETER Description
        Specifies a description of the object.

    .PARAMETER ReplicationFrequencyInMinutes
        Specifies the frequency (in minutes) for which replication will occur where this site link is in use between sites.

    .PARAMETER SitesIncluded
        Specifies the list of sites included in the site link.

    .PARAMETER SitesExcluded
        Specifies the list of sites to remove from a site link.

    .PARAMETER OptionChangeNotification
        Enables or disables Change Notification Replication on a site link. Default value is $false.

    .PARAMETER OptionTwoWaySync
        Two Way Sync on a site link. Default value is $false.

    .PARAMETER OptionDisableCompression
        Enables or disables Compression on a site link. Default value is $false.

    .PARAMETER Ensure
        Specifies if the site link is created or deleted.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Int32]
        $Cost,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Int32]
        $ReplicationFrequencyInMinutes,

        [Parameter()]
        [System.String[]]
        $SitesIncluded,

        [Parameter()]
        [System.String[]]
        $SitesExcluded,

        [Parameter()]
        [System.Boolean]
        $OptionChangeNotification = $false,

        [Parameter()]
        [System.Boolean]
        $OptionTwoWaySync = $false,

        [Parameter()]
        [System.Boolean]
        $OptionDisableCompression = $false,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present'
    )

    if ($Ensure -eq 'Present')
    {
        # Modify parameters for splatting to New-ADReplicationSiteLink.
        $desiredParameters = $PSBoundParameters
        $desiredParameters.Remove('Ensure')
        $desiredParameters.Remove('SitesExcluded')

        $currentADSiteLink = Get-TargetResource -Name $Name

        <#
            Since Set and New have different parameters we have to test if the
            site link exists to determine what cmdlet we need to use.
        #>
        if ( $currentADSiteLink.Ensure -eq 'Absent' )
        {
            Write-Verbose -Message ($script:localizedData.NewSiteLink -f $Name)
            New-ADReplicationSiteLink @desiredParameters
        }
        else
        {
            # now we have to determine if we need to add or remove sites from SitesIncluded.
            $setParameters = @{
                Identity = $Name
            }

            $replaceParameters = @{}

            # build the SitesIncluded hashtable.
            $sitesIncludedParameters = @{}
            if ($SitesExcluded)
            {
                Write-Verbose -Message ($script:localizedData.RemovingSites -f $($SiteExcluded -join ', '), $Name)

                <#
                    Wrapped in $() as we were getting some weird results without it,
                    results were not being added into Hashtable as strings.
                #>
                $sitesIncludedParameters.Add('Remove', $($SitesExcluded))
            }

            if ($SitesIncluded)
            {
                Write-Verbose -Message ($script:localizedData.AddingSites -f $($SitesIncluded -join ', '), $Name)

                <#
                    Wrapped in $() as we were getting some weird results without it,
                    results were not being added into Hashtable as strings.
                #>
                $sitesIncludedParameters.Add('Add', $($SitesIncluded))
            }

            if ($null -ne $($sitesIncludedParameters.Keys))
            {
                $setParameters.Add('SitesIncluded', $sitesIncludedParameters)
            }

            # Calculate the Options value for Change Notification replication
            if ($PSBoundParameters.ContainsKey('OptionChangeNotification'))
            {
                $changeNotification = $OptionChangeNotification
            }
            else
            {
                $changeNotification = $currentADSiteLink.OptionChangeNotification
            }

            if ($PSBoundParameters.ContainsKey('OptionTwoWaySync'))
            {
                $twoWaySync = $OptionTwoWaySync
            }
            else
            {
                $twoWaySync = $currentADSiteLink.OptionTwoWaySync
            }

            if ($PSBoundParameters.ContainsKey('OptionDisableCompression'))
            {
                $disableCompression = $OptionDisableCompression
            }
            else
            {
                $disableCompression = $currentADSiteLink.OptionDisableCompression
            }

            $optionsValue = ConvertTo-EnabledOptions -OptionChangeNotification $changeNotification -OptionTwoWaySync $twoWaySync -OptionDisableCompression $disableCompression

            if ($optionsValue -eq 0)
            {
                $setParameters.Add('Clear', 'Options')
            }
            else
            {
                $replaceParameters.Add('Options', $optionsValue)
            }

            # Add the rest of the parameters.
            foreach ($parameter in $PSBoundParameters.Keys)
            {
                if ($parameter -notmatch 'SitesIncluded|SitesExcluded|Name|Ensure|OptionChangeNotification|OptionTwoWaySync|OptionDisableCompression')
                {
                    $setParameters.Add($parameter, $PSBoundParameters[$parameter])
                }
            }

            if ($replaceParameters.Count -gt 0)
            {
                $setParameters.Add('Replace', $replaceParameters)
            }

            Set-ADReplicationSiteLink @setParameters
        }
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.RemoveSiteLink -f $Name)

        Remove-ADReplicationSiteLink -Identity $Name
    }
}

<#
    .SYNOPSIS
        Tests if the AD Replication Site Link is in a desired state.

    .PARAMETER Name
        Specifies the name of the AD Replication Site Link.

    .PARAMETER Cost
        Specifies the cost to be placed on the site link.

    .PARAMETER Description
        Specifies a description of the object.

    .PARAMETER ReplicationFrequencyInMinutes
        Specifies the frequency (in minutes) for which replication will occur where this site link is in use between sites.

    .PARAMETER SitesIncluded
        Specifies the list of sites included in the site link.

    .PARAMETER SitesExcluded
        Specifies the list of sites to remove from a site link.

    .PARAMETER OptionChangeNotification
        Enables or disables Change Notification Replication on a site link. Default value is $false.

    .PARAMETER OptionTwoWaySync
        Two Way Sync on a site link. Default value is $false.

    .PARAMETER OptionDisableCompression
        Enables or disables Compression on a site link. Default value is $false.

    .PARAMETER Ensure
        Specifies if the site link is created or deleted.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Int32]
        $Cost,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Int32]
        $ReplicationFrequencyInMinutes,

        [Parameter()]
        [System.String[]]
        $SitesIncluded,

        [Parameter()]
        [System.String[]]
        $SitesExcluded,

        [Parameter()]
        [System.Boolean]
        $OptionChangeNotification = $false,

        [Parameter()]
        [System.Boolean]
        $OptionTwoWaySync = $false,

        [Parameter()]
        [System.Boolean]
        $OptionDisableCompression = $false,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present'
    )

    $isCompliant = $true
    $currentSiteLink = Get-TargetResource -Name $Name

    # Test for Ensure.
    if ($Ensure -ne $currentSiteLink.Ensure)
    {
        return $false
    }

    # Test for SitesIncluded.
    foreach ($desiredIncludedSite in $SitesIncluded)
    {
        if ($desiredIncludedSite -notin $currentSiteLink.SitesIncluded)
        {
            Write-Verbose -Message ($script:localizedData.SiteNotFound -f $desiredIncludedSite, $($currentSiteLink.SitesIncluded -join ', '))
            $isCompliant = $false
        }
    }

    # Test for SitesExcluded.
    foreach ($desiredExcludedSite in $SitesExcluded)
    {
        if ($desiredExcludedSite -in $currentSiteLink.SitesIncluded)
        {
            Write-Verbose -Message ($script:localizedData.SiteFoundInExcluded -f $desiredExcludedSite, $($currentSiteLink.SitesIncluded -join ', '))
            $isCompliant = $false
        }
    }

    foreach ($parameter in $PSBoundParameters.Keys)
    {
        # Test for Description|ReplicationFrequencyInMinutes|Cost.
        if ($parameter -match 'Description|ReplicationFrequencyInMinutes|Cost|OptionChangeNotification|OptionTwoWaySync|OptionDisableCompression')
        {
            if ($PSBoundParameters[$parameter] -ne $currentSiteLink[$parameter])
            {
                Write-Verbose -Message ($script:localizedData.PropertyNotInDesiredState -f $parameter, $($currentSiteLink[$parameter]), $($PSBoundParameters[$parameter]))
                $isCompliant = $false
            }
        }
    }

    return $isCompliant
}

<#
    .SYNOPSIS
        Resolves the AD replication site link distinguished names to short names

    .PARAMETER SiteName
        Specifies the distinguished name of a AD replication site link

    .EXAMPLE
        PS C:\> Resolve-SiteLinkName -SiteName 'CN=Site1,CN=Sites,CN=Configuration,DC=contoso,DC=com'
        Site1
#>
function Resolve-SiteLinkName
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseCmdletCorrectly", "")]
    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteName
    )

    $adSite = Get-ADReplicationSite -Identity $SiteName

    return $adSite.Name
}

<#
    .SYNOPSIS
        Calculates the options enabled on a Site Link

    .PARAMETER OptionValue
        The value of currently enabled options
#>
function Get-EnabledOptions
{
    [OutputType([System.Collections.Hashtable])]
    [CmdletBinding()]

    param
    (
        [Parameter(Mandatory = $true)]
        [System.Int32]
        $OptionValue
    )

    $returnValue = @{
        USE_NOTIFY          = $false
        TWOWAY_SYNC         = $false
        DISABLE_COMPRESSION = $false
    }

    if (1 -band $optionValue)
    {
        $returnValue.USE_NOTIFY = $true
    }

    if (2 -band $optionValue)
    {
        $returnValue.TWOWAY_SYNC = $true
    }

    if (4 -band $optionValue)
    {
        $returnValue.DISABLE_COMPRESSION = $true
    }

    return $returnValue
}

<#
    .SYNOPSIS
        Calculates the options value for the given choices

    .PARAMETER OptionChangeNotification
        Enable/Disable Change notification replication

    .PARAMETER OptionTwoWaySync
        Enable/Disable Two Way sync

    .PARAMETER OptionDisableCompression
        Enable/Disable Compression
#>
function ConvertTo-EnabledOptions
{
    [OutputType([System.Int32])]
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.Boolean]
        $OptionChangeNotification,

        [Parameter()]
        [System.Boolean]
        $OptionTwoWaySync,

        [Parameter()]
        [System.Boolean]
        $OptionDisableCompression
    )

    $returnValue = 0

    if ($OptionChangeNotification)
    {
        $returnValue = $returnValue + 1
    }

    if ($OptionTwoWaySync)
    {
        $returnValue = $returnValue + 2
    }

    if ($OptionDisableCompression)
    {
        $returnValue = $returnValue + 4
    }

    return $returnValue
}

Export-ModuleMember -Function *-TargetResource
