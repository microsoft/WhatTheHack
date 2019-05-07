# What The Hack: IaC ARM Template Challenges

## Introduction 

Insert some stuff here setting up an intro to the challenges...
Challenges build on each other... etc...
Option to go in different orders depending on concepts being taught.

## Challenge 1 - "Hello World"

+ Develop an ARM template that accepts a generic input value and returns it as an output value.
    + Deploy it using the Azure CLI
    + Deploy it using the Azure PowerShell Cmdlets
    + Observe the deployment in the Azure Portal

    ### Key Takeaways

    + Core elements of an ARM Template and the different ways to deploy it.
    + How & where to see & troubleshoot deployments in the portal

## Challenge 2 - Deploy a Virtual Network
 
+	Extend the ARM template to provision a VNET w/one subnet 
    +	The template should take the following inputs: 
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

It is a BEST practice to store secret values (such as passwords) in the Azure Key Vault service. We have provided you with a script that can create a Key Vault for you, and prompt you to enter the secret value (password) you want to store in the vault.

Your challenge, should you accept it, is to:
+ Create an Azure Key Vault and store a secret value in it by running one of the provided KeyVault scripts of your choice. You can find the scripts in the **/Resources/armChallenges** folder:
    + [create-key-vault-CLI.sh - Azure CLI](./Resources/armChallenges/create-key-vault-CLI.sh)
    + [create-key-vault-PS.ps1 - PowerShell](.Resources/armChallenges/create-key-vault-PS.ps1)   
+ Retrieve the secret value from Azure Key Vault and pass it into your template as a parameter without having the value exposed as plain text at any point in time!
    + Verify the value of the parameter in the portal after deployment

    ### Key Takeaways

    + Handling secret values
    + Not getting fired!

    ### **BONUS Challenge 5A:** 

    The goal of this challenge was focused on how to _retrieve_ secret values from Key Vault for use in an ARM Template. You can create an Azure Key Vault using an ARM Template too!  Feel free to try this as a bonus challenge later.

## Challenge 5 - Deploy a Virtual Machine

This is where the "choose your own adventure" part of this hackathon begins. If you want to skip to using PowerShell DSC for configuration management of a Windows VM, complete Challenge 5W, then divert to the [PowerShell DSC Challenges](./dscChallenges.md).

If you do not plan on doing the [PowerShell DSC Challenges](./dscChallenges.md), then continue doing the ARM Challenges with a Linux VM (Challenge 5L).

### Challenge 5W - Deploy a Virtual Machine (Windows)

+	Extend your ARM Template to deploy a VM
    +   VM requirements -
        +   Windows VM
        +   Use a secure secret value for the admin password
    + Use a resource prefix and template variables to have consistent naming of resources
    ### Key Takeaways 
    + Globally unique naming context and complex dependencies
    + Clean code with neat parameter/variable values
    + Figuring out what Azure resources it takes to build a VM!

### Challenge 5L - Deploy a Virtual Machine (Linux)

+	Same as Challenge 5W, except deploy a Linux VM!
    + **Note:** For a Linux VM, you can use an admin password or an SSH key to control access to the VM. It is common (and a recommended practice) to use an SSH key with Linux instead of an admin password. If you are not familiar with Linux, we recommend using an admin password for this hack to keep things simple and focus on learning ARM templates.

    ### Key Takeaways 
    + Globally unique naming context and complex dependencies
    + Clean code with neat parameter/variable values
    + Figuring out what Azure resources it takes to build a VM!

## Challenge 6 - Configure a Web Server

If you are continuing with the remaining ARM Template challenges, we assume you have deployed Linux VM in the last challenge.  The remaining challenges focus on extending the ARM template with more complex infrastructure around Linux VMs.

We have provided a script that configures a web server on a Linux VM. You can find the script in the **/Resources/armChallenges** folder: [install_apache.sh](.Resources/armChallenges/install_apache.sh)

Your challenge is to:

+ Extend the ARM Template to configure a webserver on the Linux VM you deployed
    + Pull website config from its source location in Github: https://raw.githubusercontent.com/Microsoft/WhatTheHack/011-InfraAsCode-ARM-DSC/Student/Resources/armChallenges/install_apache.sh
    + Verify you can view the web page configured by the script
    
    ### Key Takeaways 
    + Custom script extensions
    + Globally unique naming context and complex dependencies
 
    ### **Bonus Challenge 6A** - Use an Artifact Location
    + Host the script file in a secure artifact (staging) location that only is only accessible to the Azure Resource Manager.

        ### Key Takeaways
        + Hosting linked resources in a secure location such as Azure Blob Storage
        + Recognizing that if you skip this bonus challenge now, you'll have to do it later anyway! :)

## Challenge 7 - Implement High Availability

+	Extend ARM template to add Public Load Balancer and put Webserver in backend pool
    +   VM requirements -
        +   Create frontend pool enabling port 80 to website
        +   Ensure the VMs are highly available!
    ### Key Takeaways
    + Resource ownership and dependencies
 
 ## Challenge 8 - SSH to your Highly Available VMs
+	Extend ARM template to add NAT Rule to ILB for SSH access to backend
    + Verify you can SSH to your VMs
    ### Key Takeaways
    + Network access policies
 
 ## Challenge 9 - Deploy a VM Scale Set
+	Extend ARM template to replace VM with a VM Scale Set 
    +   VMSS requirements -
        +   Linux VM
        +   Convert NAT rule to NAT pool
    ### Key Takeaways
    + Scales sets provide scalability for Infrastructure in Azure

## Challenge 10 - Configure VM Scale Set to run a Web Server

We have provided a script that configures a web server on a Linux VM. You can find the script in the **/Resources/armChallenges** folder: [install_apache_vmss.sh](.Resources/armChallenges/install_apache_vmss.sh)

+	Extend ARM template to add a custom script extension that installs a web server packages/roles and deploy basic web app 
    +   VMSS requirements -
        +   Pull website config from its source location in Github: https://raw.githubusercontent.com/Microsoft/WhatTheHack/011-InfraAsCode-ARM-DSC/Student/Resources/armChallenges/install_apache_vmss.sh
    ### Key Takeaways
    + Custom script extension does not lock deployment order

    ### **Bonus Challenge 10A** - Use an Artifact Location
    + Host the script file in a secure artifact (staging) location that only is only accessible to the Azure Resource Manager.

        ### Key Takeaways
        + Hosting linked resources in a secure location such as Azure Blob Storage
        + Recognizing that if you skipped Bonus Challenge 6A, here's another opportunity to try it out.
        + Recognizing that you're going to need to do this for Challenge 12 anyway! :)

## Challenge 11 - Implement Auto Scaling
+	Extend ARM template to include auto scaling policy to scale when CPU performance hits 90%
    +   VMSS requirements -
        +   Scale back down when CPU performance hits 30%
        +   Scale in single VM increments
        +   Enforce a 1 minute cool down between scale events
    ### Key Takeaways
    + ARM allows declarative management of policies and actions

## Challenge 12 - Linked Templates  
+   Challenge 10 - Separate deployments into nested templates
    +   Minmum requirements -
        +   Separate virtual network and vmss into two linked subtemplates
    ### Key Takeaways
    + Linked templates allow for granular resource management and deployment

## Bonus Challenges
+	Create Log Analytics Workspace
 
+	Add Metrics to Workspace
 
+	Create Alerts based on Metrics
    +   https://github.com/Azure/azure-quickstart-templates/blob/6691996036fd095cee3d07336acfcba48110d268/201-web-app-sql-database/azuredeploy.json 

+	Deploy Jenkins and/or VSTS for CI/CD
 
+	Piece together previously created content into pipeline
 
+	Parameterize VM Names

