
## Use Terraform to deploy Azure resources

Terraform is a tool (templating language) for building, changing, and versioning infrastructure safely and efficiently. Using Terraform, you can automate the tasks of building, changing and de-provisioning the infrastructure

## Challenge 1: Create a Resource Group
Create an Azure resource group using Terraform. It will hold all of the Azure resources you will use in subsequent challenges. You will need to run a few Terraform commands to do this like init, plan and apply. 

## Challenge 2: Create a Virtual Network
Create an Azure Virtual Network using Terraform. The virtual network should have an address space of 10.1.0.0/16 and be named "WTHVNetTF". Add one subnet to it with an address range of 10.1.0.0/24 and name it "default"

## Challenge 3: Create a Network Security Group
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

## Challenge 4: Put values into a separate variables file
So far you have been putting in your values directly into your Terraform configuration file. This is not usually a best practice. Instead of doing that create a separate Terraform variables file, put in the values you used in the prior challenge in there and reference those variables in the Terraform configuration file. 

## Challenge 5: Create an Ubuntu VM
Create an Ubuntu VM in Azure using Terraform. Use the latest version of Ubuntu. Its network card should be connected to the "default" subnet. Enable boot diagnostics for the VM. Use the SSH key you created in the prerequisites for authentication to the VM. Create a public IP Address for the VM. For security purposes it is recommended that your Network Security Group only allow your SSH's client public IP address. You can find your public IP address at <https://www.terraform.io/docs/providers/azurerm/r/public_ip.html> or if you are using Azure CloudShell, you can do: 
```bash
curl http://ifconfig.me
```

## Challenge 6: Use Packer to Create an Ubuntu image with NGINX installed

In this challenge you will build a custom image that already has the NGINX web server already installed. You will need to build a Packer template JSON file. You should have downloaded Packer during the prerequisites section. In this template you define the builders and provisioners that do the build process. You will need to include the Azure service principal credentials (client_id, client_secret, and tenant_id) and Azure subscription_id that you used earlier. In addition to installing NGINX using apt, it would be a good idea to update the VM using apt. 

Once this is done you will need to build the Packer image which will create a custom Ubuntu image.

Modify the Terraform configuration file you created in the last challenge to reference the Packer image instead. Add a Network Security Group to allow port 80. 

Test that NGINX is installed by opening your browser to the public IP address of the VM. You should see:

    Welcome to nginx!
    If you see this page, the nginx web server is successfully installed and working. Further configuration is required.

    For online documentation and support please refer to nginx.org.
    Commercial support is available at nginx.com.

Thank you for using nginx.

## References

- Terraform Azure RM Provider
    - <https://www.terraform.io/docs/providers/azurerm>

- Terraform on Azure Documentation
    - <https://docs.microsoft.com/en-us/azure/terraform>




