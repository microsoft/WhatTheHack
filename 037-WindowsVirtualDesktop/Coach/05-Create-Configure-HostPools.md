# Challenge 5: Create and Configure Host Pools and Session Hosts

[< Previous Challenge](./04-Create-Manage-Images.md) - **[Home](./README.md)** - [Next Challenge >](./06-Implement-Manage-FsLogix.md)

## Notes & Guidance

* All HostPools must be set as Validation HostPool because some challenges will only work with HostPools that are set to Validation Environment.
* Scripts for deploying Host Pools for Student are located in the Student Resource Folder. Students have skelton scripts that they will need to fill out before deploying. Complete scripts for Coach's is under the resource folder.
**Note** Metadata locations will be different location for Uk South and Japan West because of availability. When UK South and Japan West is available for Metadata, use those locations.

* East US Region
    * There should a Pooled HostPool with Windows 10 Multi Session, deployed by an ARM Template.
        * Students need to go to RDP Settings to deny Storage and Printers but allow camera and microphone

* Japan West Region
    * There should be a Personal HostPool with Windows 10 Enterprise OS, deployed via the Azure Portal.
        * Metadata location should be in West Us 2. (Use Japan West once it is available). VMs will be located in Japan West.
        * Host Pool settings for assigning users should be Direct not Automatic.
        * Student needs to assign a user to the app group first then they can assign the user to the Session Host.
        * Enable Start VM on Connect is under the Host Pool properties.
        * Allow Storage redirection, printing, camera and microphone.

* Uk South Region
    * There should be one Pooled HostPool for Remote Apps running Windows Server 2019, deployed by Azure CLI.
        * Metadata location should be in North Europe. (Use UK South once it is available). VMs should be located in UK South. 
        * Enable Screen Capture Protection by adding the reg key policy. https://docs.microsoft.com/en-us/azure/virtual-desktop/security-guide#enable-screen-capture-protection-preview
        * Deny Clipboard, Storage, Printers, Camera and Microphone.
