$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_WaitForADDomain'

# This file is used to remember the number of times the node has been rebooted.
$script:restartLogFile = Join-Path $env:temp -ChildPath 'WaitForADDomain_Reboot.tmp'

# This scriptblock is ran inside the background job.
$script:waitForDomainControllerScriptBlock = {
    param
    (
        # Only used for unit tests, and debug purpose.
        [Parameter()]
        [System.Boolean]
        $RunOnce,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [Parameter()]
        [System.String]
        $SiteName,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.Boolean]
        $WaitForValidCredentials
    )

    $domainFound = $false

    do
    {
        Import-Module ActiveDirectoryDsc

        $findDomainControllerParameters = @{
            DomainName = $DomainName
        }

        if ($SiteName)
        {
            $findDomainControllerParameters['SiteName'] = $SiteName

        }

        if ($null -ne $Credential)
        {
            $findDomainControllerParameters['Credential'] = $Credential
        }

        if ($PSBoundParameters.ContainsKey('WaitForValidCredentials'))
        {
            $findDomainControllerParameters['WaitForValidCredentials'] = $WaitForValidCredentials
        }

        $currentDomainController = $null

        # Using verbose so that Receive-Job can output whats happened.
        $currentDomainController = Find-DomainController @findDomainControllerParameters -Verbose

        if ($currentDomainController)
        {
            $domainFound = $true
        }
        else
        {
            $domainFound = $false

            # Using verbose so that Receive-Job can output whats happened.
            Clear-DnsClientCache -Verbose

            Start-Sleep -Seconds 10
        }
    } until ($domainFound -or $RunOnce)
}

<#
    .SYNOPSIS
        Returns the current state of the specified Active Directory domain.

    .PARAMETER DomainName
        Specifies the fully qualified domain name to wait for.

    .PARAMETER SiteName
        Specifies the site in the domain where to look for a domain controller.

    .PARAMETER Credential
        Specifies the credentials that are used when accessing the domain,
        unless the built-in PsDscRunAsCredential is used.

    .PARAMETER WaitTimeout
        Specifies the timeout in seconds that the resource will wait for the
        domain to be accessible. Default value is 300 seconds.

    .PARAMETER RestartCount
        Specifies the number of times the node will be reboot in an effort to
        connect to the domain.

    .PARAMETER WaitForValidCredentials
        Specifies that the resource will not throw an error if authentication
        fails using the provided credentials and continue wait for the timeout.
        This can be used if the credentials are known to eventually exist but
        there are a potential timing issue before they are accessible.
#>
function Get-TargetResource
{
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [Parameter()]
        [System.String]
        $SiteName,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.UInt64]
        $WaitTimeout = 300,

        [Parameter()]
        [System.UInt32]
        $RestartCount,

        [Parameter()]
        [System.Boolean]
        $WaitForValidCredentials
    )

    $findDomainControllerParameters = @{
        DomainName = $DomainName
    }

    Write-Verbose -Message (
        $script:localizedData.SearchDomainController -f $DomainName
    )

    if ($PSBoundParameters.ContainsKey('SiteName'))
    {
        $findDomainControllerParameters['SiteName'] = $SiteName

        Write-Verbose -Message (
            $script:localizedData.SearchInSiteOnly -f $SiteName
        )
    }

    if ($PSBoundParameters.ContainsKey('Credential'))
    {
        $cimCredentialInstance = New-CimCredentialInstance -Credential $Credential

        $findDomainControllerParameters['Credential'] = $Credential

        Write-Verbose -Message (
            $script:localizedData.ImpersonatingCredentials -f $Credential.UserName
        )
    }
    else
    {
        if ($null -ne $PsDscContext.RunAsUser)
        {
            # Running using PsDscRunAsCredential
            Write-Verbose -Message (
                $script:localizedData.ImpersonatingCredentials -f $PsDscContext.RunAsUser
            )
        }
        else
        {
            # Running as SYSTEM or current user.
            Write-Verbose -Message (
                $script:localizedData.ImpersonatingCredentials -f (Get-CurrentUser).Name
            )
        }

        $cimCredentialInstance = $null
    }

    $currentDomainController = $null

    if ($PSBoundParameters.ContainsKey('WaitForValidCredentials'))
    {
        $findDomainControllerParameters['WaitForValidCredentials'] = $WaitForValidCredentials
    }

    $currentDomainController = Find-DomainController @findDomainControllerParameters

    if ($currentDomainController)
    {
        $domainFound = $true
        $domainControllerSiteName = $currentDomainController.SiteName

        Write-Verbose -Message $script:localizedData.FoundDomainController

    }
    else
    {
        $domainFound = $false
        $domainControllerSiteName = $null

        Write-Verbose -Message $script:localizedData.NoDomainController
    }

    return @{
        DomainName              = $DomainName
        SiteName                = $domainControllerSiteName
        Credential              = $cimCredentialInstance
        WaitTimeout             = $WaitTimeout
        RestartCount            = $RestartCount
        IsAvailable             = $domainFound
        WaitForValidCredentials = $WaitForValidCredentials
    }
}

<#
    .SYNOPSIS
        Waits for the specified Active Directory domain to have a domain
        controller that can serve connections.

    .PARAMETER DomainName
        Specifies the fully qualified domain name to wait for.

    .PARAMETER SiteName
        Specifies the site in the domain where to look for a domain controller.

    .PARAMETER Credential
        Specifies the credentials that are used when accessing the domain,
        unless the built-in PsDscRunAsCredential is used.

    .PARAMETER WaitTimeout
        Specifies the timeout in seconds that the resource will wait for the
        domain to be accessible. Default value is 300 seconds.

    .PARAMETER RestartCount
        Specifies the number of times the node will be reboot in an effort to
        connect to the domain.

    .PARAMETER WaitForValidCredentials
        Specifies that the resource will not throw an error if authentication
        fails using the provided credentials and continue wait for the timeout.
        This can be used if the credentials are known to eventually exist but
        there are a potential timing issue before they are accessible.
#>
function Set-TargetResource
{
    <#
        Suppressing this rule because $global:DSCMachineStatus is used to trigger
        a reboot if the domain name cannot be found withing the timeout period.
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

        [Parameter()]
        [System.String]
        $SiteName,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.UInt64]
        $WaitTimeout = 300,

        [Parameter()]
        [System.UInt32]
        $RestartCount,

        [Parameter()]
        [System.Boolean]
        $WaitForValidCredentials
    )

    Write-Verbose -Message (
        $script:localizedData.WaitingForDomain -f $DomainName, $WaitTimeout
    )

    # Only pass properties that could be used when fetching the domain controller.
    $compareTargetResourceStateParameters = @{
        DomainName              = $DomainName
        SiteName                = $SiteName
        Credential              = $Credential
        WaitForValidCredentials = $WaitForValidCredentials
    }

    <#
        Removes any keys not bound to $PSBoundParameters.
        Need the @() around this to get a new array to enumerate.
    #>
    @($compareTargetResourceStateParameters.Keys) | ForEach-Object {
        if (-not $PSBoundParameters.ContainsKey($_))
        {
            $compareTargetResourceStateParameters.Remove($_)
        }
    }

    <#
        This returns array of hashtables which contain the properties ParameterName,
        Expected, Actual, and InDesiredState. In this case only the property
        'IsAvailable' will be returned.
    #>
    $compareTargetResourceStateResult = Compare-TargetResourceState @compareTargetResourceStateParameters

    $isInDesiredState = $compareTargetResourceStateResult.Where({ $_.ParameterName -eq 'IsAvailable' }).InDesiredState

    if (-not $isInDesiredState)
    {
        $startJobParameters = @{
            ScriptBlock  = $script:waitForDomainControllerScriptBlock
            ArgumentList = @(
                $false
                $DomainName
                $SiteName
                $Credential
                $WaitForValidCredentials
            )
        }

        Write-Verbose -Message $script:localizedData.StartBackgroundJob

        $jobSearchDomainController = Start-Job @startJobParameters

        Write-Verbose -Message $script:localizedData.WaitBackgroundJob

        $waitJobResult = Wait-Job -Job $jobSearchDomainController -Timeout $WaitTimeout

        # Wait-Job returns an object if the job completed or failed within the timeout.
        if ($waitJobResult)
        {
            Write-Verbose -Message $script:localizedData.BackgroundJobFinished
            switch ($waitJobResult.State)
            {
                'Failed'
                {
                    Write-Warning -Message $script:localizedData.BackgroundJobFailed
                }

                'Completed'
                {
                    Write-Verbose -Message $script:localizedData.BackgroundJobSuccessful

                    if ($PSBoundParameters.ContainsKey('RestartCount'))
                    {
                        Remove-RestartLogFile
                    }

                    $foundDomainController = $true
                }
            }
        }
        else
        {
            Write-Warning -Message $script:localizedData.TimeoutReached

            if ($PSBoundParameters.ContainsKey('RestartCount'))
            {
                # if the file does not exist this will set $currentRestartCount to 0.
                [System.UInt32] $currentRestartCount = Get-Content $restartLogFile -ErrorAction SilentlyContinue

                if ($currentRestartCount -lt $RestartCount)
                {
                    $currentRestartCount += 1

                    Set-Content -Path $restartLogFile -Value $currentRestartCount

                    Write-Verbose -Message (
                        $script:localizedData.RestartWasRequested -f $currentRestartCount, $RestartCount
                    )

                    $global:DSCMachineStatus = 1
                }
            }

            # The timeout was reached and no restarts was requested.
            $foundDomainController = $false
        }

        # Only output the result from the running job if Verbose was chosen.
        if ($PSBoundParameters.ContainsKey('Verbose') -or $waitJobResult.State -eq 'Failed')
        {
            Write-Verbose -Message $script:localizedData.StartOutputBackgroundJob

            Receive-Job -Job $jobSearchDomainController

            Write-Verbose -Message $script:localizedData.EndOutputBackgroundJob
        }

        Write-Verbose -Message $script:localizedData.RemoveBackgroundJob

        # Forcedly remove the job even if it was not completed.
        Remove-Job -Job $jobSearchDomainController -Force
    }
    else
    {
        $foundDomainController = $true
    }

    if ($foundDomainController)
    {
        Write-Verbose -Message ($script:localizedData.DomainInDesiredState -f $DomainName)
    }
    else
    {
        throw $script:localizedData.NoDomainController
    }
}

<#
    .SYNOPSIS
        Determines if the specified Active Directory domain have a domain controller
        that can serve connections.

    .PARAMETER DomainName
        Specifies the fully qualified domain name to wait for.

    .PARAMETER SiteName
        Specifies the site in the domain where to look for a domain controller.

    .PARAMETER Credential
        Specifies the credentials that are used when accessing the domain,
        unless the built-in PsDscRunAsCredential is used.

    .PARAMETER WaitTimeout
        Specifies the timeout in seconds that the resource will wait for the
        domain to be accessible. Default value is 300 seconds.

    .PARAMETER RestartCount
        Specifies the number of times the node will be reboot in an effort to
        connect to the domain.

    .PARAMETER WaitForValidCredentials
        Specifies that the resource will not throw an error if authentication
        fails using the provided credentials and continue wait for the timeout.
        This can be used if the credentials are known to eventually exist but
        there are a potential timing issue before they are accessible.
#>
function Test-TargetResource
{
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [Parameter()]
        [System.String]
        $SiteName,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.UInt64]
        $WaitTimeout = 300,

        [Parameter()]
        [System.UInt32]
        $RestartCount,

        [Parameter()]
        [System.Boolean]
        $WaitForValidCredentials
    )

    Write-Verbose -Message (
        $script:localizedData.TestConfiguration -f $DomainName
    )

    # Only pass properties that could be used when fetching the domain controller.
    $compareTargetResourceStateParameters = @{
        DomainName              = $DomainName
        SiteName                = $SiteName
        Credential              = $Credential
        WaitForValidCredentials = $WaitForValidCredentials
    }

    <#
        Removes any keys not bound to $PSBoundParameters.
        Need the @() around this to get a new array to enumerate.
    #>
    @($compareTargetResourceStateParameters.Keys) | ForEach-Object {
        if (-not $PSBoundParameters.ContainsKey($_))
        {
            $compareTargetResourceStateParameters.Remove($_)
        }
    }

    <#
        This returns array of hashtables which contain the properties ParameterName,
        Expected, Actual, and InDesiredState. In this case only the property
        'IsAvailable' will be returned.
    #>
    $compareTargetResourceStateResult = Compare-TargetResourceState @compareTargetResourceStateParameters

    if ($false -in $compareTargetResourceStateResult.InDesiredState)
    {
        $testTargetResourceReturnValue = $false

        Write-Verbose -Message (
            $script:localizedData.DomainNotInDesiredState -f $DomainName
        )
    }
    else
    {
        $testTargetResourceReturnValue = $true

        if ($PSBoundParameters.ContainsKey('RestartCount') -and $RestartCount -gt 0 )
        {
            Remove-RestartLogFile
        }

        Write-Verbose -Message (
            $script:localizedData.DomainInDesiredState -f $DomainName
        )
    }

    return $testTargetResourceReturnValue
}

<#
    .SYNOPSIS
        Compares the properties in the current state with the properties of the
        desired state and returns a hashtable with the comparison result.

    .PARAMETER DomainName
        Specifies the fully qualified domain name to wait for.

    .PARAMETER SiteName
        Specifies the site in the domain where to look for a domain controller.

    .PARAMETER Credential
        Specifies the credentials that are used when accessing the domain,
        unless the built-in PsDscRunAsCredential is used.

    .PARAMETER WaitForValidCredentials
        Specifies that the resource will not throw an error if authentication
        fails using the provided credentials and continue wait for the timeout.
        This can be used if the credentials are known to eventually exist but
        there are a potential timing issue before they are accessible.
#>
function Compare-TargetResourceState
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [Parameter()]
        [System.String]
        $SiteName,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.Boolean]
        $WaitForValidCredentials
    )

    $getTargetResourceParameters = @{
        DomainName              = $DomainName
        SiteName                = $SiteName
        Credential              = $Credential
        WaitForValidCredentials = $WaitForValidCredentials
    }

    <#
        Removes any keys not bound to $PSBoundParameters.
        Need the @() around this to get a new array to enumerate.
    #>
    @($getTargetResourceParameters.Keys) | ForEach-Object {
        if (-not $PSBoundParameters.ContainsKey($_))
        {
            $getTargetResourceParameters.Remove($_)
        }
    }

    $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

    <#
        Only interested in the read-only property IsAvailable, which
        should always be compared to the value $true.
    #>
    $compareResourcePropertyStateParameters = @{
        CurrentValues = $getTargetResourceResult
        DesiredValues = @{
            IsAvailable = $true
        }
        Properties    = 'IsAvailable'
    }

    return Compare-ResourcePropertyState @compareResourcePropertyStateParameters
}

function Remove-RestartLogFile
{
    [CmdletBinding()]
    param ()

    if (Test-Path -Path $script:restartLogFile)
    {
        Remove-Item $script:restartLogFile -Force -ErrorAction SilentlyContinue
    }
}
