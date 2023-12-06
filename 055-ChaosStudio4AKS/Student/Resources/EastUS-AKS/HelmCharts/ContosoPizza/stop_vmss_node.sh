
# Stop the VMSS that hosts the AKS nodes to stop incurring compute charges. There are only two VMSS in the resource group -one each for system and userpool.
# Change the value of the resource group, if required. 

export vmss_user=$(az vmss list -g MC_PizzaAppEast_pizzappeast_eastus --query '[].name' | grep userpool | tr -d "," | tr -d '"')
export vmss_system=$(az vmss list -g MC_PizzaAppEast_pizzaappeast_eastus --query '[].name' | grep systempool | tr -d "," | tr -d '"')

# Now stop the VM scale sets

az vmss stop -g MC_PizzaAppEast_pizzaappeast_eastus -n $vmss_user
az vmss stop -g MC_PizzaAppEast_pizzaappeast_eastus -n $vmss_system
