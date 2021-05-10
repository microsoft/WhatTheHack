Connect-AzAccount

#Specify your resourcegroup
$rgname="your-resourcegroupName-here"
$rg = Get-AzResourceGroup -Name $rgname

#Get Azure Monitor Action Group
(Get-AzActionGroup -ResourceGroup $rgname).Id

#Update Path to files as needed
#Update the parameters file with the names of your VMs and the ResourceId of your Action Group (use command above to find ResourceId)
$template=".\AlertsTemplate\GenerateAlertRules.json"
$para=".\AlertsTemplate\deployAlertRules.parameters.json"

$job = 'job.' + ((Get-Date).ToUniversalTime()).tostring("MMddyy.HHmm")
New-AzResourceGroupDeployment `
  -Name $job `
  -ResourceGroupName $rg.ResourceGroupName `
  -TemplateFile $template `
  -TemplateParameterFile $para

#To check your results - Get metric Alerts Rule for Resourcegroup
(Get-AzMetricAlertRuleV2 -ResourceGroupName $rg.ResourceGroupName).Name

#To delete your Alert Rules
Get-AzMetricAlertRuleV2 -ResourceGroupName $rg.ResourceGroupName | Remove-AzMetricAlertRuleV2
