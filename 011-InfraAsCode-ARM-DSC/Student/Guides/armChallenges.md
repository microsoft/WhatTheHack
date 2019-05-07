# What The Hack: IaC ARM Template Challenges

## Introduction 

Insert some stuff here setting up an intro to the challenges...
Challenges build on each other... etc...
Option to go in different orders depending on concepts being taught.

## Challenge 1 - "Hello World"

+ Develop an ARM template that accepts a generic input value and returns is as an output value.
    + Deploy it using the Azure CLI
    + Deploy it using the Azure PowerShell Cmdlets
    + Observe the deployment in the Azure Portal

    ### Key Takeaways

    + Core elements of an ARM Template and the different ways to deploy it.

## Challenge 2 - Deploy a Virtual Network
 
+	Extend the ARM template to provision a VNET w/one subnet 
    +	Template takes the following inputs - 
        +	Virtual Network Name and Address Prefix
        +	Subnet Name and Address Prefix
    +   Use a parameter file to pass in parameter values 

    ### Key Takeaways
    + Parameters and Parameter Files
    + How to find syntax for an Azure resource and add it to the template
 
## Challenge 3 - Open some ports
+	Extend the ARM template to open ports 80 and 22 and apply that rule to the subnet you created in Challenge 2.

    ### Key Takeaways
    + Variables, dependencies (Hint: Resource IDs) and idempotency

## Challenge 4 - Secret Values with Azure Key Vault

So far, the only parameters you have passed into your template have been related to the Virtual Network. In the next challenge you will deploy a VM which will require you to pass in a password for the VM's admin account.  It is an **ANTI-pattern** to put a secret value such as a password in plain text in a parameter file! NEVER do this!

### **Seriously, this is something that could cost you your job!**

It is a BEST practice to store secret values (such as passwords) in the Azure Key Vault service. We have provided you with a script that can create a Key Vault for you, and prompt you to enter the secret value (password) you want to store in it.

Create an Azure Key Vault and store a secret value in it by running one of the provided KeyVault scripts of your choice (Azure CLI or PowerShell)

Your challenge, should you accept it, is to:
+ Retrieve that secret value from Azure Key Vault and pass it into your template as a parameter!

    ### Key Takeaways

    + Handling secret values
    + Not getting fired!

**BONUS Challenge:** The goal of this challenge is focused on how to _retrieve_ secret values from Key Vault for use in an ARM Template. You can create an Azure Key Vault using an ARM Template too!  Feel free to try this as a bonus challenge later.

## Challenge 5 - Deploy a Virtual Machine

This is where the "choose your own adventure" part of this hackathon begins. If you want to skip to using PowerShell DSC for configuration management of a Windows VM, complete Challenge 5W, then divert to [PowerShell DSC Challenges](./dscChallenges.md).

If you do not plan on doing the PowerShell DSC Challenges, then continue doing the ARM Challenges with a Linux VM (Challenge 5L).

### Challenge 5W - Deploy a Virtual Machine (Windows)

+	Extend your ARM Template to deploy a VM
    +   VM requirements -
        +   Linux VM
        +   Apache website
        +   Pull website config from https://raw.githubusercontent.com/albertwo1978/training-events/master/p20-arm/scripts/install_apache.sh
    +   Key Takeaways - Customer script extensions, globally unique naming context and complex dependencies

### Challenge 5L - Deploy a Virtual Machine (Linux)

+	Extend ARM Template to deploy a webserver VM
    +   VM requirements -
        +   Linux VM
        +   Apache website
        +   Pull website config from https://raw.githubusercontent.com/albertwo1978/training-events/master/p20-arm/scripts/install_apache.sh
    +   Key Takeaways - Customer script extensions, globally unique naming context and complex dependencies
 
## Challenge 6

+	Extend ARM template to add Public Load Balancer and put Webserver in backend pool
    +   VM requirements -
        +   Create frontend pool enabling port 80 to website
    +   Key Takeaways - Resource ownership and dependencies
 
 ## Challenge 7
+	Extend ARM template to add NAT Rule to ILB for SSH access to backend
    +   Key Takeaways - Network access policies
 
 ## Challenge 8
+	Extend ARM template to replace VM with a VM Scale Set 
    +   VMSS requirements -
        +   Linux VM
        +   Convert NAT rule to NAT pool
    +   Key Takeaways - Scales sets provide scalability for Infrastructure in Azure

## Challenge 9
+	Extend ARM template to add a custom script extension that installs a web server packages/roles and deploy basic web app 
    +   VMSS requirements -
        +   Pull website config from https://raw.githubusercontent.com/albertwo1978/training-events/master/p20-arm/scripts/install_apache_vmss.sh
    +   Key Takeaways - Custom script extension does not lock deployment order

## Challenge 10
+	Extend ARM template to include auto scaling policy to scale when CPU performance hits 90%
    +   VMSS requirements -
        +   Scale back down when CPU performance hits 30%
        +   Scale in single VM increments
        +   Enforce a 1 minute cool down between scale events
    +   Key Takeaways - ARM allows declarative management of policies and actions

## Challenge 11 - Linked Templates  
+   Challenge 10 - Separate deployments into nested templates
    +   Minmum requirements -
        +   Separate virtual network and vmss into two linked subtemplates
    +   Key Takeaways - Linked templates allow for granular resource management and deployment

## Bonus Challenges
+	Create Log Analytics Workspace
 
+	Add Metrics to Workspace
 
+	Create Alerts based on Metrics
    +   https://github.com/Azure/azure-quickstart-templates/blob/6691996036fd095cee3d07336acfcba48110d268/201-web-app-sql-database/azuredeploy.json 

+	Deploy Jenkins and/or VSTS for CI/CD
 
+	Piece together previously created content into pipeline
 
+	Parameterize VM Names

