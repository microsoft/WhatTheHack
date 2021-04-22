$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADManagedServiceAccount'

<#
    .SYNOPSIS
        Gets the specified managed service account.

    .PARAMETER ServiceAccountName
        Specifies the Security Account Manager (SAM) account name of the managed service account (ldapDisplayName 'sAMAccountName').
        To be compatible with older operating systems, create a SAM account name that is 20 characters or less. Once created,
        the user's SamAccountName and CN cannot be changed.

    .PARAMETER MembershipAttribute
        Active Directory attribute used to perform membership operations for Group Managed Service Accounts (gMSAs).
        If not specified, this value defaults to SamAccountName. Only used when 'Group' is selected for 'AccountType'

    .PARAMETER AccountTypeForce
        Specifies whether or not to remove the service account and recreate it when going from single MSA to
        group MSA and vice-versa. If not specified, this value defaults to False.

    .PARAMETER Credential
        Specifies the user account credentials to use to perform this task.
        This is only required if not executing the task on a domain controller or using the -DomainController parameter.

    .PARAMETER DomainController
        Specifies the Active Directory Domain Controller instance to use to perform the task.
        This is only required if not executing the task on a domain controller.
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
        $ServiceAccountName,

        [Parameter()]
        [ValidateSet('SamAccountName', 'DistinguishedName', 'SID', 'ObjectGUID')]
        [System.String]
        $MembershipAttribute = 'SamAccountName',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Boolean]
        $AccountTypeForce = $false,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainController
    )

    Assert-Module -ModuleName 'ActiveDirectory'
    $adServiceAccountParameters = Get-ADCommonParameters @PSBoundParameters

    $targetResource = @{
        ServiceAccountName  = $ServiceAccountName
        DistinguishedName   = $null
        Path                = $null
        Description         = $null
        DisplayName         = $null
        AccountType         = $null
        AccountTypeForce    = $AccountTypeForce
        Ensure              = $null
        Enabled             = $false
        Members             = @()
        MembershipAttribute = $MembershipAttribute
        Credential          = $Credential
        DomainController    = $DomainController
    }

    try
    {
        Write-Verbose -Message ($script:localizedData.RetrievingServiceAccount -f $ServiceAccountName)

        $adServiceAccount = Get-ADServiceAccount @adServiceAccountParameters -Properties @(
            'Name'
            'DistinguishedName'
            'Description'
            'DisplayName'
            'ObjectClass'
            'Enabled'
            'PrincipalsAllowedToRetrieveManagedPassword'
            'SamAccountName'
            'DistinguishedName'
            'SID'
            'ObjectGUID'
        )

        $targetResource['Ensure'] = 'Present'
        $targetResource['Path'] = Get-ADObjectParentDN -DN $adServiceAccount.DistinguishedName
        $targetResource['Description'] = $adServiceAccount.Description
        $targetResource['DisplayName'] = $adServiceAccount.DisplayName
        $targetResource['Enabled'] = [System.Boolean] $adServiceAccount.Enabled
        $targetResource['DistinguishedName'] = $adServiceAccount.DistinguishedName

        if ( $adServiceAccount.ObjectClass -eq 'msDS-ManagedServiceAccount' )
        {
            $targetResource['AccountType'] = 'Single'
        }
        elseif ( $adServiceAccount.ObjectClass -eq 'msDS-GroupManagedServiceAccount' )
        {
            Write-Verbose -Message ($script:localizedData.RetrievingPrincipalMembers -f $MembershipAttribute)
            $adServiceAccount.PrincipalsAllowedToRetrieveManagedPassword |
                ForEach-Object {
                    $member = (Get-ADObject -Identity $_ -Properties $MembershipAttribute).$MembershipAttribute
                    $targetResource['Members'] += $member
                }

            $targetResource['AccountType'] = 'Group'
        }
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {
        Write-Verbose -Message ($script:localizedData.ManagedServiceAccountNotFound -f $ServiceAccountName)
        $targetResource['Ensure'] = 'Absent'
    }
    catch
    {
        $errorMessage = $script:localizedData.RetrievingServiceAccountError -f $ServiceAccountName
        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
    }

    return $targetResource
} #end function Get-TargetResource


<#
    .SYNOPSIS
        Tests the state of the managed service account.

    .PARAMETER ServiceAccountName
        Specifies the Security Account Manager (SAM) account name of the managed service account (ldapDisplayName 'sAMAccountName').
        To be compatible with older operating systems, create a SAM account name that is 20 characters or less. Once created,
        the user's SamAccountName and CN cannot be changed.

    .PARAMETER AccountType
        The type of managed service account. Single will create a Single Managed Service Account (sMSA) and Group will
        create a Group Managed Service Account (gMSA). If not specified, this vaule defaults to Single.

    .PARAMETER AccountTypeForce
        Specifies whether or not to remove the service account and recreate it when going from single MSA to
        group MSA and vice-versa. If not specified, this value defaults to False.

    .PARAMETER Path
        Specifies the X.500 path of the Organizational Unit (OU) or container where the new object is created.
        Specified as a Distinguished Name (DN).

    .PARAMETER Ensure
        Specifies whether the user account is created or deleted. If not specified, this value defaults to Present.

    .PARAMETER Description
        Specifies a description of the object (ldapDisplayName 'description').

    .PARAMETER DisplayName
        Specifies the display name of the object (ldapDisplayName 'displayName').

    .PARAMETER Members
        Specifies the members of the object (ldapDisplayName 'PrincipalsAllowedToRetrieveManagedPassword').
        Only used when 'Group' is selected for 'AccountType'.

    .PARAMETER MembershipAttribute
        Active Directory attribute used to perform membership operations for Group Managed Service Accounts (gMSAs).
        If not specified, this value defaults to SamAccountName. Only used when 'Group' is selected for 'AccountType'.

    .PARAMETER Credential
        Specifies the user account credentials to use to perform this task.
        This is only required if not executing the task on a domain controller or using the -DomainController parameter.

    .PARAMETER DomainController
        Specifies the Active Directory Domain Controller instance to use to perform the task.
        This is only required if not executing the task on a domain controller.
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
        $ServiceAccountName,

        [Parameter()]
        [ValidateSet('Group', 'Single')]
        [System.String]
        $AccountType = 'Single',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Boolean]
        $AccountTypeForce = $false,

        [Parameter()]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [ValidateSet('SamAccountName', 'DistinguishedName', 'SID', 'ObjectGUID')]
        [System.String]
        $MembershipAttribute = 'SamAccountName',

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainController
    )

    # Need to set these parameters to compare if users are using the default parameter values
    $PSBoundParameters['Ensure'] = $Ensure
    $PSBoundParameters['AccountType'] = $AccountType
    $PSBoundParameters['MembershipAttribute'] = $MembershipAttribute

    $compareTargetResourceNonCompliant = Compare-TargetResourceState @PSBoundParameters |
        Where-Object -FilterScript { $_.Pass -eq $false }

    # Check if Absent, if so then we don't need to propagate any other parameters
    if ($Ensure -eq 'Absent')
    {
        $ensureState = $compareTargetResourceNonCompliant |
            Where-Object -FilterScript { $_.Parameter -eq 'Ensure' }

        if ($ensureState)
        {
            Write-Verbose -Message ($script:localizedData.NotDesiredPropertyState -f `
                    'Ensure', $ensureState.Expected, $ensureState.Actual)
        }
        else
        {
            Write-Verbose -Message ($script:localizedData.MSAInDesiredState -f $ServiceAccountName)
            return $true
        }
    }
    else
    {
        $compareTargetResourceNonCompliant |
            ForEach-Object {
                Write-Verbose -Message ($script:localizedData.NotDesiredPropertyState -f `
                        $_.Parameter, $_.Expected, $_.Actual)
            }
    }

    if ($compareTargetResourceNonCompliant)
    {
        Write-Verbose -Message ($script:localizedData.MSANotInDesiredState -f $ServiceAccountName)
        return $false
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.MSAInDesiredState -f $ServiceAccountName)
        return $true
    }

} #end function Test-TargetResource

<#
    .SYNOPSIS
        Sets the state of the managed service account.

    .PARAMETER ServiceAccountName
        Specifies the Security Account Manager (SAM) account name of the managed service account (ldapDisplayName 'sAMAccountName').
        To be compatible with older operating systems, create a SAM account name that is 20 characters or less. Once created,
        the user's SamAccountName and CN cannot be changed.

    .PARAMETER AccountType
        The type of managed service account. Single will create a Single Managed Service Account (sMSA) and Group will
        create a Group Managed Service Account (gMSA). If not specified, this vaule defaults to Single.

    .PARAMETER AccountTypeForce
        Specifies whether or not to remove the service account and recreate it when going from single MSA to
        group MSA and vice-versa. If not specified, this value defaults to False.

    .PARAMETER Path
        Specifies the X.500 path of the Organizational Unit (OU) or container where the new object is created.
        Specified as a Distinguished Name (DN).

    .PARAMETER Ensure
        Specifies whether the user account is created or deleted. If not specified, this value defaults to Present.

    .PARAMETER Description
        Specifies a description of the object (ldapDisplayName 'description').

    .PARAMETER DisplayName
        Specifies the display name of the object (ldapDisplayName 'displayName').

    .PARAMETER Members
        Specifies the members of the object (ldapDisplayName 'PrincipalsAllowedToRetrieveManagedPassword').
        Only used when 'Group' is selected for 'AccountType'.

    .PARAMETER MembershipAttribute
        Active Directory attribute used to perform membership operations for Group Managed Service Accounts (gMSAs).
        If not specified, this value defaults to SamAccountName. Only used when 'Group' is selected for 'AccountType'.

    .PARAMETER Credential
        Specifies the user account credentials to use to perform this task.
        This is only required if not executing the task on a domain controller or using the -DomainController parameter.

    .PARAMETER DomainController
        Specifies the Active Directory Domain Controller instance to use to perform the task.
        This is only required if not executing the task on a domain controller.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ServiceAccountName,

        [Parameter()]
        [ValidateSet('Group', 'Single')]
        [System.String]
        $AccountType = 'Single',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Boolean]
        $AccountTypeForce = $false,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [ValidateSet('SamAccountName', 'DistinguishedName', 'SID', 'ObjectGUID')]
        [System.String]
        $MembershipAttribute = 'SamAccountName',

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainController
    )

    # Need to set these to compare if not specified since user is using defaults
    $PSBoundParameters['Ensure'] = $Ensure
    $PSBoundParameters['AccountType'] = $AccountType
    $PSBoundParameters['MembershipAttribute'] = $MembershipAttribute

    $compareTargetResource = Compare-TargetResourceState @PSBoundParameters
    $compareTargetResourceNonCompliant = @($compareTargetResource |
            Where-Object -FilterScript { $_.Pass -eq $false })

    $adServiceAccountParameters = Get-ADCommonParameters @PSBoundParameters
    $setServiceAccountParameters = $adServiceAccountParameters.Clone()
    $moveADObjectParameters = $adServiceAccountParameters.Clone()

    try
    {
        if ($Ensure -eq 'Present')
        {
            $isEnsureNonCompliant = $false

            if ($compareTargetResourceNonCompliant |
                    Where-Object -FilterScript { $_.Parameter -eq 'Ensure' })
            {
                $isEnsureNonCompliant = $true
            }

            # We want the account to be present, but it currently does not exist
            if ($isEnsureNonCompliant)
            {
                $null = $PSBoundParameters.Remove('AccountTypeForce')
                New-ADServiceAccountHelper @PSBoundParameters
            }
            else
            {
                #region Check if AccountType is compliant
                $accountTypeState = $compareTargetResourceNonCompliant |
                    Where-Object -FilterScript { $_.Parameter -eq 'AccountType' }

                # Account already exist, need to update parameters that are not in compliance
                if ($accountTypeState)
                {
                    if ($AccountTypeForce)
                    {
                        # We need to recreate account first before we can update any properties
                        Write-Verbose -Message ($script:localizedData.UpdatingManagedServiceAccountProperty -f 'AccountType', $AccountType)
                        Remove-ADServiceAccount @adServiceAccountParameters -Confirm:$false
                        $null = $PSBoundParameters.Remove('AccountTypeForce')
                        New-ADServiceAccountHelper @PSBoundParameters
                    }
                    else
                    {
                        Write-Warning -Message ($script:localizedData.AccountTypeForceNotTrue -f $accountTypeState.Actual, $accountTypeState.Expected)
                    }
                }

                # Remove AccountType since we don't want to enumerate down below
                $compareTargetResourceNonCompliant = @($compareTargetResourceNonCompliant |
                        Where-Object -FilterScript { $_.Parameter -ne 'AccountType' })
                #endregion Check if AccountType is compliant

                #region Check if Path is compliant
                $isPathNonCompliant = $false
                if ($compareTargetResourceNonCompliant |
                        Where-Object -FilterScript { $_.Parameter -eq 'Path' })
                {
                    $isPathNonCompliant = $true
                }

                if ($isPathNonCompliant)
                {
                    Write-Verbose -Message ($script:localizedData.MovingManagedServiceAccount -f $ServiceAccountName, $Path)
                    $distinguishedNameObject = $compareTargetResource |
                        Where-Object -FilterScript { $_.Parameter -eq 'DistinguishedName' }

                    $moveADObjectParameters['Identity'] = $distinguishedNameObject.Actual

                    Move-ADObject @moveADObjectParameters -TargetPath $Path
                }

                $compareTargetResourceNonCompliant = @($compareTargetResourceNonCompliant |
                        Where-Object -FilterScript { $_.Parameter -ne 'Path' })
                #endregion Check if Path is compliant

                #region Check if other parameters are compliant
                $updateProperties = $false
                $compareTargetResourceNonCompliant |
                    ForEach-Object {
                        $updateProperties = $true
                        $parameter = $_.Parameter
                        if ($parameter -eq 'Members' -and $AccountType -eq 'Group')
                        {
                            if ([system.string]::IsNullOrEmpty($Members))
                            {
                                $Members = @()
                            }
                            $listMembers = $Members -join ','

                            Write-Verbose -Message ($script:localizedData.UpdatingManagedServiceAccountProperty -f 'Members', $listMembers)
                            $setServiceAccountParameters['PrincipalsAllowedToRetrieveManagedPassword'] = $Members
                        }
                        else
                        {
                            Write-Verbose -Message ($script:localizedData.UpdatingManagedServiceAccountProperty -f $parameter, $PSBoundParameters.$parameter)
                            $setServiceAccountParameters[$parameter] = $PSBoundParameters.$parameter
                        }
                    }

                if ($compareTargetResourceNonCompliant.Count -gt 0)
                {
                    Set-ADServiceAccount @setServiceAccountParameters
                }
                #endregion Check if other parameters are compliant
            }
        }
        elseif ($Ensure -eq 'Absent')
        {
            $isEnsureNonCompliant = $false
            if ($compareTargetResourceNonCompliant |
                    Where-Object -FilterScript { $_.Parameter -eq 'Ensure' })
            {
                $isEnsureNonCompliant = $true
            }

            # We want the account to be Absent, but it is Present
            if ($isEnsureNonCompliant)
            {
                Write-Verbose -Message ($script:localizedData.RemovingManagedServiceAccount -f $ServiceAccountName)
                Remove-ADServiceAccount @adServiceAccountParameters -Confirm:$false
            }
        }
    }
    catch
    {
        $errorMessage = $script:localizedData.AddingManagedServiceAccountError -f $ServiceAccountName
        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
    }
} #end function Set-TargetResource

<#
    .SYNOPSIS
        Adds the managed service account.

    .PARAMETER ServiceAccountName
        Specifies the Security Account Manager (SAM) account name of the managed service account (ldapDisplayName 'sAMAccountName').
        To be compatible with older operating systems, create a SAM account name that is 20 characters or less. Once created,
        the user's SamAccountName and CN cannot be changed.

    .PARAMETER AccountType
        The type of managed service account. Single will create a Single Managed Service Account (sMSA) and Group will
        create a Group Managed Service Account (gMSA). If not specified, this vaule defaults to Single.

    .PARAMETER AccountTypeForce
        Specifies whether or not to remove the service account and recreate it when going from single MSA to
        group MSA and vice-versa. If not specified, this value defaults to False.

    .PARAMETER Path
        Specifies the X.500 path of the Organizational Unit (OU) or container where the new object is created.
        Specified as a Distinguished Name (DN).

    .PARAMETER Ensure
        Specifies whether the user account is created or deleted. If not specified, this value defaults to Present.

    .PARAMETER Description
        Specifies a description of the object (ldapDisplayName 'description').

    .PARAMETER DisplayName
        Specifies the display name of the object (ldapDisplayName 'displayName').

    .PARAMETER Members
        Specifies the members of the object (ldapDisplayName 'PrincipalsAllowedToRetrieveManagedPassword').
        Only used when 'Group' is selected for 'AccountType'.

    .PARAMETER MembershipAttribute
        Active Directory attribute used to perform membership operations for Group Managed Service Accounts (gMSAs).
        If not specified, this value defaults to SamAccountName. Only used when 'Group' is selected for 'AccountType'.

    .PARAMETER Credential
        Specifies the user account credentials to use to perform this task.
        This is only required if not executing the task on a domain controller or using the -DomainController parameter.

    .PARAMETER DomainController
        Specifies the Active Directory Domain Controller instance to use to perform the task.
        This is only required if not executing the task on a domain controller.
#>
function New-ADServiceAccountHelper
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ServiceAccountName,

        [Parameter()]
        [ValidateSet('Group', 'Single')]
        [System.String]
        $AccountType = 'Single',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [ValidateSet('SamAccountName', 'DistinguishedName', 'SID', 'ObjectGUID')]
        [System.String]
        $MembershipAttribute = 'SamAccountName',

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainController
    )

    Write-Verbose -Message ($script:localizedData.AddingManagedServiceAccount -f $ServiceAccountName)

    $adServiceAccountParameters = Get-ADCommonParameters @PSBoundParameters -UseNameParameter

    if ($Description)
    {
        $adServiceAccountParameters['Description'] = $Description
    }

    if ($DisplayName)
    {
        $adServiceAccountParameters['DisplayName'] = $DisplayName
    }

    if ($Path)
    {
        $adServiceAccountParameters['Path'] = $Path
    }


    # Create service account
    if ( $AccountType -eq 'Single' )
    {
        New-ADServiceAccount @adServiceAccountParameters -RestrictToSingleComputer -PassThru
    }
    elseif ( $AccountType -eq 'Group' )
    {
        if ($Members)
        {
            $adServiceAccountParameters['PrincipalsAllowedToRetrieveManagedPassword'] = $Members
        }

        $dnsHostName = '{0}.{1}' -f $ServiceAccountName, $(Get-DomainName)
        $adServiceAccountParameters['DNSHostName'] = $dnsHostName

        New-ADServiceAccount @adServiceAccountParameters -PassThru
    }
} #end function New-ADServiceAccountHelper

<#
    .SYNOPSIS
        Compares the state of the managed service account.

    .PARAMETER ServiceAccountName
        Specifies the Security Account Manager (SAM) account name of the managed service account (ldapDisplayName 'sAMAccountName').
        To be compatible with older operating systems, create a SAM account name that is 20 characters or less. Once created,
        the user's SamAccountName and CN cannot be changed.

    .PARAMETER AccountType
        The type of managed service account. Single will create a Single Managed Service Account (sMSA) and Group will
        create a Group Managed Service Account (gMSA). If not specified, this vaule defaults to Single.

    .PARAMETER AccountTypeForce
        Specifies whether or not to remove the service account and recreate it when going from single MSA to
        group MSA and vice-versa. If not specified, this value defaults to False.

    .PARAMETER Path
        Specifies the X.500 path of the Organizational Unit (OU) or container where the new object is created.
        Specified as a Distinguished Name (DN).

    .PARAMETER Ensure
        Specifies whether the user account is created or deleted. If not specified, this value defaults to Present.

    .PARAMETER Description
        Specifies a description of the object (ldapDisplayName 'description').

    .PARAMETER DisplayName
        Specifies the display name of the object (ldapDisplayName 'displayName').

    .PARAMETER Members
        Specifies the members of the object (ldapDisplayName 'PrincipalsAllowedToRetrieveManagedPassword').
        Only used when 'Group' is selected for 'AccountType'.

    .PARAMETER MembershipAttribute
        Active Directory attribute used to perform membership operations for Group Managed Service Accounts (gMSAs).
        If not specified, this value defaults to SamAccountName. Only used when 'Group' is selected for 'AccountType'.

    .PARAMETER Credential
        Specifies the user account credentials to use to perform this task.
        This is only required if not executing the task on a domain controller or using the -DomainController parameter.

    .PARAMETER DomainController
        Specifies the Active Directory Domain Controller instance to use to perform the task.
        This is only required if not executing the task on a domain controller.
#>
function Compare-TargetResourceState
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ServiceAccountName,

        [Parameter()]
        [ValidateSet('Group', 'Single')]
        [System.String]
        $AccountType,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Boolean]
        $AccountTypeForce,

        [Parameter()]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [ValidateSet('SamAccountName', 'DistinguishedName', 'SID', 'ObjectGUID')]
        [System.String]
        $MembershipAttribute,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainController
    )

    $getTargetResourceParameters = @{
        ServiceAccountName  = $ServiceAccountName
        Credential          = $Credential
        DomainController    = $DomainController
        MembershipAttribute = $MembershipAttribute
        AccountTypeForce    = $AccountTypeForce
    }

    @($getTargetResourceParameters.Keys) |
        ForEach-Object {
            if (-not $PSBoundParameters.ContainsKey($_))
            {
                $getTargetResourceParameters.Remove($_)
            }
        }

    $getTargetResource = Get-TargetResource @getTargetResourceParameters
    $compareTargetResource = @()

    # Add DistinguishedName as it won't be passed as an argument, but we want to get the DN in Set
    $PSBoundParameters['DistinguishedName'] = $getTargetResource['DistinguishedName']

    <#
        Set MembershipAttribute as it's not required to be compliant. It's only
        used when setting/getting members for gMSA and there is no way to check
        if it is in compliance since whatever is passed would be compliant itself.
    #>
    $PSBoundParameters['MembershipAttribute'] = $getTargetResource['MembershipAttribute']

    foreach ($parameter in $PSBoundParameters.Keys)
    {
        if ($PSBoundParameters.$parameter -eq $getTargetResource.$parameter)
        {
            # Check if parameter is in compliance
            $compareTargetResource += [pscustomobject] @{
                Parameter = $parameter
                Expected  = $PSBoundParameters.$parameter
                Actual    = $getTargetResource.$parameter
                Pass      = $true
            }
        }
        elseif ($parameter -eq 'Members')
        {
            # Members is only for Group MSAs, if it's single computer, we can skip over this parameter
            if ($PSBoundParameters.AccountType -eq 'Group')
            {
                $testMembersParams = @{
                    ExistingMembers = $getTargetResource.Members -as [System.String[]]
                    Members         = $Members
                }

                $expectedMembers = ($Members |
                        Sort-Object) -join ','

                $actualMembers = ($testMembersParams['ExistingMembers'] |
                        Sort-Object) -join ','

                if (-not (Test-Members @testMembersParams))
                {
                    $compareTargetResource += [pscustomobject] @{
                        Parameter = $parameter
                        Expected  = $expectedMembers
                        Actual    = $actualMembers
                        Pass      = $false
                    }
                }
                else
                {
                    $compareTargetResource += [pscustomobject] @{
                        Parameter = $parameter
                        Expected  = $expectedMembers
                        Actual    = $actualMembers
                        Pass      = $true
                    }
                }
            }
        }

        # Need to check if parameter is part of schema, otherwise ignore all other parameters like verbose
        elseif ($getTargetResource.ContainsKey($parameter))
        {
            <#
                We are out of compliance if we get here
                $PSBoundParameters.$parameter -ne $getTargetResource.$parameter
            #>
            $compareTargetResource += [pscustomobject] @{
                Parameter = $parameter
                Expected  = $PSBoundParameters.$parameter
                Actual    = $getTargetResource.$parameter
                Pass      = $false
            }
        }
    } #end foreach PSBoundParameter

    return $compareTargetResource
} #end function Compare-TargetResourceState

Export-ModuleMember -Function *-TargetResource
