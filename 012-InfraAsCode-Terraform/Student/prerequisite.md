# Prerequisites for Terraform challenges

## Install Terraform and configure it to access Azure

Installation instructions can be found at the following URL

https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure


## Create SSH Key

Generate an SSH key pair. You will need this when you create your Linux VM. You can find a detailed instructions on how to create an SSH key pair at the URL below. 

https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-ssh-keys-detailed

## Setup Terraform access to Azure

Before you can enable Terraform to provision resources into Azure you will need to create a service principal. 

You can do this with the following Azure CLI commands:

az account show --query "{subscriptionId:id, tenantId:tenantId}"
az account set --subscription="${SUBSCRIPTION_ID}"
az ad sp create-for-rbac --query '{"client_id": appId, "secret": password, "tenant": tenant}'

You can either set environment variables or incorporate the values into your Terraform files. 
```Bash
#!/bin/sh

echo "Setting environment variables for Terraform"  
export ARM_SUBSCRIPTION_ID=your_subscription_id  
export ARM_CLIENT_ID=your_appId  
export ARM_CLIENT_SECRET=your_password  
export ARM_TENANT_ID=your_tenant_id  
```
OR  
```json
provider "azurerm" {  
  subscription_id = "<subscription id>"  
  client_id       = "<service principal app id>"    
  client_secret   = "<service principal password>"    
  tenant_id       = "<service principal tenant id>"    
}  
```
## Install Packer

Installation instructions can be found at the following URL

https://www.packer.io/docs/install/index.html
