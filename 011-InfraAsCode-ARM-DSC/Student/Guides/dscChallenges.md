DSC Challenges - 

This set of challenges focuses on Configuration Management of Windows Server using PowerShell Desired State Configuration (aka DSC).

It is suggested you follow ARM Challenges 1-3 for ARM template basics, then move on to challenge 4 here for the DSC challenges.

+	Challenge 4 - Extend your ARM template to deploy a VM
    +   VM Requirements
        +   Windows Server 2016 Datacenter
    +   Clean up parameters and variables - use resource prefix & variable name suffixes
    +   Key Takeaways - VM ARM configuration & dependencies

+	Challenge 5 - Simple DSC 
    +	Create a DSC script that creates 3 folders on the C:\ drive.
    +   Set up artifacts ("staging") location in Blob storage with SAS token
    +   Extend ARM template to deploy DSC extention onto the VM
    +   Add parameters for:
        +   Artifacts location 
        +   Artifacts location SAS token
        +   DSC script archive file name
        +   DSC script function name
    +   Key Takeaways
        +   Use built in DSC Resources on Windows Server
        +   Logistics to deploy DSC script to Windows VM via ARM template


+   Challenge 6 - File Server DSC
    +   Extend the DSC script by turning 3 folders into file shares
    +   Key Takeaways
        +   Use external DSC resources from PowerShell Gallery
        +   Logistics to import & deploy external DSC resources

Bonus
+	Use PowerShell cmdlet Publish-AzureRmVMDscConfiguration to package & publish the DSC script + external resources directly to staging location in Blob storage