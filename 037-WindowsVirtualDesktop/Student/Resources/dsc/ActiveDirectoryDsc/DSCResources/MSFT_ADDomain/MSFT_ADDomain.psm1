$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADDomain'

<#
    .SYNOPSIS
        Retrieves the name of the file that tracks the status of the ADDomain resource with the
        specified domain name.

    .PARAMETER DomainName
        The domain name of the ADDomain resource to retrieve the tracking file name of.

    .NOTES
        The tracking file is currently output to the environment's temp directory.

        This file is NOT removed when a configuration completes, so if another call to a ADDomain
        resource with the same domain name occurs in the same environment, this file will already
        be present.

        This is so that when another call is made to the same resource, the resource will not
        attempt to promote the machine to a domain controller again (which would cause an error).

        If the resource should be promoted to a domain controller once again, you must first remove
        this file from the environment's temp directory (usually C:\Temp).

        If in the future this functionality needs to change so that future configurations are not
        affected, $env:temp should be changed to the resource's cache location which is removed
        after each configuration.
        ($env:systemRoot\system32\Configuration\BuiltinProvCache\MSFT_ADDomain)
#>
function Get-TrackingFilename
{
    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName
    )

    return Join-Path -Path ($env:TEMP) -ChildPath ('{0}.ADDomain.completed' -f $DomainName)
}

<#
    .SYNOPSIS
        Get the current state of the Domain.

    .PARAMETER DomainName
        The fully qualified domain name (FQDN) of a new domain. If setting up a
        child domain this must be set to a single-label DNS name.

    .PARAMETER Credential
        Specifies the user name and password that corresponds to the account used
        to install the domain controller. When adding a child domain these credentials
        need the correct permission in the parent domain. The credentials will also
        be used to query for the existence of the domain or child domain. This will
        not be created as a user in the new domain. The domain administrator password
        will be the same as the password of the local Administrator of this node.

    .PARAMETER SafeModeAdministratorPassword
        Password for the administrator account when the computer is started in Safe Mode.

    .PARAMETER ParentDomainName
        Fully qualified domain name (FQDN) of the parent domain.

    .PARAMETER DomainNetBiosName
        NetBIOS name for the new domain.

    .PARAMETER DnsDelegationCredential
        Credential used for creating DNS delegation.

    .PARAMETER DatabasePath
        Path to a directory that contains the domain database.

    .PARAMETER LogPath
        Path to a directory for the log file that will be written.

    .PARAMETER SysvolPath
        Path to a directory where the Sysvol file will be written.

    .PARAMETER ForestMode
        The Forest Functional Level for the entire forest.

    .PARAMETER DomainMode
        The Domain Functional Level for the entire domain.

    .NOTES
        No need to check whether the node is actually a domain controller.
        Domain controller functionality should be checked by the
        ADDomainController resource.

#>
function Get-TargetResource
{
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $SafeModeAdministratorPassword,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ParentDomainName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainNetBiosName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $DnsDelegationCredential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DatabasePath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $LogPath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $SysvolPath,

        [Parameter()]
        [ValidateSet('Win2008', 'Win2008R2', 'Win2012', 'Win2012R2', 'WinThreshold')]
        [System.String]
        $ForestMode,

        [Parameter()]
        [ValidateSet('Win2008', 'Win2008R2', 'Win2012', 'Win2012R2', 'WinThreshold')]
        [System.String]
        $DomainMode
    )

    Assert-Module -ModuleName 'ADDSDeployment' -ImportModule

    $returnValue = @{
        DomainName = $DomainName
        Credential = $Credential
        SafeModeAdministratorPassword = $SafeModeAdministratorPassword
        ParentDomainName = $null
        DomainNetBiosName = $null
        DnsDelegationCredential = $null
        DatabasePath = $null
        LogPath = $null
        SysvolPath = $null
        ForestMode = $null
        DomainMode = $null
        DomainExist = $false
        Forest = $null
        DnsRoot = $null
    }

    $domainFQDN = Resolve-DomainFQDN -DomainName $DomainName -ParentDomainName $ParentDomainName

    $retries = 0
    $maxRetries = 5
    $retryIntervalInSeconds = 30

    <#
        If the domain was created on this node, then the tracking file will be
        present which means we should wait for the domain to be available.
    #>
    $domainShouldExist = Test-Path -Path (Get-TrackingFilename -DomainName $DomainName)
    $domainFound = $false

    do
    {
        try
        {
            if (Test-DomainMember)
            {
                # We're already a domain member, so take the credentials out of the equation
                Write-Verbose ($script:localizedData.QueryDomainWithLocalCredential -f $domainFQDN)

                $domain = Get-ADDomain -Identity $domainFQDN -ErrorAction Stop
                $forest = Get-ADForest -Identity $domain.Forest -ErrorAction Stop
            }
            else
            {
                Write-Verbose ($script:localizedData.QueryDomainWithCredential -f $domainFQDN)

                $domain = Get-ADDomain -Identity $domainFQDN -Credential $Credential -ErrorAction Stop
                $forest = Get-ADForest -Identity $domain.Forest -Credential $Credential -ErrorAction Stop
            }

            <#
                If we don't throw an exception, the domain is already UP (on this
                node or some other domain controller that responded) and this
                resource shouldn't run.
            #>
            Write-Verbose ($script:localizedData.DomainFound -f $domain.DnsRoot)

            $returnValue['DnsRoot'] = $domain.DnsRoot
            $returnValue['Forest'] = $forest.Name
            $returnValue['ParentDomainName'] = $domain.ParentDomain
            $returnValue['DomainNetBiosName'] = $domain.NetBIOSName
            $returnValue['ForestMode'] = (ConvertTo-DeploymentForestMode -Mode $forest.ForestMode) -as [System.String]
            $returnValue['DomainMode'] = (ConvertTo-DeploymentDomainMode -Mode $domain.DomainMode) -as [System.String]
            $returnValue['DomainExist'] = $true

            $domainFound = $true

            if (-not $domainShouldExist)
            {
                Write-Warning -Message (
                    $script:localizedData.MissingTrackingFile -f (Get-TrackingFilename -DomainName $DomainName)
                )
            }
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        {
            <#
                This is thrown when the node is a domain member, meaning the node
                is able to evaluate if there is a domain controller managing the
                domain name (which is different that its own domain).
                That means this node cannot be provisioned as a domain controller
                for another domain name.
            #>
            $errorMessage = $script:localizedData.ExistingDomainMemberError -f $DomainName
            New-ObjectNotFoundException -Message $errorMessage -ErrorRecord $_
        }
        catch [Microsoft.ActiveDirectory.Management.ADServerDownException]
        {
            Write-Verbose ($script:localizedData.DomainNotFound -f $domainFQDN)

            # will fall into retry mechanism if the domain should exist.
        }
        catch [System.Security.Authentication.AuthenticationException]
        {
            $errorMessage = $script:localizedData.InvalidCredentialError -f $DomainName
            New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
        }
        catch
        {
            $errorMessage = $script:localizedData.UnhandledError -f ($_.Exception | Format-List -Force | Out-String)
            Write-Verbose $errorMessage

            if ($domainShouldExist -and ($_.Exception.InnerException -is [System.ServiceModel.FaultException]))
            {
                Write-Verbose $script:localizedData.FaultExceptionAndDomainShouldExist

                # will fall into retry mechanism if the domain should exist.
            }
            else
            {
                # Not sure what's gone on here!
                throw $_
            }
        }

        if (-not $domainFound -and $domainShouldExist)
        {
            $retries++

            $waitSeconds = $retries * $retryIntervalInSeconds

            Write-Verbose ($script:localizedData.RetryingGetADDomain -f $retries, $maxRetries, $waitSeconds)

            Start-Sleep -Seconds $waitSeconds
        }
    } while ((-not $domainFound -and $domainShouldExist) -and $retries -lt $maxRetries)

    return $returnValue
} #end function Get-TargetResource

<#
    .SYNOPSIS
        Tests the current state of the Domain.

    .PARAMETER DomainName
        The fully qualified domain name (FQDN) of a new domain. If setting up a
        child domain this must be set to a single-label DNS name.

    .PARAMETER Credential
        Specifies the user name and password that corresponds to the account used
        to install the domain controller. When adding a child domain these credentials
        need the correct permission in the parent domain. The credentials will also
        be used to query for the existence of the domain or child domain. This will
        not be created as a user in the new domain. The domain administrator password
        will be the same as the password of the local Administrator of this node.

    .PARAMETER SafeModeAdministratorPassword
        Password for the administrator account when the computer is started in Safe Mode.

    .PARAMETER ParentDomainName
        Fully qualified domain name (FQDN) of the parent domain.

    .PARAMETER DomainNetBiosName
        NetBIOS name for the new domain.

    .PARAMETER DnsDelegationCredential
        Credential used for creating DNS delegation.

    .PARAMETER DatabasePath
        Path to a directory that contains the domain database.

    .PARAMETER LogPath
        Path to a directory for the log file that will be written.

    .PARAMETER SysvolPath
        Path to a directory where the Sysvol file will be written.

    .PARAMETER ForestMode
        The Forest Functional Level for the entire forest.

    .PARAMETER DomainMode
        The Domain Functional Level for the entire domain.
#>
function Test-TargetResource
{
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $SafeModeAdministratorPassword,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ParentDomainName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainNetBiosName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $DnsDelegationCredential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DatabasePath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $LogPath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $SysvolPath,

        [Parameter()]
        [ValidateSet('Win2008', 'Win2008R2', 'Win2012', 'Win2012R2', 'WinThreshold')]
        [System.String]
        $ForestMode,

        [Parameter()]
        [ValidateSet('Win2008', 'Win2008R2', 'Win2012', 'Win2012R2', 'WinThreshold')]
        [System.String]
        $DomainMode
    )

    $targetResource = Get-TargetResource @PSBoundParameters

    $isCompliant = $true

    <#
        The Get-Target resource returns DomainName as the domain's FQDN. Therefore, we
        need to resolve this before comparison.
    #>
    $domainFQDN = Resolve-DomainFQDN -DomainName $DomainName -ParentDomainName $ParentDomainName

    if ($domainFQDN -ne $targetResource.DnsRoot)
    {
        Write-Verbose -Message (
            $script:localizedData.ExpectedDomain -f $domainFQDN
        )

        $isCompliant = $false
    }

    $propertyNames = @(
        'ParentDomainName',
        'DomainNetBiosName'
    )

    foreach ($propertyName in $propertyNames)
    {
        if ($PSBoundParameters.ContainsKey($propertyName))
        {
            $propertyValue = (Get-Variable -Name $propertyName).Value

            if ($targetResource.$propertyName -ne $propertyValue)
            {
                Write-Verbose -Message (
                    $script:localizedData.PropertyValueIncorrect `
                        -f $propertyName, $propertyValue, $targetResource.$propertyName
                )

                $isCompliant = $false
            }
        }
    }

    if ($isCompliant)
    {
        Write-Verbose -Message (
            $script:localizedData.DomainInDesiredState -f $domainFQDN
        )
    }
    else
    {
        Write-Verbose -Message (
            $script:localizedData.DomainNotInDesiredState -f $domainFQDN
        )
    }

    return $isCompliant
} #end function Test-TargetResource

<#
    .SYNOPSIS
        Sets the state of the Domain.

    .PARAMETER DomainName
        The fully qualified domain name (FQDN) of a new domain. If setting up a
        child domain this must be set to a single-label DNS name.

    .PARAMETER Credential
        Specifies the user name and password that corresponds to the account used
        to install the domain controller. When adding a child domain these credentials
        need the correct permission in the parent domain. The credentials will also
        be used to query for the existence of the domain or child domain. This will
        not be created as a user in the new domain. The domain administrator password
        will be the same as the password of the local Administrator of this node.

    .PARAMETER SafeModeAdministratorPassword
        Password for the administrator account when the computer is started in Safe Mode.

    .PARAMETER ParentDomainName
        Fully qualified domain name (FQDN) of the parent domain.

    .PARAMETER DomainNetBiosName
        NetBIOS name for the new domain.

    .PARAMETER DnsDelegationCredential
        Credential used for creating DNS delegation.

    .PARAMETER DatabasePath
        Path to a directory that contains the domain database.

    .PARAMETER LogPath
        Path to a directory for the log file that will be written.

    .PARAMETER SysvolPath
        Path to a directory where the Sysvol file will be written.

    .PARAMETER ForestMode
        The Forest Functional Level for the entire forest.

    .PARAMETER DomainMode
        The Domain Functional Level for the entire domain.
#>
function Set-TargetResource
{
    <#
        Suppressing this rule because $global:DSCMachineStatus is used to
        trigger a reboot for the one that was suppressed when calling
        Install-ADDSForest or Install-ADDSDomains.
    #>
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    <#
        Suppressing this rule because $global:DSCMachineStatus is only set,
        never used (by design of Desired State Configuration).
    #>
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Scope='Function', Target='DSCMachineStatus')]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $SafeModeAdministratorPassword,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ParentDomainName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainNetBiosName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $DnsDelegationCredential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DatabasePath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $LogPath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $SysvolPath,

        [Parameter()]
        [ValidateSet('Win2008', 'Win2008R2', 'Win2012', 'Win2012R2', 'WinThreshold')]
        [System.String]
        $ForestMode,

        [Parameter()]
        [ValidateSet('Win2008', 'Win2008R2', 'Win2012', 'Win2012R2', 'WinThreshold')]
        [System.String]
        $DomainMode
    )

    # Debug can pause Install-ADDSForest/Install-ADDSDomain, so we remove it.
    $null = $PSBoundParameters.Remove('Debug')

    # Not entirely necessary, but run Get-TargetResource to ensure we raise any pre-flight errors.
    $targetResource = Get-TargetResource @PSBoundParameters

    if (-not $targetResource.DomainExist)
    {
        $installADDSParameters = @{
            SafeModeAdministratorPassword = $SafeModeAdministratorPassword.Password
            NoRebootOnCompletion = $true
            Force = $true
            ErrorAction = 'Stop'
        }

        if ($PSBoundParameters.ContainsKey('DnsDelegationCredential'))
        {
            $installADDSParameters['DnsDelegationCredential'] = $DnsDelegationCredential
            $installADDSParameters['CreateDnsDelegation'] = $true
        }

        if ($PSBoundParameters.ContainsKey('DatabasePath'))
        {
            $installADDSParameters['DatabasePath'] = $DatabasePath
        }

        if ($PSBoundParameters.ContainsKey('LogPath'))
        {
            $installADDSParameters['LogPath'] = $LogPath
        }

        if ($PSBoundParameters.ContainsKey('SysvolPath'))
        {
            $installADDSParameters['SysvolPath'] = $SysvolPath
        }

        if ($PSBoundParameters.ContainsKey('DomainMode'))
        {
            $installADDSParameters['DomainMode'] = $DomainMode
        }

        if ($PSBoundParameters.ContainsKey('ParentDomainName'))
        {
            Write-Verbose -Message ($script:localizedData.CreatingChildDomain -f $DomainName, $ParentDomainName)
            $installADDSParameters['Credential'] = $Credential
            $installADDSParameters['NewDomainName'] = $DomainName
            $installADDSParameters['ParentDomainName'] = $ParentDomainName
            $installADDSParameters['DomainType'] = 'ChildDomain'

            if ($PSBoundParameters.ContainsKey('DomainNetBiosName'))
            {
                $installADDSParameters['NewDomainNetBiosName'] = $DomainNetBiosName
            }

            Install-ADDSDomain @installADDSParameters

            Write-Verbose -Message ($script:localizedData.CreatedChildDomain)
        }
        else
        {
            Write-Verbose -Message ($script:localizedData.CreatingForest -f $DomainName)
            $installADDSParameters['DomainName'] = $DomainName

            if ($PSBoundParameters.ContainsKey('DomainNetBiosName'))
            {
                $installADDSParameters['DomainNetBiosName'] = $DomainNetBiosName
            }

            if ($PSBoundParameters.ContainsKey('ForestMode'))
            {
                $installADDSParameters['ForestMode'] = $ForestMode
            }

            Install-ADDSForest @installADDSParameters

            Write-Verbose -Message ($script:localizedData.CreatedForest -f $DomainName)
        }

        'Finished' | Out-File -FilePath (Get-TrackingFilename -DomainName $DomainName) -Force

        <#
            Signal to the LCM to reboot the node to compensate for the one we
            suppressed from Install-ADDSForest/Install-ADDSDomain.
        #>
        $global:DSCMachineStatus = 1
    }
} #end function Set-TargetResource

Export-ModuleMember -Function *-TargetResource
