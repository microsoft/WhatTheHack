#!/bin/bash

# Bash script to find the Action Group id and then deploy the alert rules template
# Tip: Show the Integrated Terminal from View\Integrated Terminal or Ctrl+`
# Tip: highlight a line, press Ctrl+Shift+P and then "Terminal: Run Selected Text in Active Terminal" to run the line of code!

# Step 0: Test for the 'jq' program which will be needed
declare jqPath=$(which jq)
if [ ! -f $jqPath ] 
then 
  echo 'This script requires that the "jq" utility is installed and on your path'
  exit 1
fi

# Step 1: Use a name no longer then five charactors all LOWERCASE.  Your initials would work well if working in the same sub as others.
declare resourceGroupName="<resource group here>"

# Step 2: Get the Azure Monitor Action Group name and resource id
az resource list --resource-type 'Microsoft.Insights/actiongroups' -g $resourceGroupName -o json | jq '.[0] | {id: .id, name: .name}'

# Step 3: Update Path to files as needed
# Update the parameters file with the names of your VMs and the ResourceId of your Action Group (use command above to find ResourceId)
declare template="./GenerateAlertRules.json"
declare para="./deployAlertRules.parameters.json"

# Step 4: Kick off the deployment
declare job="job.$(date '+%Y%m%d.%H%m')"
az group deployment create --name $job -g $resourceGroupName --template-file $template --parameters @$para

# Step 5: To check your results - Get metricalerts Rule for Resourcegroup beginning with a name of "CPU"
az resource list --resource-type 'Microsoft.Insights/metricalerts' -g $resourceGroupName -o json | jq '.[] | select(.name|test("^CPU_"))'
