# WTH Networking Coach notes

# Challenge 1:


# Challenge 2:


**- NSGs should be applied on each subnet.**

**- Verify the security rules are applied according to the requirements.**

**- The Finance department VM should not have a public IP address assigned.**

**- The application server VM should not have a public IP address assigned.**

# Challenge 3:


**- Application gateway v2 should be used for web servers.**

**- Autoscaling is enabled for Azure application gateway.**

**- Virtual machine scale sets should be used for web server backends.**

**- Virtual machine scale set is deployed across availability zones.**

**- Standard load balancer should be used for app servers. Backend servers can be VMs or VMSS.**

**- Standard load balancer should be used for finance application.**


# Challenge 4:


**- Sucessful deployment of a hub and spoke topology.**

**- Verify connectivity from on-premises vnet to Payment Solutions vnet.**

**- Verify connectivity from on-premises vnet to Finance vnet.**

**- VPN Site to site configuration between onpremises simulated virtual network and hub vnet.**

**- Dynamic routing should be configured for on-premises connectivity.**

# Challenge 5:


**- Sucessful deployment of Azure firewall in the hub vnet.**

**- Routes should direct traffic through the Azure firewall.**

**- The Azure virtual machine should be able to reach www.microsoft.com but not be able to reach youtube.com.**

**- WAFv2 firewall should be enabled on the Application gateway in Detection mode.**

**- Logging should be enabled for both Azure Firewall and Web Application firewall.**

**- Storage account used for logging should show firewall logs and web application logs.**

# Challenge 6:


**- NSGs do not have rdp and ssh ports open to the internet.**

**- You are successfully able to login to the virtual machine using Azure Bastion.**

**- Verify session status for the Bastion connection.**

**- Bastion diagnostics logs should be sent to the storage account.**

# Challenge 7:


**- Private Endpoint should be configured to access the storage account.**

**- No public access to the storage account should be allowed.**

**- The DNS resolution should be to the private edpoint IP for the storage.**

# Challenge 8:

**- Private Link service should be configured correctly.**

**- DNS resolution for the Payments service should resolve to private IP address.**




