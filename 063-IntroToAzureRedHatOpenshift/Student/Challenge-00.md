# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the Intro To Azure Red Hat OpenShift What The Hack. This session expects you to have a baseline understanding of Kubernetes (nodes, pods, services, etc). Before you can hack, you will need to set up some prerequisites. 

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
  - [VS Code plugin for ARM Templates](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code-plugins-for-arm-templates)

## Description

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specific to this hack.

**Something to keep in mind:** This hack can be completed entirely in Azure Cloud Shell! However, if you work with Azure often, you'll want to consider installing these tools locally even if you plan to use Cloud Shell today. Most of the hack can also be completed using the ARO Web Console inside your web browser (and some of the challenges will be MUCH easier using the ARO Web Console).

Your coach will provide two URLs pointing to two GitHub repositories that contain resources you will need to complete the hack. Copy the URLs and keep them saved as you will be using them in Challenge 2 of this hack.

## Additional Pre-requisites

- Install the [OpenShift CLI (Microsoft Docs)](https://docs.microsoft.com/en-us/azure/openshift/tutorial-connect-cluster#install-the-openshift-cli)
  - **NOTE:** If you are using Linux or Mac, you can also install the CLI using homebrew: [OpenShift CLI (Homebrew)](https://formulae.brew.sh/formula/openshift-cli)
- Obtain your Red Hat pull secret by navigating to [Red Hat Pull Secret](https://cloud.redhat.com/openshift/install/azure/aro-provisioned) and clicking Download pull secret. Keep this secret in the environment you will be hacking in.
  - **NOTE:** You can upload that file to Azure Cloud Shell by dragging and dropping the file into the window.
  - **NOTE:** You will need an account before you can obtain your Red Hat pull secret
- Minimum of 40 cores (VM Quotas):
  - Azure Red Hat OpenShift requires a minimum of 40 cores to create and run an OpenShift cluster. To check your current subscription quota of the smallest supported virtual machine family SKU `Standard DSv3`, run this command: `az vm list-usage -l $LOCATION --query "[?contains(name.value, 'standardDSv3Family')]" -o table`
  - If the limit is below 40, you will need to [Increase VM-family vCPU quotas](https://docs.microsoft.com/en-us/azure/azure-portal/supportability/per-vm-quota-requests)
  - **NOTE:** If the command above returns nothing, please register the Microsoft.Compute resource provider using the commands found further down on this page.
- To create an Azure Red Hat OpenShift cluster, verify the following permissions on your Azure subscription, Azure Active Directory user, or service principal:

| Permissions  | Resource Group which contains the VNet | User executing `az aro create` | Service Principal passed as `–client-id` |
| ------------- | ------------- | ------------- | ------------- |
| User Access Administrator | X | X | |
| Contributor  | X | X | X |
- Register the resource providers in your subscription:
```
# Register the Microsoft.RedHatOpenShift resource provider
az provider register -n Microsoft.RedHatOpenShift --wait

# Register the Microsoft.Compute resource provider
az provider register -n Microsoft.Compute --wait

# Register the Microsoft.Storage resource provider
az provider register -n Microsoft.Storage --wait

# Register the Microsoft.Authorization resource provider
az provider register -n Microsoft.Authorization --wait
```

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have a bash shell with the Azure CLI available
- Verify that your current subscription quota of the smallest supported virtual machine family SKU `Standard DSv3` has a limit of at least 40 cores using the command: `az vm list-usage -l $LOCATION --query "[?contains(name.value, 'standardDSv3Family')]" -o table`
- Verify that OpenShift CLI is installed using the command: `oc help`
- Demonstrate to your coach that you have a Red Hat pull secret

## Learning Resources

- [Azure Red Hat OpenShift](https://learn.microsoft.com/en-us/azure/openshift/intro-openshift)
- [Azure Red Hat OpenShift 4 Documentation](https://docs.openshift.com/aro/4/welcome/index.html)