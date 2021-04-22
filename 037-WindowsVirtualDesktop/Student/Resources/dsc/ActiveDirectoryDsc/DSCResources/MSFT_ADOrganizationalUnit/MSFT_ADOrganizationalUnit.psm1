$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADOrganizationalUnit'

<#
    .SYNOPSIS
        Gets the Organization Unit (OU) from Active Directory

    .PARAMETER Name
        The name of Organization Unit (OU).

    .PARAMETER Path
        Specifies the X.500 path of the Organization Unit (OU) or container
        where the new object is created.

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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Path
    )

    Assert-Module -ModuleName 'ActiveDirectory'

    Write-Verbose ($script:localizedData.RetrievingOU -f $Name, $Path)

    try
    {
        $ou = Get-ADOrganizationalUnit -Filter { Name -eq $Name } -SearchBase $Path -SearchScope OneLevel -Properties ProtectedFromAccidentalDeletion, Description
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {
        $errorMessage = $script:localizedData.PathNotFoundError -f $Path
        New-ObjectNotFoundException -Message $errorMessage
    }
    catch
    {
        throw $_
    }

    if ($null -eq $ou)
    {
        $ensureState = 'Absent'
    }
    else
    {
        $ensureState = 'Present'
    }

    return @{
        Name                            = $Name
        Path                            = $Path
        Ensure                          = $ensureState
        ProtectedFromAccidentalDeletion = $ou.ProtectedFromAccidentalDeletion
        Description                     = $ou.Description
    }
} # end function Get-TargetResource

<#
    .SYNOPSIS
        Tests the state of the specified Organization Unit (OU).

    .PARAMETER Name
        The name of Organization Unit (OU).

    .PARAMETER Path
        Specifies the X.500 path of the Organization Unit (OU) or container
        where the new object is created.

    .PARAMETER Ensure
        Specifies whether the Organization Unit (OU) is present or absent.
        Default value is 'Present'.

    .PARAMETER Credential
        The credential to be used to perform the operation on Active Directory.

    .PARAMETER ProtectedFromAccidentalDeletion
        Specifies if the Organization Unit (OU) container should be protected
        from deletion. Default value is $true.

    .PARAMETER Description
        The description of the Organization Unit (OU). Default value is empty
        ('') description.

    .PARAMETER RestoreFromRecycleBin
        Try to restore the Organization Unit (OU) from the recycle bin before
        creating a new one.

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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNull()]
        [System.Boolean]
        $ProtectedFromAccidentalDeletion = $true,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $Description = '',

        [Parameter()]
        [ValidateNotNull()]
        [System.Boolean]
        $RestoreFromRecycleBin
    )

    $targetResource = Get-TargetResource -Name $Name -Path $Path

    if ($targetResource.Ensure -eq 'Present')
    {
        if ($Ensure -eq 'Present')
        {
            # Organizational unit exists
            if ([System.String]::IsNullOrEmpty($Description))
            {
                $isCompliant = (($targetResource.Name -eq $Name) -and
                    ($targetResource.Path -eq $Path) -and
                    ($targetResource.ProtectedFromAccidentalDeletion -eq $ProtectedFromAccidentalDeletion))
            }
            else
            {
                $isCompliant = (($targetResource.Name -eq $Name) -and
                    ($targetResource.Path -eq $Path) -and
                    ($targetResource.ProtectedFromAccidentalDeletion -eq $ProtectedFromAccidentalDeletion) -and
                    ($targetResource.Description -eq $Description))
            }

            if ($isCompliant)
            {
                Write-Verbose ($script:localizedData.OUInDesiredState -f $targetResource.Name)
            }
            else
            {
                Write-Verbose ($script:localizedData.OUNotInDesiredState -f $targetResource.Name)
            }
        }
        else
        {
            $isCompliant = $false
            Write-Verbose ($script:localizedData.OUExistsButShouldNot -f $targetResource.Name)
        }
    }
    else
    {
        # Organizational unit does not exist
        if ($Ensure -eq 'Present')
        {
            $isCompliant = $false
            Write-Verbose ($script:localizedData.OUDoesNotExistButShould -f $targetResource.Name)
        }
        else
        {
            $isCompliant = $true
            Write-Verbose ($script:localizedData.OUDoesNotExistAndShouldNot -f $targetResource.Name)
        }
    }

    return $isCompliant

} #end function Test-TargetResource

<#
    .SYNOPSIS
        Sets the state of the Organization Unit (OU) in Active Directory.

    .PARAMETER Name
        The name of Organization Unit (OU).

    .PARAMETER Path
        Specifies the X.500 path of the Organization Unit (OU) or container
        where the new object is created.

    .PARAMETER Ensure
        Specifies whether the Organization Unit (OU) is present or absent.
        Default value is 'Present'.

    .PARAMETER Credential
        The credential to be used to perform the operation on Active Directory.

    .PARAMETER ProtectedFromAccidentalDeletion
        Specifies if the Organization Unit (OU) container should be protected
        from deletion. Default value is $true.

    .PARAMETER Description
        The description of the Organization Unit (OU). Default value is empty
        ('') description.

    .PARAMETER RestoreFromRecycleBin
        Try to restore the Organization Unit (OU) from the recycle bin before
        creating a new one.

#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNull()]
        [System.Boolean]
        $ProtectedFromAccidentalDeletion = $true,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $Description = '',

        [Parameter()]
        [ValidateNotNull()]
        [System.Boolean]
        $RestoreFromRecycleBin
    )

    Assert-Module -ModuleName 'ActiveDirectory'

    $targetResource = Get-TargetResource -Name $Name -Path $Path

    if ($targetResource.Ensure -eq 'Present')
    {
        $ou = Get-ADOrganizationalUnit -Filter { Name -eq $Name } -SearchBase $Path -SearchScope OneLevel

        if ($Ensure -eq 'Present')
        {
            Write-Verbose ($script:localizedData.UpdatingOU -f $targetResource.Name)

            $setADOrganizationalUnitParams = @{
                Identity                        = $ou
                Description                     = $Description
                ProtectedFromAccidentalDeletion = $ProtectedFromAccidentalDeletion
            }

            if ($Credential)
            {
                $setADOrganizationalUnitParams['Credential'] = $Credential
            }

            Set-ADOrganizationalUnit @setADOrganizationalUnitParams
        }
        else
        {
            Write-Verbose ($script:localizedData.DeletingOU -f $targetResource.Name)

            if ($targetResource.ProtectedFromAccidentalDeletion)
            {
                $setADOrganizationalUnitParams = @{
                    Identity                        = $ou
                    ProtectedFromAccidentalDeletion = $ProtectedFromAccidentalDeletion
                }

                if ($Credential)
                {
                    $setADOrganizationalUnitParams['Credential'] = $Credential
                }

                Set-ADOrganizationalUnit @setADOrganizationalUnitParams
            }

            $removeADOrganizationalUnitParams = @{
                Identity = $ou
            }

            if ($Credential)
            {
                $removeADOrganizationalUnitParams['Credential'] = $Credential
            }

            Remove-ADOrganizationalUnit @removeADOrganizationalUnitParams
        }

        return # return from Set method to make it easier to test for a successful restore
    }
    else
    {
        if ($RestoreFromRecycleBin)
        {
            Write-Verbose -Message ($script:localizedData.RestoringOu -f $Name)

            $restoreParams = @{
                Identity    = $Name
                ObjectClass = 'OrganizationalUnit'
                ErrorAction = 'Stop'
            }

            if ($Credential)
            {
                $restoreParams['Credential'] = $Credential
            }

            $restoreSuccessful = Restore-ADCommonObject @restoreParams
        }

        if (-not $RestoreFromRecycleBin -or ($RestoreFromRecycleBin -and -not $restoreSuccessful))
        {
            Write-Verbose ($script:localizedData.CreatingOU -f $targetResource.Name)

            $newADOrganizationalUnitParams = @{
                Name                            = $Name
                Path                            = $Path
                Description                     = $Description
                ProtectedFromAccidentalDeletion = $ProtectedFromAccidentalDeletion
            }

            if ($Credential)
            {
                $newADOrganizationalUnitParams['Credential'] = $Credential
            }

            New-ADOrganizationalUnit @newADOrganizationalUnitParams
        }
    }
} #end function Set-TargetResource

Export-ModuleMember -Function *-TargetResource
