# Challenge 6 - Configure a Linux Server

[< Previous Challenge](./ARM-Challenge-05.md) - [Home](../readme.md) - [Next Challenge>](./ARM-Challenge-07.md)

## Introduction

If you are continuing with the remaining ARM Template challenges, we assume you have deployed Linux VM in the last challenge.  The remaining challenges focus on extending the ARM template with more complex infrastructure around Linux VMs.

The goals for this challenge include understanding:
- Custom script extensions
- Globally unique naming context and complex dependencies
- Staging artifacts in a location accessible to the Azure Resource Manager

## Description

We have provided a script (`install_apache.sh`) that configures a web server on a Linux VM. When run on the VM, the script deploys a static web page that should be available at `http://<PublicIPofTheVM>/wth.html`

You can find the script in the Resources folder for **ARM-Challenge-06**.

Your challenge is to:

- Extend the ARM Template to configure a webserver on the Linux VM you deployed
    - Host the script file in a secure artifact (staging) location that is only accessible to the Azure Resource Manager.
    - Pull the website configuration script from the artifact location.

## Success Criteria

1. Verify you can view the web page configured by the script

## Tips

- Use an Azure Blob Storage account as the artifact location
- Secure access to the artifact location with a SAS token
- Pass these values to the ARM Template as parameters