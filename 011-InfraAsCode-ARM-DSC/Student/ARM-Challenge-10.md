# Challenge 10 - Configure VM Scale Set to run a Web Server

[< Previous Challenge](./ARM-Challenge-09.md) - [Home](../readme.md) - [Next Challenge>](./ARM-Challenge-11.md)

## Introduction

The goals of this challenge include understanding:
- How extensions are configured in a VMSS
- How the custom script extension works in the context of a VMSS
- Custom script extension does not lock deployment order
- Staging artifacts in a location accessible to the Azure Resource Manager

## Description

We have provided a script (`install_apache_vmss.sh`) that configures web servers in a VMSS. When run on an individual VM instance, the script deploys a static web page that should be available at: `http://<PublicIPofTheLoadBalancer>/wth.html`  

This script is similar to the one used earlier in Challenge 6. However, it has some differences that take into account how the script will be executed on a VM that is part of scale set.

You can find the script in the Resources folder for **ARM-Challenge-10**.

Your challenge is to:

- Extend the ARM Template to configure a webserver on the VM instances of the VM Scale Set you deployed earlier
    - Host the script file in a secure artifact (staging) location that is only accessible to the Azure Resource Manager.
    - Pull the website configuration script from the artifact location.

## Success Criteria

1. Verify you can view the web page configured by the script

## Tips

- Use an Azure Blob Storage account as the artifact location
- Secure access to the artifact location with a SAS token
- Pass these values to the ARM Template as parameters