# Challenge 7: Install and Configure your Applications

[< Previous Challenge](./06-Implement-Manage-FsLogix.md) - **[Home](./README.md)** - [Next Challenge >](./08-Plan-Implement-BCDR.md)

## Notes & Guidance

### MSIX Packaging

- Students will need to use the MSIX Packaging tool MS Store app to convert app installers to .msix format. 
- [Use Self-Signed Cert Script](https://raw.githubusercontent.com/DeanCefola/PowerShell-Scripts/master/Certificate_Self%20Signed.ps1)
- Put Cert into local computer *Trusted People* store
- [Download MSIXMgr Tool](https://aka.ms/msixmgr)
- Use MSIXMgr tool to convert .MSIX to .vhdx/.cim
- Put new App Image file(s) on Azure Files MSIX Shares in each region
- MSIX AppAttach Permissions
    - Create AD Group for US,UK,Japan Session Hosts
    - Sync to Azure with Azure AD Connect
    - Verify Group membership in Azure AD 
    - Assign Azure Files Share **Contributor** permissions to AD Comptuer Group for the correct regions
    - Assign Azure Files Share **READ** permissions to AD Users Groups for the correct regions
    - Assign NTFS Permissions for AD Computer and Users Groups, matching Azure Files Permissions

### User Assignments

Follow the tables below to know which applications need to be packaged as MSIX vs what is **ALREADY** included in the Images.  
**NOTE:** Office Apps are already included in the Image.**

#### Application Deployment Options

Applications| Include in image Already | MSIX App Attach |
------------|:------------------------:|:---------------:|
Word        | X                        |                 |
Excel       | X                        |                 |
PowerPoint  | X                        |                 |
OneNote     | X                        |                 |
OneDrive    | X                        |                 |
Edge        | X                        |                 |
Teams       | X                        |                 |
Chrome      | X                        |                 |
Acrobat Reader| X                      |                 |
Notepad++   |                          | X               |
VS Code (Dev) |                        | X               |  

- Students will need to assign the correct applications through the app groups to the correct users.
    * Japan (Personal Pool) only have a Desktop application group.  Add MSIX app as a application to that DAG.
    * US (Pooled Desktops) assign all apps  apps to the Desktop Application Group (DAG).
    * UK (Remote Apps) assign all apps through Remote App Groups.

Applications    | Japan Users (Devs)  |   UK Users (Remote)   |   US Users (General)  |
----------------|:-------------------:|:---------------------:|:---------------------:|
Word            |                     |                       | X                     |  
Excel           |                     |                       | X                     |
PowerPoint      |                     |                       | App Masking           |
OneNote         |                     |                       | App Masking           |
OneDrive        |                     |                       |                       |
Edge            |                     | X                     |                       |
Teams           | X                   |                       | X                     |
Chrome          |                     | X                     |                       |
Acrobat Reader  |                     |                       |                       |
Notepad++       | X                   | X                     | X                     |
VS Code (Dev)   | X                   |                       |                       |

## Learning Resources

- [Azure Academy WVD & TEAMS Guide](https://www.youtube.com/watch?v=RfbolIgPcBY)
- [OneDrive per-Machine Mode](https://docs.microsoft.com/en-us/azure/virtual-desktop/install-office-on-wvd-master-image#install-onedrive-in-per-machine-mode)
- [Use Microsoft Teams on Azure Virtual Desktop](https://docs.microsoft.com/en-us/azure/virtual-desktop/teams-on-wvd)
- [Install Office on a master VHD image](https://docs.microsoft.com/en-us/azure/virtual-desktop/install-office-on-wvd-master-image)
