$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADReplicationSubnet'

<#
    .SYNOPSIS
        Returns the current state of the replication subnet.

    .PARAMETER Name
        The name of the AD replication subnet, e.g. 10.0.0.0/24.

    .PARAMETER Site
        The name of the assigned AD replication site, e.g. Default-First-Site-Name.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Site
    )

    <#
        Get the replication subnet filtered by it's name. If the subnet is not
        present, the command will return $null.
    #>
    Write-Verbose -Message ($script:localizedData.GetReplicationSubnet -f $Name)

    $replicationSubnet = Get-ADReplicationSubnet -Filter { Name -eq $Name } -Properties Description

    if ($null -eq $replicationSubnet)
    {
        # Replication subnet not found, return absent.
        Write-Verbose -Message ($script:localizedData.ReplicationSubnetAbsent -f $Name)

        $returnValue = @{
            Ensure      = 'Absent'
            Name        = $Name
            Site        = ''
            Location    = $null
            Description = $null
        }
    }
    else
    {
        # Get the name of the replication site, if it's not empty.
        $replicationSiteName = ''

        if ($null -ne $replicationSubnet.Site)
        {
            $replicationSiteName = Get-ADObject -Identity $replicationSubnet.Site |
                Select-Object -ExpandProperty 'Name'
        }

        # Replication subnet found, return present.
        Write-Verbose -Message ($script:localizedData.ReplicationSubnetPresent -f $Name)

        $returnValue = @{
            Ensure      = 'Present'
            Name        = $Name
            Site        = $replicationSiteName
            Location    = [System.String] $replicationSubnet.Location
            Description = [System.String] $replicationSubnet.Description
        }
    }

    return $returnValue
}

<#
    .SYNOPSIS
        Add, remove or update the replication subnet.

    .PARAMETER Ensure
        Specifies if the AD replication subnet should be added or remove. Default value is 'Present'.

    .PARAMETER Name
        The name of the AD replication subnet, e.g. 10.0.0.0/24.

    .PARAMETER Site
        The name of the assigned AD replication site, e.g. Default-First-Site-Name.

    .PARAMETER Location
        The location for the AD replication site. Default value is empty.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Site,

        [Parameter()]
        [System.String]
        $Location = '',

        [Parameter()]
        [System.String]
        $Description
    )

    <#
        Get the replication subnet filtered by it's name. If the subnet is not
        present, the command will return $null.
    #>
    $replicationSubnet = Get-ADReplicationSubnet -Filter { Name -eq $Name }

    if ($Ensure -eq 'Present')
    {
        # Add the replication subnet, if it does not exist.
        if ($null -eq $replicationSubnet)
        {
            Write-Verbose -Message ($script:localizedData.CreateReplicationSubnet -f $Name)

            $replicationSubnet = New-ADReplicationSubnet -Name $Name -Site $Site -PassThru
        }

        <#
            Get the name of the replication site, if it's not empty and update the
            site if it's not vaild.
        #>
        if ($null -ne $replicationSubnet.Site)
        {
            $replicationSiteName = Get-ADObject -Identity $replicationSubnet.Site |
                Select-Object -ExpandProperty 'Name'
        }

        if ($replicationSiteName -ne $Site)
        {
            Write-Verbose -Message ($script:localizedData.SetReplicationSubnetSite -f $Name, $Site)

            Set-ADReplicationSubnet -Identity $replicationSubnet.DistinguishedName -Site $Site -PassThru
        }

        <#
            Update the location, if it's not valid. Ensure an empty location
            string is converted to $null, because the Set-ADReplicationSubnet
            does not accept an empty string for the location, but $null.
        #>
        $nullableLocation = $Location
        if ([System.String]::IsNullOrEmpty($Location))
        {
            $nullableLocation = $null
        }

        if ($replicationSubnet.Location -ne $nullableLocation)
        {
            Write-Verbose -Message ($script:localizedData.SetReplicationSubnetLocation -f $Name, $nullableLocation)

            Set-ADReplicationSubnet -Identity $replicationSubnet.DistinguishedName -Location $nullableLocation -PassThru
        }

        if ($PSBoundParameters.ContainsKey('Description'))
        {
            if ($replicationSubnet.Description -ne $Description)
            {
                Write-Verbose -Message ($script:localizedData.SetReplicationSubnetDescription -f $Name, $Description)

                Set-ADReplicationSubnet -Identity $replicationSubnet.DistinguishedName -Description $Description
            }
        }
    }

    if ($Ensure -eq 'Absent')
    {
        # Remove the replication subnet, if it exists.
        if ($null -ne $replicationSubnet)
        {
            Write-Verbose -Message ($script:localizedData.RemoveReplicationSubnet -f $Name)

            Remove-ADReplicationSubnet -Identity $replicationSubnet.DistinguishedName -Confirm:$false
        }
    }
}

<#
    .SYNOPSIS
        Test the replication subnet.

    .PARAMETER Ensure
        Specifies if the AD replication subnet should be added or remove. Default value is 'Present'.

    .PARAMETER Name
        The name of the AD replication subnet, e.g. 10.0.0.0/24.

    .PARAMETER Site
        The name of the assigned AD replication site, e.g. Default-First-Site-Name.

    .PARAMETER Location
        The location for the AD replication site. Default value is empty.

    .PARAMETER Description
        Specifies a description of the object. This parameter sets the value of the Description property for the object.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Site,

        [Parameter()]
        [System.String]
        $Location = '',

        [Parameter()]
        [System.String]
        $Description
    )

    $currentConfiguration = Get-TargetResource -Name $Name -Site $Site

    $desiredConfigurationMatch = $currentConfiguration.Ensure -eq $Ensure

    if ($Ensure -eq 'Present')
    {
        $desiredConfigurationMatch = $desiredConfigurationMatch -and
        $currentConfiguration.Site -eq $Site -and
        $currentConfiguration.Location -eq $Location -and
        $currentConfiguration.Description -eq $Description
    }

    if ($desiredConfigurationMatch)
    {
        Write-Verbose -Message ($script:localizedData.ReplicationSubnetInDesiredState -f $Name)
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.ReplicationSubnetNotInDesiredState -f $Name)
    }

    return $desiredConfigurationMatch
}
