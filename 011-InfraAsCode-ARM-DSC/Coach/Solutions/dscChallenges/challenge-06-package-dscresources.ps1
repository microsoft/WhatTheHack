##Challenge 6 Staging Steps + Snippets

#In order to use an external DSCResource, you need to install that module
#on your local workstation (or build server) and then package its files
#into the same archive file with your DSC script (.ps1 file).

#Use the following steps

# Step 1 - Install Module from PowerShell Gallery to your local machine
#  NOTE: Repeat this step for each external DSC Resource your script uses
Install-Module -Name xSmbShare 

# Step 2 - Verify Module is installed locally by getting a list of all
# installed PowerShell modules on local machine
Get-Module -ListAvailable 

# Step 3 - Package DSC script (.ps1 file) and any external DSC Resources into Archive file locally
#  NOTE: Run this from the location where your DSC (.ps1) file exists
#  NOTE: This script will package ALL referenced DSC Resources in your .ps1 file
Publish-AzureRmVMDscConfiguration ".\challenge-06-file-server-dsc.ps1" -OutputArchivePath ".\challenge-06-file-server-dsc.ps1.zip"

# Step 4 - Deploy DSC Archive file to artifact location in Azure Blob storage
#  NOTE: You can use the Publish-AzureRmVMDscConfiguration cmdlet to perform 
#        this step directly by specifying your storage account details via
#        the cmdlet's parameters.  See the following link for more info:
# https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/publish-azurermvmdscconfiguration?view=azurermps-6.2.0

# Alternatively, you can perform the above steps manually. 
## THIS IS NOT RECOMMENDED! ##

# Step 1 - Save the module from PS Gallery locally to a folder:
Save-Module -Name xSmbShare -Path <path>

# Step 2 - Create an archive file with your DSC script (.ps1 file) and the 
#          module's folder + contents.
#          NOTE: If you have multiple external DSC Resources, you need to include each
#          module's folder contents in the archive file at the same root level as the .ps1 file

# Step 3 - Manually copy the archive file to the artifact location in blob storage
