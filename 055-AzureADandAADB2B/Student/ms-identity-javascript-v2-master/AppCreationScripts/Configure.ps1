[CmdletBinding()]
param(
    [Parameter(Mandatory = $True, HelpMessage = 'Tenant ID (This is a GUID which represents the "Directory ID" of the AzureAD tenant into which you want to create the apps')]
    [string] $TenantId
)

#Requires -Modules Microsoft.Graph.Applications

# Pre-requisites
if ($null -eq (Get-Module -ListAvailable -Name "Microsoft.Graph.Applications")) {
    Install-Module "Microsoft.Graph.Applications" -Scope CurrentUser 
}

Import-Module Microsoft.Graph.Applications

Set-Content -Value "<html><body><table>" -Path createdApps.html
Add-Content -Value "<thead><tr><th>Application</th><th>AppId</th><th>Url in the Azure portal</th></tr></thead><tbody>" -Path createdApps.html

$ErrorActionPreference = "Stop"

Function ConfigureApplications {
    <#.Description
        This function creates the Azure AD applications for the sample in the provided Azure AD tenant and updates the
        configuration files in the client and service project  of the visual studio solution (App.Config and Web.Config)
        so that they are consistent with the Applications parameters
    #>

    # Connect to the Microsoft Graph API
    Write-Host "Connecting Microsoft Graph"
    Connect-MgGraph -TenantId $TenantId -Scopes "Application.ReadWrite.All"

    # Create the spa AAD application
    Write-Host "Creating the AAD application (ms-identity-javascript-v2)"
    # create the application 
    $spaAadApplication = New-MgApplication -DisplayName "ms-identity-javascript-v2" `
        -SignInAudience AzureADMyOrg `
        -Spa @{RedirectUris = "http://localhost:3000" } `


    # create the service principal of the newly created application 
    New-MgServicePrincipal -AppId $spaAadApplication.AppId -Tags { WindowsAzureActiveDirectoryIntegratedApp }

    Write-Host "Done creating the spa application (ms-identity-javascript-v2)"

    # URL of the AAD application in the Azure portal
    # Future? $spaPortalUrl = "https://portal.azure.com/#@"+$tenantName+"/blade/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/Overview/appId/"+$spaAadApplication.AppId+"/objectId/"+$spaAadApplication.ObjectId+"/isMSAApp/"
    $spaPortalUrl = "https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/CallAnAPI/appId/" + $spaAadApplication.AppId + "/objectId/" + $spaAadApplication.Id + "/isMSAApp/"
    Add-Content -Value "<tr><td>spa</td><td>$currentAppId</td><td><a href='$spaPortalUrl'>ms-identity-javascript-v2</a></td></tr>" -Path createdApps.html

    # Add Required Resources Access (from 'spa' to 'Microsoft Graph')
    Write-Host "Getting access from 'spa' to 'Microsoft Graph'"

    $mgUserReadScope = @{
        "Id"   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
        "Type" = "Scope"
    }

    $mgResourceAccess = @($mgUserReadScope);

    [object[]]$requiredResourceAccess = @{
        "ResourceAppId"  = "00000003-0000-0000-c000-000000000000"
        "ResourceAccess" = $mgResourceAccess
    }

    Update-MgApplication -ApplicationId $spaAadApplication.Id -RequiredResourceAccess $requiredResourceAccess
    Write-Host "Granted permissions."

    # Update config file for 'spa'
    $configFile = $pwd.Path + "\..\app\authConfig.js"
    Write-Host "Updating the sample code ($configFile)"
    $dictionary = @{ "Enter_the_Application_Id_Here" = $spaAadApplication.AppId; "Enter_the_Cloud_Instance_Id_HereEnter_the_Tenant_Info_Here" = "https://login.microsoftonline.com/" + $TenantId; "Enter_the_Redirect_Uri_Here" = $spaAadApplication.Spa.RedirectUris[0] };
    ReplaceInTextFile -configFilePath $configFile -dictionary $dictionary

    # Update config file for 'spa'
    $configFile = $pwd.Path + "\..\app\graphConfig.js"
    Write-Host "Updating the sample code ($configFile)"
    $dictionary = @{ "graphMeEndpoint" = 'https://graph.microsoft.com/v1.0/me/'; "graphMailEndpoint" = 'https://graph.microsoft.com/v1.0/me/messages/' };
    UpdateTextFile -configFilePath $configFile -dictionary $dictionary
     
    Add-Content -Value "</tbody></table></body></html>" -Path createdApps.html  
}

Function UpdateLine([string] $line, [string] $value) {
    $index = $line.IndexOf('=')
    $delimiter = ';'
    if ($index -eq -1) {
        $index = $line.IndexOf(':')
        $delimiter = ','
    }
    if ($index -ige 0) {
        $line = $line.Substring(0, $index + 1) + " " + '"' + $value + '"' + $delimiter
    }
    return $line
}

Function UpdateTextFile([string] $configFilePath, [System.Collections.HashTable] $dictionary) {
    $lines = Get-Content $configFilePath
    $index = 0
    while ($index -lt $lines.Length) {
        $line = $lines[$index]
        foreach ($key in $dictionary.Keys) {
            if ($line.Contains($key)) {
                $lines[$index] = UpdateLine $line $dictionary[$key]
            }
        }
        $index++
    }

    Set-Content -Path $configFilePath -Value $lines -Force
}

Function ReplaceInLine([string] $line, [string] $key, [string] $value) {
    $index = $line.IndexOf($key)
    if ($index -ige 0) {
        $index2 = $index + $key.Length
        $line = $line.Substring(0, $index) + $value + $line.Substring($index2)
    }
    return $line
}

Function ReplaceInTextFile([string] $configFilePath, [System.Collections.HashTable] $dictionary) {
    $lines = Get-Content $configFilePath
    $index = 0
    while ($index -lt $lines.Length) {
        $line = $lines[$index]
        foreach ($key in $dictionary.Keys) {
            if ($line.Contains($key)) {
                $lines[$index] = ReplaceInLine $line $key $dictionary[$key]
            }
        }
        $index++
    }

    Set-Content -Path $configFilePath -Value $lines -Force
}

# Run interactively (will ask you for the tenant ID)
ConfigureApplications -TenantId $TenantId
