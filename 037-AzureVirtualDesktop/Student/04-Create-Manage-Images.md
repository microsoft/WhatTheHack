# Challenge 4: Create and Manage Images

[< Previous Challenge](./03-Implement-Manage-Storage.md) - **[Home](../README.md)** - [Next Challenge>](./05-Create-Configure-HostPools.md)

## Introduction

In this challenge you will create, update, and manage the images used when deploying Session Hosts into your Host Pools.

## Description

In this challenge you will be preparing three images that will be used for the different Host Pool deployments. Each image will be use a different operating system and installed applications based on the different user personas. Each image will be created and updated differently based on the scenario requirements.

1. Create the image for the Remote Field users
    * This image should be created with the Virtual Machine Capture command and the custom image should only be stored in UK South.
    * Create a virtual machine in UK South with the following specifications. The operating system is Windows Server 2019 Datacenter with the following software installed.
        * Microsoft Office
        * Microsoft OneDrive
        * Microsoft Teams
        * FSLogix
            * **NOTE:** Only install FSLogix. The configuration will occur in a future challenge.
        * Notepad++
        * Adobe Acrobat Reader
    * **HINT:** Since this operating system supports more than one user logged in at a time, there may be specific installation steps to consider.
    * **HINT:** It is recommended to reboot the server after making the customizations to the image.
    * Take a disk snapshot as a recovery point for any subsequent failures and the snapshot will be used when updating the image.
    * Run Sysprep (generalize). Then Capture the VM as a custom image.
    * **TIP:** Since the Capture makes the VM no longer usable, it is recommended to let the Capture delete the original VM.
    * Test the image by deploying a VM from the image and validating all customizations persisted.

1. Create the Image for the General Office users
    * This image should be created with the Azure Image Builder and the image should be stored in the Shared Image Gallery (SIG). The image in SIG should be available in Japan West, UK South, and US East with three image replicas per region.
    * Create an Image Template in AIB with the following customizations:
        * The operating system is Windows 10 Enterprise Multi-session, Version 20H2 + Microsoft 365 Apps (Gen 1) with the following software installed.
            * Microsoft Teams
            * **HINT:** Since this operating system is multi-session, there may be specific installation steps to consider.
        * Add a step to reboot the VM.
        * Add a step to run Windows Update.
        * **NOTE:** All Windows 10 Multi-session images from the Azure Marketplace already include the FSLogix agent.
    * Test the image by deploying a VM from the image and validating all customizations persisted. Uploading images to SIG can take some time before the image can be used for VM deployments.
    * **HINT:** If you are in an AAD tenant where you cannot create anymore custom roles for the managed identity for AIB, you can leverage a built-in role with more permissions for the FastHack.
    * **NOTE:** As of the ARM template api version "2020-02-14", AIB does support specifying the number of image replicas per region (default is 1). Therefore setting the replica count to three will be a post deployment task through the portal, PowerShell, CLI, etc.

1. Image for the Developers
    * This image can be deployed from the Azure Marketplace and other applications will be delivered with MSIx App Attach. Out of the Azure Marketplace, use the Windows 10 Enterprise, Version 20H2 (Gen 2).
    * Since there is no custom image involved for the Developers, no testing is required during this challenge.

1. Update image for Remote Field users
    * The image requires updates with additional customizations. This image was created with the VM Capture and updating the image will follow a similar flow.
    * Deploy a new VM from the snapshot taken during step 1. This should be in the UK South region.
    * Install the language packs for Spanish (Spain) and Japanese (Japan). Reboot the server.
    * Take a disk snapshot as a recovery point for any subsequent failures and the snapshot will be used when updating the image.
    * Run Sysprep. Then Capture the VM as a custom image.
    * Test the updated image by deploying a VM from the image and validating all customizations persisted.
    * Once you validated the image is properly updated, delete the original image and only keep the updated image.

1. Update image for General Office users
    * The image requires updates with additional customizations. This image was created with the Azure Image Builder and updating the image will follow a similar flow.
    * Within Azure Image Builder, add steps to install the language packs for Spanish (Spain) and Japanese (Japan) as a new image version.
    * Test the updated image by deploying a VM from the image and validating all customizations persisted.
    * Distribute the image to Japan West, UK South, and US East with three image replicas per region. Do not delete the original version.

## Success Criteria

1. The Developers should not have a custom image.
1. The General Office custom image should be part of the Shared Image Gallery with replicas in US East, Japan West, and UK South. Each replica should have two versions.
1. The Remote Field custom image should be in UK South and not part of the Shared Image Gallery.
