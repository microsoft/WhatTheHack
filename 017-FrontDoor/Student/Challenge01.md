# Challenge 1 - Setup your Environment and Discover

 **[Home](../README.md)** - [Next Challenge [2] >](./Challenge02.md)

## Pre-requisites

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

## Introduction

In order for us to get started, let's talk a few basics.  Web Browsers are the general clients used to interact with Web Sites.  For a Web Browser to load a web site, generally you need the following:
- A Domain Name System (DNS) Name
  - This lets your Web Browser take ***www.contosomasks.com*** and turn that into an IP Address to then talk to.
- Something to host your content/website
  - There are lots of choices to run the application code and/or store the JavaScript, CSS, and HTML files.
  
When it comes to DNS, you have to register Names in what's called a "Domain".  For a DNS Name of www.contosomasks.com:
- contosomasks.com would be the Domain registered with a [Domain name registrar](https://en.wikipedia.org/wiki/Domain_name_registrar)
- **www** would be an *A Record* or a *CNAME Record* created in the contosomasks.com Domain
  - **A** Record - An alias record that is a name for a specific IP Address
  - [**CNAME** Record](https://en.wikipedia.org/wiki/CNAME_record) - A Canonical Name record that maps one name to another 

We're going to setup a copy of the original Contoso Masks website.  A link to deploy the [ARM (Azure Resource Manager) template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/overview) is in the **Tips** and with template located in the [Resources folder](./Resources) folder.  This will setup:

- An Azure DNS Zone with the definition of your own subdomain of contosomasks.com.  
  - This will let you have your own standalone public DNS to use for the challenges.
- Azure App Service hosting the **www** Web site of your instance of Contoso Masks.
  - The website will be auto-deployed to the App Service.

Once we get everything deployed, we will take some time and look to analyze the website using your Web Browser's developer tools.  

## Description

For this challenge we are going to:
1. Complete all the pre-requisites
2. Deploy the ARM Template, you will be required to specify:
   1. Resource Group (best to create a new one)
   2. Region to deploy to
   3. Sitename:  **IMPORTANT** - Must be unique identifier:
      1. Up to 13 characters long
      2. Must start with a lower case letter
      3. Next up to 12 characters can be either
         1. lower case character
         2. number
         3. dash '-'
3. In your Web Browser, load up your new copy of www.***SITENAME***.contosomasks.com, where ***SITENAME*** is that parameter you used in 2.iii.  Use the Development tools in the Web Browser to understand how the web pages and resources are loading, where they are coming from, and detail on how each requests loads.

## Deploy the Website 

Use the link below to deploy the solution to your resource group.

[![Deploy the to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmicrosoft%2FWhatTheHack%2Fmaster%2F017-FrontDoor%2FStudent%2FResources%2FChallenge00%2Fazuredeploy.json)

## Success Criteria

- Show that you can load w3af and display the help
  - Running w3af_console then the command **help**
- Show the newly deployed resources in the Azure Portal
  - Highlighting the **www** record in your new Azure DNS Zone
- Demonstrate your new version of the Contoso Website loads
- Show the "waterfall" of the one of the Images in the Dev Tools of your Web Browser 


## Learning Resources

- [Domain Name System (DNS)](https://en.wikipedia.org/wiki/Domain_Name_System)
- [Azure DNS Service](https://docs.microsoft.com/en-us/azure/dns/dns-overview)
- [How a Web Browser works (video)](https://youtu.be/DuSURHrZG6I)
- [Running w3af](http://docs.w3af.org/en/latest/basic-ui.html)
- [Microsoft Edge's Network Tools](https://docs.microsoft.com/en-us/microsoft-edge/devtools-guide-chromium/network/reference)
- [Google Chrome's Network Tools](https://developers.google.com/web/tools/chrome-devtools/network)
- [How does the Internet work? (video)](https://youtu.be/yJJHukw9Lyc)
  - [Other Languages available - "The Euro-IX Video"](https://www.youtube.com/channel/UCFyucVRAAMzxyJIsxnGwsjw)
- [How the Internet crosses the Ocean (English Only)](https://www.weforum.org/agenda/2016/01/how-does-the-internet-cross-the-ocean/)


