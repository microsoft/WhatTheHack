#PowerShell Commands to create an Azure Key Vault and deployment for the WTH Infra As Code Hackathon
#Make sure to install the VS Code extension for PowerShell
#Tip: Show the Integrated Terminal from View\Integrated Terminal
#Tip: click on a line and press "F8" to run the line of code

#Make sure you are running the latest version of the Azure PowerShell modules, uncomment the line below and run it (F8)
# Install-Module -Name AzureRM -Force -Scope CurrentUser -AllowClobber

#Step 1: Use a name no longer then five charactors all lowercase.  Your initials would work well if working in the same sub as others.
$iacHackName = 'wth-iac'

#Step 2: Create ResourceGroup after updating the location to one of your choice. Use get-AzureRmLocation to see a list
Connect-AzureRmAccount
New-AzureRMResourceGroup -Name $iacHackName -Location 'East US' #<== make sure this is the same location you are deploying your template to!
$rg = get-AzureRmresourcegroup -Name $iacHackName

#Step 3: Create Key Vault and set flag to enable for template deployment with ARM
$iacHackVaultName = $iacHackName + '-KeyVault'
New-AzureRmKeyVault -VaultName $iacHackVaultName -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location -EnabledForTemplateDeployment

#Step 4: Add password as a secret.  Note:this will prompt you for a user and password.  User should be vmadmin and a password that meet the azure pwd police like P@ssw0rd123!!
Set-AzureKeyVaultSecret -VaultName $iacHackVaultName -Name "adminPassword" -SecretValue (Get-Credential).Password

#Step 5: Update azuredeploy.parameters.json file with your envPrefixName and Key Vault info example- /subscriptions/{guid}/resourceGroups/{group-name}/providers/Microsoft.KeyVault/vaults/{vault-name}
(Get-AzureRmKeyVault -VaultName $iacHackVaultName).ResourceId