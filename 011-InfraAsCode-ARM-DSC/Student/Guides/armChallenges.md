WTH - Infrastructure As Code with ARM Templates

Challenges - 

Insert some stuff here setting up an intro to the challenges...
Challenges build on each other... etc...
Option to go in different orders depending on concepts being taught.


Day 1-2 Challenges:
+	Challenge 1 - “Hello World” – ARM template that accepts generic input and passes it as output
    +   Key Takeaways - Core Elements of an ARM Template and the Different ways to deploy 
 
+	Challenge 2 - Extend ARM template to provision VNET w/ one subnet 
    +	Template takes the following inputs - 
        +	Virtual Network Name and Address Prefix
        +	Subnet Name and Address Prefix
    +   Key Takeaways - Parameters and Parameter Files
 
+	Challenge 3 - Extend ARM template to opening ports 80 and 22 and apply to the default subnet
    +   Key Takeaways - Variables, dependencies and idempotency

Note: If you want to skip to using PowerShell DSC for configuration management of a Windows VM, divert to Challenge 4 in the "dscChallenges" folder.

+	Challenge 4 - Extend ARM Template to deploy a webserver VM
    +   VM requirements -
        +   Linux VM
        +   Apache website
        +   Pull website config from https://raw.githubusercontent.com/albertwo1978/training-events/master/p20-arm/scripts/install_apache.sh
    +   Key Takeaways - Customer script extensions, globally unique naming context and complex dependencies
 
+	Challenge 5 - Extend ARM template to add Public Load Balancer and put Webserver in backend pool
    +   VM requirements -
        +   Create frontend pool enabling port 80 to website
    +   Key Takeaways - Resource ownership and dependencies
 
+	Challenge 6 - Extend ARM template to add NAT Rule to ILB for SSH access to backend
    +   Key Takeaways - Network access policies
 
+	Challenge 7 - Extend ARM template to replace VM with a VM Scale Set 
    +   VMSS requirements -
        +   Linux VM
        +   Convert NAT rule to NAT pool
    +   Key Takeaways - Scales sets provide scalability for Infrastructure in Azure

+	Challenge 8 - Extend ARM template to add a custom script extension that installs a web server packages/roles and deploy basic web app 
    +   VMSS requirements -
        +   Pull website config from https://raw.githubusercontent.com/albertwo1978/training-events/master/p20-arm/scripts/install_apache_vmss.sh
    +   Key Takeaways - Custom script extension does not lock deployment order

+	Challenge 9 - Extend ARM template to include auto scaling policy to scale when CPU performance hits 90%
    +   VMSS requirements -
        +   Scale back down when CPU performance hits 30%
        +   Scale in single VM increments
        +   Enforce a 1 minute cool down between scale events
    +   Key Takeaways - ARM allows declarative management of policies and actions

Bonus
+	Create Log Analytics Workspace
 
+	Add Metrics to Workspace
 
+	Create Alerts based on Metrics
    +   https://github.com/Azure/azure-quickstart-templates/blob/6691996036fd095cee3d07336acfcba48110d268/201-web-app-sql-database/azuredeploy.json 
 
Day 3 Challenges:  
+   Challenge 10 - Separate deployments into nested templates
    +   Minmum requirements -
        +   Separate virtual network and vmss into two linked subtemplates
    +   Key Takeaways - Linked templates allow for granular resource management and deployment

+	Deploy Jenkins and/or VSTS for CI/CD
 
+	Piece together previously created content into pipeline
 
+	Parameterize VM Names

