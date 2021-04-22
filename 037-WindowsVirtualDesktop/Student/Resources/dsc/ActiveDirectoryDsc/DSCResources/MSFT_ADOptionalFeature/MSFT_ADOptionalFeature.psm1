$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADOptionalFeature'

<#
    .SYNOPSIS
        Gets the state of the Active Directory Optional Feature.

    .PARAMETER FeatureName
        The name of the Optional feature to be enabled.

    .PARAMETER ForestFQDN
        The fully qualified domain name (FQDN) of the forest in which to change the Optional feature.

    .PARAMETER EnterpriseAdministratorCredential
        The user account credentials to use to perform this task.

#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $FeatureName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ForestFQDN,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $EnterpriseAdministratorCredential
    )

    $previousErrorActionPreference = $ErrorActionPreference

    try
    {
        # AD cmdlets generate non-terminating errors.
        $ErrorActionPreference = 'Stop'

        $forest = Get-ADForest -Server $ForestFQDN -Credential $EnterpriseAdministratorCredential

        $feature = Get-ADOptionalFeature -Identity $FeatureName -Server $forest.DomainNamingMaster -Credential $EnterpriseAdministratorCredential

        if ($feature.EnabledScopes.Count -gt 0)
        {
            Write-Verbose -Message ($script:localizedData.OptionalFeatureEnabled -f $FeatureName)
            $featureEnabled = $True
        }
        else
        {
            Write-Verbose -Message ($script:localizedData.OptionalFeatureNotEnabled -f $FeatureName)
            $featureEnabled = $False
        }
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException], [Microsoft.ActiveDirectory.Management.ADServerDownException]
    {
        $errorMessage = $script:localizedData.ForestNotFound -f $ForestFQDN
        New-ObjectNotFoundException -Message $errorMessage -ErrorRecord $_
    }
    catch [System.Security.Authentication.AuthenticationException]
    {
        $errorMessage = $script:localizedData.CredentialError
        New-InvalidArgumentException -Message $errorMessage -ArgumentName 'EnterpriseAdministratorCredential'
    }
    catch
    {
        $errorMessage = $script:localizedData.GetUnhandledException -f $ForestFQDN
        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
    }
    finally
    {
        $ErrorActionPreference = $previousErrorActionPreference
    }

    # Return a credential object without the password.
    $cimCredentialInstance = New-CimCredentialInstance -Credential $EnterpriseAdministratorCredential

    return @{
        ForestFQDN                        = $ForestFQDN
        FeatureName                       = $FeatureName
        Enabled                           = $featureEnabled
        EnterpriseAdministratorCredential = $cimCredentialInstance
    }
}

<#
    .SYNOPSIS
        Sets the state of the Active Directory Optional Feature.

    .PARAMETER FeatureName
        The name of the Optional feature to be enabled.

    .PARAMETER ForestFQDN
        The fully qualified domain name (FQDN) of the forest in which to change the Optional feature.

    .PARAMETER EnterpriseAdministratorCredential
        The user account credentials to use to perform this task.

#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $FeatureName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ForestFQDN,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $EnterpriseAdministratorCredential
    )

    $previousErrorActionPreference = $ErrorActionPreference

    try
    {
        # AD cmdlets generate non-terminating errors.
        $ErrorActionPreference = 'Stop'

        $forest = Get-ADForest -Server $ForestFQDN -Credential $EnterpriseAdministratorCredential
        $domain = Get-ADDomain -Server $ForestFQDN -Credential $EnterpriseAdministratorCredential

        $feature = Get-ADOptionalFeature -Identity $FeatureName -Server $forest.DomainNamingMaster -Credential $EnterpriseAdministratorCredential

        # Check minimum forest level and throw if not
        if (($forest.ForestMode -as [int]) -lt ($feature.RequiredForestMode -as [int]))
        {
            throw ($script:localizedData.ForestFunctionalLevelError -f $forest.ForestMode)
        }

        # Check minimum domain level and throw if not
        if (($domain.DomainMode -as [int]) -lt ($feature.RequiredDomainMode -as [int]))
        {
            throw ($script:localizedData.DomainFunctionalLevelError -f $domain.DomainMode)
        }

        Write-Verbose -Message ($script:localizedData.EnablingOptionalFeature -f $forest.RootDomain, $FeatureName)

        Enable-ADOptionalFeature -Identity $FeatureName -Scope ForestOrConfigurationSet `
            -Target $forest.RootDomain -Server $forest.DomainNamingMaster `
            -Credential $EnterpriseAdministratorCredential `
            -Verbose:$VerbosePreference
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException], [Microsoft.ActiveDirectory.Management.ADServerDownException]
    {
        $errorMessage = $script:localizedData.ForestNotFound -f $ForestFQDN
        New-ObjectNotFoundException -Message $errorMessage -ErrorRecord $_
    }
    catch [System.Security.Authentication.AuthenticationException]
    {
        $errorMessage = $script:localizedData.CredentialError
        New-InvalidArgumentException -Message $errorMessage -ArgumentName 'EnterpriseAdministratorCredential'
    }
    catch
    {
        $errorMessage = $script:localizedData.SetUnhandledException -f $ForestFQDN
        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
    }
    finally
    {
        $ErrorActionPreference = $previousErrorActionPreference
    }
}

<#
    .SYNOPSIS
        Tests the state of the Active Directory Optional Feature.

    .PARAMETER FeatureName
        The name of the Optional feature to be enabled.

    .PARAMETER ForestFQDN
        The fully qualified domain name (FQDN) of the forest in which to change the Optional feature.

    .PARAMETER EnterpriseAdministratorCredential
        The user account credentials to use to perform this task.

#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $FeatureName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ForestFQDN,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $EnterpriseAdministratorCredential
    )

    $state = Get-TargetResource @PSBoundParameters

    if ($true -eq $state.Enabled)
    {
        Write-Verbose -Message ($script:localizedData.OptionalFeatureEnabled -f $FeatureName)
        return $true
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.OptionalFeatureNotEnabled -f $FeatureName)
        return $false
    }
}

Export-ModuleMember -Function *-TargetResource
