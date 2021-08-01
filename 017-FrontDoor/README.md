# The Internet just happened to my website! - Azure Front Door (1 day)

## Introduction

The Internet is much like water, in one hand an amazing thing that provides life/capability for so much, but in the other hand can be the most destructive force in nature.  Large numbers of users, large size and/or number of resources on pages, malicious activity, site slows down the further away it is, or events triggering massive spikes in traffic are only a few of the problems **Azure Front Door** addresses.  This challenge based hack is intended to teach you how to evolve a simulated local web site (https://www.contosomasks.com) into a globally accelerated, protected web site with burst offset.

## Learning Objectives
In this hack you will be solving the common problem that websites have with the Front Door services from Azure:

1. Provision an Azure Front Door and set up SSL
2. Provision and Configure Web Application Firewall (WAF)
3. Configure simple/complex routing rules and caching rules
4. Provision a Static Web site with an Azure Storage Account
5. Discover and Monitor traffic and WAF insights thru Log Analytics

## Challenges
1. [Setup your Environment and Discover](Student/Challenge01.md)
   - Create Azure resources and leverage your Browser's Dev Tools to analyze the Website
2. [Provision your Front Door](Student/Challenge02.md)
   - Create a Front Door account with custom DNS and SSL
3. [Provision a Web Application Firewall (WAF)](Student/Challenge03.md)
   - Create a Web Application Firewall Policy and guard your site!
4. [Offload traffic for a high traffic event](Student/Challenge04.md)
   - Use a Static Web Site in Azure Storage and route specific traffic to it.
5. [Cache Static Assets](Student/Challenge05.md)
   - Use the Rules Engine in Front Door to cache some of the resources of your site

## Prerequisites
- Your own Azure subscription with Owner access
  - Or a Resource Group with Contributor access and ability to manage [Resource Providers](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types)
- Linux Instance, can be either:
  - Running Windows Subsystem for Linux (WSL) 1.0 or 2.0
  - Running on Mac
  - Running a Linux VM in Azure ([link](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-portal))
- Install [w3af](https://docs.w3af.org/en/latest/index.html) on that Linux Instance ([link](https://docs.w3af.org/en/latest/install.html))
  - This will be used to exercise the WAF
  - Just need the console version running
- Some form of Chromium Web Browser installed
  - [Microsoft Edge](https://www.microsoft.com/en-us/edge)
  - [Google Chrome](https://www.google.com/chrome/)
  
## Repository Contents
- ./Coach/Resources/ContosoMasks.com
  - Code for the website that Front Door will refer to
- ./Coach/images
  - Images for the coach's guide
- ./Student/Resources
  - code and templates needed for challenges.
- ./Student/images
  - Images for the student's guide

## Contributors
- Andy Wahrenberger



