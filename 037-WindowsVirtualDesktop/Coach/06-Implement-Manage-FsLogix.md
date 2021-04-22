# Challenge 6: Addressing User Profiles with FSLogix

[< Previous Challenge](./05-Create-Configure-HostPools.md) - **[Home](./README.md)** - [Next Challenge >](./07-Install-Configure-Apps.md)

## Notes & Guidance

- Student should have FSLogix creating profiles based on our best practices and per the scenario requirements for DR.
- This should include VHSLocations & Cloud Cache settings.  
- Configure all FSLogix GPOs with Best Practices 
- Japan Users DO NOT get FSLogix because they have personal hostpools.  
 * US Users
    * VHDLocations should be used for a single share in US 
        - `\\\\customdomain.file.core.windows.net\<fileshare-name>`

 * UK Users
    * Cloud Cache should be configured to replicatie User profiles to UK and US region
        - `type=smb,connectionString=<\Location1\Folder1>;type=smb,connectionString=<\Location2\folder2>`

Student should have the following technologies deployed.

1. FSLogix configured for cloud cache for UK South region.
2. Group or User added to Local Group on VM for FLogix Profile Exemption(s).  
3. Backup for US region profile data

## Learning Resources

- [Redirect Teams Cache data due to size of data stored in Profile](https://techcommunity.microsoft.com/t5/windows-virtual-desktop/wvd-fslogix-reduce-profile-container-size-exclude-teams-cache/m-p/1503683)  
- [Cloud Cache](https://docs.microsoft.com/en-us/fslogix/configure-cloud-cache-tutorial)
- [FSLogix Best Practices](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix#best-practice-settings-for-enterprises)
- [FSLogix Anti-Virus Exclusions](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix#antivirus-exclusions)
