$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADKDSKey'

<#
    .SYNOPSIS
        Gets the specified KDS root key

    .PARAMETER EffectiveTime
        Specifies the Effective time when a KDS root key can be used.
        There is a 10 hour minimum from creation date to allow active directory
        to properly replicate across all domain controllers. For this reason,
        the date must be set in the future for creation.While this parameter
        accepts a string, it will be converted into a DateTime object.
        This will also try to take into account cultural settings.

        Example:
        '05/01/1999 13:00' using default or 'en-US' culture would be May 1st,
        but using 'de-DE' culture would be 5th of January. The culture is
        automatically pulled from the operating system and this can be checked
        using 'Get-Culture'
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
        $EffectiveTime
    )

    Assert-Module -ModuleName 'ActiveDirectory'

    $targetResource = @{
        EffectiveTime     = $EffectiveTime
        CreationTime      = $null
        KeyId             = $null
        Ensure            = $null
        DistinguishedName = $null
    }

    Write-Verbose -Message ($script:localizedData.RetrievingKDSRootKey -f $EffectiveTime)

    try
    {
        $effectiveTimeObject = [DateTime]::Parse($EffectiveTime)
    }
    catch
    {
        $errorMessage = $script:localizedData.EffectiveTimeInvalid -f $EffectiveTime
        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
    }

    $currentUser = Get-CurrentUser
    if (-not (Assert-HasDomainAdminRights -User $currentUser))
    {
        $errorMessage = $script:localizedData.IncorrectPermissions -f $currentUser.Name
        New-InvalidResultException -Message $errorMessage
    }

    try
    {
        $kdsRootKeys = Get-KdsRootKey
    }
    catch
    {
        $errorMessage = $script:localizedData.RetrievingKDSRootKeyError -f $EffectiveTime
        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
    }

    $kdsRootKey = $null
    if ($kdsRootKeys)
    {
        $kdsRootKey = $kdsRootKeys.GetEnumerator() |
            Where-Object -FilterScript {
                [DateTime]::Parse($_.EffectiveTime) -eq $effectiveTimeObject
            }
    }

    if (-not $kdsRootKey)
    {
        $targetResource['Ensure'] = 'Absent'
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.FoundKDSRootKey -f $EffectiveTime)
        if ($kdsRootKeys.Count -gt 1)
        {
            Write-Warning -Message ($script:localizedData.FoundKDSRootKeyMultiple)
        }

        if ($kdsRootKey.Count -gt 1)
        {
            $errorMessage = $script:localizedData.FoundKDSRootKeySameEffectiveTime -f $EffectiveTime
            New-InvalidOperationException -Message $errorMessage
        }
        elseif ($kdsRootKey)
        {
            $targetResource['Ensure'] = 'Present'
            $targetResource['EffectiveTime'] = ([DateTime]::Parse($kdsRootKey.EffectiveTime)).ToString()
            $targetResource['CreationTime'] = $kdsRootKey.CreationTime
            $targetResource['KeyId'] = $kdsRootKey.KeyId
            $targetResource['DistinguishedName'] = 'CN={0},CN=Master Root Keys,CN=Group Key Distribution Service,CN=Services,CN=Configuration,{1}' -f
            $kdsRootKey.KeyId, (Get-ADRootDomainDN)
        }
    }

    return $targetResource
}

<#
    .SYNOPSIS
        Creates or deletes the KDS root Key

    .PARAMETER EffectiveTime
        Specifies the Effective time when a KDS root key can be used.
        There is a 10 hour minimum from creation date to allow active directory
        to properly replicate across all domain controllers. For this reason,
        the date must be set in the future for creation.While this parameter
        accepts a string, it will be converted into a DateTime object.
        This will also try to take into account cultural settings.

        Example:
        '05/01/1999 13:00' using default or 'en-US' culture would be May 1st,
        but using 'de-DE' culture would be 5th of January. The culture is
        automatically pulled from the operating system and this can be checked
        using 'Get-Culture'

    .PARAMETER AllowUnsafeEffectiveTime
        This option will allow you to create a KDS root key if EffectiveTime is set in the past.
        This may cause issues if you are creating a Group Managed Service Account right
        after you create the KDS Root Key. In order to get around this, you must create
        the KDS Root Key using a date in the past. This should be used at your own risk
        and should only be used in lab environments.

    .PARAMETER Ensure
        Specifies if this KDS Root Key should be present or absent

    .PARAMETER ForceRemove
       This option will allow you to remove a KDS root key if there is only one key left.
       It should not break your Group Managed Service Accounts (gMSAs), but if the gMSA
       password expires and it needs to request a new password, it will not be able to
       generate a new password until a new KDS Root Key is installed and ready for use.
       Because of this, the last KDS Root Key will not be removed unless this option is specified
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $EffectiveTime,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Boolean]
        $AllowUnsafeEffectiveTime,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Boolean]
        $ForceRemove
    )

    $getTargetResourceParameters = @{
        EffectiveTime = $EffectiveTime
        Ensure        = $Ensure
    }

    $compareTargetResourceNonCompliant = Compare-TargetResourceState @getTargetResourceParameters |
        Where-Object -FilterScript {
            $_.Pass -eq $false
        }

    $ensureState = $compareTargetResourceNonCompliant |
        Where-Object -FilterScript {
            $_.Parameter -eq 'Ensure'
        }

    if ($ensureState)
    {
        Write-Verbose -Message ($script:localizedData.NotDesiredPropertyState -f
            'Ensure', $EffectiveTime, $ensureState.Expected, $ensureState.Actual)
        Write-Verbose -Message ($script:localizedData.KDSRootKeyNotInDesiredState -f $EffectiveTime)
        return $false
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.KDSRootKeyInDesiredState -f $EffectiveTime)
        return $true
    }
}

<#
    .SYNOPSIS
        Creates or deletes the KDS root Key

    .PARAMETER EffectiveTime
        Specifies the Effective time when a KDS root key can be used.
        There is a 10 hour minimum from creation date to allow active directory
        to properly replicate across all domain controllers. For this reason,
        the date must be set in the future for creation.While this parameter
        accepts a string, it will be converted into a DateTime object.
        This will also try to take into account cultural settings.

        Example:
        '05/01/1999 13:00' using default or 'en-US' culture would be May 1st,
        but using 'de-DE' culture would be 5th of January. The culture is
        automatically pulled from the operating system and this can be checked
        using 'Get-Culture'

    .PARAMETER AllowUnsafeEffectiveTime
        This option will allow you to create a KDS root key if EffectiveTime is set in the past.
        This may cause issues if you are creating a Group Managed Service Account right
        after you create the KDS Root Key. In order to get around this, you must create
        the KDS Root Key using a date in the past. This should be used at your own risk
        and should only be used in lab environments.

    .PARAMETER Ensure
        Specifies if this KDS Root Key should be present or absent

    .PARAMETER ForceRemove
       This option will allow you to remove a KDS root key if there is only one key left.
       It should not break your Group Managed Service Accounts (gMSAs), but if the gMSA
       password expires and it needs to request a new password, it will not be able to
       generate a new password until a new KDS Root Key is installed and ready for use.
       Because of this, the last KDS Root Key will not be removed unless this option is specified
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $EffectiveTime,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Boolean]
        $AllowUnsafeEffectiveTime,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Boolean]
        $ForceRemove
    )

    $getTargetResourceParameters = @{
        EffectiveTime = $EffectiveTime
        Ensure        = $Ensure
    }

    $compareTargetResource = Compare-TargetResourceState @getTargetResourceParameters
    $ensureState = $compareTargetResource |
        Where-Object -FilterScript {
            $_.Parameter -eq 'Ensure'
        }

    # Ensure is not in proper state
    if ($ensureState.Pass -eq $false)
    {
        if ($Ensure -eq 'Present')
        {
            try
            {
                $effectiveTimeObject = [DateTime]::Parse($EffectiveTime)
            }
            catch
            {
                $errorMessage = $script:localizedData.EffectiveTimeInvalid -f $EffectiveTime
                New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
            }

            $currentDateTimeObject = Get-Date

            # We want the key to be present, but it currently does not exist
            if ($effectiveTimeObject -le $currentDateTimeObject -and
                $PSBoundParameters.ContainsKey('AllowUnsafeEffectiveTime') -and $AllowUnsafeEffectiveTime)
            {
                Write-Warning -Message ($script:localizedData.AddingKDSRootKeyDateInPast -f $EffectiveTime)
            }
            elseif ($effectiveTimeObject -le $currentDateTimeObject)
            {
                <#
                 Effective time is in the past and we don't have AllowUnsafeEffectiveTime set
                 to enabled, so we exit with an error
                #>
                $errorMessage = $script:localizedData.AddingKDSRootKeyError -f $EffectiveTime
                New-InvalidOperationException -Message $errorMessage
            }
            else
            {
                Write-Verbose -Message ($script:localizedData.AddingKDSRootKey -f $EffectiveTime)
            }

            <#
             EffectiveTime appears to expect a UTC datetime, so we are converting
             it to UTC before adding. Get-KDSRootKey will return the wrong time if we
             don't convert first
            #>
            try
            {
                Add-KDSRootKey -EffectiveTime $effectiveTimeObject.ToUniversalTime()
            }
            catch
            {
                $errorMessage = $script:localizedData.KDSRootKeyAddError -f $EffectiveTime
                New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
            }
        }
        elseif ($Ensure -eq 'Absent')
        {
            # We want the account to be Absent, but it is Present
            if ((Get-KdsRootKey).Count -gt 1)
            {
                Write-Verbose -Message ($script:localizedData.RemovingKDSRootKey -f $EffectiveTime)
            }
            else
            {
                if ($PSBoundParameters.ContainsKey('ForceRemove') -and $ForceRemove)
                {
                    Write-Verbose -Message ($script:localizedData.RemovingKDSRootKey -f $EffectiveTime)
                    Write-Warning -Message ($script:localizedData.NotEnoughKDSRootKeysPresent -f $EffectiveTime)
                }
                else
                {
                    $errorMessage = $script:localizedData.NotEnoughKDSRootKeysPresentNoForce -f $EffectiveTime
                    New-InvalidOperationException -Message $errorMessage
                }
            }

            $distinguishedName = $compareTargetResource |
                Where-Object -FilterScript { $_.Parameter -eq 'DistinguishedName' }

            try
            {
                Remove-ADObject -Identity $distinguishedName.Actual -Confirm:$false
            }
            catch
            {
                $errorMessage = $script:localizedData.KDSRootKeyRemoveError -f $EffectiveTime
                New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
            }
        }
    }
}

<#
    .SYNOPSIS
        Compares the state of the KDS root key

    .PARAMETER EffectiveTime
        Specifies the Effective time when a KDS root key can be used.
        There is a 10 hour minimum from creation date to allow active directory
        to properly replicate across all domain controllers. For this reason,
        the date must be set in the future for creation. While this parameter
        accepts a string, it will be converted into a DateTime object.
        This will also try to take into account cultural settings.

        Example:
        '05/01/1999 13:00' using default or 'en-US' culture would be May 1st,
        but using 'de-DE' culture would be 5th of January. The culture is
        automatically pulled from the operating system and this can be checked
        using 'Get-Culture'

    .PARAMETER Ensure
        Specifies if this KDS Root Key should be present or absent

#>
function Compare-TargetResourceState
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $EffectiveTime,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure
    )

    $getTargetResourceParameters = @{
        EffectiveTime = $EffectiveTime
    }

    $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
    $compareTargetResource = @()

    # Add DistinguishedName as it won't be passed as an argument, but we want to get the DN in Set
    $PSBoundParameters['DistinguishedName'] = $getTargetResourceResult['DistinguishedName']

    # Convert EffectiveTime to DateTime object for comparison
    $PSBoundParameters['EffectiveTime'] = [DateTime]::Parse($EffectiveTime)
    $getTargetResourceResult['EffectiveTime'] = [DateTime]::Parse($getTargetResourceResult.EffectiveTime)

    foreach ($parameter in $PSBoundParameters.Keys)
    {
        if ($PSBoundParameters.$parameter -eq $getTargetResourceResult.$parameter)
        {
            # Check if parameter is in compliance
            $compareTargetResource += [pscustomobject] @{
                Parameter = $parameter
                Expected  = $PSBoundParameters.$parameter
                Actual    = $getTargetResourceResult.$parameter
                Pass      = $true
            }
        }
        # Need to check if parameter is part of schema, otherwise ignore all other parameters like verbose
        elseif ($getTargetResourceResult.ContainsKey($parameter))
        {
            <#
                We are out of compliance if we get here
                $PSBoundParameters.$parameter -ne $getTargetResourceResult.$parameter
            #>
            $compareTargetResource += [pscustomobject] @{
                Parameter = $parameter
                Expected  = $PSBoundParameters.$parameter
                Actual    = $getTargetResourceResult.$parameter
                Pass      = $false
            }
        }
    } #end foreach PSBoundParameter

    return $compareTargetResource
}

<#
    .SYNOPSIS
        Checks permissions to see if the user or computer has domain admin permissions.

    .DESCRIPTION
        DSC Resources run under the SYSTEM user context and there is no Credential parameter
        to pass to the KDSRootKey powershell commands. For this reason, we need to check
        permissions manually, otherwise we get back empty results with no error. One must use
        PsDscRunAsCredential or run this resource on the domain controller

    .PARAMETER User
        The user to check permissions against

    .NOTES
        Get-KdsRootKey will return $null instead of a permission error if it can't retrieve the keys
        so we need manually check
#>
function Assert-HasDomainAdminRights
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Security.Principal.WindowsIdentity]
        $User
    )

    $windowsPrincipal = New-Object -TypeName 'System.Security.Principal.WindowsPrincipal' -ArgumentList @($User)
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem

    Write-Verbose -Message ($script:localizedData.CheckingDomainAdminUserRights -f $User.Name)
    Write-Verbose -Message ($script:localizedData.CheckingDomainAdminComputerRights -f $osInfo.CSName, $osInfo.ProductType)

    return $windowsPrincipal.IsInRole("Domain Admins") -or
    $windowsPrincipal.IsInRole("Enterprise Admins") -or
    $osInfo.ProductType -eq 2
}

<#
    .SYNOPSIS
        Returns a string with the Distinguished Name of the root domain.

    .DESCRIPTION
        If you have a domain with sub-domains, this will return the root domain name. For example,
        if you had a domain contoso.com and a sub domain of fake.contoso.com, it would return
        contoso.com.

        This is used to get the Forest level root domain name. The KDS Root Key is created at the forest
        level and this is used to determine it's distinguished name
#>
function Get-ADRootDomainDN
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param ()

    $rootDomainDN = (New-Object -TypeName System.DirectoryServices.DirectoryEntry('LDAP://RootDSE')).Get('rootDomainNamingContext')
    Write-Verbose -Message ($script:localizedData.RetrievedRootDomainDN -f $rootDomainDN)
    return $rootDomainDN
}

Export-ModuleMember *-TargetResource
