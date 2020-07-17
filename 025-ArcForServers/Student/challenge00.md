# What the Hack: Azure Arc for Servers 

## Challenge 0 - Setup
[Home](../readme.md) - [Next](challenge01.md)

### Introduction

Azure Arc for Servers is a set of tools and technology that covers a wide variety of use cases and technical scenarios. To successfully complete the Azure Arc for Servers challenges, you will need to have:

* A local computer to install and use various applications and tools such as VSCode, ssh, etc.

* Access to one or more non-production servers, preferably servers that are not hosted directly in Azure already. 

* Access to an Azure subscription with sufficient RBAC permissions to create and manage resources

There are many tools available on various platforms that can help in completing the hack, and one student's path to completion may ultimately use a different toolset to accomplish the same result. However, if you are not sure where to start, this preliminary challenge will help ensure that you have the minimum requirements setup on your local computer and cloud environment.  

### Challenge

In this challenge we will setup many of the core components needed to complete this What the Hack. 

*Note: [Azure Arc for Servers](https://docs.microsoft.com/en-us/azure/azure-arc/servers/overview) allows customers to use Azure management tools on any server running in any public cloud or on-premises environment. To get the most out of this hack, you will need to deploy a server in an environment that is not Azure. There are many ways that this can be accomplished, such as deploying to another public cloud like Google Cloud or AWS, or creating a VM on your laptop or other device with virtualization software such as Virtual Box, Hyper-V, or VMware.*

* Create an [Azure](https://azure.microsoft.com/) Subscription that you can use for this hack. If you already have a subscription you can use it or you can get a free trial [here](https://azure.microsoft.com/free/). Do not use a subscription with any production resources in it. 

* Log into the [Azure Portal](https://portal.azure.com) and confirm that you have an active subscription that you can deploy cloud services to.

* Download and install [Git SCM](https://git-scm.com/download) if you don't have it or a similar Git client installed

* Download and install [Visual Studio Code](https://code.visualstudio.com) if you don't already have it or a similar tool installed.

* Choose which type of non-Azure environment you will use to deploy servers for the hack challenges. Some options include deploying a server to a public cloud other than Azure, or deploying servers on a laptop or other device with virtualization software.
   

### Success Criteria

1. You should be able to log in to the Azure Portal and create, modify, and destroy resources in your subscription.

2. You should have a working dev environment with Visual Studio Code 
   
[Home](../readme.md) - [Next](challenge01.md)

### Hints

https://github.com/microsoft/azure_arc