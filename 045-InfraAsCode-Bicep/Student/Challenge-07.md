# Challenge 07 - Configure VM to Run a Web Server

[< Previous Challenge](./Challenge-06.md) - [Home](../README.md) - [Next Challenge >](./Challenge-08.md)

## Introduction

The goals for this challenge include understanding:
- Custom script extensions
- Globally unique naming context and complex dependencies
- Staging artifacts in a location accessible to the Azure Resource Manager

## Description

We have provided a script (`install_apache.sh`) that configures a web server on a Linux VM. When run on the VM, the script deploys a static web page that should be available at `http://<PublicIPofTheVM>/wth.html`

You can find the script in the Resources folder for **Bicep-Challenge-07**.

Your challenge is to:

- Extend the Bicep template to configure a webserver on the Linux VM you deployed.
- There are two options for how to do this:
    
    - Option 1:
        - Host the script file in a secure artifact (staging) location that is only accessible to the Azure Resource Manager.
        - Pull the website configuration script from the artifact location.
    - Option 2:
        - Read the script's body into a string and pass it as an input parameter to the Bicep template

## Success Criteria

1. Verify you can view the web page configured by the script

## Tips

- Use an Azure Blob Storage account as the artifact location
- Secure access to the artifact location with a SAS token
- Pass these values to the ARM Template as parameters

## Learning Resources

- Read a text file using [PowerShell](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-content?view=powershell-7.1)
- Read a text file using a [Linux shell](https://askubuntu.com/questions/261900/how-do-i-open-a-text-file-in-my-terminal)
