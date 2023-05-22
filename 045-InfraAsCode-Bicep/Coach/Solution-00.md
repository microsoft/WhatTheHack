# Challenge 00 - Pre-requisites - Ready, Set, Go! - Coach's Guide

**[Home](./README.md)** - [Next Challenge>](./Solution-01.md)

## Notes & Guidance

This hack is often delivered to organizations that are just getting started with managing Azure. While the focus is on how to manage Infrastructure-As-Code with Bicep, the students will also get familiar with Azure fundamentals.

Challenge 00 is all about ensuring the students have the tools in their toolbox to manage Azure and complete the hack's challenges. While this hack can be completed using the Azure Cloud Shell, it is highly recommended that students get the experience of installing all of the pre-requisite tools on their local workstation. This will better prepare them to continue working with Azure after the hack is over.

- It is common and OKAY if students spend 30-60 minutes getting all of the tools installed and configured properly. 
- Coaches should use the time while students are installing the tools to deliver the first lecture in the [IAC-Bicep-Lectures deck](WTH-IaC-Bicep-Lectures.pptx?raw=true).
- If students are completely new to Azure, coaches should demo the how to log in and navigate common commands with the Azure CLI.
  - `az login`
  - `az account list` - To Verify which subscription you are logged into
  - `az account set` - To set which subscription you are logged into
  - `az configure` - Change the default output format to "table" to make the output human readable.
  - Demonstrate how the `--help` parameter can be used to get instructions for any command. For example: `az vm --help`

## Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

The resource files include scripts and sample templates that will help students in some of the challenges.

## Prerequisite Options

Some organizations may block their users from installing software on their workstations, especially if it requires Administrator access. The Coach should share the [Challenge 00 pre-requisites](../Student/Challenge-00.md) with a stakeholder in the students' organization before hosting the hack.

If the organization blocks the installation of all or some software, there are multiple options you can consider:

- Have students with Windows devices skip installation of WSL, which requires Administrator access.
- Have students use an Azure Virtual Machine where they can install the prerequisite tools.
  - Students can create a Windows VM using the Azure Portal, then RDP into it to complete the hack. 
- Have students use a combination of Visual Studio Code on their workstation & the Azure Cloud Shell to access the Azure CLI or Azure PowerShell. For this scenario:
  - Coach's should ensure students are familiar with switching between editing files locally in VS Code, then uploading the files to the Azure Cloud Shell.
- Have students use only the Azure Cloud Shell to complete the hack. If using only Azure Cloud Shell:
  - Students will not get the rich Intellisense experience of the Bicep VS Code Extension.
  - Azure Cloud Shell times out after 20 minutes of inactivity. This can be disruptive during the hack.

## Gotchas

### Windows Subsystem for Linux + Azure CLI (Windows Users Only)

For Windows users, we recommend installing WSL first, and then installing the Azure CLI into the WSL environment as opposed to installing the Azure CLI on Windows itself. WSL + Azure CLI is recommended because:
  - Azure CLI examples often show it used within Bash scripts. Bash scripts cannot be run at the Windows Command Prompt or a PowerShell console. 
  - WSL provides easy access to Linux tools such as SSH, which make it easy to interact with Linux based resources in Azure (such as the Azure Kubernetes Service).

The following "gotchas" have been observed when installing WSL:
- WSL requires Administrator access to install on all versions of Windows. Some organizations do not provide this level of access for their users.  If this is the case, the student will not be able to install WSL.
- On Windows 10, some students struggle to install WSL as it requires multiple steps from different UIs, plus a reboot.
- On Windows 11, the WSL installation process was improved to be a single command to kick off. It still requires a reboot.

The following "gotchas" have been observed when installing the Azure CLI on WSL:
- If you have previously installed the Azure CLI on Windows and then install it in WSL, you will have two installations of the Azure CLI on your workstation. 
- You may need to restart your WSL instance so that WSL is set to use the Azure CLI instance installed in WSL, not the instance installed on Windows.
- You can verify which Azure CLI installation is being with the following command: `which az`
  - If you see `/usr/bin/az`, it is using the WSL install.
  - If you see `/mnt/c/Program Files (x86)/Microsoft SDKs/Azure/CLI2/wbin/az`, it is using the Windows install.
  - For more details see: https://github.com/Azure/azure-cli/issues/19517
- If you run into issues running Azure CLI commands on Windows, you may need to disable your VPN.

