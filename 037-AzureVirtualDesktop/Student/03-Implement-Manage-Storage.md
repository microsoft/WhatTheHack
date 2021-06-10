# Challenge 3: Implement and Manage your Storage for FSLogix

[< Previous Challenge](./02-Implement-Manage-Network.md) - **[Home](../README.md)** - [Next Challenge >](./04-Create-Manage-Images.md)

## Introduction

Deploying a solid and resilient storage solution is very important. Key components here are the number of users, regions, required, performance and optimizations we can make. Additionally we want to consider DR in case an unexpected outage happen. Finally, like everything Azure, we want to minimize cost while getting the best possible performance.

In this challenge you will be setting up storage resources to support the requirements of this project. Each region must have it own Azure Storage account to be used by each Host Pool in the respective region only.

## Description

In this challenge you will be creating three storage accounts one per region. Each region will have a dedicated host pool so each storage account will be used by one of those host pools.

1. Capacity planning is always a key point for the success of any project. For the success of this deployment your implementation must support the following points:
    * For this PoC the solution **must support 1/3 of the users** on each region. 
    * The storage capacity must support 1/3 of the users to login at the same time and have steady state sessions. You must calculate the expected amount of IOps fot this solution. **HINT:** Check the reference section to calculate the storage requirements.**
    * Solution breakout:
        * Field in UK 2000 users
        * Developers Japan 1000 users
        * Office workers US 2000 users

1. Create one storage account per region
    * You need to create three storage account one per region (East US, UK South and Japan West)
    * Storage account name must follow this name convention:
        - `storeus\<alias>`
        - `storjw\<alias>`
        - `storuks\<alias>`
        - Example: `storeusvsantana`
        
         **NOTE:** The Storage account name must have less than 15 characters due to NETBIOS limitation.

1. Create Private Endpoint for each Storage Account
    * Create a Private Endpoint connecting each storage account to the respective VNet in each region.
    * The private link must be named as follow:
        - `priveusaz140`  
        - `privjwaz140`
        - `privuksaz140`

1. Enable Storage Account Active Directory Authentication (Join Storage Account to AD DS Domain)
    * AVD requires AD DS authentication to access a Azure file share (Shared folder) to host Windows Profiles (FSLogix profile containers) and MSIX app attach applications.
    * You must enable Storage Account AD DS authentication and assign least privilege RBAC roles.
    * You must apply the permission to the following groups:
        - `avd_users_japan`
        - `avd_users_uk`
        - `avd_users_usa`

1. Create File Share and assign least privilege permission
    * Create a File Share for FSLogix Profile containers and assign least privilege permissions
    * Create a File Share for MSIX app attach and assign least privilege permissions
    * You must apply the permission to the following groups:
        - `avd_users_japan`
        - `avd_users_uk`
        - `avd_users_usa`  
    * The file shares must be named as follow:
        - `shareeusaz140`
        - `sharejwaz140`
        - `shareukaz140`

1. Allow Storage access from Network Security Group for each spoke VNet
    * Allow SMB (TCP 445) access to the storage account for each spoke VNet
    * List of NSG that must be updated:
        - `nsg-avd-d-eus`
        - `nsg-avd-d-jw`
        - `nsg-avd-d-uks`

## Success Criteria

1. Each region must have a dedicated storage account that can support 1/3 of the users IOps.

1. Storage account name must follow this name convention: `<alias>stg<region>`

1. Each host pool must have access to a storage account in the respective region using network Private Endpoint.

1. Enable Storage Account ADDS authentication to control access to all shared folders (NTFS permission).

1. Apply the least RBAC and NTFS permission to all Storage Accounts and Shared Folders to support FSLogix Container profile and MSIX app attach using the existing groups:
    - `avd_users_japan`
    - `avd_users_uk`
    - `avd_users_usa`

1. Allow Network Access to the Storage account for each spoke VNet.
You must allow access to SMB using protocol TCP and port 445 for the following NSGs:
    - `nsg-avd-d-eus`
    - `nsg-avd-d-jw`
    - `nsg-avd-d-uks`
