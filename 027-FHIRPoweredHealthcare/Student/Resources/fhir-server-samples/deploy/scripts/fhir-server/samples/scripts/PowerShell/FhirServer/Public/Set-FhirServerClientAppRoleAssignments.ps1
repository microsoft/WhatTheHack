function Set-FhirServerClientAppRoleAssignments {
    <#
    .SYNOPSIS
    Set app role assignments for the given client application
    .DESCRIPTION
    Set AppRoles for a given client application. Requires Azure AD admin privileges.
    .EXAMPLE
    Set-FhirServerClientAppRoleAssignments -AppId <Client App Id> -ApiAppId <Resource Api Id> -AppRoles globalReader,globalExporter
    .PARAMETER AppId
    The AppId of the of the client application
    .PARAMETER ApiAppId
    The objectId of the API application that has roles that need to be assigned
    .PARAMETER AppRoles
    The collection of roles from the testauthenvironment.json for the client application
    #>
    param(
        [Parameter(Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$AppId,

        [Parameter(Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$ApiAppId,

        [Parameter(Mandatory = $true )]
        [AllowEmptyCollection()]
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

    # Get the collection of roles for the user
    $apiApplication = Get-AzureAdServicePrincipal -Filter "appId eq '$ApiAppId'"
    $aadClientServicePrincipal = Get-AzureAdServicePrincipal -Filter "appId eq '$AppId'"
    $ObjectId = $aadClientServicePrincipal.ObjectId

    $existingRoleAssignments = Get-AzureADServiceAppRoleAssignment -ObjectId $apiApplication.ObjectId | Where-Object {$_.PrincipalId -eq $ObjectId} 

    $expectedRoles = New-Object System.Collections.ArrayList
    $rolesToAdd = New-Object System.Collections.ArrayList
    $rolesToRemove = New-Object System.Collections.ArrayList

    foreach ($role in $AppRoles) {
        $expectedRoles += @($apiApplication.AppRoles | Where-Object { $_.Value -eq $role })
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
        # This is known to report failure in certain scenarios, but will actually apply the permissions
        try {
            New-AzureADServiceAppRoleAssignment -ObjectId $ObjectId -PrincipalId $ObjectId -ResourceId $apiApplication.ObjectId -Id $role | Out-Null
        }
        catch {
            #The role may have been assigned. Check:
            $roleAssigned = Get-AzureADServiceAppRoleAssignment -ObjectId $apiApplication.ObjectId | Where-Object {$_.PrincipalId -eq $ObjectId -and $_.Id -eq $role}
            if (!$roleAssigned) {
                throw "Failure adding app role assignment for service principal."
            }
        }
    }

    foreach ($role in $rolesToRemove) {
        Remove-AzureADServiceAppRoleAssignment -ObjectId $ObjectId -AppRoleAssignmentId ($existingRoleAssignments | Where-Object { $_.Id -eq $role }).ObjectId | Out-Null
    }

    $finalRolesAssignments = Get-AzureADServiceAppRoleAssignment -ObjectId $apiApplication.ObjectId | Where-Object {$_.PrincipalId -eq $ObjectId} 
    $rolesNotAdded = $()
    $rolesNotRemoved = $()
    foreach ($diff in Compare-Object -ReferenceObject @($expectedRoles | Select-Object) -DifferenceObject @($finalRolesAssignments | Select-Object) -Property "Id") {
        switch ($diff.SideIndicator) {
            "<=" {
                $rolesNotAdded += $diff.Id
            }
            "=>" {
                $rolesNotRemoved += $diff.Id
            }
        }
    }

    if($rolesNotAdded -or $rolesNotRemoved) {
        if($rolesNotAdded) {
            Write-Host "The following roles were not added: $rolesNotAdded"
        }
    
        if($rolesNotRemoved) {
            Write-Host "The following roles were not removed: $rolesNotRemoved"
        }
    }
}