# Change Passwords for all licensed users

Import-Module MSOnline
$msolCred = Get-Credential
Connect-MsolService –Credential $msolCred



Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -match "EnterprisePremium"} |
Set-MsolUserPassword –NewPassword "MakeItReal2020" -ForceChangePassword $False

#make all users global admins for the labs; ignore errors for accounts already admins
Get-MsolRole | Sort Name | Select Name,Description

$roleName="Company Administrator"
Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -match "EnterprisePremium"} |
ForEach {Add-MsolRoleMember -RoleMemberEmailAddress $_.UserPrincipalName -RoleName $roleName}

#Audio Conferencing is setup already. Add a Domestic Dial Plan Trial before running this

Get-MsolAccountSku

Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -match "EnterprisePremium"} |
ForEach {Set-MsolUserLicense -UserPrincipalName  $_.UserPrincipalName -AddLicenses M365x566356:MCOPSTN1}


