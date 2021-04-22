# User name and password needed for this resource and Write-Verbose Used in helper functions
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSDSCUseVerboseMessageInDSCResource', '')]
param ()

$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

Import-Module -Name (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) `
                               -ChildPath 'CommonResourceHelper.psm1')

# Localized messages for Write-Verbose statements in this resource
$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_UserResource'

if (-not (Test-IsNanoServer))
{
    Add-Type -AssemblyName 'System.DirectoryServices.AccountManagement'
}
# get rid of this else once the fix for this is released
else
{
    Import-Module -Name 'Microsoft.Powershell.LocalAccounts'
}

# Commented out until the fix is released
#Import-Module -Name 'Microsoft.Powershell.LocalAccounts'

<#
    .SYNOPSIS
        Retrieves the user with the given username

    .PARAMETER UserName
        The name of the user to retrieve.
#>
function Get-TargetResource
{
    [OutputType([System.Collections.Hashtable])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $UserName
    )

    if (Test-IsNanoServer)
    {
        Get-TargetResourceOnNanoServer @PSBoundParameters
    }
    else
    {
        Get-TargetResourceOnFullSKU @PSBoundParameters
    }
}

<#
    .SYNOPSIS
        Creates, modifies, or deletes a user.

    .PARAMETER UserName
        The name of the user to create, modify, or delete.

    .PARAMETER Ensure
        Specifies whether the user should exist or not.
        By default this is set to Present.

    .PARAMETER FullName
        The (optional) full name or display name of the user.
        If not provided this value will remain blank.

    .PARAMETER Description
        Optional description for the user.

    .PARAMETER Password
        The desired password for the user.

    .PARAMETER Disabled
        Specifies whether the user should be disabled or not.
        By default this is set to $false

    .PARAMETER PasswordNeverExpires
        Specifies whether the password should ever expire or not.
        By default this is set to $false

    .PARAMETER PasswordChangeRequired
        Specifies whether the user must reset their password or not.
        By default this is set to $false

    .PARAMETER PasswordChangeNotAllowed
        Specifies whether the user is allowed to change their password or not.
        By default this is set to $false

    .NOTES
        If Ensure is set to 'Present' then the password parameter is required.
#>
function Set-TargetResource
{
    # Should process is called in a helper functions but not directly in Set-TargetResource
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '')]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $UserName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $FullName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Password,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [System.Boolean]
        $PasswordNeverExpires,

        [Parameter()]
        [System.Boolean]
        $PasswordChangeRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordChangeNotAllowed
    )

    if (Test-IsNanoServer)
    {
        Set-TargetResourceOnNanoServer @PSBoundParameters
    }
    else
    {
        Set-TargetResourceOnFullSKU @PSBoundParameters
    }
}

<#
    .SYNOPSIS
        Tests if a user is in the desired state.

    .PARAMETER UserName
        The name of the user to test the state of.

    .PARAMETER Ensure
        Specifies whether the user should exist or not.
        By default this is set to Present

    .PARAMETER FullName
        The full name/display name that the user should have.
        If not provided, this value will not be tested.

    .PARAMETER Description
        The description that the user should have.
        If not provided, this value will not be tested.

    .PARAMETER Password
        The password the user should have.

    .PARAMETER Disabled
        Specifies whether the user account should be disabled or not.

    .PARAMETER PasswordNeverExpires
        Specifies whether the password should ever expire or not.

    .PARAMETER PasswordChangeRequired
        Not used in Test-TargetResource as there is no easy way to test this value.

    .PARAMETER PasswordChangeNotAllowed
        Specifies whether the user should be allowed to change their password or not.
#>
function Test-TargetResource
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $UserName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $FullName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Password,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [System.Boolean]
        $PasswordNeverExpires,

        [Parameter()]
        [System.Boolean]
        $PasswordChangeRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordChangeNotAllowed
    )

    if (Test-IsNanoServer)
    {
        Test-TargetResourceOnNanoServer @PSBoundParameters
    }
    else
    {
        Test-TargetResourceOnFullSKU @PSBoundParameters
    }
}


<#
    .SYNOPSIS
        Retrieves the user with the given username when on a full server

    .PARAMETER UserName
        The name of the user to retrieve.
#>
function Get-TargetResourceOnFullSKU
{
    [OutputType([System.Collections.Hashtable])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $UserName
    )

    Set-StrictMode -Version Latest

    Assert-UserNameValid -UserName $UserName

    $disposables = @()

    try
    {
        Write-Verbose -Message 'Starting Get-TargetResource on FullSKU'

        $user = Find-UserByNameOnFullSku -UserName $UserName
        $disposables += $user
        $valuesToReturn = @{}

        if ($null -ne $user)
        {
            $valuesToReturn = @{
                UserName = $user.Name
                Ensure = 'Present'
                FullName = $user.DisplayName
                Description = $user.Description
                Disabled = (-not $user.Enabled)
                PasswordNeverExpires = $user.PasswordNeverExpires
                PasswordChangeRequired = $null
                PasswordChangeNotAllowed = $user.UserCannotChangePassword
            }
        }
        else
        {
            # The user is not found. Return Ensure = Absent.
            $valuesToReturn = @{
                UserName = $UserName
                Ensure = 'Absent'
            }
        }

        return $valuesToReturn
    }
    catch
    {
         New-InvalidOperationException -Message ($script:localizedData.MultipleMatches + $_)
    }
    finally
    {
        Remove-DisposableObject -Disposables $disposables
    }
}

<#
    .SYNOPSIS
        Creates, modifies, or deletes a user when on a full server.

    .PARAMETER UserName
        The name of the user to create, modify, or delete.

    .PARAMETER Ensure
        Specifies whether the user should exist or not.
        By default this is set to Present

    .PARAMETER FullName
        The (optional) full name or display name of the user.
        If not provided this value will remain blank.

    .PARAMETER Description
        Optional description for the user.

    .PARAMETER Password
        The desired password for the user.

    .PARAMETER Disabled
        Specifies whether the user should be disabled or not.
        By default this is set to $false

    .PARAMETER PasswordNeverExpires
        Specifies whether the password should ever expire or not.
        By default this is set to $false

    .PARAMETER PasswordChangeRequired
        Specifies whether the user must reset their password or not.
        By default this is set to $false

    .PARAMETER PasswordChangeNotAllowed
        Specifies whether the user is allowed to change their password or not.
        By default this is set to $false

    .NOTES
        If Ensure is set to 'Present' then the Password parameter is required.
#>
function Set-TargetResourceOnFullSKU
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $UserName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $FullName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Password,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [System.Boolean]
        $PasswordNeverExpires,

        [Parameter()]
        [System.Boolean]
        $PasswordChangeRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordChangeNotAllowed
    )

    Set-StrictMode -Version Latest

    Write-Verbose -Message ($script:localizedData.ConfigurationStarted -f $UserName)

    Assert-UserNameValid -UserName $UserName

    $disposables = @()

    try
    {
        if ($Ensure -eq 'Present')
        {
            try
            {
                $user = Find-UserByNameOnFullSku -UserName $UserName

            }
            catch
            {
                $disposables += $user
                New-InvalidOperationException -Message ($script:localizedData.MultipleMatches + $_)
            }

            $disposables += $user

            $userExists = $false
            $saveChanges = $false

            if ($null -eq $user)
            {
                Write-Verbose -Message ($script:localizedData.UserWithName -f $UserName, $script:localizedData.AddOperation)
            }
            else
            {
                $userExists = $true
                Write-Verbose -Message ($script:localizedData.UserWithName -f $UserName, $script:localizedData.SetOperation)
            }

            if (-not $userExists)
            {
                # The user with the provided name does not exist so add a new user
                if ($PSBoundParameters.ContainsKey('Password'))
                {
                    $user = Add-UserOnFullSku -UserName $UserName -Password $Password
                }
                else
                {
                    $user = Add-UserOnFullSku -UserName $UserName
                }

                $saveChanges = $true
            }

            # Set user properties.
            if ($PSBoundParameters.ContainsKey('FullName') -and ((-not $userExists) -or ($FullName -ne $user.DisplayName)))
            {
                $user.DisplayName = $FullName
                $saveChanges = $true
            }
            elseif (-not $userExists)
            {
                <#
                    For a newly created user, set the DisplayName property to an empty string
                    since by default DisplayName is set to user's name.
                #>
                $user.DisplayName = [String]::Empty

            }

            if ($PSBoundParameters.ContainsKey('Description') -and ((-not $userExists) -or ($Description -ne $user.Description)))
            {
                $user.Description = $Description
                $saveChanges = $true
            }

            if ($PSBoundParameters.ContainsKey('Password') -and $userExists)
            {
                Set-UserPasswordOnFullSku -User $user -Password $Password
                $saveChanges = $true
            }

            if ($PSBoundParameters.ContainsKey('Disabled') -and ((-not $userExists) -or ($Disabled -eq $user.Enabled)))
            {
                $user.Enabled = -not $Disabled
                $saveChanges = $true
            }

            if ($PSBoundParameters.ContainsKey('PasswordNeverExpires') -and ((-not $userExists) -or ($PasswordNeverExpires -ne $user.PasswordNeverExpires)))
            {
                $user.PasswordNeverExpires = $PasswordNeverExpires
                $saveChanges = $true
            }

            if ($PSBoundParameters.ContainsKey('PasswordChangeRequired') -and $PasswordChangeRequired)
            {
                # Expire the password which will force the user to change the password at the next logon
                Revoke-UserPassword -User $user
                $saveChanges = $true
            }

            if ($PSBoundParameters.ContainsKey('PasswordChangeNotAllowed') -and ((-not $userExists) -or ($PasswordChangeNotAllowed -ne $user.UserCannotChangePassword)))
            {
                $user.UserCannotChangePassword = $PasswordChangeNotAllowed
                $saveChanges = $true

            }

            if ($saveChanges)
            {
                Save-UserOnFullSku -User $user

                # Send an operation success verbose message
                if ($userExists)
                {
                    Write-Verbose -Message ($script:localizedData.UserUpdated -f $UserName)
                }
                else
                {
                    Write-Verbose -Message ($script:localizedData.UserCreated -f $UserName)
                }
            }
            else
            {
                Write-Verbose -Message ($script:localizedData.NoConfigurationRequired -f $UserName)
            }
        }
        else
        {
            Remove-UserOnFullSku -UserName $UserName
        }

        Write-Verbose -Message ($script:localizedData.ConfigurationCompleted -f $UserName)
    }
    catch
    {
         New-InvalidOperationException -Message $_
    }
    finally
    {
        Remove-DisposableObject -Disposables $disposables
    }
}

<#
    .SYNOPSIS
        Tests if a user is in the desired state when on a full server.

    .PARAMETER UserName
        The name of the user to test the state of.

    .PARAMETER Ensure
        Specifies whether the user should exist or not.
        By default this is set to Present

    .PARAMETER FullName
        The full name/display name that the user should have.
        If not provided, this value will not be tested.

    .PARAMETER Description
        The description that the user should have.
        If not provided, this value will not be tested.

    .PARAMETER Password
        The password the user should have.

    .PARAMETER Disabled
        Specifies whether the user account should be disabled or not.

    .PARAMETER PasswordNeverExpires
        Specifies whether the password should ever expire or not.

    .PARAMETER PasswordChangeRequired
        Not used in Test-TargetResource as there is no easy way to test this value.

    .PARAMETER PasswordChangeNotAllowed
        Specifies whether the user should be allowed to change their password or not.
#>
function Test-TargetResourceOnFullSKU
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $UserName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $FullName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Password,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [System.Boolean]
        $PasswordNeverExpires,

        [Parameter()]
        [System.Boolean]
        $PasswordChangeRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordChangeNotAllowed
    )

    Set-StrictMode -Version Latest

    Assert-UserNameValid -UserName $UserName

    $disposables = @()

    try
    {
        $user = Find-UserByNameOnFullSku -UserName $UserName
        $disposables += $user

        $inDesiredState = $true

        if ($null -eq $user)
        {
            # A user with the provided name does not exist
            Write-Verbose -Message ($script:localizedData.UserDoesNotExist -f $UserName)

            if ($Ensure -eq 'Absent')
            {
                return $true
            }
            else
            {
                return $false
            }
        }

        # A user with the provided name exists
        Write-Verbose -Message ($script:localizedData.UserExists -f $UserName)

        # Validate separate properties
        if ($Ensure -eq 'Absent')
        {
            # The Ensure property does not match
            Write-Verbose -Message ($script:localizedData.PropertyMismatch -f 'Ensure', 'Absent', 'Present')
            $inDesiredState = $false
        }

        if ($PSBoundParameters.ContainsKey('FullName') -and $FullName -ne $user.DisplayName)
        {
            # The FullName property does not match
            Write-Verbose -Message ($script:localizedData.PropertyMismatch -f 'FullName', $FullName, $user.DisplayName)
            $inDesiredState = $false
        }

        if ($PSBoundParameters.ContainsKey('Description') -and $Description -ne $user.Description)
        {
            # The Description property does not match
            Write-Verbose -Message ($script:localizedData.PropertyMismatch -f 'Description', $Description, $user.Description)
            $inDesiredState = $false
        }

        # Password
        if ($PSBoundParameters.ContainsKey('Password'))
        {
            if (-not (Test-UserPasswordOnFullSku -UserName $UserName -Password $Password))
            {
                # The Password property does not match
                Write-Verbose -Message ($script:localizedData.PasswordPropertyMismatch -f 'Password')
                $inDesiredState = $false
            }
        }

        if ($PSBoundParameters.ContainsKey('Disabled') -and $Disabled -eq $user.Enabled)
        {
            # The Disabled property does not match
            Write-Verbose -Message ($script:localizedData.PropertyMismatch -f 'Disabled', $Disabled, $user.Enabled)
            $inDesiredState = $false
        }

        if ($PSBoundParameters.ContainsKey('PasswordNeverExpires') -and $PasswordNeverExpires -ne $user.PasswordNeverExpires)
        {
            # The PasswordNeverExpires property does not match
            Write-Verbose -Message ($script:localizedData.PropertyMismatch -f 'PasswordNeverExpires', $PasswordNeverExpires, $user.PasswordNeverExpires)
            $inDesiredState = $false
        }

        if ($PSBoundParameters.ContainsKey('PasswordChangeNotAllowed') -and $PasswordChangeNotAllowed -ne $user.UserCannotChangePassword)
        {
            # The PasswordChangeNotAllowed property does not match
            Write-Verbose -Message ($script:localizedData.PropertyMismatch -f 'PasswordChangeNotAllowed', $PasswordChangeNotAllowed, $user.UserCannotChangePassword)
            $inDesiredState = $false
        }

        if ($inDesiredState)
        {
            Write-Verbose -Message ($script:localizedData.AllUserPropertiesMatch -f 'User', $UserName)
        }

        return $inDesiredState
    }
    catch
    {
         New-InvalidOperationException -Message ($script:localizedData.MultipleMatches + $_)
    }
    finally
    {
        Remove-DisposableObject -Disposables $disposables
    }
}


<#
    .SYNOPSIS
        Retrieves the user with the given username when on Nano Server.

    .PARAMETER UserName
        The name of the user to retrieve.
#>
function Get-TargetResourceOnNanoServer
{
    [OutputType([System.Collections.Hashtable])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $UserName
    )

    Assert-UserNameValid -UserName $UserName

    $returnValue = @{}

    # Try to find a user by a name
    try
    {
        Write-Verbose -Message 'Starting Get-TargetResource on NanoServer'
        $user = Find-UserByNameOnNanoServer -UserName $UserName

        # The user is found. Return all user properties and Ensure = 'Present'.
        $returnValue = @{
            UserName = $user.Name
            Ensure = 'Present'
            FullName = $user.FullName
            Description = $user.Description
            Disabled = -not $user.Enabled
            PasswordChangeRequired = $null
            PasswordChangeNotAllowed = -not $user.UserMayChangePassword
        }

        if ($user.PasswordExpires)
        {
            $returnValue.Add('PasswordNeverExpires', $false)
        }
        else
        {
            $returnValue.Add('PasswordNeverExpires', $true)
        }
    }
    catch [System.Exception]
    {
        if ($_.FullyQualifiedErrorId -match 'UserNotFound')
        {
            # The user is not found
            $returnValue = @{
                UserName = $UserName
                Ensure = 'Absent'
            }
        }
        else
        {
            New-InvalidOperationException -ErrorRecord $_
        }
    }

    return $returnValue
}

<#
    .SYNOPSIS
        Creates, modifies, or deletes a user when on Nano Server.

    .PARAMETER UserName
        The name of the user to create, modify, or delete.

    .PARAMETER Ensure
        Specifies whether the user should exist or not.
        By default this is set to Present

    .PARAMETER FullName
        The (optional) full name or display name of the user.
        If not provided this value will remain blank.

    .PARAMETER Description
        Optional description for the user.

    .PARAMETER Password
        The desired password for the user.

    .PARAMETER Disabled
        Specifies whether the user should be disabled or not.
        By default this is set to $false

    .PARAMETER PasswordNeverExpires
        Specifies whether the password should ever expire or not.
        By default this is set to $false

    .PARAMETER PasswordChangeRequired
        Specifies whether the user must reset their password or not.
        By default this is set to $false

    .PARAMETER PasswordChangeNotAllowed
        Specifies whether the user is allowed to change their password or not.
        By default this is set to $false

    .NOTES
        If Ensure is set to 'Present' then the Password parameter is required.
#>
function Set-TargetResourceOnNanoServer
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $UserName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $FullName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Password,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [System.Boolean]
        $PasswordNeverExpires,

        [Parameter()]
        [System.Boolean]
        $PasswordChangeRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordChangeNotAllowed
    )

    Set-StrictMode -Version Latest

    Write-Verbose -Message ($script:localizedData.ConfigurationStarted -f $UserName)

    Assert-UserNameValid -UserName $UserName

    # Try to find a user by a name.
    $userExists = $false

    try
    {
        $user = Find-UserByNameOnNanoServer -UserName $UserName
        $userExists = $true
    }
    catch [System.Exception]
    {
        if ($_.FullyQualifiedErrorId -match 'UserNotFound')
        {
            # The user is not found.
            Write-Verbose -Message ($script:localizedData.UserDoesNotExist -f $UserName)
        }
        else
        {
            New-InvalidOperationException -ErrorRecord $_
        }
    }

    if ($Ensure -eq 'Present')
    {
        # Ensure is set to 'Present'

        if (-not $userExists)
        {
            # The user with the provided name does not exist so add a new user
            New-LocalUser -Name $UserName -NoPassword
            Write-Verbose -Message ($script:localizedData.UserCreated -f $UserName)
        }

        # Set user properties
        if ($PSBoundParameters.ContainsKey('FullName'))
        {
            if (-not $userExists -or $FullName -ne $user.FullName)
            {
                    Set-LocalUser -Name $UserName -FullName $FullName
            }
        }
        elseif (-not $userExists)
        {
            # For a newly created user, set the DisplayName property to an empty string since by default DisplayName is set to user's name.
            Set-LocalUser -Name $UserName -FullName ([String]::Empty)
        }

        if ($PSBoundParameters.ContainsKey('Description') -and ((-not $userExists) -or ($Description -ne $user.Description)))
        {
                Set-LocalUser -Name $UserName -Description $Description
        }

        # Set the password regardless of the state of the user
        if ($PSBoundParameters.ContainsKey('Password'))
        {
            Set-LocalUser -Name $UserName -Password $Password.Password
        }

        if ($PSBoundParameters.ContainsKey('Disabled') -and ((-not $userExists) -or ($Disabled -eq $user.Enabled)))
        {
            if ($Disabled)
            {
                Disable-LocalUser -Name $UserName
            }
            else
            {
                Enable-LocalUser -Name $UserName
            }
        }

        $existingUserPasswordNeverExpires = (($userExists) -and ($null -eq $user.PasswordExpires))
        if ($PSBoundParameters.ContainsKey('PasswordNeverExpires') -and ((-not $userExists) -or ($PasswordNeverExpires -ne $existingUserPasswordNeverExpires)))
        {
            Set-LocalUser -Name $UserName -PasswordNeverExpires:$passwordNeverExpires
        }

        # Only set the AccountExpires attribute if PasswordChangeRequired is set to true
        if ($PSBoundParameters.ContainsKey('PasswordChangeRequired') -and ($PasswordChangeRequired))
        {
            Set-LocalUser -Name $UserName -AccountExpires ([DateTime]::Now)
        }

        # NOTE: The parameter name and the property name have opposite meaning.
        $expected = (-not $PasswordChangeNotAllowed)
        $actual = $expected

        if ($userExists)
        {
            $actual = $user.UserMayChangePassword
        }

        if ($PSBoundParameters.ContainsKey('PasswordChangeNotAllowed') -and ((-not $userExists) -or ($expected -ne $actual)))
        {
            Set-LocalUser -Name $UserName -UserMayChangePassword $expected
        }
    }
    else
    {
        # Ensure is set to 'Absent'
        if ($userExists)
        {
            # The user exists
            Remove-LocalUser -Name $UserName

            Write-Verbose -Message ($script:localizedData.UserRemoved -f $UserName)
        }
        else
        {
            Write-Verbose -Message ($script:localizedData.NoConfigurationRequiredUserDoesNotExist -f $UserName)
        }
    }

    Write-Verbose -Message ($script:localizedData.ConfigurationCompleted -f $UserName)
}

<#
    .SYNOPSIS
        Tests if a user is in the desired state when on Nano Server.

    .PARAMETER UserName
        The name of the user to test the state of.

    .PARAMETER Ensure
        Specifies whether the user should exist or not.
        By default this is set to Present

    .PARAMETER FullName
        The full name/display name that the user should have.
        If not provided, this value will not be tested.

    .PARAMETER Description
        The description that the user should have.
        If not provided, this value will not be tested.

    .PARAMETER Password
        The password the user should have.

    .PARAMETER Disabled
        Specifies whether the user account should be disabled or not.

    .PARAMETER PasswordNeverExpires
        Specifies whether the password should ever expire or not.

    .PARAMETER PasswordChangeRequired
        Not used in Test-TargetResource as there is no easy way to test this value.

    .PARAMETER PasswordChangeNotAllowed
        Specifies whether the user should be allowed to change their password or not.
#>
function Test-TargetResourceOnNanoServer
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $UserName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $FullName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Password,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [System.Boolean]
        $PasswordNeverExpires,

        [Parameter()]
        [System.Boolean]
        $PasswordChangeRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordChangeNotAllowed
    )

    Assert-UserNameValid -UserName $UserName

    # Try to find a user by a name
    try
    {
        $user = Find-UserByNameOnNanoServer -UserName $UserName
    }
    catch [System.Exception]
    {
        if ($_.FullyQualifiedErrorId -match 'UserNotFound')
        {
            # The user is not found
            return ($Ensure -eq 'Absent')
        }
        else
        {
            New-InvalidOperationException -ErrorRecord $_
        }
    }

    # A user with the provided name exists
    Write-Verbose -Message ($script:localizedData.UserExists -f $UserName)

    # Validate separate properties
    if ($Ensure -eq 'Absent')
    {
        # The Ensure property does not match
        Write-Verbose -Message ($script:localizedData.PropertyMismatch -f 'Ensure', 'Absent', 'Present')
        return $false
    }

    if ($PSBoundParameters.ContainsKey('FullName') -and $FullName -ne $user.FullName)
    {
        # The FullName property does not match
        Write-Verbose -Message ($script:localizedData.PropertyMismatch -f 'FullName', $FullName, $user.FullName)
        return $false
    }

    if ($PSBoundParameters.ContainsKey('Description') -and $Description -ne $user.Description)
    {
        # The Description property does not match
        Write-Verbose -Message ($script:localizedData.PropertyMismatch -f 'Description', $Description, $user.Description)
        return $false
    }

    if ($PSBoundParameters.ContainsKey('Password'))
    {
        if(-not (Test-CredentialsValidOnNanoServer -UserName $UserName -Password $Password.Password))
        {
            # The Password property does not match
            Write-Verbose -Message ($script:localizedData.PasswordPropertyMismatch -f 'Password')
            return $false
        }
    }

    if ($PSBoundParameters.ContainsKey('Disabled') -and ($Disabled -eq $user.Enabled))
    {
        # The Disabled property does not match
        Write-Verbose -Message ($script:localizedData.PropertyMismatch -f 'Disabled', $Disabled, $user.Enabled)
        return $false
    }

    $existingUserPasswordNeverExpires = ($null -eq $user.PasswordExpires)
    if ($PSBoundParameters.ContainsKey('PasswordNeverExpires') -and $PasswordNeverExpires -ne $existingUserPasswordNeverExpires)
    {
        # The PasswordNeverExpires property does not match
        Write-Verbose -Message ($script:localizedData.PropertyMismatch -f 'PasswordNeverExpires', $PasswordNeverExpires, $existingUserPasswordNeverExpires)
        return $false
    }

    if ($PSBoundParameters.ContainsKey('PasswordChangeNotAllowed') -and $PasswordChangeNotAllowed -ne (-not $user.UserMayChangePassword))
    {
        # The PasswordChangeNotAllowed property does not match
        Write-Verbose -Message ($script:localizedData.PropertyMismatch -f 'PasswordChangeNotAllowed', $PasswordChangeNotAllowed, (-not $user.UserMayChangePassword))
        return $false
    }

    # All properties match. Return $true.
    Write-Verbose -Message ($script:localizedData.AllUserPropertiesMatch -f 'User', $UserName)
    return $true
}

<#
    .SYNOPSIS
        Checks that the username does not contain invalid characters.

    .PARAMETER UserName
        The username to validate.
#>
function Assert-UserNameValid
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $UserName
    )

    # Check if the name consists of only periods and/or white spaces
    $wrongName = $true

    for ($i = 0; $i -lt $UserName.Length; $i++)
    {
        if (-not [System.Char]::IsWhiteSpace($UserName, $i) -and $UserName[$i] -ne '.')
        {
            $wrongName = $false
            break
        }
    }

    $invalidChars = @('\', '/', '"', '[', ']', ':', '|', '<', '>', '+', '=', ';', ',', '?', '*', '@')

    if ($wrongName)
    {
        New-InvalidArgumentException `
            -Message ($script:localizedData.InvalidUserName -f $UserName, [System.String]::Join(' ', $invalidChars)) `
            -ArgumentName 'UserName'
    }

    if ($UserName.IndexOfAny($invalidChars) -ne -1)
    {
        New-InvalidArgumentException `
            -Message ($script:localizedData.InvalidUserName -f $UserName, [System.String]::Join(' ', $invalidChars)) `
            -ArgumentName 'UserName'
    }
}

<#
    .SYNOPSIS
        Tests the local user's credentials on the local machine.

    .PARAMETER UserName
        The username to validate the credentials of.

    .PARAMETER Password
        The password of the given user.
#>
function Test-CredentialsValidOnNanoServer
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $UserName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Security.SecureString]
        $Password
    )

    $source = @'
        [Flags]
        private enum LogonType
        {
            Logon32LogonInteractive = 2,
            Logon32LogonNetwork,
            Logon32LogonBatch,
            Logon32LogonService,
            Logon32LogonUnlock,
            Logon32LogonNetworkCleartext,
            Logon32LogonNewCredentials
        }

        [Flags]
        private enum LogonProvider
        {
            Logon32ProviderDefault = 0,
            Logon32ProviderWinnt35,
            Logon32ProviderWinnt40,
            Logon32ProviderWinnt50
        }

        [DllImport("api-ms-win-security-logon-l1-1-1.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        private static extern Boolean LogonUser(
            String lpszUserName,
            String lpszDomain,
            IntPtr lpszPassword,
            LogonType dwLogonType,
            LogonProvider dwLogonProvider,
            out IntPtr phToken
            );


        [DllImport("api-ms-win-core-handle-l1-1-0.dll",
            EntryPoint = "CloseHandle", SetLastError = true,
            CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        internal static extern bool CloseHandle(IntPtr handle);

        public static bool ValidateCredentials(string username, SecureString password)
        {
            IntPtr tokenHandle = IntPtr.Zero;
            IntPtr unmanagedPassword = IntPtr.Zero;

            unmanagedPassword = SecureStringMarshal.SecureStringToCoTaskMemUnicode(password);

            try
            {
                return LogonUser(
                    username,
                    null,
                    unmanagedPassword,
                    LogonType.Logon32LogonInteractive,
                    LogonProvider.Logon32ProviderDefault,
                    out tokenHandle);
            }
            catch
            {
                return false;
            }
            finally
            {
                if (tokenHandle != IntPtr.Zero)
                {
                    CloseHandle(tokenHandle);
                }
                if (unmanagedPassword != IntPtr.Zero) {
                    Marshal.ZeroFreeCoTaskMemUnicode(unmanagedPassword);
                }
                unmanagedPassword = IntPtr.Zero;
            }
        }
'@

    Add-Type -PassThru -Namespace Microsoft.Windows.DesiredStateConfiguration.NanoServer.UserResource `
        -Name CredentialsValidationTool -MemberDefinition $source -Using System.Security -ReferencedAssemblies System.Security.SecureString.dll | Out-Null
    return [Microsoft.Windows.DesiredStateConfiguration.NanoServer.UserResource.CredentialsValidationTool]::ValidateCredentials($UserName, $Password)
}

<#
    .SYNOPSIS
        Queries a user by the given username. If found the function returns a UserPrincipal object.
        Otherwise, the function returns $null.

    .PARAMETER UserName
        The username to search for.
#>
function Find-UserByNameOnFullSku
{
    [OutputType([System.DirectoryServices.AccountManagement.UserPrincipal])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserName
    )

    $principalContext = New-Object `
                -TypeName System.DirectoryServices.AccountManagement.PrincipalContext `
                -ArgumentList ([System.DirectoryServices.AccountManagement.ContextType]::Machine)

    $user = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($principalContext, $UserName)

    return $user
}

<#
    .SYNOPSIS
        Adds a user with the given username and returns the new user object

    .PARAMETER UserName
        The username for the new user
#>
function Add-UserOnFullSku
{
    [OutputType([System.DirectoryServices.AccountManagement.UserPrincipal])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Password
    )

    $principalContext = New-Object `
                -TypeName 'System.DirectoryServices.AccountManagement.PrincipalContext' `
                -ArgumentList @( [System.DirectoryServices.AccountManagement.ContextType]::Machine )

    $user = New-Object -TypeName 'System.DirectoryServices.AccountManagement.UserPrincipal' `
                       -ArgumentList @( $principalContext )
    $user.Name = $UserName

    if ($PSBoundParameters.ContainsKey('Password'))
    {
        $user.SetPassword($Password.GetNetworkCredential().Password)
    }

    return $user
}

<#
    .SYNOPSIS
        Sets the password for the given user

    .PARAMETER User
        The user to set the password for

    .PARAMETER Password
        The credential to use for the user's password
#>
function Set-UserPasswordOnFullSku
{
    [OutputType([System.DirectoryServices.AccountManagement.UserPrincipal])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.DirectoryServices.AccountManagement.UserPrincipal]
        $User,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Password
    )

    $User.SetPassword($Password.GetNetworkCredential().Password)
}

<#
    .SYNOPSIS
        Validates the password is correct for the given user. Returns $true if the
        Password is correct for the given username, false otherwise.

    .PARAMETER UserName
        The UserName to check

    .PARAMETER Password
        The credential to check
#>
function Test-UserPasswordOnFullSku
{
    [OutputType([Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Password
    )

    $principalContext = New-Object `
                -TypeName 'System.DirectoryServices.AccountManagement.PrincipalContext' `
                -ArgumentList @( [System.DirectoryServices.AccountManagement.ContextType]::Machine )
    try
    {
        $credentailsValid = $principalContext.ValidateCredentials($UserName, $Password.GetNetworkCredential().Password)
        return $credentailsValid
    }
    finally
    {
        $principalContext.Dispose()
    }
}


<#
    .SYNOPSIS
        Queries a user by the given username. If found the function returns a UserPrincipal object.
        Otherwise, the function returns $null.

    .PARAMETER UserName
        The username to search for.
#>
function Remove-UserOnFullSku
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserName
    )

    $user = Find-UserByNameOnFullSku -Username $UserName

    if ($null -ne $user)
    {
        try
        {
            Write-Verbose -Message ($script:localizedData.UserWithName -f $UserName, $script:localizedData.RemoveOperation)
            $user.Delete()
            Write-Verbose -Message ($script:localizedData.UserRemoved -f $UserName)
        }
        finally
        {
            $user.Dispose()
        }
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.NoConfigurationRequiredUserDoesNotExist -f $UserName)
    }
}

<#
    .SYNOPSIS
        Saves changes for the given user on a machine.

    .PARAMETER User
        The user to save the changes of
#>
function Save-UserOnFullSku
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.DirectoryServices.AccountManagement.UserPrincipal]
        $User
    )

    $User.Save()
}

<#
    .SYNOPSIS
        Expires the password of the given user.

    .PARAMETER User
        The user to expire the password of.
#>
function Revoke-UserPassword
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.DirectoryServices.AccountManagement.UserPrincipal]
        $User
    )

    $User.ExpirePasswordNow()
}

<#
    .SYNOPSIS
        Queries a user by the given username. If found the function returns a LocalUser object.
        Otherwise, the function throws an error that the user was not found.

    .PARAMETER UserName
        The username to search for.
#>
function Find-UserByNameOnNanoServer
{
    #[OutputType([Microsoft.PowerShell.Commands.LocalUser])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserName
    )

    return Get-LocalUser -Name $UserName -ErrorAction Stop
}

<#
    .SYNOPSIS
        Disposes of the contents of an array list containing IDisposable objects.

    .PARAMETER Disosables
        The array list of IDisposable Objects to dispose of.
#>
function Remove-DisposableObject
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.Collections.ArrayList]
        [AllowEmptyCollection()]
        $Disposables
    )

    if ($null -ne $Disposables)
    {
        foreach ($disposable in $Disposables)
        {
            if ($disposable -is [System.IDisposable])
            {
                $disposable.Dispose()
            }
        }
    }
}

Export-ModuleMember -Function *-TargetResource
