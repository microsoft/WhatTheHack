
## Use Terraform to deploy Azure resources

Terraform is a tool (templating language) for building, changing, and versioning infrastructure safely and efficiently. Using Terraform, you can automate the tasks of building, changing and de-provisioning(destroy)the infrastructure

## Challenge 1
Create a resource group using Terraform. 

## Challenge 2 
Create an Azure Virtual Network using Terraform. The virtual network should have an address space of 10.1.0.0/16 and be named "WTHVNetTF". Add one subnet to it with an address range of 10.1.0.0/24 and name it "default"

## Challenge 3
Add a Network Security Group named WTHNSG with the following settings:
* Name: SSH
* Priority: 1001
* Direction: Inbound
* Access: Allow
* Protocol: Tcp
* source_port_range: *
* destination_port_range: 22
* source_address_prefix: * 
* destination_address_prefix: * 

## Challenge 4
Up to this point you have been putting in your values directly into your Terraform configuration file. Instead of doing that create a variables file, put in the values you used in the prior challenge in there and reference those variables. 

## Challenge 5
Create an Ubuntu VM in Azure. Use the latest version of Ubuntu. It's network card should be connected to the "default" subnet. Enable boot diagnostics for the VM. Use the SSH key you created in the prerequisites for authentication to the VM. 

## Challenge 6
Do whatever 
### Use Packer to Create an Ubuntu image with NGINX installed

In the packer template (vmNGINX_Packer.json) , update the azure service principal credentials (client_id, client_secret, and tenant_id) and azure subscription_id

Build the packer image using the following command. This will create an azure custom image in the resource group defined in the template

`packer build vmNGINX_Packer.json`

### Build and Deploy the VM using the Terraform Template

Terraform Template files:
    
    variables.tf 
    (This file contains values of the variables used in the template)
    
    linuxVM.tf  
    (This file contains the code of the infrastructure that you are deploying)

    output.tf
    (This file contains settings that needs to be displayed after the deployment)

Initialize Terraform 

`terraform init`

Validate the template 

`terraform plan`

if the validation is successful, apply the template

`terraform apply`

To clean up the environment created, use the following command

`terraform destroy`


## References

### Terraform Azure RM Provider

https://www.terraform.io/docs/providers/azurerm/


### Terraform on Azure Documentation

https://docs.microsoft.com/en-us/azure/terraform/





