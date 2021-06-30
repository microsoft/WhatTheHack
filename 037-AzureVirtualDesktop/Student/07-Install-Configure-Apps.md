# Challenge 7: Install and Configure your Applications

[< Previous Challenge](./06-Implement-Manage-FsLogix.md) - **[Home](../README.md)** - [Next Challenge >](./08-Plan-Implement-BCDR.md)

## Introduction

Based on the noted requirements we will need to split up the applications in a few different ways. Image based apps are typically used by all and updated together like the Microsoft Office Applications.
However if a small subset of users do not require the apps, they can be hidden or masked with FSLogix application masking.  

Those apps that require more frequent updates and assignments may be more dynamic can be mapped on the fly via MSix App Packaging. 
MSIX requires a few step with regards to preparing the environment as the packages require a signature via certificates.  
The best practice is to perform application packaging on a dedicated Packaging VM, but in this case, either spin up a new VM on your East US spoke or use your domain controller.

- Application Masking (FSLogix)  
    Office Apps will be included in the image but only some need to utilize PowerPoint and OneNote  

- Included in the image  
    Office Applications overall and Adobe Acrobat  

- Mapped on-the-fly via MSIX
    Notepad++ and VS Code will be used in Japan, whereas Notepad++ in each of the 3 regions

## Description

First we'll need to consider where we want to store the applications for installation. 
Typically this is a common file share. We will use the MSIX File Shares that were created in Challenge 3.

**NOTE:** The packaging admin will need contributor rights on this share, users will only need the SMB Reader role. 

### Application Masking (FSLogix)

1. Install the application masking rules editor on a Packaging VM that contains the applications to mask.      
2. Create a rule set Hiding PowerPoint and OneNote and assign to the group of US based users.
3. Deploy or copy the rule set files to each Session Host.
4. Test the PowerPoint and OneNote apps are hidden from a user in the US based user group. 

### MSIX Applications (on-the-fly mapping apps)

The 2 applications we need to package as .MSIX files for App Attach are Notepad++ and VS Code. 
Be sure to have those downloaded on the Packaging VM.  

Prepare the environment for Signed Packages:  
1. For the sake of this excercise we'll utilize a [self signed certificate as outlined in the script here.](https://raw.githubusercontent.com/DeanCefola/PowerShell-Scripts/master/Certificate_Self%20Signed.ps1)
2. Deploy the self-signed certificate to each VM in your host pool.
    **Important: The certificate will need to be in the Trusted People store**
    **NOTE: You can additionally push this cert out through GPO.**

Create and deploy packages:

1. Download and install the [MSIX Packaging Tool](https://docs.microsoft.com/en-us/windows/msix/packaging-tool/tool-overview) 
2. Create pacakges:
    - Notepad++
    - VS Code  

3. Expand the MSIX packages to VHD/VHDx/CIM 
4. Copy the converted disk image(s) to the MSIX Azure File share created.
5. Configure the application group for the MSIX packages to apply to the appropriate group of users.
    - An alternate 3rd party tool for managing MSIX Packages to include expanding to VHD is [MSIX Hero](https://msixhero.net/).
    
    **NOTE:** Sometimes in packaging you will run into issues and errors.  If so another good resource is [PSFTooling](https://www.microsoft.com/en-us/p/tmurgent-psftooling/9nc6k0q954jv#activetab=pivot:overviewtab).

### Remote Apps (Pooled - UK)

The UK host pool is for Remote Apps. Add The following Apps and grant the UK users group access.

- Excel
- Word
- PowerPoint
- OneNote
- Edge
- Chrome
- Notepad++ (MSIX package)

### Desktop (Pooled - US)

The US host pool is for Pooled Desktops. Add The following Apps and grant the US users group access.

- Notepad++ (MSIX package)

### Desktop (Personal - Japan)

The US host pool is for Pooled Desktops. Add The following Apps and grant the US users group access.

- Notepad++ (MSIX package)
- VSCode (MSIX package)

## Success Criteria

1. MSIX Packaging of Visual Code and Notepad++.
1. Assigning apps to Desktop Application Groups
1. Assigning apps to Remote Application Groups
1. App Masking for the appropriate apps and host pool(s)
