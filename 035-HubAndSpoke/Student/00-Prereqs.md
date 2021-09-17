# Challenge 0: Pre-requisites - Ready, Set, Go! 

**[Home](../README.md)** - [Next Challenge >](./01-HubNSpoke-basic.md)

## Introduction

A smart Azure engineer always has the right tools in their toolbox. In addition, a good grasp on key foundational networking concepts.

## Description

In this challenge we'll be setting up all the tools we will need to complete our challenges.

- Make sure that you have joined the Teams group for this track. Please ask your coach about the correct Teams channel to join.
- Ask your coach about the subscription you are going to use to fulfill the challenges
- Install the recommended toolset, being one of this:
    - The Powershell way (same tooling for Windows, Linux or Mac):
        - [Powershell core (7.x)](https://docs.microsoft.com/en-us/powershell/scripting/overview)
        - [Azure Powershell modules](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az)
        - [Visual Studio Code](https://code.visualstudio.com/): the Windows Powershell ISE might be an option here for Windows users, but VS Code is far, far better
        - [vscode Powershell extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
    - The Azure CLI way:
        - [Windows Subsystem for Linux](https://docs.microsoft.com/windows/wsl/install-win10), if you are running Windows and want to install the Azure CLI under a Linux shell like bash or zsh
        - [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
        - [Visual Studio Code](https://code.visualstudio.com/): the Windows Powershell ISE might be an option here for Windows users, but VS Code is far, far better
        - [VScode Azure CLI extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.azurecli)
    - The Azure Portal way: not really recommended, but you can still the portal to fulfill most of the challenges. Do not complain about having to do more than once the same task across the challenges :)

**NOTE:** You can use Azure Powershell and CLI on the Azure Cloud Shell, but running the commands locally along Visual Studio Code will give you a much better experience

### Networking 101

We recommend to review the below LinkedIn training and Azure docs(< 4 hours) in order to revisit key networking concepts necessary for the successful completion of this FastHack.

- [Networking Basics](https://www.linkedin.com/learning/networking-foundations-networking-basics?u=3322)
    - Network Addresses
    - Pieces and Parts of a Network
        - Network Interface Cards
        - Routers (Routing Table, Default route concept, Longest Prefix Route)
    - The OSI Model
    - Network Services
	    - DNS
	    - NAT (and PAT)

- [Learning IP Addressing](https://www.linkedin.com/learning/learning-ip-addressing-2019?u=3322)
    - Configuring and verifying IP addresses
    - IPv4 address structure
    - Public vs. private IPv4 addresses
    - Looking up IP addresses with DNS (DNS Hierarchical structure, DNS Record Types)

- [Learning Subnetting](https://www.linkedin.com/learning/learning-subnetting-2019?u=3322)
    - The structure of ipv4 addressess
        - Address classes
        - Public vs. private ipv4 communication
    - Types of IPv4 Communication
    - Basic Subnetting
        - The need for subnetting
    - Advanced Subnetting
        - Classless Interdomain Routing (CIDR)

- [Azure Virtual Network FAQ](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-faq)
- [Azure Private Endpoint](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview)

- [Network Routing](https://www.linkedin.com/learning/introduction-to-network-routing?u=3322)
    - Introduction
        - What runs over IP
    - Networking Model
        - The OSI Model
        - Routing Tools
    - Intro to IPv4 (Classful vs. classless, NAT and PAT)
    - Routing, Switching and Firewalls
        - Dynamic Routing (OSPF vs. BGP)
        - Static Routing
        - Firewalls (Proxies, State Table)

- [Virtual Network Routing](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview)

- [Firewalls](https://www.linkedin.com/learning/firewall-administration-essential-training-2?u=3322)
    - Intro
        - Types of Firewalls
    - Basic Firewall Configuration
        - Understand traditional firewalls
        - Understand Protocols (TCP, UDP, ICMP)
    - Advanced Firewall Configuration
        - Prevent local traffic from exiting to the internet
    - Configuration Case Studies
        - Understand proxies and SSL

- [Azure Firewall](https://docs.microsoft.com/en-us/azure/firewall/overview)
- [Azure Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview)

- [VPN](https://www.linkedin.com/learning/learning-vpn?u=3322)
    - Introduction
    - VPN Protocols
        - Terms and Basics
        - IKEv2
    - VPN Implementations
        - Appliances and multifunction devices
    - Troubleshooting tips

- [Azure VNG](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways)

## Success Criteria

1. You have an Azure shell at your disposal (Powershell, WSL(2), Mac, Linux or Azure Cloud Shell)
2. Visual Studio Code is installed.
3. Running `az login` or `Connect-AzAccount` allows to authenticate to Azure
4. You have reviewed foundational knowledge in the Networking 101 section
