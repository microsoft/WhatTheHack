# Challenge 0: Pre-requisites - Ready, Set, Go! - Coach's Guide

**[Home](./README.md)** - [Next Challenge>](./Solution-01.md)

## Notes & Guidance

Below are more details on the pre-requisites which you may wish to share with students if they have questions about the details of any one of these.

## Azure Subscription

You will need an Azure subscription to complete this hackathon. If you don't have one...

[Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)

Our goal in the hackathon is limiting the cost of using Azure services. 

If you've never used Azure, you will get:
- $200 free credits for use for up to 30 days
- 12 months of popular free services  (includes storage, Linux VMs)
- Then there are services that are free up to a certain quota

Details can be found here on [free services](https://azure.microsoft.com/en-us/free/).

If you have used Azure before, we will still try to limit cost of services by suspending, shutting down services, or destroying services before the end of the hackathon. You will still be able to use the free services (up to their quotas) like Azure App Service or Functions.

## Windows Subsystem for Linux

The Windows Subsystem for Linux (WSL) lets developers run Linux environments -- including most command-line tools, utilities, and applications -- directly on Windows, unmodified, without the overhead of a virtual machine.

WSL is an essential tool Azure admins should have on their workstations if they are running Windows! If you work with Linux servers in Azure (or anywhere), having access to WSL enables you to easily connect to them and use all the tools you're used to.

[Install the Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)

If you drive a Mac or Linux workstation, then you've already got Terminal access, carry on! :)

## Managing Cloud Resources

We can manage cloud resources via the following ways:

- Web Interface/Dashboard
  - [Azure Portal](https://portal.azure.com/)
- CLI
  - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  - [Azure PowerShell Cmdlets](https://docs.microsoft.com/en-us/powershell/azure/install-azurerm-ps)
- CLI within Web Interface
  - [Azure Cloud Shell (Bash)](https://shell.azure.com/bash)
  - [Azure Cloud Shell (PowerShell)](https://shell.azure.com/powershell)


### Azure Portal

Build, manage, and monitor everything from simple web apps to complex cloud applications in a single, unified console.

Manage your resources via a web interface (i.e. GUI) at [https://portal.azure.com/](https://portal.azure.com/)

The Azure Portal is a great tool for quick prototyping, proof of concepts, and testing things out in Azure by deploying resources manually. However, when deploying production resources to Azure, it is highly recommended that you an automation tool, templates, or scripts instead of the portal. 

**Note:** That's why you're participating in this "Infrastructure as Code" hackathon!

### Azure CLI

The Azure CLI is a cross-platform command-line tool providing a great experience for managing Azure resources. The CLI is designed to make scripting easy, flexibly query data, support long-running operations as non-blocking processes, and more. It is available on Windows, Mac, and Linux.

The Azure CLI will be the preferred (and supported) approach for this event, so please install the Azure CLI on your workstation. If you are not able to install the Azure CLI, or are using a workstation that is not your own, you can use the Azure CLI in the browser via the Azure Cloud Shell from the Azure Portal.

For Windows users, see the note below about how and where to install the Azure CLI!


- [Install on Windows](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest)
- [Install on macOS](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest)
- Install on Linux or Windows Subsystem for Linux (WSL)
  - [Install with apt on Debian or Ubuntu](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest)
  - [Install with yum on RHEL, Fedora, or CentOS](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-yum?view=azure-cli-latest)
  - [Install from script](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?view=azure-cli-latest)
- [Run in Docker container](https://docs.microsoft.com/en-us/cli/azure/run-azure-cli-docker?view=azure-cli-latest)

#### Note for Windows Users

The Azure CLI can be installed locally on Windows. If you do this, you will access and use the Azure CLI from the Windows Command Prompt or PowerShell Console.

While majority of the documentation should work fine locally on Windows, as you search the web for examples of how to use the Azure CLI, the examples frequently show Azure CLI commands used in Bash shell scripts. Bash shell scripts will not run in the Windows Command Prompt or PowerShell Console.

For this reason, we recommend using [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) for interacting with the Azure CLI. This means you should install the Azure CLI within your WSL environment by following the instructions for the Linux distro you are using.

Alternatively, you can use the [Azure Cloud Shell](https://shell.azure.com/bash). This is discussed shortly in the next section.

### Azure PowerShell CmdLets

Azure PowerShell provides a set of cmdlets that use the Azure Resource Manager model for managing your Azure resources. 

[Install the Azure PowerShell Cmdlets](https://docs.microsoft.com/en-us/powershell/azure/install-azurerm-ps)

The Azure PowerShell Cmdlets are functionally equivalent to the Azure CLI and can be used to complete all of the challenges instead of the Azure CLI. However, the Azure PowerShell Cmdlets are required for the PowerShell DSC challenges. 


### Azure Cloud Shell

The Azure Cloud Shell is a free interactive Bash or PowerShell shell that you can use to run the Azure CLI or PowerShell Cmdlets needed to complete the hackathon challenges. It has common Azure tools pre-installed and configured to use with your account. Just click the **Copy** button to copy the code, paste it into the Cloud Shell, and then press enter to run it.  There are a few ways to launch the Cloud Shell:

|  |   |
|-----------------------------------------------|---|
| Click **Try It** in the upper right corner of a code block. | ![Cloud Shell in this article](https://github.com/MicrosoftDocs/azure-docs/raw/master/includes/media/cloud-shell-try-it/cli-try-it.png) |
| Open Cloud Shell in your browser. | [![https://shell.azure.com/bash](https://github.com/MicrosoftDocs/azure-docs/raw/master/includes/media/cloud-shell-try-it/launchcloudshell.png)](https://shell.azure.com/bash) |
| Click the **Cloud Shell** button on the menu in the upper right of the [Azure portal](https://portal.azure.com). |	![Cloud Shell in the portal](https://github.com/MicrosoftDocs/azure-docs/raw/master/includes/media/cloud-shell-try-it/cloud-shell-menu.png) |
|  |  |


**Note:** If you use the Azure CLI or PowerShell from the Azure Cloud Shell, you will need to copy the template files you will be creating and editing on your workstation during the hackathon to the Cloud Shell environment.


## Visual Studio Code

Visual Studio Code is a lightweight but powerful source code editor which runs on your desktop and is available for Windows, macOS and Linux. It comes with built-in support for JavaScript, TypeScript and Node.js and has a rich ecosystem of extensions for other languages (such as C++, C#, Java, Python, PHP, Go) and runtimes (such as .NET and Unity).

[**Install Visual Studio Code**](https://code.visualstudio.com/)

VS Code runs on Windows, Mac, and Linux. Yes, Mac AND Linux!  It's a quick install, NOT a 2 hour install like its namesake full-fledged IDE tool on Windows.

### Visual Studio Code plugins for Bicep

VS Code is lightweight because there is an ecosystem of plugins that help provide support for many different programming languages and file types.  There are two plugins available which we recommend for creating and editing ARM templates in VS Code. We will be using these during the hackathon.

[**Bicep Plugin**](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)

This extension provides language support for Bicep and its language expressions.  It adds syntax color-coding support and intellisense for editing Bicep file in VS Code.

[**Bicep CLI**](https://github.com/Azure/bicep/blob/main/docs/installing.md)

 Compiles Bicep files into ARM templates. Cross-platform.
