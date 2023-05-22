# Challenge 10 - Configure VM Scale Set to Run a Web Server Using cloud-init

[< Previous Challenge](./Challenge-09.md) - [Home](../README.md) - [Next Challenge >](./Challenge-11.md)

## Introduction

The goals of this challenge include understanding:
- How cloud-init scripts can be run on a Virtual Machine Scale Set (VMSS)

## Description

We have provided a script (`cloud-init.txt`) that configures Apache web server on a Linux VMSS. When run on an individual VM instance, the script deploys a static web page that should be available at: `http://<PublicIPofTheLoadBalancer>/wth.html`  

You can find the script in the Resources folder for `/Challenge-10`.

Your challenge is to:

- Extend the VMSS Bicep template to configure a webserver on instances of the VM Scale Set deployed earlier
    - Deploy a new VMSS instance with a different name to the previously deployed VMSS
    - Read the script body into a string and pass it as an input parameter
    - Pass the script body to the `customData` property of the VM Scale Set definition

## Success Criteria

1. Verify you can view the web page configured by the script

## Learning Resources

- [cloud-init support for virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/using-cloud-init)
- Read a text file using [PowerShell](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-content?view=powershell-7.1)
- Read a text file using a [Linux shell](https://askubuntu.com/questions/261900/how-do-i-open-a-text-file-in-my-terminal)
