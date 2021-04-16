# Challenge 3 - Implement and Manage your storage for FsLogix

[< Previous Challenge](./02-Implement-Manage-Network.md) - **[Home](README.md)** - [Next Challenge >](./04-Create-Manage-Images.md)

1. Capacity planning

According to the projects requirement he solution must support 1/3 of expected users. It means 2000/3=666. Log in/Log off needs avg. of 50 IOPS per user, per share. Steady state is 10 IOPS per user per share.

Possible solution would a storage account with the following size:

- 10240 GiB
- Baseline IO/s: 10640
- Burst IO/s: 30720
- Egress Rate: 674.4 MiBytes/s
- Ingress Rate: 449.6 MiBytes/s

1. Create one storage account per region

```PowerShell
Set-AzContext -Subscription <SubID> -Tenant <TenantID>

$resourceGroupName = "WVD"

$alias = "<Your Alias>" # This Variable cannot be bigger than 8 characters due to 15 limit NETBIOS
$storageAccountEastUS = ("storeus"+$alias)
$storageAccountJapanWest = ("storjw"+$alias)
$storageAccountUKSouth = ("storuks"+$alias)

$regionEastUS = "eastus"
$regionJapanWest = "japanwest"
$regionUKSouth = "uksouth"

New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountEastUS -SkuName Premium_LRS -Location $regionEastUS -Kind FileStorage
New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountJapanWest -SkuName Premium_LRS -Location $regionJapanWest -Kind FileStorage
New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountUKSouth -SkuName Premium_LRS -Location $regionUKSouth -Kind FileStorage

$shareNameUS = "shareeusaz140"
$shareNameJW = "sharejwaz140"
$shareNameUK = "shareukaz140" 

# The size to solve this lab is :10240 Gib. It would consume U$ 1638.40 monthly.
# Note: For a lab purpose use 100 GB U$16.00 monthly
New-AzRmStorageShare -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountEastUS -Name $shareNameUS -AccessTier Premium -QuotaGiB 10240
New-AzRmStorageShare -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountJapanWest -Name $shareNameJW -AccessTier Premium -QuotaGiB 10240
New-AzRmStorageShare -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountUKSouth -Name $shareNameUK -AccessTier Premium -QuotaGiB 10240
```

1. Create Private Endpoint for each Storage Account

The New-StgFileSharePrivateEndpoint function must be executed once per Storage Account to create the Private EndPoint with respective VNet/Subnet.

The function New-StgPrivateDNS must be executed only once to create the Private Azure DNS with the name 'privatelink.file.core.windows.net'.

Finally you need to link the private DNS to a VNet and setup the config records to auto register. You must run the function New-StgPrivateDNSConfig once per storage account to link it.

```PowerShell
##########################################
# Private End-Point Function
##########################################
function New-StgFileSharePrivateEndpoint {
    param (
        [string]$resourceGroupName,
        [string]$storageAccountName,
        [string]$location,
        [string]$vnetName,
        [string]$subnetName

    )
    $stg = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName

    $parameters1 = @{
        Name = $storageAccountName+"-to-vnet"
        PrivateLinkServiceId = $stg.ID
        GroupID = 'file'
    }
    $privateEndpointConnection = New-AzPrivateLinkServiceConnection @parameters1

    $vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName
    $subnetConfig = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnetName
    Set-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet -AddressPrefix $subnetConfig.AddressPrefix -PrivateEndpointNetworkPoliciesFlag Disabled
    $vnet | Set-AzVirtualNetwork

    $parameters2 = @{
        ResourceGroupName = $resourceGroupName
        Name = $storageAccountEastUS+"-PrivEndpoint"
        Location = $location
        Subnet = $subnetConfig
        PrivateLinkServiceConnection = $privateEndpointConnection
    }
    New-AzPrivateEndpoint @parameters2    
}

New-StgFileSharePrivateEndpoint -resourceGroupName $resourceGroupName -storageAccountName $storageAccountEastUS -location $regionEastUS -vnetName 'SpokeVnet-d-eus' -subnetName 'wvd-eus'


$zoneName = 'privatelink.file.core.windows.net'
# RG 'rg-wth-wvd-d-eus'


##########################################
# Private DNS Zone Function
##########################################
function New-StgPrivateDNS {
    param (
        [string]$resourceGroupName,
        [string]$zoneName
    )
    ## Create private dns zone. ##
    $parameters1 = @{
        ResourceGroupName = $resourceGroupName
        Name = $zoneName
    }
    New-AzPrivateDnsZone @parameters1
}

New-StgPrivateDNS -resourceGroupName $resourceGroupName -zoneName $zoneName

##########################################
# Private DNS Zone Link and Config Function
##########################################
function New-StgPrivateDNSConfig {
    param (
        [string]$resourceGroupName,
        [string]$privateEndpointName,
        [string]$vnetName,
        [string]$zoneName
    )

    ## Place virtual network into variable. ##
    $vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName
    $zone = Get-AzPrivateDnsZone -ResourceGroupName $resourceGroupName -Name $zoneName

    ## Create dns network link. ##
    $parameters2 = @{
        ResourceGroupName = $resourceGroupName
        ZoneName = $zoneName
        Name = 'vnetlink-'+$vnetName
        VirtualNetworkId = $vnet.Id
    }
    $link = New-AzPrivateDnsVirtualNetworkLink @parameters2

    ## Create DNS configuration ##
    $parameters3 = @{
        Name = $zoneName
        PrivateDnsZoneId = $zone.ResourceId
    }
    $config = New-AzPrivateDnsZoneConfig @parameters3

    ## Create DNS zone group. ##
    $parameters4 = @{
        ResourceGroupName = $resourceGroupName
        PrivateEndpointName = $privateEndpointName
        Name = $privateEndpointName
        PrivateDnsZoneConfig = $config
    }
    New-AzPrivateDnsZoneGroup @parameters4    
}

New-StgPrivateDNSConfig -resourceGroupName $resourceGroupName -privateEndpointName ($storageAccountEastUS+"-PrivEndpoint") -vnetName 'WVD-vnet-eastus' -zoneName $zoneName
```

1. Enable Storage Account Active Directory Authentication (Join Storage Account to AD DS Domain)

This script must be executed from a Domain Controller logged in with an user Account that has access to both AD and Azure Subscription.
The following parameters must be changed:

- $SubscriptionId = "\<your-subscription-id-here>"
- $ResourceGroupName = "\<resource-group-name-here>"
- $StorageAccountName = "\<storage-account-name-here>"
- $OU = "\<ou-distinguishedname-here>"

This script must be executed for all Storage Account regions.

```PowerShell
##########################################
# STG ADDS Join Domain
##########################################
#Change the execution policy to unblock importing AzFilesHybrid.psm1 module
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

$moduleZipPath = ($env:USERPROFILE+"\Desktop\AzFilesHybrid.zip")
$moduleFolderPath = $moduleZipPath.Substring(0,$moduleZipPath.Length-4)

New-Item -Path $moduleFolderPath

Invoke-WebRequest -Uri https://github.com/Azure-Samples/azure-files-samples/releases/download/v0.2.3/AzFilesHybrid.zip -OutFile $moduleZipPath
Expand-Archive -LiteralPath $moduleZipPath -DestinationPath $moduleFolderPath

cd $moduleFolderPath

# Navigate to where AzFilesHybrid is unzipped and stored and run to copy the files into your path
.\CopyToPSPath.ps1

#Import AzFilesHybrid module
Import-Module -Name AzFilesHybrid

#Login with an Azure AD credential that has either storage account owner or contributer Azure role assignment
Connect-AzAccount

#Define parameters
$SubscriptionId = "<your-subscription-id-here>"
$ResourceGroupName = "<resource-group-name-here>"
$StorageAccountName = "<storage-account-name-here>"
$OU = "<ou-distinguishedname-here>" # Ex: "OU=Computers,OU=RootUsers,DC=victorhepoca,DC=local"

#Select the target subscription for the current session
Select-AzSubscription -SubscriptionId $SubscriptionId 

Join-AzStorageAccountForAuth `
        -ResourceGroupName $ResourceGroupName `
        -StorageAccountName $StorageAccountName `
        -DomainAccountType "ComputerAccount" `
        -OrganizationalUnitDistinguishedName $OU

# Adding Session Hosts Computer account to the region AD Group. This is requirement for MSIX
Add-ADGroupMember -Identity wvd_users_uk -Members "<Session Host Computer Account>"
```

1. Create File Share and assign least privilege permission

```PowerShell

###################################################
# Creating Storage Share for each Storage Account
###################################################
$shareNameUS = "shareeusaz140"
$shareNameJW = "sharejwaz140"
$shareNameUK = "shareukaz140"

# The size to solve this lab is :10240 Gib. It would consume U$ 1638.40 monthly.
# Note: For a lab purpose use 100 GB U$16.00 monthly
New-AzRmStorageShare -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountEastUS -Name $shareNameUS -AccessTier Premium -QuotaGiB 10240
New-AzRmStorageShare -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountJapanWest -Name $shareNameJW -AccessTier Premium -QuotaGiB 10240
New-AzRmStorageShare -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountUKSouth -Name $shareNameUK -AccessTier Premium -QuotaGiB 10240

# File Share Admin Access
function Add-FSAZADMRoleAccess {
    param (
        [string]$storageName,
        [string]$UserUPN
    )
    $admUser = Get-AzADUser -UserPrincipalName $UserUPN
    $stgAADRoleFSADM = "Storage File Data SMB Share Elevated Contributor"
    $stgEastUS = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageName
    New-AzRoleAssignment -ObjectId $admUser.Id -RoleDefinitionName $stgAADRoleFSADM -Scope $stgEastUS.id    
}
Add-FSAZADMRoleAccess -storageName $storageAccountEastUS -UserUPN "<Synced Admin User>"
Add-FSAZADMRoleAccess -storageName $storageAccountJapanWest -UserUPN "<Synced Admin User>"
Add-FSAZADMRoleAccess -storageName $storageAccountUKSouth -UserUPN "<Synced Admin User>"

# File Share Regular Access
function Add-FSAZRoleAccess {
    param (
        [string]$storageName,
        [string]$ADGroupName
    )
    $admUser = Get-AzADGroup -DisplayName $ADGroupName
    $stgAADRoleFSADM = "Storage File Data SMB Share Contributor"
    $stgEastUS = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageName
    New-AzRoleAssignment -ObjectId $admUser.Id -RoleDefinitionName $stgAADRoleFSADM -Scope $stgEastUS.id    
}
Add-FSAZRoleAccess -storageName $storageAccountEastUS -ADGroupName "wvd_users_japan"
Add-FSAZRoleAccess -storageName $storageAccountJapanWest -ADGroupName "wvd_users_uk"
Add-FSAZRoleAccess -storageName $storageAccountUKSouth -ADGroupName "wvd_users_usa"

##################################
# Mount each share
##################################
function connectFS {
    param (
        [string]$letter,
        [string]$storageName
    )
    $connectTestResult = Test-NetConnection -ComputerName "$storageName.file.core.windows.net" -Port 445
    if ($connectTestResult.TcpTestSucceeded) {
        # Mount the drive
        New-PSDrive -Name $letter -PSProvider FileSystem -Root "\\$storageName.file.core.windows.net\shareeusaz140" -Persist
    } else {
        Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
    }    
}
connectFS -letter Z -storageName $storageAccountEastUS
connectFS -letter Y -storageName $storageAccountJapanWest
connectFS -letter W -storageName $storageAccountUKSouth

# Assign permission to each file share to the respective region
# Assign the right NTFS permission
function assignNTFSRights {
    param (
        [string]$domain,
        [string]$ADGroupName
    )
    icacls Z: /remove "Authenticated Users"
    icacls Z: /remove "Builtin\Users"    
    icacls Z: /remove "Creator Owner"
    icacls Z: /grant ($domain+"\"+$ADGroupName+":(M)")
    icacls Z: /grant "Creator Owner:(OI)(CI)(IO)(M)"
}
assignNTFSRights -domain "<DomainName>" -ADGroupName "wvd_users_japan"
assignNTFSRights -domain "<DomainName>" -ADGroupName "wvd_users_uk"
assignNTFSRights -domain "<DomainName>" -ADGroupName "wvd_users_usa"
```

1. Allow SMB/Cifs (TCP 445) in NSG

```PowerShell
function AllowNSG {
    param (
        [string]$NSGName,
        [string]$resourceGroupName,
        [string]$StoragePrivateEndpointIP
    )
    # Get the NSG resource
    $nsg = Get-AzNetworkSecurityGroup -Name $nsgname -ResourceGroupName $resourceGroupName

    # Add the inbound security rule.
    $nsg | Add-AzNetworkSecurityRuleConfig -Name "AllowSMBOutbound" -Description "Allow SMB Outbound" -Access Allow `
        -Protocol TCP -Direction Outbound -Priority 180 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
        -DestinationAddressPrefix $StoragePrivateEndpointIP -DestinationPortRange 445

    # Update the NSG.
    $nsg | Set-AzNetworkSecurityGroup    
}
AllowNSG -resourceGroupName $resourceGroupName -NSGName "nsg-wvd-d-eus" -StoragePrivateEndpointIP "<Storage Private Endpoint IP>"
AllowNSG -resourceGroupName $resourceGroupName -NSGName "nsg-wvd-d-jw" -StoragePrivateEndpointIP "<Storage Private Endpoint IP>"
AllowNSG -resourceGroupName $resourceGroupName -NSGName "nsg-wvd-d-uks" -StoragePrivateEndpointIP "<Storage Private Endpoint IP>"
```

## Learning Resources

- [Azure Academy - The AZ-140 WVD Exam series](https://www.youtube.com/watch?v=DZNc1DQxEEA&list=PL-V4YVm6AmwW1DBM25pwWYd1Lxs84ILZT)

- [WVD Storage Performance - Storage capacity planning](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix#performance-requirements)

- [WVD Storage Performance - Performance reference](https://docs.microsoft.com/en-us/azure/virtual-desktop/faq#whats-the-largest-profile-size-fslogix-can-handle)

- [WVD - Create File Share](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-file-share)

- [Detailed Steps - Create an Azure file share](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-create-file-share?tabs=azure-powershell)

- [Storage Files Network Overview](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-networking-overview)

- [Private Endpoint - Configure Azure Files network endpoints](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-networking-endpoints?tabs=azure-portal)

- [PowerShell Create Group - New-ADGroup](https://docs.microsoft.com/en-us/powershell/module/activedirectory/new-adgroup?view=winserver2012-ps)

- [ADDS Groups](https://docs.microsoft.com/en-us/windows/security/identity-protection/access-control/active-directory-security-groups)

- [WVD - Enable ADDS Storage Files authentication](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-identity-ad-ds-enable)

- [WVD - Create File Share FSLogix container profile](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-file-share)

- [WVD - MSIX app attach file share](https://docs.microsoft.com/en-us/azure/virtual-desktop/app-attach-file-share)

### Draft - (Everything under Draft are points that need to be documented in this challenge. The draft will be removed at the end.)

Points of attention:

- Storage Account Name: we need to standardize it to be used by scripts in the subsequent challenges.

Setup Private Endpoint - Each stg will have two private endpoints one for DC Auth and one for Host Pool access. *** requires validation
Setup AAD Auth, File Share Permission and RBAC Permission (Azure Files Share Permissions)
We need 3 groups in the domain controller
wvd_users_japan,
wvd_users_uk,
wvd_users_usa
These are to be used to grant permissions to the Azure Files shares in the portal and in the Windows NTFS Permissions

We need to cover MSIX AD Auth permission since they are different than FSLogix
Keep DR in mind for the next challenge

Capacity:

* Field in UK
    - 2000 pooled
    - Remote app only windows Server 2019

* Developers Japan
	- 1000 personal
	- Windows 10 Enterprise
* Office workers US
    - 2000 pooled
	- Windows 10 Multi-Session

Log in / Log off needs avg. of 50 IOPS per user, per share
Steady state is 10 IOPS per user per share

EXAMPLE:
1/3 of the 2,000 users in the US performance would be:
33,000+ IOPS per share for Login / LogOff
6,000+   IOPS for steady state
Reference: https://docs.microsoft.com/en-us/azure/virtual-desktop/faq#whats-the-largest-profile-size-fslogix-can-handle
https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix#performance-requirements

Possible solution will be:
10240 GiB
Baseline IO/s: 10640
Burst IO/s: 30720
Egress Rate: 674.4 MiBytes/s
Ingress Rate: 449.6 MiBytes/s

Protocol:
SMB

This is the link I'll follow to create the storage account and assign the permissions for FSLogix:
https://docs.microsoft.com/en-us/azure/virtual-desktop/create-file-share

Naming for Share:
shareeusaz140
sharejwaz140
shareukaz140

Private Link names:
priveusaz140  
privjwaz140
privuksaz140
