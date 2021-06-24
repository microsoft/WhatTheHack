#PowerShell Commands to create an Azure Key Vault and deployment for Monitoring workshop
#Make sure to install the VS Code extension for PowerShell
#Tip: Show the Integrated Terminal from View\Integrated Terminal
#Tip: click on a line and press "F8" to run the line of code

#Make sure you are running the latest version of the Azure PowerShell modules, uncomment the line below and run it (F8)
# Install-Module -Name Az -Force -Scope CurrentUser -AllowClobber

#Step 1: Use a name no longer then five charactors all lowercase.  Your initials would work well if working in the same sub as others.
$monWorkShopName = 'your-initials-here'

#Step 2: Create ResourceGroup after updating the location to one of your choice. Use get-AzureRmLocation to see a list
Connect-AzAccount
New-AzResourceGroup -Name $monWorkShopName -Location 'East US'
$rg = get-AzResourcegroup -Name $monWorkShopName

#Step 3: Create Key Vault and set flag to enable for template deployment with ARM
$MonWorkShopVaultName = $monWorkShopName + 'MonWorkshopVault'
New-AzKeyVault -VaultName $MonWorkShopVaultName -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location -EnabledForTemplateDeployment

#Step 4: Add password as a secret.  Note:this will prompt you for a user and password.  User should be vmadmin and a password that meet the azure pwd police like P@ssw0rd123!!
Set-AzKeyVaultSecret -VaultName $MonWorkShopVaultName -Name "VMPassword" -SecretValue (Get-Credential).Password

#Step 5: Update azuredeploy.parameters.json file with your envPrefixName and Key Vault info example- /subscriptions/{guid}/resourceGroups/{group-name}/providers/Microsoft.KeyVault/vaults/{vault-name}
(Get-AzKeyVault -VaultName $MonWorkShopVaultName).ResourceId

#Step 6: Run deployment below after updating and SAVING the parameter file with your key vault info.  Make sure to update the paths to the json files or run the command from the same directory
#Note: Feel free to modify the ARM template to use a different VM Series.
New-AzResourceGroupDeployment -Name $monWorkShopName -ResourceGroupName $monWorkShopName -TemplateFile '.\VMSSazuredeploy.json' -TemplateParameterFile '.\azuredeploy.parameters.json'