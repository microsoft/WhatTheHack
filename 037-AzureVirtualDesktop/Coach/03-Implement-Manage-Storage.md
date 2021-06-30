# Challenge 3: Implement and Manage your Storage for FsLogix

[< Previous Challenge](./02-Implement-Manage-Network.md) - **[Home](./README.md)** - [Next Challenge >](./04-Create-Manage-Images.md)

## Notes & Guidance

- Capacity planning
	- According to the projects requirement he solution must support 1/3 of expected users. It means 2000/3=666. Log in/Log off needs avg. of 50 IOPS per user, per share. Steady state is 10 IOPS per user per share.

Possible solution would a storage account with the following size:

- 10240 GiB
- Baseline IO/s: 10640
- Burst IO/s: 30720
- Egress Rate: 674.4 MiBytes/s
- Ingress Rate: 449.6 MiBytes/s

**NOTE:** Scripts to complete this section are in the Coach's Solution's folder if the Student needs help.

Students need too:

1. Create one storage account per region
1. Create Private Endpoint for each Storage Account
1. Enable Storage Account Active Directory Authentication (Join Storage Account to AD DS Domain)
1. Create File Share and assign least privilege permission
1. Allow SMB/Cifs (TCP 445) in NSG

## Learning Resources

- [Azure Academy - The AZ-140 AVD Exam series](https://www.youtube.com/watch?v=DZNc1DQxEEA&list=PL-V4YVm6AmwW1DBM25pwWYd1Lxs84ILZT)

- [AVD Storage Performance - Storage capacity planning](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix#performance-requirements)

- [AVD Storage Performance - Performance reference](https://docs.microsoft.com/en-us/azure/virtual-desktop/faq#whats-the-largest-profile-size-fslogix-can-handle)

- [AVD - Create File Share](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-file-share)

- [Detailed Steps - Create an Azure file share](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-create-file-share?tabs=azure-powershell)

- [Storage Files Network Overview](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-networking-overview)

- [Private Endpoint - Configure Azure Files network endpoints](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-networking-endpoints?tabs=azure-portal)

- [PowerShell Create Group - New-ADGroup](https://docs.microsoft.com/en-us/powershell/module/activedirectory/new-adgroup?view=winserver2012-ps)

- [ADDS Groups](https://docs.microsoft.com/en-us/windows/security/identity-protection/access-control/active-directory-security-groups)

- [AVD - Enable ADDS Storage Files authentication](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-identity-ad-ds-enable)

- [AVD - Create File Share FSLogix container profile](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-file-share)

- [AVD - MSIX app attach file share](https://docs.microsoft.com/en-us/azure/virtual-desktop/app-attach-file-share)
