# Usage Guide for V2

This document aims to describe the basic process to get started with V2 of the codebase.
It does not go into detail about how to customize the code, but instead focuses on demonstrating the end-to-end lifecycle.

## Prerequisites

The code is designed to be used from a Unix-based OS such as MacOS, Linux, Cygwin, or Windows Subsystem for Linux.
There are several options available:

1. Use your local workstation's OS directly
1. Use a Linux-based VM running on your local workstation (e.g. VirtualBox/Vagrant)
1. Use a Linux-based VM running in Azure
1. Use the Azure Cloud Shell

Depending on the OS option you choose, you may need to install/upgrade certain tools.

You also need some familiarity with using the following technologies/tools:

1. Linux command line
1. Git (ideally command line)
1. Azure portal
1. SAP Launchpad (login credentials required for SAP software downloads)

### Obtaining the Code

Before continuing you should first obtain a copy of the code, so that you can use the utility scripts provided.

**Note:** Currently, the utility scripts are only available for Linux/MacOS workstations. If you are interested in Windows support, then please upvote (:thumbsup:) the issue [Add utility scripts for Windows](https://github.com/Azure/sap-hana/issues/289).

1. On the Linux command line, navigate to the directory you wish to clone the code within.
   This directory will be the parent directory of the directory containing the code. For example:

   ```text
   cd ~/projects/
   ```

   **Note:** Ensure you choose a directory without any spaces in its absolute path, to avoid potential future issues with tooling that might not handle this setup.

1. Clone this repository from GitHub. For example:

   ```text
   git clone https://github.com/Azure/sap-hana.git
   ```

   **Note:** See [Cloning a repository](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository) if you are not familiar with this process.

1. Navigate into the project root directory. For example:

   ```text
   cd sap-hana
   ```

   **Note:** All of the following process steps should be run from the project root directory.

### Checking Tool Dependencies

Running the code requires the following tools with the minimal supported/tested versions:

| Tool      | Minimum Version Supported / Tested |
|-----------|------------------------------------|
| Azure CLI | 2.0.63                             |
| Terraform | 0.12.12                            |
| Ansible   | 2.8.1 (see note below)             |

1. To easily check which tool versions you have installed, run the following utility script:

   ```text
   util/check_workstation.sh
   ```

   Example output:

   ```text
   azure-cli = 2.0.77
   Terraform = 0.12.16
   ansible = 2.8.4
   ```

   **Note:** Ansible is only a prerequisite of the workstation if you opt to split the Terraform and Ansible stages, and intend to run Ansible from your workstation rather than the runtime instance (RTI) in Azure.

### Configuring the Target Azure Subscription

Before running any of the following code/scripts, you should login to the Azure CLI and always ensure you are configured to work with the correct Azure subscription.

1. To login to the Azure CLI, run the following command and follow the guided login process:

   ```text
   az login
   ```

   **Note:** If you have access to multiple subscriptions you may need to use the following type of command to select the desired target subscription:

   ```text
   az account set --subscription <subscription name or id>
   ```

1. To easily check which Azure subscription is your current target, run the following utility script:

   ```text
   util/check_subscription.sh
   ```

   Example output:

   ```text
   Your current subscription is MyOrg Azure Subscription (ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)
   ```

### Configuring Authorization with Azure

In order for Terraform/Ansible to manage resources in Azure, a _Service Principal_ is required.
The following process creates a new service principal in Azure, and stores the details required in an authorization script on the local workstation.
This script can then be used (_sourced_) to configure the required environment variables on the local workstation that allows Terraform/Ansible to run without prompting the user for further authentication information.

1. To easily create the service principal and authorization script, run the following command providing the name you wish to give the service principal as the only command line argument (here the name `sp-eng-test` is used):

   ```text
   util/create_service_principal.sh sp-eng-test
   ```

   Example output:

   ```text
   Creating Azure Service Principal: sp-eng-test...
   Changing "sp-eng-test" to a valid URI of "http://sp-eng-test", which is the required format used for service principal names
   Creating a role assignment under the scope of "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
     Retrying role assignment creation: 1/36
     Retrying role assignment creation: 2/36
   A service principal has been created in Azure > App registrations, with the name: sp-eng-test
   Azure authorization details can be found within the script: set-sp.sh
   The Azure authorization details are automatically used by the utility scripts if present.
   ```

 **Note:** The generated authorization script contains secret information, which you should store and secure appropriately.

### Configuring Deployment Template

The SAP environments deployed by this codebase are configured by JSON input files.
These configuration files provide a high degree of customization for the user, but can be a little daunting if you are new to the codebase.
Therefore example configuration files have been supplied with the code.

The minimal amount of change required to an example configuration file is to configure your SAP Launchpad credentials so that the code can automatically login and download the required SAP packages to install.

Configuring your SAP Launchpad credentials for a JSON template requires you to provide your SAP user and password to another utility script. This needs to be done for each template you intend to deploy.

1. Run the following utility script to configure your SAP download credentials:

   ```text
   util/set_sap_download_credentials.sh <sap_user> <sap_password> <template_name>
   ```

   **Note:** If your SAP Launchpad password has spaces in, you will need to enclose it in double quotes.

   **Note:** The current templates are located in `deploy/v2/template_samples/` and you do not need to specify the `.json` extension.

You can programatically set the deployment's resource group name in Azure using another utility script.  This needs to be done for each template you intend to deploy.

1. Run the following utility script to configure your deployment resource group name:

   ```text
   util/set_resource_group.sh <resource_group_name> <template_name>
   ```

   **Note:** You can avoid this step by setting the environment variable `SAP_HANA_RESOURCE_GROUP` to your desired resource group name.
   This can be done in any of the standard ways, such as:

     - Setting in your current terminal session (e.g. `export SAP_HANA_RESOURCE_GROUP="rg-sap-hana-dev"`)
     - Setting as a prefix of your script command (e.g. `SAP_HANA_RESOURCE_GROUP="rg-sap-hana-dev" util/terraform_v2.sh plan single_node_hana`)
     - Setting in your dot files (e.g. in `.bash_profile`)

   In any case, this opens up scope for programatically setting the HANA deployment resource group using something personal to your user (e.g. $USER variable), which helps to avoid clashes with others that might be sharing the same Azure subscription.

In HA systems, you must set the password to be used for the cluster user in the template you intend to deploy. You can programatically set this using a utility script:

1. Run the following utility script to configure the `hacluster` user password:

   ```text
   util/set_ha_cluster_password.sh <ha_cluster_password> <template_name>
   ```

   **Note:** This value will only be used in deployments where the SAP HANA Database definition has `high_availability` set to `true`.

## Build/Update/Destroy Lifecycle

In the following steps you will need to substitute a `<template_name>` for the template. To see the currently available tempaltes, run:\
`util/terraform_v2.sh`

1. If you are provisioning a clustered system, then you must first create a fencing agent service principal for the SAP HANA SID you are provisioning.
   To easily create the service principal and authorization script, run the following command providing the HANA SID you wish to be included in the service principal name as the only command line argument (here the SID `HN1` is used):

   ```text
   util/create_fencing_agent.sh HN1
   ```

   Example output:

   ```text
   Creating Azure Service Principal: sap-hana-HN1-fencing-agent...
   Changing "fencing-agent-T0D" to a valid URI of "http://sap-hana-HN1-fencing-agent", which is the required format used for service principal names
   Creating a role assignment under the scope of "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
     Retrying role assignment creation: 1/36

   A role has been created in the Azure subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx, with the name: sap-hana-HN1-fencing-agent
   A fencing agent has been created in Azure > App registrations, with the name: sap-hana-HN1-fencing-agent
   The role has been assigned to the fencing agent
   The fencing agent authorization details can be found within the script: set-clustering-auth-HN1.sh
   The authorization details are copied to the RTI during Terraform provisioning for usage by Ansible.
   ```

1. To easily initialize Terraform, run the following utility script:

   ```text
   util/terraform_v2.sh init
   ```

1. To easily check which resources will be deployed, run the following utility script:

   ```text
   util/terraform_v2.sh plan <template_name>
   ```

1. To easily discover which operating systems can be used to build HANA VMs, run the following utility script withput parameters:

   ```text
   util/set_sap_os.sh
   ```

   :information_source: The specific versions of operating systems which are tied to the "convenience names" are defined in the `util/sap_os_offers.json` file. The names "SLES" and "RHEL" are preset to match the more specific `sles12sp5` (`offer: sles-sap-12-sp5`, `sku: gen1`) and `redhat76` (`offer: RHEL-SAP-HA`, `sku: 7.6`) respectively.

1. To easily choose which operating system will be used to build HANA VMs, run the following utility script with the required SAP OS chosen from the above list:

   ```text
   util/set_sap_os.sh <SAP OS> <template name>
   ```

1. To easily deploy the system, run the following utility script with an input template name (e.g. `single_node_hana`):

   ```text
   util/terraform_v2.sh apply <template_name>
   ```

   **Note:** This process can take in the region of 90 minutes to complete.
   Particularly slow stages are:

     - `Installing OS package` (~5 minutes)
     - `Download installation media` (~5 minutes)
     - `Extract media archive` (~15 minutes)
     - `Install HANA Database using hdblcm` (~10 minutes)
     - `Install XSA components` (~35 minutes)
     - `Install SHINE` (~10 minutes)

1. To review/inspect the provisioned resources navigate to the `test_rg` resource group of your configured Azure subscription in Azure portal.
   By default, all the provisioned resources (excluding the service principal) are deployed into the same resource group.

1. To easily delete the provisioned resources, run the following utility script with an input template name (e.g. `single_node_hana`):

   ```text
   util/terraform_v2.sh destroy <template_name>
   ```

1. To easily clean up the working directries and files, run the following utility script:

   ```text
   util/terraform_v2.sh clean
   ```

   :hand: This is a destructive and irreversible process. It list which files are to be removed, and will ask for confirmation.

## Summary

The following illustrates an example summary of the commands and processes required:

```bash
# Obtain the Code: Takes about 2 minutes and is performed once
cd ~/projects/
git clone https://github.com/Azure/sap-hana.git
cd sap-hana

# Check Tool Dependencies: Takes under a minute and is performed once
util/check_workstation.sh

# Configure Target Azure Subscription: Tales under a minute and is performed once per subscription
az login
util/check_subscription.sh

# Configure Azure Authorization: Takes under a minute and is performed once per subscription
util/create_service_principal.sh sp-eng-test

# Configure Deployment Template: Takes under a minute and is performed once per SAP system build
util/set_sap_download_credentials.sh S123456789 MySAPpass single_node_hana

# Build/Update Lifecycle: Takes about 90 minutes and is performed once per SAP system build/update

# For Clustered systems Provision Fence Agent Service Principal
util/create_fenching_agent.sh HN1
util/terraform_v2.sh init
util/terraform_v2.sh apply single_node_hana

# Destroy Lifecycle: Takes about 15 minutes and is performed once per SAP system build
util/terraform_v2.sh destroy single_node_hana
```
