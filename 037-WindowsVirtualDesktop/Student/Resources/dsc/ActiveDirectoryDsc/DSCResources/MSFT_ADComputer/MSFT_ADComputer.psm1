$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADComputer'

<#
    A property map that maps the resource parameters to the corresponding
    Active Directory computer account object attribute.
#>
$script:computerObjectPropertyMap = @(
    @{
        ParameterName = 'ComputerName'
        PropertyName  = 'CN'
    },
    @{
        ParameterName = 'Location'
    },
    @{
        ParameterName = 'DnsHostName'
    },
    @{
        ParameterName = 'ServicePrincipalNames'
        PropertyName  = 'ServicePrincipalName'
    },
    @{
        ParameterName = 'UserPrincipalName'
    },
    @{
        ParameterName = 'DisplayName'
    },
    @{
        ParameterName = 'Path'
        PropertyName  = 'DistinguishedName'
    },
    @{
        ParameterName = 'Description'
    },
    @{
        ParameterName = 'Enabled'
    },
    @{
        ParameterName = 'Manager'
        PropertyName  = 'ManagedBy'
    },
    @{
        ParameterName = 'DistinguishedName'
        ParameterType = 'Read'
        PropertyName  = 'DistinguishedName'
    },
    @{
        ParameterName = 'SID'
        ParameterType = 'Read'
    }
)

<#
    .SYNOPSIS
        Returns the current state of the Active Directory computer account.

    .PARAMETER ComputerName
         Specifies the name of the Active Directory computer account to manage.
         You can identify a computer by its distinguished name, GUID, security
         identifier (SID) or Security Accounts Manager (SAM) account name.

    .PARAMETER RequestFile
        Specifies the full path to the Offline Domain Join Request file to create.

    .PARAMETER EnabledOnCreation
        Specifies if the computer account is created enabled or disabled.
        By default the Enabled property of the computer account will be set to
        the default value of the cmdlet New-ADComputer. This property is ignored
        if the parameter RequestFile is specified in the same configuration.
        This parameter does not enforce the property `Enabled`. To enforce the
        property `Enabled` see the resource ADObjectEnabledState.

    .PARAMETER DomainController
        Specifies the Active Directory Domain Services instance to connect to perform the task.

        Used by Get-ADCommonParameters and is returned as a common parameter.

    .PARAMETER Credential
        Specifies the user account credentials to use to perform the task.

        Used by Get-ADCommonParameters and is returned as a common parameter.

    .PARAMETER RestoreFromRecycleBin
        Try to restore the organizational unit from the recycle bin before
        creating a new one.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ComputerName,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $RequestFile,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $DomainController,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNull()]
        [System.Boolean]
        $RestoreFromRecycleBin,

        [Parameter()]
        [ValidateNotNull()]
        [System.Boolean]
        $EnabledOnCreation
    )

    Assert-Module -ModuleName 'ActiveDirectory' -ImportModule

    <#
        These are properties that have no corresponding property in a
        Computer account object.
    #>
    $getTargetResourceReturnValue = @{
        Ensure                = 'Absent'
        ComputerName          = $null
        Location              = $null
        DnsHostName           = $null
        ServicePrincipalNames = $null
        UserPrincipalName     = $null
        DisplayName           = $null
        Path                  = $null
        Description           = $null
        Enabled               = $false
        Manager               = $null
        DomainController      = $DomainController
        Credential            = $Credential
        RequestFile           = $RequestFile
        RestoreFromRecycleBin = $RestoreFromRecycleBin
        EnabledOnCreation     = $EnabledOnCreation
        DistinguishedName     = $null
        SID                   = $null
        SamAccountName        = $null
    }

    $getADComputerResult = $null

    try
    {
        <#
            Create an array of the Active Directory Computer object property
            names to retrieve from the Computer object.
        #>
        $computerObjectProperties = Convert-PropertyMapToObjectProperties -PropertyMap $script:computerObjectPropertyMap

        <#
            When the property ServicePrincipalName is read with Get-ADComputer
            the property name must be 'ServicePrincipalNames', but when it is
            written with Set-ADComputer the property name must be
            'ServicePrincipalName'. This difference is handled here.
        #>
        $computerObjectProperties = @($computerObjectProperties |
                Where-Object -FilterScript {
                    $_ -ne 'ServicePrincipalName'
                })

        $computerObjectProperties += @('ServicePrincipalNames')

        Write-Verbose -Message ($script:localizedData.RetrievingComputerAccount -f $ComputerName)

        $getADComputerParameters = Get-ADCommonParameters @PSBoundParameters
        $getADComputerParameters['Properties'] = $computerObjectProperties

        # If the computer account is not found Get-ADComputer will throw an error.
        $getADComputerResult = Get-ADComputer @getADComputerParameters

        Write-Verbose -Message ($script:localizedData.ComputerAccountIsPresent -f $ComputerName)

        $getTargetResourceReturnValue['Ensure'] = 'Present'
        $getTargetResourceReturnValue['ComputerName'] = $getADComputerResult.CN
        $getTargetResourceReturnValue['Location'] = $getADComputerResult.Location
        $getTargetResourceReturnValue['DnsHostName'] = $getADComputerResult.DnsHostName
        $getTargetResourceReturnValue['ServicePrincipalNames'] = [System.String[]] $getADComputerResult.ServicePrincipalNames
        $getTargetResourceReturnValue['UserPrincipalName'] = $getADComputerResult.UserPrincipalName
        $getTargetResourceReturnValue['DisplayName'] = $getADComputerResult.DisplayName
        $getTargetResourceReturnValue['Path'] = Get-ADObjectParentDN -DN $getADComputerResult.DistinguishedName
        $getTargetResourceReturnValue['Description'] = $getADComputerResult.Description
        $getTargetResourceReturnValue['Enabled'] = $getADComputerResult.Enabled
        $getTargetResourceReturnValue['Manager'] = $getADComputerResult.ManagedBy
        $getTargetResourceReturnValue['DomainController'] = $DomainController
        $getTargetResourceReturnValue['Credential'] = $Credential
        $getTargetResourceReturnValue['RequestFile'] = $RequestFile
        $getTargetResourceReturnValue['RestoreFromRecycleBin'] = $RestoreFromRecycleBin
        $getTargetResourceReturnValue['EnabledOnCreation'] = $EnabledOnCreation
        $getTargetResourceReturnValue['DistinguishedName'] = $getADComputerResult.DistinguishedName
        $getTargetResourceReturnValue['SID'] = $getADComputerResult.SID
        $getTargetResourceReturnValue['SamAccountName'] = $getADComputerResult.SamAccountName
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {
        Write-Verbose -Message ($script:localizedData.ComputerAccountIsAbsent -f $ComputerName)
    }
    catch
    {
        $errorMessage = $script:localizedData.FailedToRetrieveComputerAccount -f $ComputerName
        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
    }

    return $getTargetResourceReturnValue
}

<#
    .SYNOPSIS
        Determines if the Active Directory computer account is in the desired state.

    .PARAMETER ComputerName
         Specifies the name of the Active Directory computer account to manage.
         You can identify a computer by its distinguished name, GUID, security
         identifier (SID) or Security Accounts Manager (SAM) account name.

    .PARAMETER Ensure
        Specifies whether the computer account is present or absent.
        Valid values are 'Present' and 'Absent'. The default is 'Present'.

    .PARAMETER UserPrincipalName
        Specifies the UPN assigned to the computer account.

    .PARAMETER DisplayName
        Specifies the display name of the computer.

    .PARAMETER Path
        Specifies the X.500 path of the container where the computer is located.

    .PARAMETER Location
        Specifies the location of the computer, such as an office number.

    .PARAMETER DnsHostName
        Specifies the fully qualified domain name (FQDN) of the computer.

    .PARAMETER ServicePrincipalNames
        Specifies the service principal names for the computer account.

    .PARAMETER Description
        Specifies a description of the computer account.

    .PARAMETER Manager
        Specifies the user or group Distinguished Name that manages the computer
        account. Valid values are the user's or group's DistinguishedName,
        ObjectGUID, SID or SamAccountName.

    .PARAMETER RequestFile
        Specifies the full path to the Offline Domain Join Request file to create.

    .PARAMETER DomainController
        Specifies the Active Directory Domain Services instance to connect to perform the task.

    .PARAMETER Credential
        Specifies the user account credentials to use to perform the task.

    .PARAMETER RestoreFromRecycleBin
        Try to restore the organizational unit from the recycle bin before
        creating a new one.

    .PARAMETER EnabledOnCreation
        Specifies if the computer account is created enabled or disabled.
        By default the Enabled property of the computer account will be set to
        the default value of the cmdlet New-ADComputer. This property is ignored
        if the parameter RequestFile is specified in the same configuration.
        This parameter does not enforce the property `Enabled`. To enforce the
        property `Enabled` see the resource ADObjectEnabledState.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        # Common Name
        [Parameter(Mandatory = $true)]
        [System.String]
        $ComputerName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $UserPrincipalName,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $Location,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $DnsHostName,

        [Parameter()]
        [ValidateNotNull()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $Manager,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $RequestFile,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $DomainController,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNull()]
        [System.Boolean]
        $RestoreFromRecycleBin,

        [Parameter()]
        [ValidateNotNull()]
        [System.Boolean]
        $EnabledOnCreation
    )

    Write-Verbose -Message (
        $script:localizedData.TestConfiguration -f $ComputerName
    )

    $getTargetResourceParameters = @{
        ComputerName          = $ComputerName
        RequestFile           = $RequestFile
        DomainController      = $DomainController
        Credential            = $Credential
        RestoreFromRecycleBin = $RestoreFromRecycleBin
        EnabledOnCreation     = $EnabledOnCreation
    }

    # Need the @() around this to get a new array to enumerate.
    @($getTargetResourceParameters.Keys) |
        ForEach-Object {
            if (-not $PSBoundParameters.ContainsKey($_))
            {
                $getTargetResourceParameters.Remove($_)
            }
        }

    $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

    $testTargetResourceReturnValue = $true

    if ($Ensure -eq 'Absent')
    {
        if ($getTargetResourceResult.Ensure -eq 'Present')
        {
            Write-Verbose -Message (
                $script:localizedData.ComputerAccountShouldBeAbsent -f $ComputerName
            )

            $testTargetResourceReturnValue = $false
        }
    }
    else
    {
        if ($getTargetResourceResult.Ensure -eq 'Absent')
        {
            Write-Verbose -Message (
                $script:localizedData.ComputerAccountShouldBePresent -f $ComputerName
            )

            $testTargetResourceReturnValue = $false
        }
        else
        {
            <#
                - Ignores the parameter ComputerName since we are not supporting
                  renaming a computer account.
                - Ignore to compare the parameter ServicePrincipalNames here
                  because it needs a special comparison, so it is handled
                  afterwards.
                - Ignores the Enabled property because it is not enforced in this
                  resource.
            #>
            $compareTargetResourceStateParameters = @{
                CurrentValues    = $getTargetResourceResult
                DesiredValues    = $PSBoundParameters
                # This gives an array of properties to compare.
                Properties       = $script:computerObjectPropertyMap.ParameterName
                # But these properties
                IgnoreProperties = @(
                    'ComputerName'
                    'ServicePrincipalNames'
                    'Enabled'
                )
            }

            $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters

            if ($false -in $compareTargetResourceStateResult.InDesiredState)
            {
                $testTargetResourceReturnValue = $false
            }

            if ($PSBoundParameters.ContainsKey('ServicePrincipalNames'))
            {
                $testServicePrincipalNamesParameters = @{
                    ExistingServicePrincipalNames = $getTargetResourceResult.ServicePrincipalNames
                    ServicePrincipalNames         = $ServicePrincipalNames
                }

                $testTargetResourceReturnValue = Test-ServicePrincipalNames @testServicePrincipalNamesParameters
            }
        }

    }

    if ($testTargetResourceReturnValue)
    {
        Write-Verbose -Message ($script:localizedData.ComputerAccountInDesiredState -f $ComputerName)
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.ComputerAccountNotInDesiredState -f $ComputerName)
    }

    return $testTargetResourceReturnValue
}

<#
    .SYNOPSIS
        Creates, removes or modifies the Active Directory computer account.

    .PARAMETER ComputerName
         Specifies the name of the Active Directory computer account to manage.
         You can identify a computer by its distinguished name, GUID, security
         identifier (SID) or Security Accounts Manager (SAM) account name.

    .PARAMETER Ensure
        Specifies whether the computer account is present or absent.
        Valid values are 'Present' and 'Absent'. The default is 'Present'.

    .PARAMETER UserPrincipalName
        Specifies the UPN assigned to the computer account.

    .PARAMETER DisplayName
        Specifies the display name of the computer.

    .PARAMETER Path
        Specifies the X.500 path of the container where the computer is located.

    .PARAMETER Location
        Specifies the location of the computer, such as an office number.

    .PARAMETER DnsHostName
        Specifies the fully qualified domain name (FQDN) of the computer.

    .PARAMETER ServicePrincipalNames
        Specifies the service principal names for the computer account.

    .PARAMETER Description
        Specifies a description of the computer account.

    .PARAMETER Manager
        Specifies the user or group Distinguished Name that manages the computer
        account. Valid values are the user's or group's DistinguishedName,
        ObjectGUID, SID or SamAccountName.

    .PARAMETER RequestFile
        Specifies the full path to the Offline Domain Join Request file to create.

    .PARAMETER DomainController
        Specifies the Active Directory Domain Services instance to connect to perform the task.

    .PARAMETER Credential
        Specifies the user account credentials to use to perform the task.

    .PARAMETER RestoreFromRecycleBin
        Try to restore the organizational unit from the recycle bin before
        creating a new one.

    .PARAMETER EnabledOnCreation
        Specifies if the computer account is created enabled or disabled.
        By default the Enabled property of the computer account will be set to
        the default value of the cmdlet New-ADComputer. This property is ignored
        if the parameter RequestFile is specified in the same configuration.
        This parameter does not enforce the property `Enabled`. To enforce the
        property `Enabled` see the resource ADObjectEnabledState.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ComputerName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $UserPrincipalName,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $Location,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $DnsHostName,

        [Parameter()]
        [ValidateNotNull()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $Manager,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $RequestFile,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $DomainController,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNull()]
        [System.Boolean]
        $RestoreFromRecycleBin,

        [Parameter()]
        [ValidateNotNull()]
        [System.Boolean]
        $EnabledOnCreation
    )

    $getTargetResourceParameters = @{
        ComputerName          = $ComputerName
        RequestFile           = $RequestFile
        DomainController      = $DomainController
        Credential            = $Credential
        RestoreFromRecycleBin = $RestoreFromRecycleBin
        EnabledOnCreation     = $EnabledOnCreation
    }

    # Need the @() around this to get a new array to enumerate.
    @($getTargetResourceParameters.Keys) |
        ForEach-Object {
            if (-not $PSBoundParameters.ContainsKey($_))
            {
                $getTargetResourceParameters.Remove($_)
            }
        }

    $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

    if ($Ensure -eq 'Present')
    {
        if ($getTargetResourceResult.Ensure -eq 'Absent')
        {
            $restorationSuccessful = $false

            # Try to restore computer account from recycle bin if it exists.
            if ($RestoreFromRecycleBin)
            {
                Write-Verbose -Message (
                    $script:localizedData.RestoringComputerAccount -f $ComputerName
                )

                $restoreADCommonObjectParameters = Get-ADCommonParameters @PSBoundParameters
                $restoreADCommonObjectParameters['ObjectClass'] = 'Computer'
                $restoreADCommonObjectParameters['ErrorAction'] = 'Stop'

                $restorationSuccessful = Restore-ADCommonObject @restoreADCommonObjectParameters
            }

            if (-not $RestoreFromRecycleBin -or ($RestoreFromRecycleBin -and -not $restorationSuccessful))
            {
                <#
                    The computer account does not exist, or the computer account
                    was not present in recycle bin, so the computer account needs
                    to be created.
                #>

                if ($RequestFile)
                {
                    <#
                        Use DJOIN to create the computer account as well as the
                        Offline Domain Join (ODJ) request file.
                    #>

                    # This should only be performed on a Domain Member, so detect the Domain Name.
                    $domainName = Get-DomainName

                    Write-Verbose -Message (
                        $script:localizedData.CreateOfflineDomainJoinRequest -f $RequestFile, $ComputerName, $domainName
                    )

                    $dJoinArguments = @(
                        '/PROVISION'
                        '/DOMAIN',
                        $domainName
                        '/MACHINE',
                        $ComputerName
                    )

                    if ($PSBoundParameters.ContainsKey('Path'))
                    {
                        $dJoinArguments += @(
                            '/MACHINEOU',
                            $Path
                        )
                    }

                    if ($PSBoundParameters.ContainsKey('DomainController'))
                    {
                        $dJoinArguments += @(
                            '/DCNAME',
                            $DomainController
                        )
                    }

                    $dJoinArguments += @(
                        '/SAVEFILE',
                        $RequestFile
                    )

                    $startProcessParameters = @{
                        FilePath     = 'djoin.exe'
                        ArgumentList = $dJoinArguments
                        Timeout      = 300
                    }

                    $dJoinProcessExitCode = Start-ProcessWithTimeout @startProcessParameters

                    if ($dJoinProcessExitCode -ne 0)
                    {
                        $errorMessage = $script:localizedData.FailedToCreateOfflineDomainJoinRequest -f $ComputerName, $dJoinProcessExitCode
                        New-InvalidOperationException -Message $errorMessage
                    }
                    else
                    {
                        Write-Verbose -Message (
                            $script:localizedData.CreatedOfflineDomainJoinRequestFile -f $RequestFile
                        )
                    }
                }
                else
                {
                    $newADComputerParameters = Get-ADCommonParameters @PSBoundParameters -UseNameParameter

                    if ($PSBoundParameters.ContainsKey('Path'))
                    {
                        Write-Verbose -Message (
                            $script:localizedData.CreateComputerAccountInPath -f $ComputerName, $Path
                        )

                        $newADComputerParameters['Path'] = $Path
                    }
                    else
                    {
                        Write-Verbose -Message (
                            $script:localizedData.CreateComputerAccount -f $ComputerName
                        )
                    }

                    <#
                        If the parameter EnabledOnCreation is specified, then the
                        property Enabled is set to that value.
                    #>
                    if ($PSBoundParameters.ContainsKey('EnabledOnCreation'))
                    {
                        if ($EnabledOnCreation)
                        {
                            Write-Verbose -Message ($script:localizedData.EnabledComputerAccount -f $ComputerName)
                        }
                        else
                        {
                            Write-Verbose -Message ($script:localizedData.DisabledComputerAccount -f $ComputerName)
                        }

                        $newADComputerParameters['Enabled'] = $EnabledOnCreation
                    }

                    New-ADComputer @newADComputerParameters
                }
            }

            <#
                Now retrieve the newly created computer account so the other
                properties can be set if specified.
            #>
            $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
        }

        <#
            - Ignores the parameter ComputerName since we are not supporting
              renaming a computer account.
            - Ignore to compare the parameter ServicePrincipalNames here
              because it needs a special comparison, so it is handled
              afterwards.
            - Ignores the Enabled property because it is not enforced in this
              resource.
        #>
        $compareTargetResourceStateParameters = @{
            CurrentValues    = $getTargetResourceResult
            DesiredValues    = $PSBoundParameters
            # This gives an array of properties to compare.
            Properties       = $script:computerObjectPropertyMap.ParameterName
            # But these properties
            IgnoreProperties = @(
                'ComputerName'
                'ServicePrincipalNames'
                'Enabled'
            )
        }

        $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters

        if ($PSBoundParameters.ContainsKey('ServicePrincipalNames'))
        {
            $testServicePrincipalNamesParameters = @{
                ExistingServicePrincipalNames = $getTargetResourceResult.ServicePrincipalNames
                ServicePrincipalNames         = $ServicePrincipalNames
            }

            $compareTargetResourceStateResult += @{
                ParameterName  = 'ServicePrincipalNames'
                Expected       = $testServicePrincipalNamesParameters.ServicePrincipalNames
                Actual         = $testServicePrincipalNamesParameters.ExistingServicePrincipalNames
                InDesiredState = Test-ServicePrincipalNames @testServicePrincipalNamesParameters
            }
        }

        $commonParameters = Get-ADCommonParameters @PSBoundParameters

        if ($compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'Path' -and -not $_.InDesiredState }))
        {
            <#
                Must move the computer account since we can't simply
                update the DistinguishedName property

                It does not work moving the computer account using the
                SamAccountName as the identity, so using the property
                DistinguishedName instead.
            #>
            $moveADObjectParameters = $commonParameters.Clone()
            $moveADObjectParameters['Identity'] = $getTargetResourceResult.DistinguishedName

            Write-Verbose -Message (
                $script:localizedData.MovingComputerAccount -f $ComputerName, $getTargetResourceResult.Path, $Path
            )

            Move-ADObject @moveADObjectParameters -TargetPath $Path
        }

        $replaceComputerProperties = @{}
        $removeComputerProperties = @{}

        # Get all properties, other than Path, that is not in desired state.
        $propertiesNotInDesiredState = $compareTargetResourceStateResult |
            Where-Object -FilterScript {
                $_.ParameterName -ne 'Path' -and -not $_.InDesiredState
            }

        foreach ($property in $propertiesNotInDesiredState)
        {
            $computerAccountPropertyName = ($script:computerObjectPropertyMap |
                    Where-Object -FilterScript {
                        $_.ParameterName -eq $property.ParameterName
                    }).PropertyName

            if (-not $computerAccountPropertyName)
            {
                $computerAccountPropertyName = $property.ParameterName
            }

            if ($property.Expected)
            {
                Write-Verbose -Message (
                    $script:localizedData.UpdatingComputerAccountProperty -f $computerAccountPropertyName, ($property.Expected -join ''',''')
                )

                # Replace the current value.
                $replaceComputerProperties[$computerAccountPropertyName] = $property.Expected
            }
            else
            {
                Write-Verbose -Message (
                    $script:localizedData.RemovingComputerAccountProperty -f $property.ParameterName, ($property.Actual -join ''',''')
                )

                # Remove the current value since the desired value is empty or nothing.
                $removeComputerProperties[$computerAccountPropertyName] = $property.Actual
            }
        }

        $setADComputerParameters = $commonParameters.Clone()

        # Set-ADComputer is only called if we have something to change.
        if ($replaceComputerProperties.Count -gt 0 -or $removeComputerProperties.Count -gt 0)
        {
            if ($replaceComputerProperties.Count -gt 0)
            {
                $setADComputerParameters['Replace'] = $replaceComputerProperties
            }
            if ($removeComputerProperties.Count -gt 0)
            {
                $setADComputerParameters['Remove'] = $removeComputerProperties
            }

            Set-DscADComputer -Parameters $setADComputerParameters

            Write-Verbose -Message (
                $script:localizedData.UpdatedComputerAccount -f $ComputerName
            )
        }
    }
    elseif ($Ensure -eq 'Absent' -and $getTargetResourceResult.Ensure -eq 'Present')
    {
        # User exists and needs removing
        Write-Verbose -Message (
            $script:localizedData.RemovingComputerAccount -f $ComputerName
        )

        $removeADComputerParameters = Get-ADCommonParameters @PSBoundParameters
        $removeADComputerParameters['Confirm'] = $false

        Remove-ADComputer @removeADComputerParameters |
            Out-Null
    }
}

<#
    .SYNOPSIS
        This evaluates the service principal names current state against the
        desired state.

    .PARAMETER ExistingServicePrincipalNames
        An array of existing service principal names that should be compared
        against the array in parameter ServicePrincipalNames.

    .PARAMETER ServicePrincipalNames
        An array of the desired service principal names that should be compared
        against the array in parameter ExistingServicePrincipalNames.
#>
function Test-ServicePrincipalNames
{
    param
    (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [System.String[]]
        $ExistingServicePrincipalNames,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [System.String[]]
        $ServicePrincipalNames

    )

    $testServicePrincipalNamesReturnValue = $true

    $testMembersParameters = @{
        ExistingMembers = $ExistingServicePrincipalNames
        Members         = $ServicePrincipalNames
    }

    if (-not (Test-Members @testMembersParameters))
    {
        Write-Verbose -Message (
            $script:localizedData.ServicePrincipalNamesNotInDesiredState `
                -f ($ExistingServicePrincipalNames -join ','), ($ServicePrincipalNames -join ',')
        )

        $testServicePrincipalNamesReturnValue = $false
    }
    else
    {
        Write-Verbose -Message (
            $script:localizedData.ServicePrincipalNamesInDesiredState
        )
    }

    return $testServicePrincipalNamesReturnValue
}

Export-ModuleMember -Function *-TargetResource
