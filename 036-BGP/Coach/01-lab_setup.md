# Challenge 1: Lab Setup

**[Home](./README.md)** - [Next Challenge >](./02-enable_bgp.md)

## Notes and Guidance

The script [bgp.sh](https://github.com/erjosito/azcli/blob/master/bgp.sh) can be used to create the basic topology. This script has been tested to run in the Azure Cloud shell, and takes around 1 hour to complete.

Participants have reportedly struggled with the scripts, sometimes because of not having enough privilege to accept the Cisco CSR Marketplace image, sometimes for other issues.

Hence it is recommended that the coach runs this script previous to the actual event, or at least one participant has tested it.

The resources can of course be created manually, but participants often get a "waste of time" feeling when investing a long time in creating Azure resources and configuring IPsec tunnels.

## Solution Guide

In the [Solution file](./Solutions/01_Solution.md) you can find a sample script output when deploying the environment with [bgp.sh](https://github.com/erjosito/azcli/blob/master/bgp.sh), as well as sample outputs of the recommended diagnose commands.