# Challenge 2 - Simple DSC

[< Previous Challenge](./DSC-Challenge-01.md) - [Home](../readme.md) - [Next Challenge>](./DSC-Challenge-03.md)

## Introduction

The goals of this challenge include understanding:
+   Use the built in DSC Resources on Windows Server
+   Logistics to deploy a PowerShell DSC script to a Windows VM via ARM template

## Description

+	Create a DSC script that creates 3 folders on the C:\ drive.
    +   Set up artifacts ("staging") location in Blob storage with SAS token
    +   Extend ARM template to deploy DSC extention onto the VM
    +   Add parameters for:
        +   Artifacts location 
        +   Artifacts location SAS token
        +   DSC script archive file name
        +   DSC script function name

## Success Criteria

1. Connect to the VM via Remote Desktop and verify that the three folders have been created on the C:\ drive.

## Learning Resources

- [Windows PowerShell DSC Overview](https://docs.microsoft.com/en-us/powershell/scripting/dsc/overview/overview?view=powershell-7)
- [Built-in Windows Resources](https://docs.microsoft.com/en-us/powershell/scripting/dsc/resources/resources?view=powershell-7#windows-built-in-resources)
- [Securing PowerShell DSC within Azure ARM Templates](https://poshsecurity.com/blog/securing-powershell-dsc-within-azure-arm-templates)
- [Using PowerShell DSC in ARM Templates](https://www.mavention.nl/blogs-cat/using-powershell-dsc-in-arm-templates/?cn-reloaded=1)
- [Desired State Configuration extension with ARM Templates](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/dsc-template)
- [Introduction to the Azure DSC extension handler](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/dsc-overview)
- [PowerShell DSC Extension](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/dsc-windows)


## Tips

- Pay attention to the version of the ARM template DSC extension resource. There have been multiple versions of it.  Document samples you find may vary or use older versions that have beend deprecated.