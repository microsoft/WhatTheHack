
terraform {
  required_version = ">= 0.12"
  backend "azurerm" {
    resource_group_name   = "tstate"
    storage_account_name  = "tstate09762"
    container_name        = "tstate"
    key                   = "terraform.tfstate"
    #access_key            = " " #export from keyvault or set ARM_ACCESS_KEY env variable
  }
}
