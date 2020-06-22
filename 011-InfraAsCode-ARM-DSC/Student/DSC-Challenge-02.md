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

1. Connect to the VM via Remote Desktop and verify that the three folders have been created on the C:\ driver.

## Learning Resources

- Link for built in DSC Resources for Windows Server
- Sample DSC script

## Tips

- Pay attention to the version of the ARM template DSC extension resource. There have been multiple versions of it.  Document samples you find may vary or use older versions that have beend deprecated.