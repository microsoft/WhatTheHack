
# Resources
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfchallenge08acr" {
  name     = var.rgname
  location = var.location
}


resource "azurerm_container_registry" "acr" {
  name                = "${var.acrname}${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.tfchallenge08acr.name
  location            = azurerm_resource_group.tfchallenge08acr.location
  sku                 = "Standard"
  admin_enabled       = true

}

variable "imagenames" {
  type = list(string)
  default = ["erjosito/yadaweb:1.0", "erjosito/yadaapi:1.0"]
}
module "importimage" {
  count = length(var.imagenames)

  source = "github.com/onemtc/terraform-wth/modules/importimage"
  // source    = "../../../../modules/importimage"
  acrid     = azurerm_container_registry.acr.id
  imagename = var.imagenames[count.index]
}
