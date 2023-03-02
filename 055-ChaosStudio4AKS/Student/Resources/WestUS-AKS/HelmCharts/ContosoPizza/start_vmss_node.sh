
# Start the VMSS that hosts the AKS nodes. There are only two VMSS in the resource group -one each for systempool and userpool.
# Change the value of the resource group, if required. 

export vmss_user=$(az vmss list -g MC_PizzaAppWest_pizzaappwest_westus --query '[].name' | grep userpool | tr -d "," | tr -d '"')
export vmss_system=$(az vmss list -g MC_PizzaAppWest_pizzaappwest_westus --query '[].name' | grep systempool | tr -d "," | tr -d '"')

# Now start the VM scale sets

az vmss start -g MC_PizzaAppWest_pizzaappwest_westus -n $vmss_system
az vmss start -g MC_PizzaAppWest_pizzaappwest_westus -n $vmss_user
