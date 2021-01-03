function New-FhirServerSmartClientReplyUrl {
    <#
    .SYNOPSIS
    Adds a SMART on FHIR Proxy Reply URL to a client app
    .DESCRIPTION
    Adds a SMART on FHIR Proxy Reply URL to a client app
    .EXAMPLE
    New-FhirServerSmartClientReplyUrl -AppId 9125e524-1509-XXXX-XXXX-74137cc75422 -FhirServerUrl https://fhir-server -ReplyUrl https://app-server/my-app
    #>
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$AppId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FhirServerUrl,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ReplyUrl
    )

    Set-StrictMode -Version Latest
    
    # Get current AzureAd context
    try {
        $session = Get-AzureADCurrentSessionInfo -ErrorAction Stop
    } 
    catch {
        throw "Please log in to Azure AD with Connect-AzureAD cmdlet before proceeding"
    }


    $appReg = Get-AzureADApplication -Filter "AppId eq '$AppId'"
    if (!$appReg) {
        Write-Host "Application with AppId = $AppId was not found."
        return
    }

    $origReplyUrls = $appReg.ReplyUrls
    
    # Form new reply URL: https://fhir-server/<base64url encoded reply url>/*
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($ReplyUrl)
    $encodedText =[Convert]::ToBase64String($bytes)
    $encodedText = $encodedText.TrimEnd('=');
    $encodedText = $encodedText.Replace('/','_');
    $encodedText = $encodedText.Replace('+','-');
    
    $newReplyUrl = $FhirServerUrl.TrimEnd('/') + "/AadSmartOnFhirProxy/callback/" + $encodedText

    # Add Reply URL if not already in the list 
    if ($origReplyUrls -NotContains $newReplyUrl) {
        $origReplyUrls.Add($newReplyUrl)
        Set-AzureADApplication -ObjectId $appReg.ObjectId -ReplyUrls $origReplyUrls
    }
    else
    {
        Write-Host "Skipping Reply URL add. Already added."
    }
}
