# Import the Helper module
$modulePath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath 'Modules'
Import-Module -Name (Join-Path -Path $modulePath -ChildPath (Join-Path -Path Helper -ChildPath Helper.psm1))

# Localized messages
data LocalizedData
{
    # culture="en-US"
    ConvertFrom-StringData @'
CheckingZoneMessage                     = Checking DNS server zone with name '{0}' is '{1}'...
AddingZoneMessage                       = Adding DNS server zone '{0}' ...
RemovingZoneMessage                     = Removing DNS server zone '{0}' ...

CheckPropertyMessage                    = Checking DNS server zone property '{0}' ...
NotDesiredPropertyMessage               = DNS server zone property '{0}' is not correct. Expected '{1}', actual '{2}'
SetPropertyMessage                      = DNS server zone property '{0}' is set

CredentialRequiresComputerNameMessage   = The Credentials Parameter can only be used when ComputerName is also specified.
DirectoryPartitionReplicationScopeError = A Directory Partition can only be specified when the Replication Scope is set to 'Custom'
'@
}

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

        [Parameter()]
        [ValidateSet('None','NonsecureAndSecure','Secure')]
        [System.String]
        $DynamicUpdate = 'Secure',

        [Parameter(Mandatory = $true)]
        [ValidateSet('Custom','Domain','Forest','Legacy')]
        [System.String]
        $ReplicationScope,

        [Parameter()]
        [System.String]
        $DirectoryPartitionName,

        [Parameter()]
        [System.String]
        $ComputerName,

        [Parameter()]
        [pscredential]
        $Credential,

        [Parameter()]
        [ValidateSet('Present','Absent')]
        [System.String]
        $Ensure = 'Present'
    )
    Assert-Module -Name 'DNSServer'
    Write-Verbose ($LocalizedData.CheckingZoneMessage -f $Name, $Ensure)

    if (!$PSBoundParameters.ContainsKey('ComputerName') -and $PSBoundParameters.ContainsKey('Credential'))
    {
        throw $LocalizedData.CredentialRequiresComputerNameMessage
    }

    $getParams = @{
        Name = $Name
        ErrorAction = 'SilentlyContinue'
    }

    if ($PSBoundParameters.ContainsKey('ComputerName'))
    {
        $cimSessionParams = @{
            ErrorAction = 'SilentlyContinue'
            ComputerName = $ComputerName
        }
        if ($PSBoundParameters.ContainsKey('Credential'))
        {
            $cimSessionParams += @{
                Credential = $Credential
            }
        }
        $getParams = @{
            CimSession = New-CimSession @cimSessionParams
        }
    }

    $dnsServerZone = Get-DnsServerZone @getParams
    if ($getParams.CimSession)
    {
        Remove-CimSession -CimSession $getParams.CimSession
    }
    $targetResource = @{
        Name = $dnsServerZone.ZoneName
        DynamicUpdate = $dnsServerZone.DynamicUpdate
        ReplicationScope = $dnsServerZone.ReplicationScope
        DirectoryPartitionName = $dnsServerZone.DirectoryPartitionName
        Ensure = if ($null -eq $dnsServerZone) { 'Absent' } else { 'Present' }
    }
    return $targetResource
} #end function Get-TargetResource

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [Parameter()]
        [ValidateSet('None','NonsecureAndSecure','Secure')]
        [System.String]
        $DynamicUpdate = 'Secure',

        [Parameter(Mandatory = $true)]
        [ValidateSet('Custom','Domain','Forest','Legacy')]
        [System.String]
        $ReplicationScope,

        [Parameter()]
        [System.String]
        $DirectoryPartitionName,

        [Parameter()]
        [System.String]
        $ComputerName,

        [Parameter()]
        [pscredential]
        $Credential,

        [Parameter()]
        [ValidateSet('Present','Absent')]
        [System.String]
        $Ensure = 'Present'
    )
    $targetResource = Get-TargetResource @PSBoundParameters
    $targetResourceInCompliance = $true
    if ($Ensure -eq 'Present')
    {
        if ($targetResource.Ensure -eq 'Present')
        {
            if ($targetResource.DynamicUpdate -ne $DynamicUpdate)
            {
                Write-Verbose ($LocalizedData.NotDesiredPropertyMessage -f 'DynamicUpdate', $DynamicUpdate, $targetResource.DynamicUpdate)
                $targetResourceInCompliance = $false
            }
            if ($targetResource.ReplicationScope -ne $ReplicationScope)
            {
                Write-Verbose ($LocalizedData.NotDesiredPropertyMessage -f 'ReplicationScope', $ReplicationScope, $targetResource.ReplicationScope)
                $targetResourceInCompliance = $false
            }
            if ($DirectoryPartitionName -and $targetResource.DirectoryPartitionName -ne $DirectoryPartitionName)
            {
                Write-Verbose ($LocalizedData.NotDesiredPropertyMessage -f 'DirectoryPartitionName', $DirectoryPartitionName, $targetResource.DirectoryPartitionName)
                $targetResourceInCompliance = $false
            }
        }
        else
        {
            # Dns zone is present and needs removing
            Write-Verbose ($LocalizedData.NotDesiredPropertyMessage -f 'Ensure', 'Present', 'Absent')
            $targetResourceInCompliance = $false
        }
    }
    else
    {
        if ($targetResource.Ensure -eq 'Present')
        {
            ## Dns zone is absent and should be present
            Write-Verbose ($LocalizedData.NotDesiredPropertyMessage -f 'Ensure', 'Absent', 'Present')
            $targetResourceInCompliance = $false
        }
    }
    return $targetResourceInCompliance
} #end function Test-TargetResource

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [Parameter()]
        [ValidateSet('None','NonsecureAndSecure','Secure')]
        [System.String]
        $DynamicUpdate = 'Secure',

        [Parameter(Mandatory = $true)]
        [ValidateSet('Custom','Domain','Forest','Legacy')]
        [System.String]
        $ReplicationScope,

        [Parameter()]
        [System.String]
        $DirectoryPartitionName,

        [Parameter()]
        [System.String]
        $ComputerName,

        [Parameter()]
        [pscredential]
        $Credential,

        [Parameter()]
        [ValidateSet('Present','Absent')]
        [System.String]
        $Ensure = 'Present'
    )
    Assert-Module -Name 'DNSServer'
    $targetResource = Get-TargetResource @PSBoundParameters

    $params = @{
        Name = $Name
    }

    if ($PSBoundParameters.ContainsKey('ComputerName'))
    {
        $cimSessionParams = @{
            ErrorAction = 'SilentlyContinue'
            ComputerName = $ComputerName
        }
        if ($PSBoundParameters.ContainsKey('Credential'))
        {
            $cimSessionParams += @{
                Credential = $Credential
            }
        }
        $params += @{
            CimSession = New-CimSession @cimSessionParams
        }
    }

    if ($Ensure -eq 'Present')
    {
        if ($targetResource.Ensure -eq 'Present')
        {
            ## Update the existing zone
            if ($targetResource.DynamicUpdate -ne $DynamicUpdate)
            {
                $params += @{DynamicUpdate = $DynamicUpdate}
                Write-Verbose ($LocalizedData.SetPropertyMessage -f 'DynamicUpdate')
            }
            if ($targetResource.ReplicationScope -ne $ReplicationScope)
            {
                $params += @{ReplicationScope = $ReplicationScope}
                Write-Verbose ($LocalizedData.SetPropertyMessage -f 'ReplicationScope')
            }
            if ($DirectoryPartitionName -and $targetResource.DirectoryPartitionName -ne $DirectoryPartitionName)
            {
                if ($replicationScope -ne 'Custom')
                {
                    # ReplicationScope must be 'Custom' if a DirectoryPartitionName is specified
                    $newTerminationErrorParms = @{
                        ErrorMessage  = $LocalizedData.DirectoryPartitionReplicationScopeError
                        ErrorId       = 'DirectoryPartitionReplicationScopeError'
                        ErrorCategory = 'InvalidArgument'
                    }
                    New-TerminatingError @newTerminationErrorParms
                }
                # ReplicationScope is a required parameter if DirectoryPartitionName is specified
                if ($params.keys -notcontains 'ReplicationScope')
                {
                    $params += @{ReplicationScope = $ReplicationScope }
                }
                $params += @{DirectoryPartitionName = $DirectoryPartitionName }
                Write-Verbose ($LocalizedData.SetPropertyMessage -f 'DirectoryPartitionName')
            }
            Set-DnsServerPrimaryZone @params
        }
        elseif ($targetResource.Ensure -eq 'Absent')
        {
            ## Create the zone
            Write-Verbose ($LocalizedData.AddingZoneMessage -f $targetResource.Name)
            $params += @{
                DynamicUpdate = $DynamicUpdate
                ReplicationScope = $ReplicationScope
            }
            if ($DirectoryPartitionName)
            {
                if ($replicationScope -ne 'Custom')
                {
                    # ReplicationScope must be 'Custom' if a DirectoryPartitionName is specified
                    $newTerminationErrorParms = @{
                        ErrorMessage  = $LocalizedData.DirectoryPartitionReplicationScopeError
                        ErrorId       = 'DirectoryPartitionReplicationScopeError'
                        ErrorCategory = 'InvalidArgument'
                    }
                    New-TerminatingError @newTerminationErrorParms
                }
                $params += @{
                    DirectoryPartitionName = $DirectoryPartitionName
                }
            }
            Add-DnsServerPrimaryZone @params
        }
    }
    elseif ($Ensure -eq 'Absent')
    {
        # Remove the DNS Server zone
        Write-Verbose ($LocalizedData.RemovingZoneMessage -f $targetResource.Name)
        Remove-DnsServerZone @params -Force
    }
    if ($params.CimSession)
    {
        Remove-CimSession -CimSession $params.CimSession
    }
} #end function Set-TargetResource
