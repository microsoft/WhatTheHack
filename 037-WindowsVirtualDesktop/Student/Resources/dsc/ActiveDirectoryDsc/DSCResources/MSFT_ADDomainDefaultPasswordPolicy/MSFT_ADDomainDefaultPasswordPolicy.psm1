$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADDomainDefaultPasswordPolicy'

# List of changeable policy properties
$mutablePropertyMap = @(
    @{
        Name = 'ComplexityEnabled'
    }
    @{
        Name       = 'LockoutDuration'
        IsTimeSpan = $true
    }
    @{
        Name       = 'LockoutObservationWindow'
        IsTimeSpan = $true
    }
    @{
        Name = 'LockoutThreshold'
    }
    @{
        Name       = 'MinPasswordAge'
        IsTimeSpan = $true
    }
    @{
        Name       = 'MaxPasswordAge'
        IsTimeSpan = $true
    }
    @{
        Name = 'MinPasswordLength'
    }
    @{
        Name = 'PasswordHistoryCount'
    }
    @{
        Name = 'ReversibleEncryptionEnabled'
    }
)

<#
    .SYNOPSIS
        Returns the current state of the Active Directory default domain password
        policy.

    .PARAMETER DomainName
         Name of the domain to which the password policy will be applied.

    .PARAMETER DomainController
        Active Directory domain controller to enact the change upon.

    .PARAMETER Credential
        Credentials used to access the domain.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential
    )

    Assert-Module -ModuleName 'ActiveDirectory'

    $PSBoundParameters['Identity'] = $DomainName

    $getADDefaultDomainPasswordPolicyParams = Get-ADCommonParameters @PSBoundParameters

    Write-Verbose -Message ($script:localizedData.QueryingDomainPasswordPolicy -f $DomainName)

    $policy = Get-ADDefaultDomainPasswordPolicy @getADDefaultDomainPasswordPolicyParams

    return @{
        DomainName                  = $DomainName
        ComplexityEnabled           = $policy.ComplexityEnabled
        LockoutDuration             = ConvertFrom-Timespan -Timespan $policy.LockoutDuration -TimeSpanType Minutes
        LockoutObservationWindow    = ConvertFrom-Timespan -Timespan $policy.LockoutObservationWindow -TimeSpanType Minutes
        LockoutThreshold            = $policy.LockoutThreshold
        MinPasswordAge              = ConvertFrom-Timespan -Timespan $policy.MinPasswordAge -TimeSpanType Minutes
        MaxPasswordAge              = ConvertFrom-Timespan -Timespan $policy.MaxPasswordAge -TimeSpanType Minutes
        MinPasswordLength           = $policy.MinPasswordLength
        PasswordHistoryCount        = $policy.PasswordHistoryCount
        ReversibleEncryptionEnabled = $policy.ReversibleEncryptionEnabled
    }
} #end Get-TargetResource

<#
    .SYNOPSIS
        Determines if the Active Directory default domain password policy is in
        the desired state

    .PARAMETER DomainName
         Name of the domain to which the password policy will be applied.

    .PARAMETER ComplexityEnabled
        Whether password complexity is enabled for the default password policy.

    .PARAMETER LockoutDuration
        Length of time that an account is locked after the number of failed login attempts (minutes).

    .PARAMETER LockoutObservationWindow
        Maximum time between two unsuccessful login attempts before the counter is reset to 0 (minutes).

    .PARAMETER LockoutThreshold
        Number of unsuccessful login attempts that are permitted before an account is locked out.

    .PARAMETER MinPasswordAge
        Minimum length of time that you can have the same password (minutes).

    .PARAMETER MaxPasswordAge
        Maximum length of time that you can have the same password (minutes).

    .PARAMETER MinPasswordLength
        Minimum number of characters that a password must contain.

    .PARAMETER PasswordHistoryCount
        Number of previous passwords to remember.

    .PARAMETER ReversibleEncryptionEnabled
        Whether the directory must store passwords using reversible encryption.

    .PARAMETER DomainController
        Active Directory domain controller to enact the change upon.

    .PARAMETER Credential
        Credentials used to access the domain.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [Parameter()]
        [System.Boolean]
        $ComplexityEnabled,

        [Parameter()]
        [System.UInt32]
        $LockoutDuration,

        [Parameter()]
        [System.UInt32]
        $LockoutObservationWindow,

        [Parameter()]
        [System.UInt32]
        $LockoutThreshold,

        [Parameter()]
        [System.UInt32]
        $MinPasswordAge,

        [Parameter()]
        [System.UInt32]
        $MaxPasswordAge,

        [Parameter()]
        [System.UInt32]
        $MinPasswordLength,

        [Parameter()]
        [System.UInt32]
        $PasswordHistoryCount,

        [Parameter()]
        [System.Boolean]
        $ReversibleEncryptionEnabled,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential
    )

    $getTargetResourceParams = @{
        DomainName = $DomainName
    }

    if ($PSBoundParameters.ContainsKey('Credential'))
    {
        $getTargetResourceParams['Credential'] = $Credential
    }

    if ($PSBoundParameters.ContainsKey('DomainController'))
    {
        $getTargetResourceParams['DomainController'] = $DomainController
    }

    $targetResource = Get-TargetResource @getTargetResourceParams

    $inDesiredState = $true
    foreach ($property in $mutablePropertyMap)
    {
        $propertyName = $property.Name

        if ($PSBoundParameters.ContainsKey($propertyName))
        {
            $expectedValue = $PSBoundParameters[$propertyName]
            $actualValue = $targetResource[$propertyName]

            if ($expectedValue -ne $actualValue)
            {
                $valueIncorrectMessage = $script:localizedData.ResourcePropertyValueIncorrect -f $propertyName, $expectedValue, $actualValue
                Write-Verbose -Message $valueIncorrectMessage
                $inDesiredState = $false
            }
        }
    }

    if ($inDesiredState)
    {
        Write-Verbose -Message ($script:localizedData.ResourceInDesiredState -f $DomainName)
        return $true
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.ResourceNotInDesiredState -f $DomainName)
        return $false
    }
} #end Test-TargetResource

<#
    .SYNOPSIS
        Modifies the Active Directory default domain password policy.

    .PARAMETER DomainName
         Name of the domain to which the password policy will be applied.

    .PARAMETER ComplexityEnabled
        Whether password complexity is enabled for the default password policy.

    .PARAMETER LockoutDuration
        Length of time that an account is locked after the number of failed login attempts (minutes).

    .PARAMETER LockoutObservationWindow
        Maximum time between two unsuccessful login attempts before the counter is reset to 0 (minutes).

    .PARAMETER LockoutThreshold
        Number of unsuccessful login attempts that are permitted before an account is locked out.

    .PARAMETER MinPasswordAge
        Minimum length of time that you can have the same password (minutes).

    .PARAMETER MaxPasswordAge
        Maximum length of time that you can have the same password (minutes).

    .PARAMETER MinPasswordLength
        Minimum number of characters that a password must contain.

    .PARAMETER PasswordHistoryCount
        Number of previous passwords to remember.

    .PARAMETER ReversibleEncryptionEnabled
        Whether the directory must store passwords using reversible encryption.

    .PARAMETER DomainController
        Active Directory domain controller to enact the change upon.

    .PARAMETER Credential
        Credentials used to access the domain.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [Parameter()]
        [System.Boolean]
        $ComplexityEnabled,

        [Parameter()]
        [System.UInt32]
        $LockoutDuration,

        [Parameter()]
        [System.UInt32]
        $LockoutObservationWindow,

        [Parameter()]
        [System.UInt32]
        $LockoutThreshold,

        [Parameter()]
        [System.UInt32]
        $MinPasswordAge,

        [Parameter()]
        [System.UInt32]
        $MaxPasswordAge,

        [Parameter()]
        [System.UInt32]
        $MinPasswordLength,

        [Parameter()]
        [System.UInt32]
        $PasswordHistoryCount,

        [Parameter()]
        [System.Boolean]
        $ReversibleEncryptionEnabled,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential
    )

    Assert-Module -ModuleName 'ActiveDirectory'

    $PSBoundParameters['Identity'] = $DomainName

    $setADDefaultDomainPasswordPolicyParams = Get-ADCommonParameters @PSBoundParameters

    foreach ($property in $mutablePropertyMap)
    {
        $propertyName = $property.Name

        if ($PSBoundParameters.ContainsKey($propertyName))
        {
            $propertyValue = $PSBoundParameters[$propertyName]

            if ($property.IsTimeSpan -eq $true)
            {
                $propertyValue = ConvertTo-TimeSpan -TimeSpan $propertyValue -TimeSpanType Minutes
            }

            $setADDefaultDomainPasswordPolicyParams[$propertyName] = $propertyValue

            Write-Verbose -Message ($script:localizedData.SettingPasswordPolicyValue -f $propertyName, $propertyValue)
        }
    }

    Write-Verbose -Message ($script:localizedData.UpdatingDomainPasswordPolicy -f $DomainName)

    [ref] $null = Set-ADDefaultDomainPasswordPolicy @setADDefaultDomainPasswordPolicyParams
} #end Set-TargetResource

Export-ModuleMember -Function *-TargetResource
