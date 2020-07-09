USER=admin_$RANDOM #set this to whatever you like but it's not something that should be easy
PASS=$(uuidgen) #Again - whatever you like but keep it safe! Better to make it random
LOCATION=westus
STORAGENAME=tailwind$RANDOM #this has to be unique across azure
SKU=Standard_LRS
APPNAME=tailwind-reports

echo "Enter the name of a Resource Group to use. If it doesn't exist, we'll create it."
read RG

echo
echo "...working"
echo

az group create -n $RG -l $LOCATION

echo
echo "Creating Storage Account $STORAGENAME in group $RG"
echo

az storage account create --name $STORAGENAME --location $LOCATION --resource-group $RG --sku $SKU

echo
echo "Done. Getting your connection string..."
echo

az storage account show-connection-string -n $STORAGENAME

echo
echo "All done. Copy the above connection string into the 'AzureWebJobs' key in your 'local.settings.json' file."
