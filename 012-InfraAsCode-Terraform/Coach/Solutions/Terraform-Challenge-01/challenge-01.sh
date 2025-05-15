# If self-deploying the challenges, recommend adding a prefix or suffix to Azure resources.
# For example, resourceGroupName = "<my initials>-challenge-01-rg"

##### PART 1 ###############

SUFFIX='lnc01'
LOCATION='westus3'
RG="tfstate-${SUFFIX}"
SANAME="tfstate${SUFFIX}"
CONTAINER='tfstate'

# Create RG
az group create --name $RG --location $LOCATION
# Create storage account
az storage account create --resource-group $RG --name $SANAME --sku Standard_LRS --encryption-services blob
# Create blob container
az storage container create --name $CONTAINER --account-name $SANAME

echo "You will need to configure the backend of your challenge-01.tf as follows:"
echo "
backend \"azurerm\" {
    resource_group_name = \"$RG\"
    storage_account_name = \"$SANAME\"
    container_name       = \"$CONTAINER\"
    key                  = "terraform.tfstate"
}"

# Part 2
terraform init
terraform validate
terraform plan
terraform output storageid


