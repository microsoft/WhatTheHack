function Set-FhirServerUserAppRoleAssignments {
    <#
    .SYNOPSIS
    Set app role assignments for a user
    .DESCRIPTION
    Set AppRoles for a given user. Requires Azure AD admin privileges.
    .EXAMPLE
    Set-FhirServerUserAppRoleAssignments -UserPrincipalName <User Principal Name> -ApiAppId <Resource Api Id> -AppRoles globalReader,globalExporter
    .PARAMETER UserPrincipalName
    The user principal name (e.g. myalias@contoso.com) of the of the user
    .PARAMETER ApiAppId
    The AppId of the API application that has roles that need to be assigned
    .PARAMETER AppRoles
    The array of roles for the client application
    #>
    param(
        [Parameter(Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName,

        [Parameter(Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$ApiAppId,

        [Parameter(Mandatory = $true )]
        [ValidateNotNull()]
        [string[]]$AppRoles
    )

    Set-StrictMode -Version Latest

    # Get current AzureAd context
    try {
        Get-AzureADCurrentSessionInfo -ErrorAction Stop | Out-Null
    } 
    catch {
        throw "Please log in to Azure AD with Connect-AzureAD cmdlet before proceeding"
    }

    $aadUser = Get-AzureADUser -Filter "UserPrincipalName eq '$UserPrincipalName'"
    if (!$aadUser)
    {
        throw "User not found"
    }

    $servicePrincipal = Get-AzureAdServicePrincipal -Filter "appId eq '$ApiAppId'"

    # Get the collection of roles for the user
    $existingRoleAssignments = Get-AzureADUserAppRoleAssignment -ObjectId $aadUser.ObjectId | Where-Object {$_.ResourceId -eq $servicePrincipal.ObjectId}

    $expectedRoles = New-Object System.Collections.ArrayList
    $rolesToAdd = New-Object System.Collections.ArrayList
    $rolesToRemove = New-Object System.Collections.ArrayList

    foreach ($role in $AppRoles) {
        $expectedRoles += @($servicePrincipal.AppRoles | Where-Object { $_.Value -eq $role })
    }

    foreach ($diff in Compare-Object -ReferenceObject @($expectedRoles | Select-Object) -DifferenceObject @($existingRoleAssignments | Select-Object) -Property "Id") {
        switch ($diff.SideIndicator) {
            "<=" {
                $rolesToAdd += $diff.Id
            }
            "=>" {
                $rolesToRemove += $diff.Id
            }
        }
    }

    foreach ($role in $rolesToAdd) {
        New-AzureADUserAppRoleAssignment -ObjectId $aadUser.ObjectId -PrincipalId $aadUser.ObjectId -ResourceId $servicePrincipal.ObjectId -Id $role | Out-Null
    }

    foreach ($role in $rolesToRemove) {
        Remove-AzureADUserAppRoleAssignment -ObjectId $aadUser.ObjectId -AppRoleAssignmentId ($existingRoleAssignments | Where-Object { $_.Id -eq $role }).ObjectId | Out-Null
    }
}