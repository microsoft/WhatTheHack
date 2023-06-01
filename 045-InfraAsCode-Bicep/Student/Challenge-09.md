# Challenge 09 - Configure VM Scale Set to Run a Web Server

[< Previous Challenge](./Challenge-08.md) - [Home](../README.md) - [Next Challenge >](./Challenge-10.md)

## Introduction

The goals of this challenge include understanding:
- How extensions are configured in a Virtual Machine Scale Set (VMSS)
- How the custom script extension works in the context of a VMSS

## Description

We have provided a script (`install_apache_vmss.sh`) that configures Apache web server on a Linux VMSS. When run on an individual VM instance, the script deploys a static web page that should be available at: `http://<PublicIPofTheLoadBalancer>/wth.html`  

You can find the script in the Resources folder for `/Challenge-09`.

Your challenge is to:

- Extend the VMSS Bicep template to configure a webserver on instances of the VM Scale Set deployed earlier
    - Add the Azure VM Custom Script Extension to the VM Scale Set definition
    - Read the script body into a string and pass it as an input parameter

## Success Criteria

1. Verify you can view the web page configured by the script

## Learning Resources

- Read a text file using [PowerShell](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-content?view=powershell-7.1)
- Read a text file using a [Linux shell](https://askubuntu.com/questions/261900/how-do-i-open-a-text-file-in-my-terminal)
