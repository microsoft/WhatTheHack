Connect-AzureRmAccount

#Specify your resourcegroup
$rgname=""
$rg = Get-AzureRmResourceGroup -Name $rgname

#Get Azure Monitor Action Group
(Get-AzureRmResource -ResourceType 'Microsoft.Insights/actiongroups').ResourceId

#Update Path to files as needed
#Update the parameters file with the names of your VMs and the ResourceId of your Action Group (use command above to find ResourceId)
$template=".\AlertsTemplate\GenerateAlertRules.json"
$para=".\AlertsTemplate\deployAlertRules.parameters.json"

$job = 'job.' + ((Get-Date).ToUniversalTime()).tostring("MMddyy.HHmm")
New-AzureRmResourceGroupDeployment `
  -Name $job `
  -ResourceGroupName $rg.ResourceGroupName `
  -TemplateFile $template `
  -TemplateParameterFile $para


#Note: At the time I created this, the PowerShell cmdlet was targeting the wrong resourceType and is scheduled to be updated
#To check your results - Get metrixAlerts Rule for Resourcegroup
Get-AzureRmResource -ResourceGroupName $rg.ResourceGroupName -ResourceType 'Microsoft.Insights/metricalerts' -Name CPU*| ft

#To delete your Alert Rules
Get-AzureRmResource -ResourceGroupName $rg.ResourceGroupName -ResourceType 'Microsoft.Insights/metricalerts'  -Name CPU* | Remove-AzureRmResource -Force