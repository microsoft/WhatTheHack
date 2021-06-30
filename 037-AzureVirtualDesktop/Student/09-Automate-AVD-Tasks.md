# Challenge 9: Automate AVD Tasks

[< Previous Challenge](./08-Plan-Implement-BCDR.md) - **[Home](../README.md)** - [Next Challenge>](./10-Monitor-Manage-Performance-Health.md)

## Introduction

In this challenge you will be automating common Azure Virtual Desktop management tasks, deploying the scaling automation solution, and configuring the Start VM On Connect solution.

## Description

In this challenge you need to complete the following management tasks:

1. Replace the AVD session hosts in the UK South host pool with a new image

    - 1.1: Turn drain mode on for the session hosts using PowerShell
    - 1.2: Validate no sessions exist on the session hosts using PowerShell
    - 1.3: Remove all the session hosts from the host pool using PowerShell
    - 1.4: Delete the session hosts using Azure CLI
    - 1.5: Get the registration key using Azure CLI
    - 1.6: Deploy new session hosts using Azure CLI and an ARM Template

1. Update properties on the East US host pool

    - 2.1: Reset all the custom RDP properties on the host pool using Azure CLI
    - 2.2: Add the following RDP properties using Azure CLI:
        - enable camera redirection
        - enable microphone redirection
        - disable multiple display support
    - 2.3: Change the load balancing algorithm to depth-first using Azure CLI

1. Publish a Remote App on the UK South host pool

    - 3.1: Create an application group called "Monet" using Azure CLI
    - 3.2: Publish Paint as an application in the Monet application group using PowerShell
    - 3.3: Change the display name for the Paint app to "Monet" using PowerShell
    - 3.4: Create an RBAC assignment for the Monet application group adding only "hulk" using Azure CLI

1. Enable the Scaling Automation solution for the UK South and East US host pools using PowerShell with the following requirements:

    - Office hours: 9am - 5pm in their timezone
    - Only 1 VM should be on during off hours to save on cost
    - 2 users per CPU
    - Recurrence Interval should be 15 mins
    - Force logoff should be set to 0

1. Group Policy for AVD: the idle session and disconnected session settings are enabled    
1. Configure the Start VM On Connect solution for the Japan West host pool using PowerShell

## Success Criteria

1. The AVD session hosts in the UK South host pool have been replaced with a new image using Azure CLI, PowerShell, and an ARM Template.
2. The East US host pool has the correct RDP properties and load balancing algorithm using Azure CLI.
3. The Monet application group has been added to the workspace in UK South, the Paint application has been added to the application group with the correct display name, "Monet", and the RBAC assignment on the application group only includes "hulk" using Azure CLI and PowerShell.
4. The Scaling Automation solution is deployed and scaling the session hosts in the UK South and East US host pools based on the requirements defined in the description using PowerShell.
5. The Start VM On Connect solution has been configured for the Japan West host pool using PowerShell.

## Learning Resources

- [PowerShell: Desktop Virtualization](https://docs.microsoft.com/en-us/powershell/module/az.desktopvirtualization)
- [Azure CLI: Desktop Virtualization](https://docs.microsoft.com/en-us/cli/azure/ext/desktopvirtualization/desktopvirtualization)
- [Run the Azure Resource Manager template to provision a new host pool](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-host-pools-azure-marketplace#run-the-azure-resource-manager-template-to-provision-a-new-host-pool)
- [Scale session hosts using Azure Automation](https://docs.microsoft.com/en-us/azure/virtual-desktop/set-up-scaling-script)
